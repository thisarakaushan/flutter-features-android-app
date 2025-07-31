class AppState {
  final int counter;
  final bool isLoading;

  AppState({required this.counter, this.isLoading = false});

  AppState copyWith({int? counter, bool? isLoading}) {
    return AppState(
      counter: counter ?? this.counter,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
