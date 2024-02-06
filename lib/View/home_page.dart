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
            DateTime dateTime = inputFormat.parse(inputString);

            // Format the date in the desired output format with month name
            DateFormat outputFormat = DateFormat("MMMM dd, yyyy", 'en_US');
            String formattedDate = outputFormat.format(dateTime);
            return Column(
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsetsDirectional.all(8),
                    padding: EdgeInsetsDirectional.only(start: 10,top: 8,bottom: 8,end: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.cyanAccent),
                    height: _height * 0.3,
                    width: _width * 0.8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(formattedDate),
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
