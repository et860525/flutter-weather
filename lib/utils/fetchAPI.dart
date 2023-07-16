import 'dart:io';
import 'package:dio/dio.dart';
import 'package:weather_app/models/weather.dart';

class WeatherApiClient {
  static const baseUrl =
      'https://opendata.cwb.gov.tw/api/v1/rest/datastore/F-C0032-001';

  final authToken = 'CWB-405F824E-2EC9-4A49-B0CF-7E44724E70A1';

  Future<Weather> getWeather(String locationName) async {
    // Don't want fetch api with empty string
    if (locationName.isEmpty) {
      return Weather();
    }

    // If Client use '台'
    if (locationName.startsWith('台')) {
      locationName = locationName.replaceFirst(RegExp('台'), '臺');
    }

    final Response response = await Dio().get(baseUrl, queryParameters: {
      'Authorization': authToken,
      'locationName': locationName
    });

    if (response.statusCode != 200) {
      throw const HttpException('Unable to fetch weather data');
    }

    return Weather.fromJson(response.data);
  }
}
