import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesKeys {
  final String idToken;

  const SharedPreferencesKeys(this.idToken);
}

Future<SharedPreferencesKeys> getCredentials() async {
  final prefs = await SharedPreferences.getInstance();
  final idToken = prefs.getString('idToken') ?? '';

  return SharedPreferencesKeys(idToken);
}
