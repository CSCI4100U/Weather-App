import 'package:flutter/material.dart';

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

Icon generateWeatherIcon(int weatherCode) {
  switch (weatherCode) {
    case 0: // Clear sky
      return const Icon(Icons.sunny);
    case 1:
    case 2:
    case 3: // Partly cloudy
      return const Icon(Icons.wb_cloudy);
    case 45:
    case 48: // Foggy
      return const Icon(Icons.foggy);
    case 51:
    case 53:
    case 55: // Drizzle
      return const Icon(Icons.water_drop_outlined);
    case 61:
    case 63:
    case 65:
    case 66:
    case 67: // Rain
    case 80:
    case 81:
    case 82:
      return const Icon(Icons.water_drop);
    case 71:
    case 73:
    case 75:
    case 77: // Snow
    case 85:
    case 86:
      return const Icon(Icons.snowing);
    case 95:
    case 96:
    case 99: // Thunder
      return const Icon(Icons.thunderstorm);
    default:
      return const Icon(Icons.question_mark);
  }
}