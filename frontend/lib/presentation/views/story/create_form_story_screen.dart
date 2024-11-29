import 'dart:io';

import 'package:bookie/config/permissions/image.dart';
import 'package:bookie/domain/entities/genre.dart';
import 'package:bookie/domain/entities/story.dart';
import 'package:bookie/infrastructure/mappers/genredb_mapper.dart';
import 'package:bookie/presentation/providers/genres_provider.dart';
import 'package:bookie/presentation/providers/story_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    // Recolectar los datos del formulario
    final String title = _titleController.text;
    final String synopsis = _synopsisController.text;
    final String? imagePath = _selectedImage?.path;
    final Dio dio = Dio();
    String? image;

    // TODO REVISAR PARA VER SI SE PUEDE QUITAR ESTA PARTE O SOLO BASE64
    // generar url de imagen con cloudinary
    final String url = "https://api.cloudinary.com/v1_1/dlixnwuhi/image/upload";

    // enviar peticion:
    // Crear FormData
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
        print("URL de la imagen subida: ${response.data}");
        image = response.data['url'];
      } catch (e) {
        print("Error al subir la imagen: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                'Error al subir la imagen',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.red),
        );
        return;
      }
    }

    // TODO DESCOMENTAR ESTA PARTE SI SE USA BASE64
    // Convertir la imagen a base64
    // image =
    //     imagePath != null ? await convertImageToBase64(imagePath) : null;

    // Obtener el nombre del género para enviarlo al backend
    final String genreString =
        GenreToStringExtension(_selectedGenre!).toBackendString;

    // Crear un objeto con los datos a enviar y enviarlo
    final StoryForm storyForm = StoryForm(
      title: title,
      synopsis: synopsis,
      genre: genreString,
      creatorId: 1,
      image: image,
    );

    // Crear el historia en el backend
    ref.read(createStoryProvider(storyForm).future).then(
      (story) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Historia creada'), backgroundColor: Colors.green),
        );
      },
    ).catchError((e) {
      print("EROOOOOOOOOOOOOOOOOOOOO: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('No se pudo crear la historia'),
            backgroundColor: Colors.red),
      );
    });
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
    ref.read(getGenresProvider.notifier).loadGenres();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final genres = ref.watch(getGenresProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear historia"),
        actions: [
          TextButton(
            onPressed: _isFormValid() ? _submitForm : null,
            child: Text(
              _isFormValid() ? "Siguiente" : "",
              style: TextStyle(
                color: _isFormValid()
                    ? colors.primary
                    : colors.onSurface.withOpacity(0.5),
              ),
            ),
          )
        ],
      ),
      body: Padding(
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
                                mainAxisAlignment: MainAxisAlignment.center,
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
              const Text("Género Literario",
                  style: TextStyle(fontWeight: FontWeight.bold)),
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
                      child: ChoiceChip(
                        label: Text(genreName),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedGenre = selected ? genre : null;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
