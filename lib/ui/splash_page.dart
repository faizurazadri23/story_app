import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';

class SplashPage extends StatefulWidget {
  final VoidCallback onFinish;

  const SplashPage({super.key, required this.onFinish});

  @override
  State<SplashPage> createState() => _StateSplash();
}

class _StateSplash extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      authProvider.checkLogin();

      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          widget.onFinish();
          final loggedIn = context.read<AuthProvider>().isLoggedIn;
          if(loggedIn){
            context.go('/story');
          }else{
            context.go('/login');
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/logo_app.png',
          width: 100,
          height: 100,
        ),
      ),
    );
  }
}
