// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_brace_in_string_interps
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_info/Controller/Provider/connectivity_provider.dart';
import 'package:weather_info/Modal/weather_api_helper.dart';
import '../Controller/Provider/search_provider.dart';
import '../Controller/Provider/theme_provider.dart';
import '../Modal/weather_modal.dart';
import '../main.dart';

bool isConnected = false;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    var sp = Provider.of<SearchProvider>(context, listen: false);
    sp.fetchDataFromPrefs();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    Color whiteColour = Colors.white;
    Color offwhiteColour = Colors.white54;

    var sp = Provider.of<SearchProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.location_on),
        actions: [
          Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) => Switch(
                    value: themeProvider.currentTheme,
                    onChanged: (bool value) {
                      themeProvider.changeTheme(value);
                    },
                  )),
        ],
        title: (sp.loc == null) ? Text("RAJKOT") : Text("${sp.loc}"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: ApiHelper().getApiData(sp.loc),
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

            DateFormat outputFormat = DateFormat("MMMM dd, yyyy", 'en_US');
            TimeOfDay timeOfDay = TimeOfDay.fromDateTime(dateTime);
            String formattedDate = outputFormat.format(dateTime);

            String formattedTimeString = timeOfDay.format(context);
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      controller: sp.tController,
                      onChanged: (value) async {
                        String baseUrl =
                            "https://api.weatherapi.com/v1/forecast.json?key=e09f03988e1048d2966132426232205&q=";
                        String endUrl = "$value&aqi=no";
                        String api = baseUrl + endUrl;
                        http.Response res = await http.get(Uri.parse(api));
                        if (res.statusCode == 200) {
                          sp.loc = value;
                          prefs.setString("City", value);
                        } else {
                          print("NO DATA FOUND");
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Please Enter Valid Country"),
                            duration: Duration(seconds: 2),
                            // Adjust the duration as needed
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                          ));
                          sp.clear();
                          Navigator.pop(context);
                        }
                      },
                      onSaved: (value) async {},
                      decoration: InputDecoration(
                        labelText: 'Enter City',
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.location_city),
                      ),
                      cursorColor: Colors.white,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                    ),
                  ),
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsetsDirectional.all(8),
                          padding: EdgeInsetsDirectional.only(
                              start: 10, top: 8, bottom: 8, end: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: (Theme.of(context).brightness ==
                                      Brightness.light)
                                  ? [
                                      Colors.blue,
                                      Colors.purple,
                                    ]
                                  : [
                                      Colors.black54,
                                      Colors.blueGrey,
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
                          height: deviceHeight * 0.65,
                          width: deviceWidth * 0.98,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    formattedDate,
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.tealAccent),
                                  ),
                                  Spacer(),
                                  Text(formattedTimeString,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.tealAccent)),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    "LAT: ${data.location?.lat}",
                                    style: TextStyle(
                                        color: whiteColour, fontSize: 20),
                                  ),
                                  Spacer(),
                                  Text(
                                    "LON: ${data.location?.lon}",
                                    style: TextStyle(
                                        color: whiteColour, fontSize: 20),
                                  ),
                                ],
                              ),
                              Row(
                                textBaseline: TextBaseline.alphabetic,
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                children: [
                                  Text(
                                    "${data.current!.tempC}°",
                                    style: TextStyle(
                                      fontSize: deviceHeight * 0.08,
                                      fontWeight: FontWeight.w500,
                                      color: whiteColour,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    data.current!.condition!.text ?? "",
                                    style: TextStyle(
                                      fontSize: deviceHeight * 0.025,
                                      fontWeight: FontWeight.w500,
                                      color: whiteColour,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "${data.location!.name} ,${data.location!.region}, ${data.location!.country}",
                                style: TextStyle(
                                  fontSize: deviceHeight * 0.025,
                                  fontWeight: FontWeight.w500,
                                  color: whiteColour,
                                ),
                              ),
                              Container(
                                height: deviceHeight * 0.18,
                                width: deviceWidth,
                                decoration: BoxDecoration(
                                  color: whiteColour.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(
                                      deviceHeight * 0.02),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.light_mode_outlined,
                                            size: deviceHeight * 0.04,
                                          ),
                                          SizedBox(
                                            height: deviceHeight * 0.03,
                                          ),
                                          Text(
                                            "Sunrise",
                                            style: TextStyle(
                                              fontSize: deviceHeight * 0.02,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          SizedBox(
                                            height: deviceHeight * 0.003,
                                          ),
                                          Text(
                                            "${data.forecast!.forecastday![0].astro!.sunrise}",
                                            // "Sunrise Time",
                                            style: TextStyle(
                                              fontSize: deviceHeight * 0.024,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Icon(
                                            Icons.dark_mode_outlined,
                                            size: deviceHeight * 0.04,
                                          ),
                                          SizedBox(
                                            height: deviceHeight * 0.03,
                                          ),
                                          Text(
                                            "Sunset",
                                            style: TextStyle(
                                              fontSize: deviceHeight * 0.02,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          SizedBox(
                                            height: deviceHeight * 0.003,
                                          ),
                                          Text(
                                            "${data.forecast!.forecastday![0].astro!.sunset}",
                                            // "Sunset Time",
                                            style: TextStyle(
                                              fontSize: deviceHeight * 0.024,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: deviceHeight * 0.05),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                child: Row(
                                  children: List.generate(
                                    data.forecast!.forecastday![0].hour!.length,
                                    (index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 28),
                                        child: Column(
                                          children: [
                                            (data
                                                            .forecast!
                                                            .forecastday![0]
                                                            .hour![DateTime
                                                                    .now()
                                                                .hour]
                                                            .time!
                                                            .split(
                                                                "${DateTime.now().day}")[
                                                        1] ==
                                                    data
                                                        .forecast!
                                                        .forecastday![0]
                                                        .hour![index]
                                                        .time!
                                                        .split(
                                                            "${DateTime.now().day}")[1])
                                                ? Text(
                                                    "Now",
                                                    style: TextStyle(
                                                      color: whiteColour,
                                                      fontSize:
                                                          deviceHeight * 0.022,
                                                    ),
                                                  )
                                                : Text(
                                                    data
                                                        .forecast!
                                                        .forecastday![0]
                                                        .hour![index]
                                                        .time!
                                                        .split(
                                                            "${DateTime.now().day}")[1],
                                                    style: TextStyle(
                                                      color: whiteColour,
                                                      fontSize:
                                                          deviceHeight * 0.022,
                                                    ),
                                                  ),
                                            SizedBox(
                                              height: deviceHeight * 0.01,
                                            ),
                                            Image.network(
                                              "http:${data.forecast!.forecastday![0].hour![index].condition!.icon}",
                                              height: deviceHeight * 0.05,
                                              width: deviceHeight * 0.05,
                                            ),
                                            SizedBox(
                                              height: deviceHeight * 0.01,
                                            ),
                                            Text(
                                              "${data.forecast!.forecastday![0].hour![index].tempC}°",
                                              style: TextStyle(
                                                color: whiteColour,
                                                fontSize: deviceHeight * 0.022,
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 180,
                          top: 69,
                          child: Text(
                            "c",
                            style: TextStyle(
                              fontSize: deviceHeight * 0.05,
                              fontWeight: FontWeight.w500,
                              color: whiteColour,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(width: deviceWidth * 0.05),
                      Text(
                        "Weather Details",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: deviceHeight * 0.01),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: deviceWidth * 0.03),
                        height: deviceHeight * 0.16,
                        width: deviceWidth * 0.45,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(deviceHeight * 0.02),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: (Theme.of(context).brightness ==
                                    Brightness.light)
                                ? [
                                    Colors.blue,
                                    Colors.purple,
                                  ]
                                : [
                                    Colors.black54,
                                    Colors.blueGrey,
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
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Icon(
                                  Icons.thermostat,
                                  size: deviceHeight * 0.04,
                                  color: whiteColour,
                                ),
                              ),
                              SizedBox(
                                height: deviceHeight * 0.01,
                              ),
                              Center(
                                child: Text(
                                  "Feels Like",
                                  style: TextStyle(
                                    fontSize: deviceHeight * 0.02,
                                    fontWeight: FontWeight.w500,
                                    color: offwhiteColour,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: deviceHeight * 0.003,
                              ),
                              Center(
                                child: Text(
                                  "${data.current!.feelslikeC}°",
                                  style: TextStyle(
                                    color: whiteColour,
                                    fontSize: deviceHeight * 0.025,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        margin:
                            EdgeInsetsDirectional.only(end: deviceWidth * 0.03),
                        height: deviceHeight * 0.16,
                        width: deviceWidth * 0.45,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: (Theme.of(context).brightness ==
                                    Brightness.light)
                                ? [
                                    Colors.blue,
                                    Colors.purple,
                                  ]
                                : [
                                    Colors.black54,
                                    Colors.blueGrey,
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
                          borderRadius:
                              BorderRadius.circular(deviceHeight * 0.02),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Icon(
                                  Icons.air,
                                  size: deviceHeight * 0.04,
                                  color: whiteColour,
                                ),
                              ),
                              SizedBox(
                                height: deviceHeight * 0.01,
                              ),
                              Center(
                                child: Text(
                                  "SW wind",
                                  style: TextStyle(
                                    color: offwhiteColour,
                                    fontSize: deviceHeight * 0.02,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: deviceHeight * 0.003,
                              ),
                              Center(
                                child: Text(
                                  "${data.current!.windKph} km/h",
                                  style: TextStyle(
                                    color: whiteColour,
                                    fontSize: deviceHeight * 0.025,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: deviceHeight * 0.01),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: deviceWidth * 0.03),
                        height: deviceHeight * 0.16,
                        width: deviceWidth * 0.45,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(deviceHeight * 0.02),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: (Theme.of(context).brightness ==
                                    Brightness.light)
                                ? [
                                    Colors.blue,
                                    Colors.purple,
                                  ]
                                : [
                                    Colors.black54,
                                    Colors.blueGrey,
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
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Icon(
                                  Icons.water_drop,
                                  size: deviceHeight * 0.04,
                                  color: whiteColour,
                                ),
                              ),
                              SizedBox(
                                height: deviceHeight * 0.01,
                              ),
                              Center(
                                child: Text(
                                  "Humidity",
                                  style: TextStyle(
                                    fontSize: deviceHeight * 0.02,
                                    fontWeight: FontWeight.w500,
                                    color: offwhiteColour,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: deviceHeight * 0.003,
                              ),
                              Center(
                                child: Text(
                                  "${data.current!.humidity} %",
                                  style: TextStyle(
                                    color: whiteColour,
                                    fontSize: deviceHeight * 0.025,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        margin:
                            EdgeInsetsDirectional.only(end: deviceWidth * 0.03),
                        height: deviceHeight * 0.16,
                        width: deviceWidth * 0.45,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: (Theme.of(context).brightness ==
                                    Brightness.light)
                                ? [
                                    Colors.blue,
                                    Colors.purple,
                                  ]
                                : [
                                    Colors.black54,
                                    Colors.blueGrey,
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
                          borderRadius:
                              BorderRadius.circular(deviceHeight * 0.02),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Icon(
                                  Icons.light_mode_outlined,
                                  size: deviceHeight * 0.04,
                                  color: whiteColour,
                                ),
                              ),
                              SizedBox(
                                height: deviceHeight * 0.01,
                              ),
                              Center(
                                child: Text(
                                  "UV",
                                  style: TextStyle(
                                    color: offwhiteColour,
                                    fontSize: deviceHeight * 0.02,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: deviceHeight * 0.003,
                              ),
                              Center(
                                child: Text(
                                  "${data.current!.uv} Strong",
                                  style: TextStyle(
                                    color: whiteColour,
                                    fontSize: deviceHeight * 0.025,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: deviceHeight * 0.01),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: deviceWidth * 0.03),
                        height: deviceHeight * 0.16,
                        width: deviceWidth * 0.45,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(deviceHeight * 0.02),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: (Theme.of(context).brightness ==
                                    Brightness.light)
                                ? [
                                    Colors.blue,
                                    Colors.purple,
                                  ]
                                : [
                                    Colors.black54,
                                    Colors.blueGrey,
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
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Icon(
                                  Icons.visibility,
                                  size: deviceHeight * 0.04,
                                  color: whiteColour,
                                ),
                              ),
                              SizedBox(
                                height: deviceHeight * 0.01,
                              ),
                              Center(
                                child: Text(
                                  "Visibility",
                                  style: TextStyle(
                                    fontSize: deviceHeight * 0.02,
                                    fontWeight: FontWeight.w500,
                                    color: offwhiteColour,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: deviceHeight * 0.003,
                              ),
                              Center(
                                child: Text(
                                  "${data.current!.visKm} km",
                                  style: TextStyle(
                                    color: whiteColour,
                                    fontSize: deviceHeight * 0.025,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        margin:
                            EdgeInsetsDirectional.only(end: deviceWidth * 0.03),
                        height: deviceHeight * 0.16,
                        width: deviceWidth * 0.45,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: (Theme.of(context).brightness ==
                                    Brightness.light)
                                ? [
                                    Colors.blue,
                                    Colors.purple,
                                  ]
                                : [
                                    Colors.black54,
                                    Colors.blueGrey,
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
                          borderRadius:
                              BorderRadius.circular(deviceHeight * 0.02),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Icon(
                                  Icons.wind_power,
                                  size: deviceHeight * 0.04,
                                  color: whiteColour,
                                ),
                              ),
                              SizedBox(
                                height: deviceHeight * 0.01,
                              ),
                              Center(
                                child: Text(
                                  "Air Pressure",
                                  style: TextStyle(
                                    color: offwhiteColour,
                                    fontSize: deviceHeight * 0.02,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: deviceHeight * 0.003,
                              ),
                              Center(
                                child: Text(
                                  "${data.current!.pressureMb} hPa",
                                  style: TextStyle(
                                    color: whiteColour,
                                    fontSize: deviceHeight * 0.025,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar:
          Consumer<ConnectivityProvider>(builder: (context, netProvider, val) {
        netProvider.addNetListener();
        if (!netProvider.isNet) {
          return Container(
            color: Colors.red,
            width: double.infinity,
            height: 40,
            padding: EdgeInsets.all(8),
            child: Center(
              child: Text(
                "No Connection..",
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        } else {
          // Hide the message when internet connection is available
          return SizedBox.shrink();
        }
      }),
    );
  }
}
