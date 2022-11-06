import 'package:flutter/material.dart';
import 'package:weather_app/account_page.dart';

// TODO
// Current Weather
// Weather For 6 Hours In Advance

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    List<Widget> page = _generateHomePage();
    return Scaffold(
      body: ListView.separated(
        separatorBuilder: (context, index) {
          return const SizedBox(height: 8);
        },
        itemCount: page.length,
        itemBuilder: (context, index) {
          return page[index];
        }
      ),
    );
  }

  _generateHomePage() {
    return [
      // TODO: Stack image of weather type?
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            "90""°",
            style: TextStyle(
                fontSize: 80
            ),
          ),
          Icon(
            Icons.sunny,
            size: 50,
            color: Colors.yellow,
          ),
        ],
      ),
      const Center(child: Text("Feels like 80°")),
      const Center(child: Text("High: 100°      Low: 40°")),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("5 PM"),
              Icon(Icons.sunny),
              Text("90°"),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("5 PM"),
              Icon(Icons.sunny),
              Text("90°"),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("5 PM"),
              Icon(Icons.sunny),
              Text("90°"),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("5 PM"),
              Icon(Icons.sunny),
              Text("90°"),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("5 PM"),
              Icon(Icons.sunny),
              Text("90°"),
            ],
          ),
        ],
      ),
    ];
  }
}
