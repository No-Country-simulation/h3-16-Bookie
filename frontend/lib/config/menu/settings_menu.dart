import 'package:flutter/material.dart';

class SettingsMenuItem {
  final String title;
  final String? subTitle;
  final String? link;
  final IconData icon;

  const SettingsMenuItem(
      {required this.title, this.subTitle, this.link, required this.icon});
}

const settingsMenuItems = <SettingsMenuItem>[
  SettingsMenuItem(
      title: 'Perfil de usuario',
      subTitle: 'Configuración de la cuenta',
      link: '/home/4/profile',
      icon: Icons.person),
  SettingsMenuItem(
      title: 'Cambiar tema',
      subTitle: 'Colores y temas',
      link: '/home/4/theme',
      icon: Icons.color_lens_outlined),
  SettingsMenuItem(title: 'Cerrar sesión', icon: Icons.logout, link: "/login"),
];
