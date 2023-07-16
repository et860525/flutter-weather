import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/utils/weatherIconMapping.dart';
import 'package:weather_app/widgets/weatherCard.dart';

class WeatherForecast extends StatelessWidget {
  final Location location;

  const WeatherForecast({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Format like {Wx: [List<Time>]}
    final times = {};

    for (var ele in location.weatherElement) {
      times.putIfAbsent(ele.elementName, () => ele.time);
    }

    // Set title with 'startDate' & 'endDate'
    String getTitle(String _startDate, String _endDate) {
      DateTime today = DateTime.now().toLocal();
      DateTime _startD = DateTime.parse(_startDate);
      DateTime _endD = DateTime.parse(_endDate);
      final titleDayFilter = {'AM': '白天', 'PM': '晚上'};

      if (today.day != _startD.day) {
        return '明日${titleDayFilter[DateFormat('a').format(_startD)]}';
      } else if (_startD.day != _endD.day) {
        return '今晚明晨';
      } else if (today.day == _startD.day && today.day == _endD.day) {
        return '今天白天';
      } else {
        return '今日';
      }
    }

    // Weather icons
    const weatherTypes = {
      'isClear': [1],
      'isCloudy': [2, 3, 4, 5, 6, 7],
      'isThunderstorm': [15, 16, 17, 18, 21, 22, 33, 34, 35, 36, 41],
      'isCloudyFog': [25, 26, 27, 28],
      'isFog': [24],
      'isPartiallyClearWithRain': [
        8,
        9,
        10,
        11,
        12,
        13,
        14,
        19,
        20,
        29,
        30,
        31,
        32,
        38,
        39
      ],
      'isSnowing': [23, 37, 42],
    };

    const weatherIcons = {
      'AM': {
        'isThunderstorm': WeatherIcons.thunder_storm_day,
        'isClear': WeatherIcons.clear_day,
        'isCloudyFog': WeatherIcons.mist_day,
        'isCloudy': WeatherIcons.clouds_day,
        'isFog': WeatherIcons.mist_day,
        'isPartiallyClearWithRain': WeatherIcons.shower_rain_day,
        'isSnowing': WeatherIcons.snow_day,
      },
      'PM': {
        'isThunderstorm': WeatherIcons.thunder_storm_night,
        'isClear': WeatherIcons.clear_night,
        'isCloudyFog': WeatherIcons.mist_night,
        'isCloudy': WeatherIcons.clouds_night,
        'isFog': WeatherIcons.mist_night,
        'isPartiallyClearWithRain': WeatherIcons.shower_rain_night,
        'isSnowing': WeatherIcons.snow_night,
      },
    };

    String weatherCodeTrans(Map<String, List<int>> map, String value) {
      for (final entry in map.entries) {
        if (entry.value.contains(int.parse(value))) {
          return entry.key;
        }
      }
      return '1';
    }

    IconData weatherCode2Icon(String _startDate, String iconCode) {
      DateTime _startD = DateTime.parse(_startDate);
      return weatherIcons[DateFormat('a').format(_startD)]![
              weatherCodeTrans(weatherTypes, iconCode)] ??
          WeatherIcons.clear_day;
    }

    return SizedBox(
        height: 240,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              3,
              (index) {
                return Card(
                    child: SizedBox(
                        width: screenWidth * 0.28,
                        child: WeatherCard(
                          startTime: DateFormat('H:mm').format(DateTime.parse(
                              times['Wx'][index].toJson()['startTime'])),
                          endTime: DateFormat('H:mm').format(DateTime.parse(
                              times['Wx'][index].toJson()['endTime'])),
                          title: getTitle(
                              times['Wx'][index].toJson()['startTime'],
                              times['Wx'][index].toJson()['endTime']),
                          wxName: times['Wx'][index].toJson()['parameter']
                              ['parameterName'],
                          wxValue: times['Wx'][index].toJson()['parameter']
                              ['parameterValue'],
                          maxT: times['MaxT'][index].toJson()['parameter']
                              ['parameterName'],
                          minT: times['MinT'][index].toJson()['parameter']
                              ['parameterName'],
                          pop: times['PoP'][index].toJson()['parameter']
                              ['parameterName'],
                          ci: times['CI'][index].toJson()['parameter']
                              ['parameterName'],
                          weatherIcon: weatherCode2Icon(
                              times['Wx'][index].toJson()['startTime'],
                              times['Wx'][index].toJson()['parameter']
                                  ['parameterValue']),
                        )));
              },
            )));
  }
}
