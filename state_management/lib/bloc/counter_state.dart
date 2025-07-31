class CounterState {
  final int counter;
  final bool isLoading;

  const CounterState({required this.counter, this.isLoading = false});

  CounterState copyWith({int? counter, bool? isLoading}) {
    return CounterState(
      counter: counter ?? this.counter,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
