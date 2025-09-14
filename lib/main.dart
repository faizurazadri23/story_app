import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/api/api_services.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/detail_story_provider.dart';
import 'package:story_app/provider/form_story_provider.dart';
import 'package:story_app/provider/password_visibility_provider.dart';
import 'package:story_app/provider/story_list_provider.dart';
import 'package:story_app/ui/my_app.dart';

import 'db/auth_repository.dart';

void main() {
  runApp(MultiProvider(providers: [
    Provider(create: (context) => ApiServices()),
    ChangeNotifierProvider(create: (_) => PasswordVisibilityProvider()),
    ChangeNotifierProvider(create: (context) => AuthProvider(AuthRepository(), context.read<ApiServices>())),
    ChangeNotifierProvider(create: (context) => FormStoryProvider(context.read<ApiServices>())),
    ChangeNotifierProvider(create: (context) => StoryListProvider(context.read<ApiServices>())),
    ChangeNotifierProvider(create: (context) => DetailStoryProvider(context.read<ApiServices>())),

  ], child: MyApp(),));

}
