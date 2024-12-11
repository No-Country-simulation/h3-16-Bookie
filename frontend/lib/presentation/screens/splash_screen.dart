import 'package:bookie/config/auth/auth0.dart';
import 'package:bookie/config/constants/general.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Variables para controlar el fade-in y fade-out
  double _opacity = 0.0; // Inicia con opacidad 0 (invisible)

  @override
  void initState() {
    super.initState();
    _showSplash();
  }

  Future<void> _checkLoginStatus() async {
    final authService = AuthService();
    await authService.checkLoginWithPreferencesAndDB(
        context); // Verificar y loguear si es necesario
  }

  // Función que maneja el flujo de la splash screen
  Future<void> _showSplash() async {
    // Primero, espera un pequeño tiempo antes de comenzar el fade-in
    await Future.delayed(const Duration(milliseconds: 750));

    // Iniciar fade-in
    setState(() {
      _opacity = 1.0;
    });

    // Esperar 2 segundos antes de iniciar el fade-out
    await Future.delayed(const Duration(seconds: 3));

    // Cambiar la opacidad para el fade-out
    setState(() {
      _opacity = 1.0; // Iniciar fade-out
    });

    // Esperar 1 segundo para completar el fade-out
    await Future.delayed(const Duration(seconds: 1));

    // Comprobar si el widget sigue montado antes de navegar
    if (mounted) {
      // context.go('/login');
      _checkLoginStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor:
          colors.primary.withOpacity(0.2), // Fondo atractivo de color azul
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity, // Controlamos la opacidad para el efecto
          duration: const Duration(
              milliseconds: 1000), // Duración del fade-in y fade-out
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Imagen desde URL con bordes redondeados
              ClipRRect(
                borderRadius: BorderRadius.circular(16), // Bordes redondeados
                child: Image.asset(
                  GeneralConstants.logo, // Cambia por la URL de tu imagen
                  width: 240, // Ancho de la imagen
                  height: 120, // Alto de la imagen
                  fit: BoxFit.cover, // Ajuste de la imagen
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
