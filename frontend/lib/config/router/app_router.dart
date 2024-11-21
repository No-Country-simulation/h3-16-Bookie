import 'package:bookie/presentation/screens/history_screen.dart';
import 'package:bookie/presentation/screens/home_screen.dart';
import 'package:bookie/presentation/screens/login_screen.dart';
import 'package:bookie/presentation/screens/register_screen.dart';
import 'package:bookie/presentation/screens/splash_screen.dart';
import 'package:bookie/presentation/views/settings/settings_profile_screen.dart';
import 'package:bookie/presentation/views/settings/settings_theme_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/splash', // Ruta inicial
  routes: [
    GoRoute(path: "/splash", builder: (context, state) => const SplashScreen()),
    GoRoute(path: "/login", builder: (context, state) => LoginScreen()),
    GoRoute(path: "/register", builder: (context, state) => RegisterScreen()),
    // Ruta principal de HomeScreen
    GoRoute(
      path: '/home/:page', // Ruta dinámica para cambiar de pantalla
      name: HomeScreen.name,
      builder: (context, state) {
        final pageIndex = int.parse(state.pathParameters['page'] ?? '0');
        return HomeScreen(pageIndex: pageIndex);
      },
      routes: [
        GoRoute(
            path: 'profile',
            name: SettingsProfileScreen.name,
            builder: (context, state) => const SettingsProfileScreen()),
        GoRoute(
          path: 'theme',
          name: SettingsThemeScreen.name,
          builder: (context, state) => const SettingsThemeScreen(),
        ),
      ],
    ),

    // Ruta para ver la información de un card específico
    GoRoute(
      path: '/history/:id', // Ruta dinámica con el parámetro 'id'
      name: HistoryScreen.name,
      builder: (context, state) {
        final cardId = state.pathParameters['id'] ?? '';
        return HistoryScreen(cardId: cardId); // Pasa el id al HistoryScreen
      },
    ),

    // Ruta de redirección para '/' hacia '/home/0'
    GoRoute(
      path: '/',
      redirect: (_, __) => '/home/0', // Redirige a la primera página
    ),
  ],
);
