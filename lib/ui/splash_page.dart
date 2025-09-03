import 'package:flutter/material.dart';

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
    Future.delayed(Duration(seconds: 3), () {
      widget.onFinish();
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
