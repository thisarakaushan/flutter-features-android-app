// Packages
import 'package:flutter/foundation.dart';

class CounterProvider extends ChangeNotifier {
  int _counter = 0;
  bool _isLoading = false;

  int get counter => _counter;
  bool get isLoading => _isLoading;

  void increment() {
    _counter++;
    notifyListeners(); // Notify all listening widgets
  }

  void decrement() {
    _counter--;
    notifyListeners();
  }

  void reset() {
    _counter = 0;
    notifyListeners();
  }

  Future<void> incrementAsync() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(Duration(seconds: 1));

    _counter++;
    _isLoading = false;
    notifyListeners();
  }
}
