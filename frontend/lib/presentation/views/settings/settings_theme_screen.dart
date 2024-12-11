import 'package:bookie/presentation/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsThemeScreen extends ConsumerWidget {
  static const String name = 'settings-theme';

  const SettingsThemeScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final isDarkmode = ref.watch(themeNotifierProvider).isDarkmode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Settings'),
        actions: [
          IconButton(
              icon: Icon(isDarkmode
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined),
              onPressed: () {
                ref.read(themeNotifierProvider.notifier).toggleDarkmode();
              })
        ],
      ),
      body: _SettingsChangerTheme(),
    );
  }
}

class _SettingsChangerTheme extends ConsumerWidget {
  const _SettingsChangerTheme();

  @override
  Widget build(BuildContext context, ref) {
    final List<Color> colors = ref.watch(colorListProvider);
    final int selectedColor = ref.watch(themeNotifierProvider).selectedColor;

    // Mapa de colores a sus nombres
    final colorNames = <Color, String>{
      Colors.amber: 'Ámbar',
      Colors.blue: 'Azul',
      Colors.red: 'Rojo',
      Colors.green: 'Verde',
      Colors.purple: 'Púrpura',
      Colors.yellow: 'Amarillo',
      Colors.orange: 'Naranja',
    };

    return ListView.builder(
      itemCount: colors.length,
      itemBuilder: (context, index) {
        final Color color = colors[index];
        final String colorName =
            colorNames[color] ?? 'Desconocido'; // Nombre del color

        return RadioListTile(
          title: Row(
            children: [
              // Círculo de color junto al nombre
              // Container(
              //   width: 24,
              //   height: 24,
              //   decoration: BoxDecoration(
              //     color: color, // Color del círculo
              //     shape: BoxShape.circle,
              //   ),
              // ),
              // const SizedBox(width: 8), // Espacio entre el círculo y el texto
              Text(
                colorName, // Nombre del color
                style: TextStyle(
                    color:
                        color), // Color del texto coincide con el color del círculo
              ),
            ],
          ),
          activeColor: color,
          value: index,
          groupValue: selectedColor,
          onChanged: (value) {
            ref.watch(themeNotifierProvider.notifier).changeColorIndex(index);
          },
        );
      },
    );
  }
}
