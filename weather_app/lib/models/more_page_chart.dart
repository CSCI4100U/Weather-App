import 'package:flutter/material.dart';
import 'package:charts_flutter_new/flutter.dart' as charts;

import '../views/settings_page.dart';

class MorePageChart extends StatelessWidget {
  const MorePageChart({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    List weatherDetails = weather!.getWeatherDetails(index)
        .map((e) => e.toString()).toList();
    List dateTimes = weather!.times!
        .map((e) => e.toString()).toList();

    List<DataTime> data = [];

    for (int i=0; i<weatherDetails.length; ++i) {
      data.add(DataTime(
        data: double.tryParse(weatherDetails[i]) ?? 0.0,
        time: DateTime(
            int.tryParse(dateTimes[i].substring(0,4))!,
            int.tryParse(dateTimes[i].substring(5,7))!,
            int.tryParse(dateTimes[i].substring(8,10))!,
            int.tryParse(dateTimes[i].substring(11,13))!,
            int.tryParse(dateTimes[i].substring(14))!,
        ),
      ));
    }

    List<Widget> page = [
      SizedBox(
        height: 200,
        width: 300,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            //CHART
            SizedBox(
              height: 200,
              width: 2400,
              child: charts.TimeSeriesChart(
                [
                  charts.Series<DataTime, DateTime>(
                    id: "${settings.settingNames[index]} Data",
                    colorFn: (_,__) => charts.MaterialPalette.blue.shadeDefault,
                    domainFn: (dt,_) => dt.time,
                    measureFn: (dt,_) => dt.data,
                    data: data,
                  )
                ],
                animate: true,
                defaultRenderer: charts.LineRendererConfig(
                    includePoints: true
                ),
              ),
            ),
            //TABLE
          ],
        ),
      ),
    ];


    return SizedBox( // do not remove container (for dialog)
        height: 400,
        width: 300,
        child: ListView.separated(
            separatorBuilder: (context, i) {
              return const SizedBox(height: 8);
            },
            itemCount: page.length,
            itemBuilder: (context, i) {
              return page[i];
            }
        )
    );
  }
}

class DataTime {
  double data;
  DateTime time;

  DataTime({
    required this.data,
    required this.time,
  });
}
