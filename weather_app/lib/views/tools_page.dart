import 'package:flutter/material.dart';

// TODO Scheduled Weather Updates

class ToolsPage extends StatefulWidget {
  const ToolsPage({Key? key}) : super(key: key);

  @override
  State<ToolsPage> createState() => _ToolsPageState();
}

class _ToolsPageState extends State<ToolsPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("Tools Page"),
    );
  }
}
