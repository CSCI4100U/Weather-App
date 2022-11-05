import 'package:flutter/material.dart';

// TODO
// User Selecting Weather Information Stored In Settings Object
// Fetching Information
// Return Weather Info In Weather Object

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Settings"),
    );
  }
}

