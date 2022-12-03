import 'package:flutter/material.dart';

class WeatherDownload extends StatefulWidget {
  const WeatherDownload({Key? key}) : super(key: key);

  @override
  State<WeatherDownload> createState() => _WeatherDownloadState();
}

class _WeatherDownloadState extends State<WeatherDownload> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text("Store Weather Data"),
        ),
      body: Text("Select"),
    );
  }
}
