import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/utils/fetchAPI.dart';
import 'package:weather_app/widgets/searchBar.dart';
import 'package:weather_app/widgets/forecast.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Input with Button',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black)),
      ),
      home: const MyHomePage(),
    );
  }
}

final locationNameProvider = StateProvider<String>((ref) => '');

final weatherDataProvider = FutureProvider<Weather>((ref) async {
  final inputLocationName = ref.watch(locationNameProvider);

  return WeatherApiClient().getWeather(inputLocationName);
});

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue weatherData = ref.watch(weatherDataProvider);

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(children: [
            SearchArea(locationNameProvider, weatherDataProvider),
            weatherData.when(
                loading: () => const CircularProgressIndicator(),
                error: (err, stack) => Text('Error: $err'),
                data: (data) {
                  final weatherData = data.toJson();

                  if (weatherData['records'] == null) {
                    return const Text(
                      '請輸入縣市名稱',
                      style: TextStyle(fontSize: 24.0),
                    );
                  } else if (weatherData['records']['location'].isEmpty) {
                    return const Text(
                      '輸入的站名可能有誤',
                      style: TextStyle(fontSize: 24.0),
                    );
                  } else {
                    return Column(
                      children: <Widget>[
                        // Location
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Icon(
                              Icons.location_on_outlined,
                              color: Colors.black87,
                              size: 30.0,
                              semanticLabel:
                                  'Text to announce in accessibility modes',
                            ),
                            Text(
                              weatherData['records']['location'][0]
                                  ['locationName'],
                              style: const TextStyle(
                                  fontSize: 24, color: Colors.black87),
                            )
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                        ),
                        WeatherForecast(location: data.records.location[0])
                      ],
                    );
                  }
                })
          ])),
    );
  }
}
