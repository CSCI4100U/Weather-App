import 'package:flutter/material.dart';
import 'weather_from_url.dart';

// TODO
// Register and Sign In
// Validating Sign In Information From Cloud Storage
// Return Settings Object of User Settings After Sign In

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Sign In"),
    );
  }
}
