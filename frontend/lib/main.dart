import 'package:bookie/config/constants/environment.dart';
import 'package:bookie/config/router/app_router.dart';
import 'package:bookie/config/theme/app_theme.dart';
import 'package:bookie/presentation/providers/theme_provider.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  OpenAI.apiKey = Environment.theOpenAIKey;

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
