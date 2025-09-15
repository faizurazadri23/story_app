import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/data/api/api_services.dart';
import 'package:story_app/provider/SharedPreferencesProvider.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/camera_provider.dart';
import 'package:story_app/provider/detail_story_provider.dart';
import 'package:story_app/provider/form_story_provider.dart';
import 'package:story_app/provider/password_visibility_provider.dart';
import 'package:story_app/provider/story_list_provider.dart';
import 'package:story_app/provider/theme_provider.dart';
import 'package:story_app/ui/my_app.dart';
import 'package:story_app/utils/service/remote_config_service.dart';
import 'package:story_app/utils/service/shared_preference_service.dart';

import 'db/auth_repository.dart';
import 'firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final prefs = await SharedPreferences.getInstance();
  final sharedPreferencesService = SharedPreferenceService(prefs);
  await RemoteConfigService().init();
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => ApiServices()),
        Provider(create: (context) => SharedPreferenceService(prefs)),
        ChangeNotifierProvider(
          create: (context) => SharedPreferencesProvider(
            context.read<SharedPreferenceService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(sharedPreferencesService),
        ),
        ChangeNotifierProvider(create: (_) => PasswordVisibilityProvider()),
        ChangeNotifierProvider(
          create: (context) =>
              AuthProvider(AuthRepository(), context.read<ApiServices>()),
        ),
        ChangeNotifierProvider(
          create: (context) => FormStoryProvider(context.read<ApiServices>()),
        ),
        ChangeNotifierProvider(
          create: (context) => StoryListProvider(context.read<ApiServices>()),
        ),
        ChangeNotifierProvider(
          create: (context) => DetailStoryProvider(context.read<ApiServices>()),
        ),
      ],
      child: MyApp(),
    ),
  );
}
