import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/camera_provider.dart';
import 'package:story_app/provider/theme_provider.dart';
import 'package:story_app/ui/camera_page.dart';
import 'package:story_app/ui/splash_page.dart';
import 'package:story_app/ui/story/detail_story_page.dart';
import 'package:story_app/ui/story/form_story_page.dart';
import 'package:story_app/ui/story/story_page.dart';
import 'package:story_app/ui/user/login_page.dart';
import 'package:story_app/ui/user/profile_page.dart';
import 'package:story_app/ui/user/register_page.dart';
import 'package:story_app/utils/styles/theme/story_theme.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _StateMyApp();
}

class _StateMyApp extends State<MyApp> {
  late final GoRouter router;

  @override
  void initState() {
    super.initState();
    router = GoRouter(
      refreshListenable: context.read<AuthProvider>(),
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) =>
              SplashPage(onFinish: context.read<AuthProvider>().finishSplash),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => LoginPage(
            onLogin: () {},
            onRegister: () {
              context.push('/register');
            },
          ),
        ),
        GoRoute(path: '/register', builder: (context, state) => RegisterPage()),
        GoRoute(
          path: '/story',
          builder: (context, state) => StoryPage(
            onLogout: () async {
              final statusLogin = await context.read<AuthProvider>().logout();
              if (!statusLogin && context.mounted) {
                context.go('/login');
              }
            },
          ),
        ),
        GoRoute(
          path: '/story/form',
          builder: (context, state) => FormStoryPage(),
        ),
        GoRoute(
          path: '/story/detail',
          builder: (context, state) {
            return DetailStoryPage(id: state.extra as String);
          },
        ),
        GoRoute(path: '/profile', builder: (context, state) => ProfilePage()),
        GoRoute(
          path: '/camera',
          builder: (context, state) {
            return FutureBuilder<List<CameraDescription>>(future: availableCameras(), builder: (context, snapshot) {
              if(!snapshot.hasData){
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              final cameras = snapshot.data!;
              return ChangeNotifierProvider(create: (_) => CameraProvider(cameras),child: CameraPage(),);
            },);
          },
        ),
      ],
      initialLocation: '/splash',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, value, child) {
        return MaterialApp.router(
          title: 'Narrato',
          routerConfig: router,
          darkTheme: _buildTheme(themeData: StoryTheme.darkTheme),
          theme: _buildTheme(themeData: StoryTheme.lightTheme),
          themeMode: value.selectedThemeMode,
        );
      },
    );
  }

  ThemeData _buildTheme({required ThemeData themeData}) {
    return themeData.copyWith(
      textTheme: GoogleFonts.aBeeZeeTextTheme(themeData.textTheme),
    );
  }
}
