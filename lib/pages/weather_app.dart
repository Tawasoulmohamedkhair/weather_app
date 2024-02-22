import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weathr_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});
  @override
  State<WeatherPage> createState() => _WeatherPage();
}

class _WeatherPage extends State<WeatherPage> {
  //apikey
  final _weatherService = WeatherService('efd3321346f2b9acbebc716e03a47fe4');
  Weather? _weather;
  //fetch weather
  _fetchWeather() async {
    //get the current city
    String cityName = await _weatherService.getCurrenCity();
    //get weather for  city
    try {
      final weather = await _weatherService.getweather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  //weather animation
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';
    switch (mainCondition.toLowerCase()) {
      case 'cloude':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.gson';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //cityname
            Text(_weather?.cityName ?? 'Loading city ..'),
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
            //temperature
            Text('${_weather?.temperature.round()}  ْ C'),
          ],
        ),
      ),
    );
  }
}
