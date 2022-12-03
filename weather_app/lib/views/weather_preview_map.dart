import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/views/weather_preview_page.dart';

import '../models/Weather.dart';
import '../utility/weather_from_url.dart';

class WeatherPreviewMap extends StatefulWidget {
  const WeatherPreviewMap({Key? key}) : super(key: key);

  @override
  State<WeatherPreviewMap> createState() => _WeatherPreviewMapState();
}

class _WeatherPreviewMapState extends State<WeatherPreviewMap> {
  static String mapBoxAccessToken = "pk.eyJ1IjoiYWxkZW5jaCIsImEiOiJjbGFsZjByMTgwNHUwM3JxcmF3MmU0Mml2In0.B_r22ZMZ5ICZ-0LYq0Obrg";
  static const String mapBoxStyleID = "https://api.mapbox.com/styles/v1/aldench/cla65x0sy000d14o6vvn53m1e/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYWxkZW5jaCIsImEiOiJjbGE2NXE2bHEwZmtvM25wdDFwY2JyYmg1In0.Vsmh8e1g__H62vpjlMpUxQ";
  String address = "Loading Address";
  String countryArea = "";
  MapController _mapController = MapController();
  Weather? weather;

  @override
  Widget build(BuildContext context) {
    WeatherBLoC weatherBLoC = context.watch<WeatherBLoC>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
      ),
      body:
      Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
                minZoom: 5,
                maxZoom: 15,
                zoom: 10,
                center: LatLng(weatherBLoC!.currentPosition!.latitude, weatherBLoC!.currentPosition!.longitude)
            ),
            layers: [
              TileLayerOptions(
                  urlTemplate: mapBoxStyleID,
                  additionalOptions: {
                    "mapStyleId" : mapBoxStyleID,
                    "accessToken" : mapBoxAccessToken
                  }
              )
            ],
          ),
          const Center(
            child: Icon(
              Icons.adjust,
              size: 40,
              color: Colors.teal,
            ),
          )

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          loadContent(generateUrl(_mapController.center.latitude, _mapController.center.longitude, DateTime.now())).then(
                  (result) async {
                if (result.runtimeType == SnackBar){
                  ScaffoldMessenger.of(context).showSnackBar(result);
                }
                else{
                  weather = result as Weather;
                  final placemark = await placemarkFromCoordinates(_mapController.center.latitude, _mapController.center.longitude);
                  setState(() {
                    address = "${placemark[0].subThoroughfare} "
                        "${placemark[0].thoroughfare}";
                    countryArea = "${placemark[0].administrativeArea} "
                        "${placemark[0].isoCountryCode}";
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WeatherPreviewPage(
                            address: this.address,
                            countryArea: this.countryArea,
                            weather: this.weather,
                          )
                      )
                  );
                }
              }
          );
        },
        child: const Icon(
          Icons.check,
          size: 30,
        ),
        tooltip: "View This Locations Weather",
      ),
    );
  }
}
