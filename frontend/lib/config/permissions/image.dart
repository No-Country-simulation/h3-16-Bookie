import 'package:permission_handler/permission_handler.dart';

Future<bool> requestPermissions() async {
  final status = await Permission.camera.request();
  if (status.isGranted) {
    return true;
  } else if (status.isDenied || status.isPermanentlyDenied) {
    openAppSettings(); // Redirige al usuario a la configuración de la app
    return false;
  }
  return false;
}
