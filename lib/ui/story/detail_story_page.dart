import 'package:flutter/material.dart';

class DetailStoryPage extends StatefulWidget {
  final String id;

  const DetailStoryPage({super.key, required this.id});

  @override
  State<DetailStoryPage> createState() => _StateDetailStory();
}

class _StateDetailStory extends State<DetailStoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Story')),
      body: Center(child: Text('Detail Story')),
    );
  }
}
