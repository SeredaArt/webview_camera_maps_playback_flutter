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
      home: const MyHomePage(title: 'Elephants Dream'),
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
  double visibility = 0;

  String secondsToString(int secondValue) {
    return secondValue < 10 ? '0$secondValue' : secondValue.toString();
  }

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
          'https://storage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4'),
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
            body: SizedBox(
      height: MediaQuery.sizeOf(context).height,
      child: GestureDetector(
          onTap: () {
            visibility = visibility == 0 ? 1 : 0.0;
            setState(() {});
          },
          child: Stack(children: [
            VideoPlayer(_controller),
            AnimatedOpacity(
                opacity: visibility,
                duration: const Duration(milliseconds: 400),
                child: ColoredBox(
                    color: Colors.black12.withOpacity(0.3),
                    child: Stack(
            children: [
            Align(
            alignment: Alignment.topLeft,
                child: Text(
                  'Elephants Dream',
                  style:
                  TextStyle(color: Colors.white, fontSize: 20),
                )),
            Padding(
                padding:
                const EdgeInsets.only(left: 16, bottom: 16),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Colors.white.withOpacity(0.5),
                    ),
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                Duration currentPosition =
                                    _controller.value.position;
                                Duration targetPosition =
                                    currentPosition +
                                        const Duration(
                                            seconds: -10);
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
                                    currentPosition +
                                        const Duration(seconds: 10);
                                _controller.seekTo(targetPosition);
                              },
                              icon: Icon(Icons.forward_10)),
                        ]),
                  ),
                )),
            Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Slider(
                        max: _controller
                            .value.duration.inMilliseconds
                            .toDouble(),
                        value: _controller
                            .value.position.inMilliseconds
                            .toDouble(),
                        activeColor: Colors.red,
                        inactiveColor: Colors.grey,
                        onChanged: (value) {
                          _controller.seekTo(Duration(
                              milliseconds: value.toInt()));
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                '${_controller.value.position.inMinutes} : ${(secondsToString((_controller.value.position.inSeconds % 60)))}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14)),
                            Text(
                                '${_controller.value.duration.inMinutes} : ${(secondsToString(_controller.value.duration.inSeconds % 60))}',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14))
                          ],
                        ),
                      )
                    ])),
          ],
          )))
          ])),
    )));
  }
}
