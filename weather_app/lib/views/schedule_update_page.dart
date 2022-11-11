import 'package:flutter/material.dart';

class ScheduleUpdatePage extends StatefulWidget {
  const ScheduleUpdatePage({Key? key}) : super(key: key);

  @override
  State<ScheduleUpdatePage> createState() => _ScheduleUpdatePageState();
}

class _ScheduleUpdatePageState extends State<ScheduleUpdatePage> {
  List<String> weekdays = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
  String? dropdownValue;

  TimeOfDayFormat timeFormat = TimeOfDayFormat.h_colon_mm_space_a;
  TimeOfDay? setTime;
  String notificationType = "Weekly";

  @override
  void initState() {
    super.initState();
    dropdownValue = weekdays[DateTime.now().weekday-1];
    setTime = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              const Text("Select When To Show Weather Updates",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    width: 140,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          updateTime();
                        });
                      },
                      child: Text(
                        "${setTime!.format(context)}",
                        style: const TextStyle(
                            fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  DropdownButton(
                    value: dropdownValue,
                    items: weekdays.map(
                            (String weekday){
                          return DropdownMenuItem(
                              value: weekday,
                              child: Text(weekday,
                                style: const TextStyle(
                                    fontSize: 20,
                                ),
                              )
                          );
                        }
                    ).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        dropdownValue = value;
                      });
                    },
                  )
                ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 100),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 130,
                  child: RadioListTile(
                      title: const Text("Daily",
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      value: "Daily",
                      groupValue: notificationType,
                      onChanged: (value){
                        setState(() {
                          notificationType = value!;
                        });
                      }
                  ),
                ),
                SizedBox(
                  width: 140,
                  child: RadioListTile(
                      title: const Text("Weekly",
                        style: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      value: "Weekly",
                      groupValue: notificationType,
                      onChanged: (value){
                        setState(() {
                          notificationType = value!;
                        });
                      }
                  ),
                )
              ],
            ),
            ElevatedButton(
                onPressed: scheduleNotification,
                child: const Text("Schedule",
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                )
            )
          ]
        )
      ),
    );
  }

  Future updateTime() async{
    TimeOfDay? result = await showTimePicker(
        context: context,
        initialTime: setTime!
    );
    if (result != null){
      setState(() {
        setTime = result;
      });
    }
  }

  Future scheduleNotification() async{
    // If Daily Weather Update
    if (notificationType == "Daily"){

    }
    // If Weekly Weather Update
    else{

    }
  }
}
