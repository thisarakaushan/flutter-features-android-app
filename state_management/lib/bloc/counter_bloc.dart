// Packages
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
import 'counter_event.dart';

// States
import 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterState(counter: 0)) {
    // Event handlers
    on<CounterIncremented>(_onIncrement);
    on<CounterDecremented>(_onDecrement);
    on<CounterReset>(_onReset);
    on<CounterIncrementedAsync>(_onIncrementAsync);
  }

  void _onIncrement(CounterIncremented event, Emitter<CounterState> emit) {
    emit(state.copyWith(counter: state.counter + 1));
  }

  void _onDecrement(CounterDecremented event, Emitter<CounterState> emit) {
    emit(state.copyWith(counter: state.counter - 1));
  }

  void _onReset(CounterReset event, Emitter<CounterState> emit) {
    emit(state.copyWith(counter: 0));
  }

  Future<void> _onIncrementAsync(
    CounterIncrementedAsync event,
    Emitter<CounterState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    // Simulate API call
    await Future.delayed(Duration(seconds: 1));

    emit(state.copyWith(counter: state.counter + 1, isLoading: false));
  }
}
