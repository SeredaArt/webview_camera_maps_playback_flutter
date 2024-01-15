import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late VideoPlayerController _controller;
  bool paused = true;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
          'https://storage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4'),
      // closedCaptionFile: _loadCaptions(),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    _controller.addListener(() {
      setState(() {});
    });

    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
  }

  @override
  void disposeState() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SizedBox(
          height: MediaQuery.sizeOf(context).height,
          child: Stack(
            children: [
              VideoPlayer(_controller),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: VideoProgressIndicator(_controller,
                      allowScrubbing: true)),
              Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 16),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: Colors.white.withOpacity(0.5),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        IconButton(
                            onPressed: () {
                              Duration currentPosition =
                                  _controller.value.position;
                              Duration targetPosition = currentPosition +
                                  const Duration(seconds: -10);
                              _controller.seekTo(targetPosition);
                            },
                            icon: Icon(Icons.replay_10)),
                        IconButton(
                            onPressed: () {
                              _controller.value.isPlaying
                                  ? _controller.pause()
                                  : _controller.play();
                            },
                            icon: _controller.value.isPlaying
                                ? Icon(Icons.pause)
                                : Icon(Icons.play_arrow)),
                        IconButton(
                            onPressed: () {
                              Duration currentPosition =
                                  _controller.value.position;
                              Duration targetPosition =
                                  currentPosition + const Duration(seconds: 10);
                              _controller.seekTo(targetPosition);
                            },
                            icon: Icon(Icons.forward_10)),
                      ]),
                    ),
                  )),
            ],
          )),

      // )g comma makes auto-formatting nicer for build methods.
    ));
  }
}
