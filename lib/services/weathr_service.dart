import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:geocoding/geocoding.dart';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = 'http://api.openweathermap.org/data/2.5/weather';
  final String apiKey;
  // final String metric;
  WeatherService(
    this.apiKey,
  );
  Future<Weather?>? getweather(String cityName, String metric) async {
    // try {
    final response = await http
        .get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=$metric'));
    //print('$BASE_URL?q=$cityName&appid=$apiKey&units=metric');
    //print("response.body");
    //print(response.body);
    //print("response.statusCode");
    //print(response.statusCode);
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<String> getCurrenCity() async {
    //get permision from user
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      //fetch the current location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      //convert the location into a list of placemark object
      List<Placemark>? placemarks = await
          // GeocodingPlatform.instance?.
          placemarkFromCoordinates(position.latitude, position.longitude);
      //print(placemarks);
      //extract the city name from the first placemark
      String? city = placemarks[0].locality;
      return city ?? "";
    } catch (e) {
      rethrow;
    }
  }
}
