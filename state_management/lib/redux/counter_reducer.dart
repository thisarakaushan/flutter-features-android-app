// Packages
import 'package:redux/redux.dart';

// States
import 'app_state.dart';

// Actions
import 'counter_actions.dart';

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    counter: counterReducer(state.counter, action),
    isLoading: loadingReducer(state.isLoading, action),
  );
}

final counterReducer = combineReducers<int>([
  TypedReducer<int, IncrementAction>(_increment).call,
  TypedReducer<int, DecrementAction>(_decrement).call,
  TypedReducer<int, ResetAction>(_reset).call,
]);

final loadingReducer = combineReducers<bool>([
  TypedReducer<bool, SetLoadingAction>(_setLoading).call,
]);

int _increment(int state, IncrementAction action) => state + 1;

int _decrement(int state, DecrementAction action) => state - 1;

int _reset(int state, ResetAction action) => 0;

bool _setLoading(bool state, SetLoadingAction action) => action.isLoading;

// Middleware for async actions
void asyncMiddleware(
  Store<AppState> store,
  dynamic action,
  NextDispatcher next,
) {
  if (action is IncrementAsyncAction) {
    store.dispatch(SetLoadingAction(true));

    Future.delayed(Duration(seconds: 1)).then((_) {
      store.dispatch(IncrementAction());
      store.dispatch(SetLoadingAction(false));
    });
  } else {
    next(action);
  }
}
