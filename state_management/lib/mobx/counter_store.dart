import 'package:mobx/mobx.dart';

// Include generated file
part 'counter_store.g.dart';

// ignore: library_private_types_in_public_api
class CounterStore = _CounterStore with _$CounterStore;

// The store-class
abstract class _CounterStore with Store {
  @observable
  int counter = 0;

  @observable
  bool isLoading = false;

  @action
  void increment() {
    counter++;
  }

  @action
  void decrement() {
    counter--;
  }

  @action
  void reset() {
    counter = 0;
  }

  @action
  Future<void> incrementAsync() async {
    isLoading = true;

    // Simulate API call
    await Future.delayed(Duration(seconds: 1));

    counter++;
    isLoading = false;
  }

  @computed
  String get counterStatus {
    if (counter < 0) return 'Negative';
    if (counter == 0) return 'Zero';
    if (counter < 10) return 'Single digit';
    return 'Double digit or more';
  }

  @computed
  bool get isEven => counter % 2 == 0;
}
