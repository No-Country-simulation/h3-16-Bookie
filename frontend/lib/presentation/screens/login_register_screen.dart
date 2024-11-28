import 'package:bookie/config/auth/auth0.dart';
import 'package:flutter/material.dart';

// Pantalla de inicio de sesión
class LoginOrRegisterScreen extends StatelessWidget {
  final AuthService authService = AuthService();

  LoginOrRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDarkmode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     "Inicia sesión o regístrate",
      //     style: TextStyle(color: isDarkmode ? Colors.black : Colors.white),
      //   ),
      //   backgroundColor: colors.primary,
      // ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.webp',
                width: 200,
                height: 100,
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => authService
                    .login(context), // Usamos el servicio AuthService
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: colors.primary,
                ),
                child: Text(
                  "Iniciar sesión con Auth0",
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkmode ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
