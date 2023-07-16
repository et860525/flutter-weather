import 'package:flutter/material.dart';
import 'package:weather_app/utils/weatherIconMapping.dart';

class WeatherCard extends StatelessWidget {
  final String startTime;
  final String endTime;
  final String title;
  final String wxName;
  final String wxValue;
  final String maxT;
  final String minT;
  final String pop;
  final String ci;
  final IconData? weatherIcon;

  const WeatherCard(
      {super.key,
      required this.startTime,
      required this.endTime,
      required this.title,
      required this.wxName,
      required this.wxValue,
      required this.maxT,
      required this.minT,
      required this.pop,
      required this.ci,
      required this.weatherIcon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
          Text(
            "$startTime ~ $endTime",
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Icon(weatherIcon ?? WeatherIcons.clear_day, size: 42.0),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text("$minT ~ $maxT"),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.water_drop_outlined,
                        size: 20.0,
                      ),
                      Text(' $pop%')
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      ' $ci',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
