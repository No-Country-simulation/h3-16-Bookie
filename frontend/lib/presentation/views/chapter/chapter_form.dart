import 'dart:io';

import 'package:bookie/config/geolocator/geolocator.dart';
import 'package:bookie/config/permissions/image.dart';
import 'package:bookie/domain/entities/chapter.dart';
import 'package:bookie/presentation/providers/chapter_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class CreateChapterScreen extends ConsumerStatefulWidget {
  static const String name = 'create-chapter';
  final int storyId;

  const CreateChapterScreen({super.key, required this.storyId});

  @override
  ConsumerState<CreateChapterScreen> createState() =>
      _CreateChapterScreenState();
}

class _CreateChapterScreenState extends ConsumerState<CreateChapterScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderlined = false;
  double? latitude;
  double? longitude;
  bool isSaveEnabled = false;
  // final QuillController _controller = QuillController.basic();

  void _toggleBold() {
    setState(() {
      _isBold = !_isBold;
    });
  }

  void _toggleItalic() {
    setState(() {
      _isItalic = !_isItalic;
    });
  }

  void _toggleUnderline() {
    setState(() {
      _isUnderlined = !_isUnderlined;
    });
  }

  @override
  void initState() {
    super.initState();

    // Monitorear el foco para actualizar el estado
    focusNode.addListener(() {
      setState(() {});
    });
  }

  void _openAlignmentMenu() {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(0, 0, 0,
          60), // Ajusta la posición para que se muestre encima del BottomAppBar
      items: [
        PopupMenuItem(
          value: 'left',
          child: Row(
            children: [
              Icon(Icons.format_align_left),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'center',
          child: Row(
            children: [
              Icon(Icons.format_align_center),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'right',
          child: Row(
            children: [
              Icon(Icons.format_align_right),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'bold',
          child: Row(
            children: [
              Icon(Icons.format_bold),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'italic',
          child: Row(
            children: [
              Icon(Icons.format_italic),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'underline',
          child: Row(
            children: [
              Icon(Icons.format_underline),
            ],
          ),
        ),
      ],
      elevation: 8.0,
    ).then((value) {
      if (value != null) {
        switch (value) {
          case 'left':
            // Lógica para alinear a la izquierda
            break;
          case 'center':
            // Lógica para alinear al centro
            break;
          case 'right':
            // Lógica para alinear a la derecha
            break;
          case 'bold':
            _toggleBold(); // Cambia el estado de negrita
            break;
          case 'italic':
            _toggleItalic(); // Cambia el estado de cursiva
            break;
          case 'underline':
            _toggleUnderline(); // Cambia el estado de subrayado
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    focusNode.dispose();
    super.dispose();
  }

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
        _contentController.text.isNotEmpty;
  }

  Future<void> addMarker() async {
    try {
      // Usa tu lógica de geolocalización aquí
      // Ejemplo:
      var position = await determinePosition();
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
        isSaveEnabled =
            true; // Habilitar el botón después de obtener la ubicación
      });
    } catch (e) {
      // Maneja el error de geolocalización
      print('Error al obtener la ubicación: $e');
    }
  }

  void _submitForm() async {
    final String title = _titleController.text;
    final String content = _contentController.text;
    final String? imagePath = _selectedImage?.path;
    final Dio dio = Dio();
    String? image;

    // Subir imagen a Cloudinary
    if (imagePath != null) {
      try {
        FormData formData = FormData.fromMap({
          "file": await MultipartFile.fromFile(imagePath),
          "upload_preset": "ml_default",
          "cloud_name": "dlixnwuhi",
        });

        final response = await dio.post(
            "https://api.cloudinary.com/v1_1/dlixnwuhi/image/upload",
            data: formData);

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

    if (title.isNotEmpty &&
        content.isNotEmpty &&
        latitude != null &&
        longitude != null) {
      final chapterForm = ChapterForm(
        title: title,
        content: content,
        image: image,
        latitude: latitude!,
        longitude: longitude!,
        historyId: widget.storyId,
      );

      ref.read(chapterProvider.notifier).addChapter(chapterForm).then(
        (chapter) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Capítulo creado'),
                backgroundColor: Colors.green),
          );
        },
      ).catchError((e) {
        print("Error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('No se pudo crear el capítulo'),
              backgroundColor: Colors.red),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Por favor, revisa los datos ingresados'),
            backgroundColor: Colors.red),
      );
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

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Titulo con un X para cerrar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () =>
                          Navigator.pop(context), // Cerrar el BottomSheet
                      child: const Icon(Icons.close),
                    ),
                    const Text(
                      'Una cosa más',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    // Botón "Guardar"

                    TextButton(
                      onPressed: isSaveEnabled
                          ? _submitForm
                          : null, // El botón se habilita solo si la latitud y longitud están definidas
                      child: Text(
                        'Guardar',
                      ),
                    ),
                  ],
                ),
                // Opciones
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.location_on),
                  title: const Text("Agregar marcador"),
                  onTap: () async {
                    // Navigator.pop(context); // Cerrar el BottomSheet
                    await addMarker(); // Lógica de Geolocator para agregar marcador
                  },
                ),
                // Puedes agregar más opciones aquí si es necesario
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear capítulo"),
        actions: [
          TextButton(
            onPressed: _isFormValid() ? _showBottomSheet : null,
            child: Text(
              "Guardar",
              style: TextStyle(
                color: _isFormValid()
                    ? colors.primary
                    : colors.onSurface.withOpacity(0.5),
              ),
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            padding: EdgeInsets.zero,
            onSelected: (value) {
              if (value == 'preview') {
                print("Vista previa seleccionada");
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'preview',
                child: Text('Vista previa'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                          height: 120,
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
                                      Text("Agregar una imagen al capítulo"),
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
                  // const SizedBox(height: 16),

                  // Input de título
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: "Agregale un título",
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      labelStyle: TextStyle(
                        color: _titleController.text.isEmpty
                            ? null
                            : Colors.transparent,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obligatorio";
                      }
                      return null;
                    },
                    onChanged: (_) => setState(() {}),
                  ),
                  // const SizedBox(height: 16),

                  // Input de contenido del capítulo (sin línea base)
                  TextFormField(
                    controller: _contentController,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      labelText:
                          "Pulsa aquí para empezar a escribir", // El texto del label cambiará dinámicamente
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      floatingLabelAlignment: FloatingLabelAlignment.center,
                      // Esto hace la etiqueta invisible si no se está usando
                      // labelStyle: TextStyle(color: Colors.transparent),
                      border:
                          InputBorder.none, // Esto oculta la línea de la base
                      labelStyle: TextStyle(
                        color: focusNode.hasFocus ||
                                _contentController.text.isNotEmpty
                            ? Colors
                                .transparent // Cuando está enfocado o tiene texto, ocultar el label
                            : null, // Si no está enfocado y está vacío, mostrar el label
                      ),
                    ),
                    maxLines:
                        null, // Esto permite que el campo crezca hacia abajo
                    // expands: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obligatorio";
                      }
                      return null;
                    },
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                ],
              )),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 4, // Añade sombra si es necesario
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Botones de deshacer y rehacer
            IconButton(
              icon: Icon(Icons.undo),
              onPressed: () {
                // Lógica para deshacer
              },
            ),
            IconButton(
              icon: Icon(Icons.redo),
              onPressed: () {
                // Lógica para rehacer
              },
            ),
            // Botón de formato que abre el menú de formato
            IconButton(
              icon: Icon(Icons.text_format),
              onPressed: _openAlignmentMenu,
            ),
            // Botón de traducir
            IconButton(
              icon: Icon(Icons.translate),
              onPressed: () {
                // Lógica para traducir
              },
            ),
            // Botón de IA
            IconButton(
              icon: Icon(Icons.auto_awesome),
              onPressed: () {
                // Lógica para mejorar el texto con IA
              },
            ),
          ],
        ),
      ),
    );
  }
}
