import "package:flutter/material.dart";

class WeatherPreviewPage extends StatefulWidget {
  const WeatherPreviewPage({Key? key}) : super(key: key);

  @override
  State<WeatherPreviewPage> createState() => _WeatherPreviewPageState();
}

class _WeatherPreviewPageState extends State<WeatherPreviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather App"),
      ),
      // body: FlutterMap,
    );
  }
}
