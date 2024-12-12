import 'package:translator/translator.dart';

Future<Translation> translateGoogle(
    {required String language, required String text}) async {
  try {
    final translator = GoogleTranslator();

    final translation = await translator.translate(text, to: language);

    return translation;
  } catch (e) {
    rethrow;
  }
}
