// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_info/Modal/weather_api_helper.dart';
import '../Modal/weather_modal.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    String loc = "Rajkot";
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        actions: [Icon(Icons.location_on_sharp)],
        title: Text("Weather's Information"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: ApiHelper().getApiData(loc),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error : ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            Weather? data = snapshot.data;
            String inputString = data!.location!.localtime!;
            // Parse the input string to DateTime with a specific format
            DateFormat inputFormat = DateFormat("yyyy-MM-dd H:mm");

            // 2024-02-06 7:48

            DateTime dateTime = inputFormat.parse(inputString);

            // Format the date in the desired output format with month name
            DateFormat outputFormat = DateFormat("MMMM dd, yyyy", 'en_US');
            TimeOfDay timeOfDay = TimeOfDay.fromDateTime(dateTime);
            String formattedDate = outputFormat.format(dateTime);
            String formattedTimeString = timeOfDay.format(context);
            return Column(
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsetsDirectional.all(8),
                    padding: EdgeInsetsDirectional.only(
                        start: 10, top: 8, bottom: 8, end: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.blue,
                          Colors.purple,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    height: _height * 0.3,
                    width: _width * 0.8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              formattedDate,
                              style:
                                  TextStyle(fontSize: 20, color: Colors.tealAccent),
                            ),
                            Spacer(),
                            Text(formattedTimeString,
                                style: TextStyle(
                                    fontSize: 18, color: Colors.tealAccent)),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              "LAT: ${data.location?.lat}",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            Spacer(),
                            Text(
                              "LON: ${data.location?.lon}",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "${data.current!.tempC}°",
                              style: TextStyle(
                                fontSize: _height * 0.08,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              data.current!.condition!.text ?? "",
                              style: TextStyle(
                                fontSize: _height * 0.025,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Text("Hello"),
                      ],
                    ),
                  ),
                )
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
