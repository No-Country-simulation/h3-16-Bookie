import 'dart:io';

import 'package:bookie/config/geolocator/geolocator.dart';
import 'package:bookie/config/helpers/get_country_province.dart';
import 'package:bookie/config/permissions/image.dart';
import 'package:bookie/config/persistent/shared_preferences.dart';
import 'package:bookie/domain/entities/genre_entity.dart';
import 'package:bookie/domain/entities/story_entity.dart';
import 'package:bookie/infrastructure/mappers/genredb_mapper.dart';
import 'package:bookie/presentation/providers/genres_provider.dart';
import 'package:bookie/presentation/providers/stories_user_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class CreateFormStoryScreen extends ConsumerStatefulWidget {
  static const String name = 'create-form-story';

  const CreateFormStoryScreen({super.key});

  @override
  ConsumerState<CreateFormStoryScreen> createState() =>
      _CreateFormStoryScreenState();
}

class _CreateFormStoryScreenState extends ConsumerState<CreateFormStoryScreen> {
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;
  bool isEnabled = true;
  XFile? _selectedImage;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _synopsisController = TextEditingController();
  Genre? _selectedGenre; // Ahora es un enum Genre

  void _pickImage(ImageSource source) async {
    bool permissionsGranted = await requestPermissions();
    if (permissionsGranted) {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permisos denegados.')),
      );
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  bool _isFormValid() {
    return _titleController.text.isNotEmpty &&
        _synopsisController.text.isNotEmpty &&
        _selectedGenre != null;
  }

  void _submitForm() async {
    FocusScope.of(context).unfocus();

    setState(() {
      isEnabled = false;
      isLoading = true;
    });

    try {
      // Recolectar los datos del formulario
      final String title = _titleController.text;
      final String synopsis = _synopsisController.text;
      final String? imagePath = _selectedImage?.path;
      final Dio dio = Dio();
      String? image;

      final String url =
          "https://api.cloudinary.com/v1_1/dlixnwuhi/image/upload";

      // creacion url de la imagen
      if (imagePath != null) {
        try {
          FormData formData = FormData.fromMap({
            "file": await MultipartFile.fromFile(imagePath),
            "upload_preset": "ml_default",
            "cloud_name": "dlixnwuhi",
          });

          // Enviar la solicitud de subida de la imagen
          final response = await dio.post(url, data: formData);

          // Obtener la URL de la imagen subida
          image = response.data['secure_url'];
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                  'Error al subir la imagen',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.red),
          );
          return;
        }
      }

      final String genreString =
          GenreToStringExtension(_selectedGenre!).toBackendString;

      // Obtener credenciales de usuario
      final credentials = await SharedPreferencesKeys.getCredentials();

      // Obtener la ubicación actual
      final position = await determinePosition();

      // Obtener el nombre del pais y provincia
      final countryAndProvince = await getCountryAndProvinceUsingGeocoding(
          position.latitude, position.longitude);

      // Crear un objeto con los datos a enviar y enviarlo
      final StoryForm storyForm = StoryForm(
        title: title,
        synopsis: synopsis,
        genre: genreString,
        creatorId: int.parse(credentials.id ?? '1'),
        image: image,
        country: countryAndProvince?.country ?? "TEMPORAL",
        province: countryAndProvince?.province ?? "TEMPORAL",
      );

      // Crear el historia en el backend
      final storyCreated =
          await ref.read(storiesUserProvider.notifier).createStory(storyForm);

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      _titleController.clear();
      _synopsisController.clear();
      _formKey.currentState?.reset();
      //       content: Text('Historia creada'), backgroundColor: Colors.green),
      // );
      //Navegar a la ruta `/form-chapter` con GoRouter

      if (context.mounted) {
        context.push(
          '/chapter/create/${storyCreated.id}',
        );
      }
      isLoading = false;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('No se pudo crear la historia'),
            backgroundColor: Colors.red),
      );
      isLoading = false;
    } finally {
      setState(() {
        isEnabled = true; // Habilitar el botón después de enviar el formulario
      });
    }
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text("Tomar foto"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Seleccionar de la galería"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // Limpiar los controladores al inicializar
    ref.read(getGenresProvider.notifier).loadGenres();
  }

  // @override
  // void didChangeDependencies() {
  //   // Limpiar los controladores cada vez que la pantalla cambie
  //   super.didChangeDependencies();
  //   _titleController.clear();
  //   _synopsisController.clear();
  // }

  @override
  void dispose() {
    // Limpiar los controladores al salir de la pantalla
    _titleController.dispose();
    _synopsisController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final genres = ref.watch(getGenresProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear historia"),
        actions: [
          AbsorbPointer(
            absorbing: !isEnabled,
            child: TextButton(
              onPressed: _isFormValid() ? _submitForm : null,
              child: Text(
                "Siguiente",
                style: TextStyle(
                  color: (_isFormValid() && isEnabled)
                      ? colors.primary
                      : colors.onSurface.withOpacity(0.5),
                ),
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          AbsorbPointer(
            absorbing: !isEnabled,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Selector de imagen
                    GestureDetector(
                      onTap: _showImageSourceActionSheet,
                      child: Stack(
                        children: [
                          Container(
                            height: 180,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: colors.onSurface.withOpacity(0.5)),
                              borderRadius: BorderRadius.circular(12),
                              color: colors.surface,
                            ),
                            child: _selectedImage == null
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.add_a_photo, size: 32),
                                        SizedBox(height: 8),
                                        Text("Agregar foto"),
                                      ],
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      File(_selectedImage!.path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          if (_selectedImage != null)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: _removeImage,
                                child: CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.red.withOpacity(0.8),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Input de título
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: "Título de la historia",
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Campo obligatorio";
                        }
                        return null;
                      },
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),

                    // Input de sinopsis
                    TextFormField(
                      controller: _synopsisController,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        labelText: "Agregar Sinopsis",
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Campo obligatorio";
                        }
                        return null;
                      },
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),

                    // Géneros literarios
                    Text("Género Literario",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: colors.primary)),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: genres.length,
                        itemBuilder: (context, index) {
                          final genre = genres[index];
                          final genreName = GenreExtension(genre).displayName;
                          final isSelected = _selectedGenre == genre;

                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedGenre = isSelected ? null : genre;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _selectedGenre == genre
                                      ? colors.primary
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(
                                      8.0), // Bordes redondeados
                                ),
                                padding: const EdgeInsets.only(
                                    left: 12.0, right: 12.0, top: 9.0),
                                child: Text(
                                  genreName,
                                  style: TextStyle(
                                    color: _selectedGenre == genre
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isLoading)
            ModalBarrier(
              color: Colors.black.withOpacity(0.5),
              dismissible: false,
            ),
          if (isLoading)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SpinKitFadingCircle(
                    color: colors.primary,
                    size: 50.0,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Iniciando historia...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
