import 'package:bookie/config/constants/environment.dart';
import 'package:flutter/material.dart';
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:go_router/go_router.dart';

class AuthService {
  final auth0 = Auth0(Environment.theAuth0Domain, Environment.theAuth0ClientId);

  Future<void> login(BuildContext context) async {
    try {
      // Invoca el Universal Login
      final credentials = await auth0
          .webAuthentication(
            scheme: 'demo',
          )
          .login();

      // Redirige a la ruta '/home' con las credenciales
      if (context.mounted) {
        context.go('/home/0', extra: credentials); // Usando go_router
      }
    } catch (e) {
      print("ERORRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR: $e");
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await auth0
          .webAuthentication(
            scheme: 'demo',
          )
          .logout();

      // Limpiar cualquier dato de sesión persistente si estás usando almacenamiento local
      // Ejemplo usando SecureStorage (si lo usas)
      // await SecureStorage().delete(key: 'userToken');

      if (context.mounted) {
        context.go('/splash'); // Redirige a la pantalla de splash/login
      }
    } catch (e) {
      print("ERROOOOOOOOOOOO LOGOUTTTTTTTTTTTTTTTTTTTTT: $e");
    }
  }
}
