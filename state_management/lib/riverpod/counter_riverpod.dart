// Packages
import 'package:flutter_riverpod/flutter_riverpod.dart';

// StateNotifier for complex state management
class CounterNotifier extends StateNotifier<AsyncValue<int>> {
  CounterNotifier() : super(const AsyncValue.data(0));

  void increment() {
    state = AsyncValue.data(state.value! + 1);
  }

  void decrement() {
    state = AsyncValue.data(state.value! - 1);
  }

  void reset() {
    state = const AsyncValue.data(0);
  }

  Future<void> incrementAsync() async {
    state = const AsyncValue.loading();

    // Simulate API call
    await Future.delayed(Duration(seconds: 1));

    // Get current value safely
    final currentValue = state.value ?? 0;
    state = AsyncValue.data(currentValue + 1);
  }
}

// Providers
final counterProvider = StateNotifierProvider<CounterNotifier, AsyncValue<int>>(
  (ref) => CounterNotifier(),
);

// Simple state provider for comparison
final simpleCounterProvider = StateProvider<int>((ref) => 0);

// Computed/Derived state
final counterDoubledProvider = Provider<int>((ref) {
  final counter = ref.watch(simpleCounterProvider);
  return counter * 2;
});

// Family provider example
final counterWithInitialValueProvider = StateProvider.family<int, int>((
  ref,
  initialValue,
) {
  return initialValue;
});
