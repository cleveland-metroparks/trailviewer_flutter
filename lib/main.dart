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

final trailviewer = GlobalKey<TrailViewerBaseState>();

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: zooDarkGreen,
            title: const Text("TrailView Flutter"),
            actions: [
              IconButton(
                  onPressed: () async {
                    trailviewer.currentState
                        ?.goToImageId("e1df43ce85ff48bd98c5faf06cae42f1");
                  },
                  icon: const Icon(Icons.compare_arrows_rounded))
            ]),
        body: TrailViewerBase(
          key: trailviewer,
          onImageChange: (image) {
            print(image.id);
          },
        ));
  }
}
