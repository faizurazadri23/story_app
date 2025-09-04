import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/api/api_services.dart';
import 'package:story_app/provider/PasswordVisibilityProvider.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/ui/my_app.dart';

import 'db/auth_repository.dart';

void main() {
  final authRepository = AuthRepository(ApiServices());
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider(authRepository)),
    ChangeNotifierProvider(create: (_) => PasswordVisibilityProvider()),
  ], child: MyApp(),));

}
