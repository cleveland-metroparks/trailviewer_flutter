import 'package:flutter/material.dart';
import 'package:trailviewer_flutter/common.dart';
import 'package:trailviewer_flutter/trailviewer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrailView Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: zooDarkGreen),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: zooDarkGreen,
          title: const Text("TrailView Flutter"),
        ),
        body: const TrailViewerBase());
  }
}
