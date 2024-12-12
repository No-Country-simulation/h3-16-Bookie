import 'dart:convert';
import 'dart:io';

Future<String> convertImageToBase64(String imagePath) async {
  final bytes = await File(imagePath).readAsBytes();
  return base64Encode(bytes);
}