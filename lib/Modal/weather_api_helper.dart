// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_info/Modal/weather_modal.dart';

import '../util.dart';

class ApiHelper {
  static ApiHelper obj = ApiHelper._();

  ApiHelper._();

  factory ApiHelper() {
    return obj;
  }

  Future<Weather?> getApiData(String? location) async {
    String baseUrl =
        "https://api.weatherapi.com/v1/forecast.json?key=e09f03988e1048d2966132426232205&q=";
    String endUrl = "$location&aqi=no";
    String api = baseUrl + endUrl;
    http.Response res = await http.get(Uri.parse(api));
    if (res.statusCode == 200) {
      Map decodedData = jsonDecode(res.body);
      var response = weatherFromJson(res.body);
      return response;
    }
    else{
      print("NOT GET");
    }
    return null;
  }
}
