import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchArea extends ConsumerWidget {
  SearchArea(this.textInputProvider, this.weatherDataProvider, {super.key});

  final StateProvider<String> textInputProvider;
  final FutureProvider weatherDataProvider;

  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(final BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
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
                  .read(textInputProvider.notifier)
                  .update((state) => state = _textEditingController.text);

              ref.read(weatherDataProvider.future);
            },
            child: const Text('確認'),
          ),
        ],
      ),
    );
  }
}
