import 'package:bookie/config/constants/environment.dart';
import 'package:bookie/config/router/app_router.dart';
import 'package:bookie/config/theme/app_theme.dart';
import 'package:bookie/presentation/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');

  MapboxOptions.setAccessToken(Environment.theMapboxToken);

  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppTheme appTheme = ref.watch(themeNotifierProvider);

    return MaterialApp.router(
      routerConfig: appRouter,
      title: 'Bookie',
      debugShowCheckedModeBanner: false,
      theme: appTheme.getTheme(),
    );
  }
}
