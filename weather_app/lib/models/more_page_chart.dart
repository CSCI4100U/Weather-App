import 'package:flutter/material.dart';
import 'package:charts_flutter_new/flutter.dart' as charts;
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:intl/intl.dart';

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
    String unit = weather!.getWeatherUnit(index);
    String name = FlutterI18n
        .translate(context, "more.${settings.settingNames[index]}");

    List<DataTime> data = [];

    for (int i=0; i<weatherDetails.length; ++i) {
      data.add(DataTime(
        data: double.tryParse(weatherDetails[i]) ?? 0.0,
        time: DateTime.parse(dateTimes[i]),
      ));
    }

    List<Widget> page = [
      SizedBox(
        height: 200,
        width: 300,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child:
            //CHART
            SizedBox(
              height: 200,
              width: 9600,
              child: charts.TimeSeriesChart(
                [
                  charts.Series<DataTime, DateTime>(
                    id: "$name ${FlutterI18n.translate(context, "more.data")}",
                    colorFn: (_,__) => charts.MaterialPalette.blue.shadeDefault,
                    domainFn: (dt,_) => dt.time,
                    measureFn: (dt,_) => dt.data,
                    data: data,
                  )
                ],
                animate: false,
                defaultRenderer: charts.LineRendererConfig(
                    includePoints: true
                ),
                dateTimeFactory: const charts.LocalDateTimeFactory(),
                domainAxis: charts.DateTimeAxisSpec(
                  tickFormatterSpec: const charts.AutoDateTimeTickFormatterSpec(

                    hour: charts.TimeFormatterSpec(
                      format: 'HH:00',
                      transitionFormat: 'E d H:00',
                    ),
                  ),
                  tickProviderSpec: charts.StaticDateTimeTickProviderSpec(
                    data.map((e) => charts.TickSpec(e.time)).toList()
                  )
                ),
                primaryMeasureAxis: const charts.NumericAxisSpec(
                  renderSpec: charts.NoneRenderSpec()
                ),
                behaviors: [
                  charts.RangeAnnotation(data.map(
                    (e) => charts.LineAnnotationSegment(
                      DateTime(
                          e.time.year,
                          e.time.month,
                          e.time.day,
                          e.time.hour
                      ),
                      charts.RangeAnnotationAxisType.domain,
                      startLabel: '${e.data}$unit'
                    ),
                  ).toList()),
                ],
              ),
            ),
        ),
      ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text(
                FlutterI18n.translate(context, "more.time"),
                style: const TextStyle(fontStyle: FontStyle.italic),
              )),
            DataColumn(label: Text(name, style:
              const TextStyle(fontStyle: FontStyle.italic))),
          ],
          rows: data.map(
              (e) => DataRow(cells: [
                DataCell(Text(
                    // (e.time.hour == 0)
                    DateFormat("E d H:00", "en").format(e.time)
                    // : DateFormat("HH:mm").format(e.time)
                )),
                DataCell(Text("${e.data.toString()}$unit")),
              ])
          ).toList()
        ),
      ),
    ];


    return SizedBox( // do not remove container (for dialog)
        height: 400,
        width: 400,
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
