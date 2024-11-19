import 'package:bookie/config/constants/environment.dart';
import 'package:flutter/material.dart';
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:go_router/go_router.dart';

class AuthService {
  final auth0 = Auth0(Environment.theAuth0Domain, Environment.theAuth0ClientId);

  Future<void> login(BuildContext context) async {
    try {
      // Invoca el Universal Login
      final credentials = await auth0.webAuthentication().login(useHTTPS: true);

      // Redirige a la ruta '/home' con las credenciales
      if (context.mounted) {
        print("Credenciales obtenidas: $credentials");
        context.go('/home/0', extra: credentials); // Usando go_router
      }
    } catch (e) {
      print("Error de autenticación: $e");
    }
  }
  

  Future<void> logout(BuildContext context) async {
    await auth0.webAuthentication().logout();
    if (context.mounted) {
      context.go('/login'); // Redirige al login después de logout
    }
  }
}
