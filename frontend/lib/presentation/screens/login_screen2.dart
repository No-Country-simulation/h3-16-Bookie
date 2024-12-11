import 'package:bookie/config/constants/general.dart';
import 'package:bookie/presentation/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

class LoginScreen2 extends StatefulWidget {
  const LoginScreen2({super.key});

  @override
  State<LoginScreen2> createState() => _LoginScreen2State();
}

class _LoginScreen2State extends State<LoginScreen2> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false; // Para mostrar el indicador de carga

  // Función para hacer la llamada a la API de login
  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      final email = _emailController.text;
      final password = _passwordController.text;

      try {
        // Simulamos un proceso de login
        await Future.delayed(Duration(seconds: 2));

        if (email.isNotEmpty && password.isNotEmpty) {
          // Mostrar un mensaje de éxito
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('¡Login exitoso!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          // Esperar un poco para mostrar el efecto y luego navegar a /home/0
          await Future.delayed(Duration(milliseconds: 500));
          if (mounted) {
            context.go('/home/0');
          }
        } else {
          // Si hubo un error, mostramos un mensaje en rojo
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: Por favor, comprueba tus datos'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        // Si ocurre algún error, mostramos un mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: No se pudo iniciar sesión'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDarkmode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text("Iniciar sesión",
            style: TextStyle(color: isDarkmode ? Colors.black : Colors.white)),
        backgroundColor: colors.primary,
      ),
      body: Stack(
        children: [
          // Formulario de login
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(16), // Bordes redondeados
                      child: Image.asset(
                        GeneralConstants.logo, // Cambia por la URL de tu imagen
                        width: 240, // Ancho de la imagen
                        height: 120, // Alto de la imagen
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Email input
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: "Correo electrónico",
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese su correo';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),

                          // Password input
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "Contraseña",
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese su contraseña';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 24),

                          // Login Button
                          ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : _login, // Deshabilitar el botón durante el login
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.primary,
                              minimumSize: Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text("Iniciar sesión",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: isDarkmode
                                        ? Colors.black
                                        : Colors.white)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    // Switch to Register page
                    TextButton(
                      onPressed: () {
                        // Navegar a la pantalla de registro
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterScreen()),
                        );
                      },
                      child: Text(
                        "¿No tienes cuenta? Regístrate aquí",
                        style: TextStyle(color: colors.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Cargar el loader encima del formulario
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(
                    0.5), // Fondo oscuro para hacer opaco el formulario
                child: Center(
                  child: SpinKitFadingCircle(
                    color: colors.primary,
                    size: 50.0,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
