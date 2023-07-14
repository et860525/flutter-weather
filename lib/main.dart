import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      ),
      home: MyHomePage(),
    );
  }
}

final locationNameProvider = StateProvider<String>((ref) => '');

final weatherDataProvider = FutureProvider((ref) async {
  final inputLocationName = ref.watch(locationNameProvider).toString();

  if (inputLocationName.isEmpty) {
    return {'status': 'None'};
  } else {
    try {
      Response response = await Dio().get(
          'https://opendata.cwb.gov.tw/api/v1/rest/datastore/F-C0032-001',
          queryParameters: {
            'Authorization': 'CWB-405F824E-2EC9-4A49-B0CF-7E44724E70A1',
            'locationName': inputLocationName
          });

      if (response.statusCode == 200) {
        var data = response.data['records'];
        return data;
      } else {
        return {};
      }
    } catch (e) {
      print(e);
    }
  }
});

class MyHomePage extends ConsumerWidget {
  MyHomePage({Key? key}) : super(key: key);

  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue weatherData = ref.watch(weatherDataProvider);

    return Scaffold(
        body: Column(children: [
      Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textEditingController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter text...',
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            ElevatedButton(
              onPressed: () async {
                // Update locationName
                ref
                    .read(locationNameProvider.notifier)
                    .update((state) => state = _textEditingController.text);

                ref.read(weatherDataProvider.future);
              },
              child: const Text('確認'),
            ),
          ],
        ),
      ),
      weatherData.when(
          loading: () => const CircularProgressIndicator(),
          error: (err, stack) => Text('Error: $err'),
          data: (data) {
            if (data['status'] == 'None') {
              print(data);
            } else {
              for (var ele in data['location'][0]['weatherElement']) {
                // print(ele);
              }
            }
            return Column(
              children: [
                if (data['status'] == 'None')
                  Text('No Data Here')
                else
                  for (var ele in data['location'][0]['weatherElement']) ...[
                    Text(ele.toString())
                  ]
              ],
            );
          })
    ]));
  }
}
