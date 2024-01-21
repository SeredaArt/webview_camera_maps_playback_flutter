import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

class _MyHomePageState extends State<MyHomePage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController? controller;
  XFile? imageFile;

  late TabController _tabController;
  int _currentTabIndex = 0;
  List<String> lastImages = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
    unawaited(initCamera());
  }

  @override
  void disposeState() {
    super.dispose();
    _tabController.dispose();
    controller?.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCameraController(cameraController.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Stack(
            children: [
              controller?.value.isInitialized == true
                  ? Center(
                      child: CameraPreview(controller!),
                    )
                  : const SizedBox(),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: IconButton(
                      onPressed: () async {
                        imageFile = await controller?.takePicture();
                        lastImages.add(imageFile!.path);
                        setState(() {});
                      },
                      icon: const Icon(Icons.camera)))
            ],
          ),
          ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: lastImages.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2.0)),
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height / 4,
                  child: Image.file(
                    File(lastImages[index]),
                    fit: BoxFit.cover,
                  ),
                );
              }),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              _tabController.index = index;
              _currentTabIndex = index;
            });
          },
          currentIndex: _currentTabIndex,
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
              icon: Icon(Icons.camera),
              label: 'Сamera',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.camera),
              label: 'Gallery',
            ),
          ]),

      // )g comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> _initializeCameraController(
      CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller!.dispose();
    }

    final CameraController cameraController = CameraController(
      cameraDescription,
      kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,
      enableAudio: true,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    controller = cameraController;

    cameraController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  Future<void>? initCamera() async {
    var cameras = await availableCameras();

    controller = CameraController(cameras[0], ResolutionPreset.max);

    await controller!.initialize();

    setState(() {});
  }
}
