import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesKeys {
  static const String _nameKey = 'name';
  static const String _emailKey = 'email';
  static const String _idKey = 'id';
  static const String _idTokenKey = 'idToken';

  // Función para obtener las credenciales almacenadas
  static Future<SharedPrefencesFields> getCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    return SharedPrefencesFields(
      name: prefs.getString(_nameKey) ?? '',
      email: prefs.getString(_emailKey) ?? '',
      id: prefs.getString(_idKey) ?? '',
      idToken: prefs.getString(_idTokenKey) ?? '',
    );
  }

  // Función para guardar las credenciales
  static Future<void> saveCredentials(SharedPrefencesFields credentials) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_idKey, credentials.id ?? '');
    await prefs.setString(_nameKey, credentials.name ?? '');
    await prefs.setString(_emailKey, credentials.email ?? '');
    await prefs.setString(_idTokenKey, credentials.idToken ?? '');
  }

  // Función para limpiar las credenciales
  static Future<void> clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_idKey);
    await prefs.remove(_nameKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_idTokenKey);
  }
}

class SharedPrefencesFields {
  String? name;
  String? email;
  String? id;
  String? idToken;

  SharedPrefencesFields({
    this.name,
    this.email,
    this.id,
    this.idToken,
  });
}
