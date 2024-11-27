import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String theOpenAIKey = dotenv.env['OPEN_AI_API_KEY'] ?? '';
  static String theAuth0Domain = dotenv.env['AUTH0_DOMAIN'] ?? '';
  static String theAuth0ClientId = dotenv.env['AUTH0_CLIENT_ID'] ?? '';
  static String theUrlDeployBackend = dotenv.env['URL_DEPLOY_BACKEND'] ?? '';
  static String theGoogleMapsApiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
}
