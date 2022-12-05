import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

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
        title: Text(FlutterI18n.translate(context, "app.title")),
        actions: [
          IconButton(
              onPressed: (){
                weatherBLoC.currentPosition = null;
                weatherBLoC.changedPosition = false;
                Geolocator.getCurrentPosition().then(
                        (Position position) {
                          _mapController.move(
                              LatLng(
                                  position.latitude,
                                  position.longitude
                              ),
                              10
                          );
                        }
                );
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                          FlutterI18n.translate(context, "map.currentlocationsnackbar"),
                          style: const TextStyle(fontSize: 20),
                        )
                    )
                );
              },
              icon: const Icon(Icons.my_location_outlined),
              tooltip: FlutterI18n.translate(context, "map.currentlocationtooltip"),
          )
        ],
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
                center: LatLng(weatherBLoC.currentPosition!.latitude, weatherBLoC.currentPosition!.longitude)
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
          weatherBLoC.loadContent(generateUrl(_mapController.center.latitude, _mapController.center.longitude, weatherBLoC.date)).then(
                  (result) async {
                if (result.runtimeType == SnackBar){
                  ScaffoldMessenger.of(context).showSnackBar(result);
                }
                else{
                  weather = result as Weather;
                  final placemark = await placemarkFromCoordinates(_mapController.center.latitude, _mapController.center.longitude);
                  weatherBLoC.address = "${placemark[0].subThoroughfare} "
                      "${placemark[0].thoroughfare}";
                  weatherBLoC.countryArea = "${placemark[0].administrativeArea} "
                      "${placemark[0].isoCountryCode}";
                  weatherBLoC.currentPosition = Position(
                    latitude: _mapController.center.latitude,
                    longitude: _mapController.center.longitude,
                      timestamp: weatherBLoC.date, accuracy: 100, altitude: 0,
                      heading: 0, speed: 0, speedAccuracy: 0
                  );
                  weatherBLoC.changedPosition = true;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(weatherBLoC.countryArea,
                        style: const TextStyle(fontSize: 20),
                      )
                  ));
                }
              }
          );
        },
        tooltip: FlutterI18n.translate(context, "map.selecttooltip"),
        child: const Icon(
          Icons.check,
          size: 30,
        ),
      ),
    );
  }
}
