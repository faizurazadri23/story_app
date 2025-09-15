import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/ui/camera_page.dart';
import 'package:story_app/ui/splash_page.dart';
import 'package:story_app/ui/story/detail_story_page.dart';
import 'package:story_app/ui/story/form_story_page.dart';
import 'package:story_app/ui/story/story_page.dart';
import 'package:story_app/ui/user/login_page.dart';
import 'package:story_app/ui/user/profile_page.dart';
import 'package:story_app/ui/user/register_page.dart';

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
        GoRoute(path: '/story', builder: (context, state) => StoryPage(onLogout: () async {
          final statusLogin = await context.read<AuthProvider>().logout();
          if (!statusLogin && context.mounted) {
            context.go('/login');
          }
        },)),
        GoRoute(
          path: '/story/form',
          builder: (context, state) => FormStoryPage(),
        ),
        GoRoute(
          path: '/story/detail',
          builder: (context, state){
            return DetailStoryPage(id: state.extra as String);
          },
        ),
        GoRoute(path: '/profile', builder: (context, state) => ProfilePage()),
        GoRoute(path: '/camera',builder: (context, state) {
          return CameraPage(cameras: state.extra as List<CameraDescription>);
        }),
      ],
      initialLocation: '/splash',
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Narrato',
      routerConfig: router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}
