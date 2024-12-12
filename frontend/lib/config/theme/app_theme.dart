import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const colorList = <Color>[
  Colors.yellow,
  Colors.amber,
  Colors.blue,
  Colors.red,
  Colors.orange,
  Colors.green,
  // Colors.purple,
  // Colors.yellow,
  // Colors.teal,
  // Colors.deepPurple,
  // Colors.pink,
  // Colors.pinkAccent,
];

class AppTheme {
  final int selectedColor;
  final bool isDarkmode;

  AppTheme({
    this.selectedColor = 0,
    this.isDarkmode = true,
  })  : assert(selectedColor >= 0, 'Selected color must be greater then 0'),
        assert(selectedColor < colorList.length,
            'Selected color must be less or equal than ${colorList.length - 1}');

  ThemeData getTheme() => ThemeData(
      useMaterial3: true,
      brightness: isDarkmode ? Brightness.dark : Brightness.light,
      colorSchemeSeed: colorList[selectedColor],
      appBarTheme: const AppBarTheme(centerTitle: false),
      textTheme: GoogleFonts.merriweatherTextTheme().apply(
        bodyColor: isDarkmode ? Colors.white : Colors.black,
        displayColor: isDarkmode ? Colors.white : Colors.black,
      ));

  AppTheme copyWith({int? selectedColor, bool? isDarkmode}) => AppTheme(
        selectedColor: selectedColor ?? this.selectedColor,
        isDarkmode: isDarkmode ?? this.isDarkmode,
      );
}
