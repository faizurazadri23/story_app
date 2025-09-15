import 'package:flutter/material.dart';
enum StoryColors{
  blue("Blue", Colors.deepPurple);

  const StoryColors(this.name, this.color);

  final String name;
  final Color color;
}