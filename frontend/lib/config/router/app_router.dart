import 'package:bookie/presentation/screens/login_register_screen.dart';
import 'package:bookie/presentation/screens/story_map_screen.dart';
import 'package:bookie/presentation/screens/story_screen.dart';
import 'package:bookie/presentation/screens/home_screen.dart';
import 'package:bookie/presentation/screens/splash_screen.dart';
import 'package:bookie/presentation/screens/writer_screen.dart';
import 'package:bookie/presentation/views/chapter/chapter_form.dart';
import 'package:bookie/presentation/views/chapter/chapter_sucess.dart';
import 'package:bookie/presentation/views/chapter/view/chapters_view_story.dart';
import 'package:bookie/presentation/views/map/chapter/map_chapter.dart';
import 'package:bookie/presentation/views/settings/settings_profile_screen.dart';
import 'package:bookie/presentation/views/settings/settings_theme_screen.dart';
import 'package:bookie/presentation/views/story/create_form_story_screen.dart';
import 'package:bookie/presentation/views/story/edit_story_view_chapters.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  // initialLocation: '/chapters/view/138/0', // Ruta inicial
  initialLocation: "/splash", // Ruta inicial
  routes: [
    GoRoute(path: "/splash", builder: (context, state) => const SplashScreen()),
    GoRoute(
        path: "/login", builder: (context, state) => LoginOrRegisterScreen()),
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
          builder: (context, state) {
            final extra = state.extra as Map?;

            final userId = extra?['userId'] ?? 0;

            return SettingsProfileScreen(
              writerId: userId,
            );
          },
        ),
        GoRoute(
          path: 'theme',
          name: SettingsThemeScreen.name,
          builder: (context, state) => const SettingsThemeScreen(),
        ),
      ],
    ),

    GoRoute(
      // path: 'form-story',
      path: '/story/create',
      name: CreateFormStoryScreen.name,
      builder: (context, state) => const CreateFormStoryScreen(),
    ),

    // Ruta para modificar historia, detalles y capítulos
    GoRoute(
      path: '/story/edit/:storyId', // Ruta dinámica con el parámetro 'id'
      name: StoryEditDetailChaptersPage.name,
      builder: (context, state) {
        final storyId = int.parse(state.pathParameters['storyId'] ?? '0');
        return StoryEditDetailChaptersPage(
            storyId: storyId); // Lo pasamos al componente
      },
    ),
    // view chapter
    GoRoute(
      path: '/chapters/view/:storyId/:chapterIndex',
      name: ChaptersViewStory.name,
      builder: (context, state) {
        final storyId = int.parse(state.pathParameters['storyId'] ?? '0');
        final chapterIndex =
            int.parse(state.pathParameters['chapterIndex'] ?? '0');
        return ChaptersViewStory(
            storyId: storyId,
            chapterIndex: chapterIndex); // Lo pasamos al componente
      },
      routes: [
        GoRoute(
          path: 'map',
          name: MapChapter.name,
          builder: (context, state) => const MapChapter(),
        ),
      ],
    ),
    GoRoute(
      // path: '/form-chapter/:storyId',
      path: '/chapter/create/:storyId',
      name: CreateChapterScreen.name,
      builder: (context, state) {
        final storyId = int.parse(state.pathParameters['storyId'] ?? '0');

        return CreateChapterScreen(
          storyId: storyId,
        ); // Lo pasamos al componente
      },
      routes: [
        GoRoute(
            path: 'edit/:chapterId',
            name: '${CreateChapterScreen.name}-edit',
            builder: (context, state) {
              final storyId = int.parse(state.pathParameters['storyId'] ?? '0');
              final chapterId =
                  int.parse(state.pathParameters['chapterId'] ?? '0');

              final extra = state.extra
                  as Map?; // Esto recupera los parámetros adicionales de la ruta (como 'title' y 'content')

              final String titleMod = extra?['title'] ??
                  ''; // Usar un valor por defecto si no existe
              final String contentMod = extra?['content'] ?? '';
              final bool edit = extra?['edit'] ?? false;

              return CreateChapterScreen(
                storyId: storyId,
                chapterId: chapterId,
                titleMod: titleMod,
                contentMod: contentMod,
                edit: edit,
              );
            }),
      ],
    ),
    // sucess page create chapter
    GoRoute(
      path: '/chapter/success/:storyId/:chapterIndex',
      name: ChapterSuccess.name,
      builder: (context, state) {
        final storyId = int.parse(state.pathParameters['storyId'] ?? '0');
        final chapterIndex =
            int.parse(state.pathParameters['chapterIndex'] ?? '0');
        return ChapterSuccess(
          storyId: storyId,
          chapterIndex: chapterIndex,
        );
      },
    ),

    // Ruta para ver la información de una historia específica
    GoRoute(
      path: '/story/:id', // Ruta dinámica con el parámetro 'id'
      name: StoryScreen.name,
      builder: (context, state) {
        final storyId = state.pathParameters['id'] ?? '';
        return StoryScreen(
            storyId: int.parse(storyId)); // Pasa el id al HistoryScreen
      },
      routes: [
        GoRoute(
          path: 'map',
          name: StoryMapScreen.name,
          builder: (context, state) => const StoryMapScreen(),
        ),
      ],
    ),

    // Ruta para ver la información de un writer específico
    GoRoute(
      path: '/writer/:writerId', // Ruta dinámica con el parámetro 'id'
      name: WriterProfileScreen.name,
      builder: (context, state) {
        final writerId = state.pathParameters['writerId'] ?? '';
        return WriterProfileScreen(
            writerId: int.parse(writerId)); // Pasa el id al ProfileScreen
      },
    ),

    // Ruta de redirección para '/' hacia '/home/0' si no existe la ruta
    GoRoute(
      path: '/',
      redirect: (_, __) => '/home/0', // Redirige a la primera página
    ),
  ],
);
