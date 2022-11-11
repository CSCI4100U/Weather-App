import 'package:flutter/material.dart';
import 'package:weather_app/views/schedule_update_page.dart';

// TODO Scheduled Weather Updates

class ToolsPage extends StatefulWidget {
  const ToolsPage({Key? key}) : super(key: key);

  @override
  State<ToolsPage> createState() => _ToolsPageState();
}

class _ToolsPageState extends State<ToolsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: (){
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const ScheduleUpdatePage()
                  )
              );
            },
            child: const Text("Schedule Weather Updates")),
      ),
    );
  }
}
