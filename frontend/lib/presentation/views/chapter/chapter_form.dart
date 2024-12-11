import 'dart:io';

import 'package:bookie/config/geolocator/geolocator.dart';
import 'package:bookie/config/helpers/get_country_province.dart';
import 'package:bookie/config/openai/openai_config.dart';
import 'package:bookie/config/permissions/image.dart';
import 'package:bookie/config/translator/translator.dart';
import 'package:bookie/domain/entities/chapter_entity.dart';
import 'package:bookie/presentation/providers/chapter_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class CreateChapterScreen extends ConsumerStatefulWidget {
  static const String name = 'create-chapter';
  final int storyId;
  final int? chapterId;
  final String? titleMod;
  final String? contentMod;
  final bool? edit;

  const CreateChapterScreen({
    super.key,
    required this.storyId,
    this.edit,
    this.chapterId,
    this.titleMod,
    this.contentMod,
  });

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
  bool isEnabled = true;
  bool isLoading = false;
  String loadingMessage = "";
  String _generatedText = ""; // Texto acumulado.
  String _prompt = "";
  bool _isGeneratingText = true;

  // final QuillController _controller = QuillController.basic();

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // Obtenemos los parámetros de la ruta actual
  //   final Map<String, dynamic>? extra =
  //       GoRouterState.of(context).extra as Map<String, dynamic>?;

  //   // Inicializamos los controladores con los valores obtenidos de la ruta
  //   _titleController = TextEditingController(text: extra?['title'] ?? "");
  //   _contentController = TextEditingController(text: extra?['content'] ?? "");
  //   // _imageController = TextEditingController(text: extra?['image'] ?? "");
  // }

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
    // focusNode.addListener(() {
    //   setState(() {});
    // });
    _titleController.clear();
    _contentController.clear();
    _formKey.currentState?.reset();

    // asignar si se va a modificar el capitulo
    if (widget.titleMod != null && widget.contentMod != null) {
      setState(() {
        _titleController.text = widget.titleMod!;
        _contentController.text = widget.contentMod!;
      });
    }
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // Limpiar los controladores cada vez que la pantalla cambie
  //   _titleController.clear();
  //   _contentController.clear();
  //   _formKey.currentState?.reset(); // Resetea el estado del formulario
  // }

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
    super.dispose();
    _titleController.dispose();
    _contentController.dispose();
    focusNode.dispose();
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
    return _titleController.text.trim().isNotEmpty &&
        _contentController.text.trim().isNotEmpty;
  }

  Future<Position> getCurrentPosition() async {
    try {
      var position = await determinePosition();
      return position;
    } catch (e) {
      rethrow;
    }
  }

  void _showSaveChapterDialog() {
    final colors = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      barrierDismissible: false, // No se puede cerrar al hacer clic afuera
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              '${widget.edit == true ? "Modificar" : "Guardar"} capítulo',
              style: TextStyle(color: colors.primary, fontSize: 22),
              textAlign: TextAlign.center),
          content: Text(
              "Vas a ${widget.edit == true ? "modificar" : "guardar"} este capítulo con tu ubicación actual. Verifica que sea la ubicación correcta antes de proceder."),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
              ),
              onPressed: () {
                focusNode.unfocus();
                // Aquí puedes añadir la lógica para guardar el capítulo con la ubicación actual
                _submitForm();
              },
              child: Text(widget.edit == true ? "Modificar" : "Guardar",
                  style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el modal sin hacer nada
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _submitForm() async {
    // cerrar el modal
    Navigator.of(context).pop();

    focusNode.unfocus();

    setState(() {
      isEnabled = false;
      isLoading = true;
      loadingMessage = "Espera, estamos guardando la historia...";
    });

    final String title = _titleController.text;
    final String content = _contentController.text;
    final String? imagePath = _selectedImage?.path;
    final Dio dio = Dio();
    String? image;

    try {
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

      setState(() {
        loadingMessage = "Determinando ubicación...";
      });

      if (latitude == null || longitude == null) {
        final position = await determinePosition();
        latitude = position.latitude;
        longitude = position.longitude;
      }

      if (title.trim().isNotEmpty &&
          content.trim().isNotEmpty &&
          latitude != null &&
          longitude != null) {
        final chapterForm = ChapterForm(
          title: title,
          content: content,
          latitude: latitude!,
          longitude: longitude!,
          historyId: widget.storyId,
          image: image,
        );

        setState(() {
          loadingMessage = "Ya falta poco...";
        });

        Chapter? chapter;
        if (widget.edit != true) {
          chapter =
              await ref.read(chapterProvider.notifier).addChapter(chapterForm);
        } else {
          chapter = await ref
              .read(chapterProvider.notifier)
              .modChapter(chapterForm, widget.chapterId!);
        }

        final chapterIndex =
            ref.read(chapterProvider.notifier).currentChapter(chapter.id);

        _titleController.clear();
        _contentController.clear();
        _formKey.currentState?.reset(); // Resetea el estado del formulario

        if (context.mounted) {
          context.push("/chapter/success/${widget.storyId}/$chapterIndex");
        }

        // await Future.delayed(const Duration(seconds: 1));
        isLoading = false;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Por favor, revisa los datos ingresados'),
              backgroundColor: Colors.red),
        );
        isLoading = false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error al subir la imagen'),
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

  void _showGenerateStoryDialogConfirm(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      barrierDismissible: false, // No se puede cerrar al hacer clic afuera

      builder: (BuildContext context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          title: Text('Generar texto'),
          content: Text(
              'Se generará una historia basado en el contenido actual con inteligencia artificial, también puedes mejorar y corregir la historia que escribistes.'),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
              ),
              onPressed: () {
                focusNode.unfocus();
                _generateAndModifyStory(context);
              },
              child: Text('Generar o corregir historia',
                  style: TextStyle(color: Colors.black)),
            ),
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: colors.primary,
            //   ),
            //   onPressed: () {
            //     focusNode.unfocus();
            //     _modifyStory(context);
            //   },
            //   child: Text('Mejorar y corregir',
            //       style: TextStyle(color: Colors.black)),
            // ),
            TextButton(
              onPressed: () {
                setState(() {
                  isLoading = false;
                  isEnabled = true;
                  _isGeneratingText = true;
                });
                Navigator.of(context).pop(); // Cerrar el modal sin eliminar
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _generateAndModifyStory(BuildContext context) async {
    if (_contentController.text.trim().isNotEmpty && _isGeneratingText) {
      setState(() {
        _isGeneratingText = false;
      });
      _showGenerateStoryDialogConfirm(context);
      return;
    }

    setState(() {
      isEnabled = false;
      isLoading = true;
      _generatedText = "";
      // _contentController.clear();
      loadingMessage = "Generando historia...";
    });

    if (!_isGeneratingText) {
      Navigator.of(context).pop(); // Cerrar el modal
    }

    // _contentController.text = "Generando historia..."; // Actualiza el TextField

    try {
      final position = await determinePosition();
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });

      final getCountryAndProvince = await getCountryAndProvinceUsingGeocoding(
        latitude!,
        longitude!,
      );

      final chatStream = await generateStory(
        contextStory:
            // Este título es importante a considerar en la generación de la historia:
            "Contexto: ${_titleController.text.trim().isEmpty ? "" : _titleController.text}, ${_prompt.trim().isEmpty ? "" : _prompt}. Lugar: ${getCountryAndProvince?.country ?? ""}, ${getCountryAndProvince?.province ?? ""}",
      );

      chatStream.listen((streamChatCompletion) {
        final newText =
            streamChatCompletion.choices.first.delta.content?[0]?.text ?? "";
        _generatedText += newText; // Acumula el texto progresivamente.
        _contentController.text =
            _generatedText; // Actualiza el TextField dinámicamente.

        // Asegúrate de que el cursor esté al final del texto
        // focusNode.requestFocus(); // Solicita el enfoque
        // _contentController.selection = TextSelection.fromPosition(
        //   TextPosition(offset: _contentController.text.length),
        // );
      }, onDone: () {
        setState(() {
          isLoading = false; // Finaliza el estado de carga.
          isEnabled = true;
        });
      });
    } catch (e) {
      if (!_isGeneratingText) {
        Navigator.of(context).pop(); // Cerrar el modal
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al generar texto'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        isLoading = false;
        isEnabled = true;
      });
    } finally {
      setState(() {
        // isLoading = false;
        _isGeneratingText = true;
      });
    }
  }

  void _modifyStory(BuildContext context) async {
    if (_contentController.text.trim().isEmpty) {
      Navigator.of(context).pop(); // Cerrar el modal
    }

    setState(() {
      isLoading = true;
      isEnabled = false;
      _generatedText = "";
      loadingMessage = "Mejorando historia...";
    });

    try {
      final chatStream = await modifyStory(
        storyToModify: _contentController.text.trim(),
      );

      // para cerrar el modal
      Navigator.of(context).pop(); // Cerrar el modal

      chatStream.listen((streamChatCompletion) {
        final newText =
            streamChatCompletion.choices.first.delta.content?[0]?.text ?? "";
        _generatedText += newText;
        _contentController.text = _generatedText;

        // Asegúrate de que el cursor esté al final del texto
        // focusNode.requestFocus(); // Solicita el enfoque
        // _contentController.selection = TextSelection.fromPosition(
        //   TextPosition(offset: _contentController.text.length),
        // );
      }, onDone: () {
        setState(() {
          isLoading = false; // Finaliza el estado de carga.
          isEnabled = true;
        });
      });
    } catch (e) {
      if (!_isGeneratingText) {
        Navigator.of(context).pop(); // Cerrar el modal
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al modificar texto'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        isLoading = false;
        isEnabled = true;
      });
    } finally {
      setState(() {
        // isLoading = false;
        _isGeneratingText = true;
      });
    }
  }

  void _showTranslateStoryDialogConfirm(BuildContext context) {
    if (_contentController.text.trim().isEmpty) {
      return;
    }

    final colors = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          alignment: Alignment.center,
          content: Column(
            mainAxisSize:
                MainAxisSize.min, // Ajustar el tamaño del modal al contenido
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                ),
                onPressed: () {
                  focusNode.unfocus();
                  _translateStory("es", context);
                },
                child: Text('Español', style: TextStyle(color: Colors.black)),
              ),
              const SizedBox(height: 10), // Separador entre botones
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                ),
                onPressed: () {
                  _translateStory("en", context);
                },
                child: Text('Inglés', style: TextStyle(color: Colors.black)),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                ),
                onPressed: () {
                  _translateStory("pt", context);
                },
                child: Text('Portugués', style: TextStyle(color: Colors.black)),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                ),
                onPressed: () {
                  _translateStory("it", context);
                },
                child: Text('Italiano', style: TextStyle(color: Colors.black)),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                ),
                onPressed: () {
                  _translateStory("fr", context);
                },
                child: Text('Francés', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _translateStory(String language, BuildContext context) async {
    setState(() {
      isEnabled = false;
      isLoading = true;
      loadingMessage = "Traduciendo...";
    });

    Navigator.of(context).pop(); // Cerrar el modal

    try {
      final translateStory = await translateGoogle(
        language: language,
        text: _contentController.text.trim(),
      );

      if (translateStory.text.isNotEmpty) {
        setState(() {
          _contentController.text = translateStory.text;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No se pudo traducir el texto.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al traducir texto'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isEnabled = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear capítulo"),
        actions: [
          AbsorbPointer(
            absorbing: !isEnabled,
            child: TextButton(
              onPressed: (_isFormValid() && isEnabled)
                  ? () => _showSaveChapterDialog()
                  : null,
              child: Text(
                widget.edit == true ? "Modificar" : "Guardar",
                style: TextStyle(
                  color: (_isFormValid() && isEnabled)
                      ? colors.primary
                      : colors.onSurface.withOpacity(0.5),
                ),
              ),
            ),
          ),
          AbsorbPointer(
            absorbing: !isEnabled,
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              padding: EdgeInsets.zero,
              onSelected: (value) {
                if (value == 'preview') {
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'preview',
                  child: Text('Vista previa'),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          AbsorbPointer(
            absorbing: !isEnabled,
            child: SingleChildScrollView(
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(Icons.add_a_photo, size: 32),
                                            SizedBox(height: 8),
                                            Text(
                                                "Agregar una imagen al capítulo"),
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
                                      backgroundColor:
                                          Colors.red.withOpacity(0.8),
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
                          textAlign: TextAlign.center,
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
                        Stack(children: [
                          TextFormField(
                            controller: _contentController,
                            focusNode: focusNode,
                            decoration: InputDecoration(
                              labelText:
                                  "Pulsa aquí para empezar a escribir", // El texto del label cambiará dinámicamente
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              floatingLabelAlignment:
                                  FloatingLabelAlignment.center,
                              // Esto hace la etiqueta invisible si no se está usando
                              // labelStyle: TextStyle(color: Colors.transparent),
                              border: InputBorder
                                  .none, // Esto oculta la línea de la base
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
                            onChanged: (value) => setState(() {
                              _prompt = value.trim();
                            }),
                          ),

                          // Botón de limpiar
                          if (_contentController.text.trim().isNotEmpty)
                            Positioned(
                              top: 4,
                              right: 6, // Ajusta la posición a la derecha
                              child: GestureDetector(
                                onTap: () {
                                  if (_contentController.text.trim().length >
                                      500) {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Borrar historia'),
                                            content: Text(
                                                '¿Estás seguro de que quieres hacerlo?'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  _contentController
                                                      .clear(); // Limpiar el campo
                                                  setState(
                                                      () {}); // Actualizar la UI
                                                  Navigator.of(context)
                                                      .pop(); // Cerrar el modal
                                                },
                                                child: Text('Sí'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Cerrar el modal
                                                },
                                                child: Text('No'),
                                              ),
                                            ],
                                          );
                                        });
                                    return;
                                  }

                                  _contentController
                                      .clear(); // Limpiar el campo
                                  setState(() {}); // Actualizar la UI
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.8),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.delete,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                        ]),
                        const SizedBox(height: 16),
                      ],
                    )),
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
                    loadingMessage,
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
      bottomNavigationBar: AbsorbPointer(
        absorbing: !isEnabled,
        child: BottomAppBar(
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
                  focusNode.unfocus();
                  // Lógica para traducir
                  _showTranslateStoryDialogConfirm(context);
                },
              ),
              // Botón de IA
              IconButton(
                icon: Icon(Icons.auto_awesome),
                onPressed: () {
                  focusNode.unfocus();
                  _generateAndModifyStory(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
