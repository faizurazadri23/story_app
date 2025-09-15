import 'package:flutter/material.dart';
import 'package:story_app/utils/styles/colors/story_colors.dart';
import 'package:story_app/utils/styles/typography/story_text_styles.dart';

class StoryTheme {
  static TextTheme get _textTheme {
    return TextTheme(
      displayLarge: StoryTextStyles.displayLarge,
      displayMedium: StoryTextStyles.displayMedium,
      displaySmall: StoryTextStyles.displaySmall,
      headlineLarge: StoryTextStyles.headLineLarge,
      headlineMedium: StoryTextStyles.headlineMedium,
    );
  }

  static AppBarTheme get _appBarTheme {
    return AppBarTheme(toolbarTextStyle: _textTheme.titleLarge);
  }

  static ThemeData get lightTheme {
    return ThemeData(
      colorSchemeSeed: StoryColors.blue.color,
      brightness: Brightness.light,
      textTheme: _textTheme,
      useMaterial3: true,
      appBarTheme: _appBarTheme,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorSchemeSeed: StoryColors.blue.color,
      brightness: Brightness.dark,
      textTheme: _textTheme,
      useMaterial3: true,
      appBarTheme: _appBarTheme,
    );
  }
}
