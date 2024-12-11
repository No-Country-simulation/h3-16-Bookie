import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:bookie/config/constants/environment.dart';
import 'package:bookie/config/fetch/fetch_api.dart';
import 'package:bookie/config/persistent/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthService {
  final auth0 = Auth0(Environment.theAuth0Domain, Environment.theAuth0ClientId);

  Future<void> checkLoginWithPreferencesAndDB(BuildContext context) async {
    try {
      // Verificar si hay credenciales guardadas en SharedPreferences
      final credentials = await SharedPreferencesKeys.getCredentials();

      if (credentials.idToken != null && credentials.idToken!.isNotEmpty) {
        try {
          // Validar las credenciales en la base de datos
          final response = await FetchApi.fetchDio().get(
            '/auth/user',
            options: Options(
              headers: {
                'Authorization': 'Bearer ${credentials.idToken}',
              },
            ),
          );

          // Si las credenciales son válidas, redirigir a Home
          if (response.data['id'] != null) {
            if (context.mounted) {
              context.go('/home/0'); // Redirigir al home
            }
            return;
          }
        } catch (e) {
          print("Usuario no encontrado o credenciales inválidas: $e");
        }
      }

      if (context.mounted) {
        await loginOrRegisterWithAuth0(context);
        // context.go('/login'); // Redirigir a la pantalla de login
      }
      // Si no hay credenciales válidas, proceder al login con Auth0
      // await loginOrRegisterWithAuth0(context);
    } catch (e) {
      print("Error al verificar credenciales: $e");
    }
  }

  Future<void> loginOrRegisterWithAuth0(BuildContext context) async {
    try {
      // Realizar el flujo de inicio de sesión con Auth0
      final authCredentials =
          await auth0.webAuthentication(scheme: 'demo').login();

      // Obtener información del usuario desde la API
      final response = await FetchApi.fetchDio().get(
        '/auth/user',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${authCredentials.idToken}',
          },
        ),
      );

      // Guardar las credenciales obtenidas en SharedPreferences
      await SharedPreferencesKeys.saveCredentials(
        SharedPrefencesFields(
          name: response.data['name'],
          email: response.data['email'],
          id: response.data['id'].toString(),
          idToken: authCredentials.idToken,
        ),
      );

      // Mostrar mensaje de éxito
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('¡Sesión iniciada exitosamente!'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/home/0'); // Redirigir al home
      }
    } catch (e) {
      print("Error en el flujo de inicio de sesión con Auth0: $e");
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await auth0
          .webAuthentication(
            scheme: 'demo',
          )
          .logout();

      // Limpiar datos de sesión persistente
      await SharedPreferencesKeys.clearCredentials();

      if (context.mounted) {
        context.go('/splash'); // Redirige a la pantalla de splash/login
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cerrar sesión'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
