import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  GoogleMapController? _controller;
  double sliderValue = 1;

  static const CameraPosition _coordGoogle = CameraPosition(
      target: LatLng(43.887709263406045, 144.05816632323334), zoom: 14.45);

  @override
  void disposeState() {
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          GoogleMap(
            initialCameraPosition: _coordGoogle,
            onMapCreated: (controller) {
              _controller = controller;
            },
          ),
          Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.white.withOpacity(0.5),
                  ),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(
                        onPressed: () {
                          _controller?.animateCamera(
                              CameraUpdate.newLatLng(_coordGoogle.target));
                        },
                        icon: Icon(Icons.home)),
                    IconButton(
                        onPressed: () {
                          _controller?.animateCamera(CameraUpdate.zoomIn());
                        },
                        icon: Icon(Icons.zoom_in)),
                    IconButton(
                        onPressed: () {
                          _controller?.animateCamera(CameraUpdate.zoomOut());
                        },
                        icon: Icon(Icons.zoom_out)),
                  ]),
                ),
              )),
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.white.withOpacity(0.8),
                    width: 200,
                    height: 40,
                    child: Slider(
                      min: 1,
                      max: 50,
                      value: sliderValue,
                      activeColor: Colors.red,
                      inactiveColor: Colors.grey,
                      onChanged: (value) {
                        setState(() {
                          sliderValue = value;
                        });
                        _controller?.animateCamera(CameraUpdate.zoomTo(value));
                      },
                    ),
                  ))),
        ]),
      ),
    );
  }
}
