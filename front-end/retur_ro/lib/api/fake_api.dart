import 'dart:async';

class FakeApi {
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
