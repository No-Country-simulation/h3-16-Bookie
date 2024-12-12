import 'package:animate_do/animate_do.dart';
import 'package:bookie/config/auth/auth0.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
class LoginOrRegisterScreen extends StatefulWidget {
  const LoginOrRegisterScreen({super.key});

  @override
  State<LoginOrRegisterScreen> createState() => _LoginOrRegisterScreenState();
}

class _LoginOrRegisterScreenState extends State<LoginOrRegisterScreen> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final authService = AuthService();
    await authService.checkLoginWithPreferencesAndDB(
        context); // Verificar y loguear si es necesario
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          // Fondo animado con Lottie
          const AnimatedBackground(),
          // Confetti explosivo
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 80), // Espaciado para el logo
                  // Logo de la app
                  FadeInDown(
                    duration: const Duration(milliseconds: 750),
                    child: Image.asset(
                      'assets/images/logo.webp',
                      width: 150,
                      height: 80,
                    ),
                  ),
                  SizedBox(height: 50),
                  // Breve descripción de la app
                  FadeInRight(
                    duration: const Duration(milliseconds: 1000),
                    child: Text(
                      "¡Sumérgete en historias donde cada lugar ilumina tu viaje!",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  Center(
                    child: SizedBox(
                      height: 200,
                      width: 200,
                      child: ZoomIn(
                          delay: const Duration(milliseconds: 750),
                          duration: const Duration(milliseconds: 1500),
                          child: Lottie.asset('assets/lottie/success.json')),
                    ),
                  ),

                  Spacer(), // Empuja el botón hacia abajo
                  // Botón de inicio de sesión
                  Center(
                    child: SizedBox(
                      height: 50,
                      width: 200,
                      child: FadeInRight(
                        delay: const Duration(milliseconds: 1200),
                        duration: const Duration(milliseconds: 500),
                        child: ElevatedButton(
                          onPressed: () async {
                            // Lógica de inicio de sesión
                            await authService.loginOrRegisterWithAuth0(context);
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: colors.primary,
                          ),
                          child: Text(
                            "Iniciar sesión",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF6A501E), // Dorado oscuro cálido
                Colors.amber.withOpacity(
                    0.7 + _controller.value * 0.3), // Dorado brillante
                Color(0xFF4F3B1B), // Dorado oscuro profundo
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [
                0.0,
                0.5 +
                    _controller.value * 0.2, // Control de la fluidez del dorado
                1.0,
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
