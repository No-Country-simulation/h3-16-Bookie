import 'package:flutter/material.dart';

class UserSettingsScreen extends StatelessWidget {
  const UserSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración'),
        backgroundColor: Colors.yellow,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // Sección de información general
          ListTile(
            leading: Icon(Icons.person, color: Colors.yellowAccent),
            title: Text('Cambiar nombre de usuario'),
            subtitle: Text('Actualiza tu nombre visible'),
            onTap: () {
              // Acción para cambiar nombre de usuario
            },
          ),
          Divider(),
          // Sección de notificaciones
          ListTile(
            leading: Icon(Icons.notifications, color: Colors.yellowAccent),
            title: Text('Notificaciones'),
            subtitle: Text('Configura tus preferencias de notificación'),
            onTap: () {
              // Acción para notificaciones
            },
          ),
          Divider(),
          // Sección de ajustes de privacidad
          ListTile(
            leading: Icon(Icons.lock, color: Colors.yellowAccent),
            title: Text('Privacidad'),
            subtitle: Text('Administra tus configuraciones de privacidad'),
            onTap: () {
              // Acción para privacidad
            },
          ),
          Divider(),
          // Sección de temas
          ListTile(
            leading: Icon(Icons.color_lens, color: Colors.yellowAccent),
            title: Text('Tema'),
            subtitle: Text('Elige entre tema claro o oscuro'),
            onTap: () {
              // Acción para cambiar tema
            },
          ),
          Divider(),
          // Sección de cerrar sesión
          ListTile(
            leading: Icon(Icons.logout, color: Colors.redAccent),
            title: Text(
              'Cerrar sesión',
              style: TextStyle(color: Colors.redAccent),
            ),
            onTap: () {
              // Acción para cerrar sesión
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  // Diálogo para confirmar el cierre de sesión
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Cerrar sesión'),
          content: Text('¿Estás seguro de que quieres cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar el diálogo
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar el diálogo
                // Lógica para cerrar sesión
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.redAccent,
              ),
              child: Text('Cerrar sesión'),
            ),
          ],
        );
      },
    );
  }
}