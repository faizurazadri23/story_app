import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/ui/splash_page.dart';
import 'package:story_app/ui/story/detail_story_page.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      refreshListenable: context.read<AuthProvider>(),
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) =>
              SplashPage(onFinish:  context.read<AuthProvider>().finishSplash,),
        ),
        GoRoute(path: '/login', builder: (context, state) => LoginPage(onLogin: () {

        },onRegister: () {
           context.push('/register');
        },)),
        GoRoute(path: '/register', builder: (context, state) => RegisterPage()),
        GoRoute(path: '/story', builder: (context, state) => StoryPage()),
        GoRoute(path: '/profile', builder: (context, state) => ProfilePage()),
        GoRoute(
          path: '/detail',
          builder: (context, state) => DetailStoryPage(),
        ),
      ],
      initialLocation: '/splash',
      redirect: (context, state) {
        final splashDone = context.read<AuthProvider>().isSplashDone;
        final loggedIn = context.read<AuthProvider>().isLoggedIn;
        final current = state.matchedLocation;

        print("Check login ${loggedIn}");
        if (!splashDone && current != '/splash') return '/splash';

        if (splashDone && !loggedIn && current != '/login' && current != '/register') {
          return '/login';
        }

        if (splashDone &&
            loggedIn &&
            (current == '/login' || current == '/splash')) {
          return '/story';
        }

        return null;
      },
    );
    return MaterialApp.router(
      title: 'Narrato',
      routerConfig: router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}
