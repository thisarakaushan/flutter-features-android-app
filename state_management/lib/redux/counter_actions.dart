abstract class CounterAction {}

class IncrementAction extends CounterAction {}

class DecrementAction extends CounterAction {}

class ResetAction extends CounterAction {}

class SetLoadingAction extends CounterAction {
  final bool isLoading;
  SetLoadingAction(this.isLoading);
}

class IncrementAsyncAction extends CounterAction {}
