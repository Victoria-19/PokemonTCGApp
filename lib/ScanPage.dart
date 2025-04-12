import 'package:camera/camera.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ScanPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const ScanPage(this.cameras, {super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();

}

class _ScanPageState extends State<ScanPage> {
  late CameraController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.cameras[0], ResolutionPreset.medium);
    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    });
  }
}

@override 
void dispose() {
  _controller.dispose();
  super.dispose();
}

@override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) return Container();

    return Scaffold(
      appBar: AppBar(title: Text("Scan Pokémon Card")),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: CameraPreview(_controller),
          ),
          ElevatedButton(
            onPressed: () async {
              final XFile file = await _controller.takePicture();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OCRPage(imagePath: file.path),
                ),
              );
            },
            child: Text("Scan Card"),
          ),
        ],
      ),
    );
  }
