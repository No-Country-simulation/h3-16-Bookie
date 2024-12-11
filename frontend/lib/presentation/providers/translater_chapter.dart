import 'package:bookie/config/translator/translator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PageContentNotifier extends StateNotifier<String> {
  PageContentNotifier() : super('');

  // Actualizar el contenido traducido
  void updatePageContent(String newContent) {
    state = newContent;
  }

  // Reiniciar el estado
  void reset() {
    state = '';
  }

  // Método para traducir el contenido y actualizar el estado
  Future<void> translateContent(
      String originalContent, String targetLanguage) async {
    try {
      final translation = await translateGoogle(
          language: targetLanguage, text: originalContent);
      state = translation.text;
    } catch (e) {
      // Aquí puedes manejar el error según tus necesidades
    }
  }
}

final pageContentProvider =
    StateNotifierProvider<PageContentNotifier, String>((ref) {
  return PageContentNotifier();
});
