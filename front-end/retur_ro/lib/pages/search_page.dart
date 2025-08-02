import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        Padding(padding: EdgeInsets.all(16.0), child: _AutocompleteSearch()),
      ],
    );
  }
}

class _AutocompleteSearch extends StatefulWidget {
  const _AutocompleteSearch();

  @override
  State<_AutocompleteSearch> createState() => _AutocompleteSearchState();
}

class _AutocompleteSearchState extends State<_AutocompleteSearch> {
  String _searchQuery = '';
  late Iterable<String> _lastOptions = [];

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue value) async {
        _searchQuery = value.text;
        final Iterable<String> results = await _FakeApi.searchAddresses(
          value.text,
        );

        if (_searchQuery != value.text) {
          return _lastOptions;
        }

        _lastOptions = results;

        return results;
      },
      onSelected: (String selection) {
        debugPrint('Selected: $selection');
      },
      fieldViewBuilder:
          (
            BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted,
          ) {
            return TextFormField(
              controller: textEditingController,
              focusNode: focusNode,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search for a location",
              ),
              onFieldSubmitted: (String value) {
                onFieldSubmitted();
              },
            );
          },
    );
  }
}

class _FakeApi {
  static const List<String> _addresses = [
    '123 Main St, Anytown, USA',
    '456 Elm St, Othertown, USA',
    '789 Oak St, Anothertown, USA',
    '101 Pine St, Yetanothertown, USA',
    '123 Main St, Anytown, USA',
    '456 Elm St, Othertown, USA',
    '789 Oak St, Anothertown, USA',
    '101 Pine St, Yetanothertown, USA',
  ];

  static Future<Iterable<String>> searchAddresses(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (query == '') {
      return const Iterable<String>.empty();
    }
    return _addresses.where(
      (address) => address.toLowerCase().contains(query.toLowerCase()),
    );
  }
}
