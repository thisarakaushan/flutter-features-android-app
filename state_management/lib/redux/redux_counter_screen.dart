// Packages
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

// States
import 'app_state.dart';

// Actions
import 'counter_actions.dart';

class ReduxCounterScreen extends StatelessWidget {
  const ReduxCounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Redux Counter'), backgroundColor: Colors.red),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Redux Pattern Flow:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('1. Actions describe what happened'),
            Text('2. Reducers specify state changes'),
            Text('3. Store holds application state'),
            Text('4. StoreConnector rebuilds on changes'),
            SizedBox(height: 32),

            // StoreConnector listens to store changes
            StoreConnector<AppState, AppState>(
              converter: (Store<AppState> store) => store.state,
              builder: (context, state) {
                return Column(
                  children: [
                    if (state.isLoading)
                      CircularProgressIndicator()
                    else
                      Text(
                        '${state.counter}',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    SizedBox(height: 16),
                    Text(
                      'StoreConnector rebuilds: ${DateTime.now().millisecond}',
                    ),
                  ],
                );
              },
            ),

            SizedBox(height: 32),
            Text('This text never rebuilds'),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          StoreConnector<AppState, VoidCallback>(
            converter: (Store<AppState> store) {
              return () => store.dispatch(IncrementAction());
            },
            builder: (context, callback) {
              return FloatingActionButton(
                heroTag: "increment",
                onPressed: callback,
                backgroundColor: Colors.red,
                child: Icon(Icons.add),
              );
            },
          ),
          SizedBox(height: 8),
          StoreConnector<AppState, VoidCallback>(
            converter: (Store<AppState> store) {
              return () => store.dispatch(DecrementAction());
            },
            builder: (context, callback) {
              return FloatingActionButton(
                heroTag: "decrement",
                onPressed: callback,
                backgroundColor: Colors.red,
                child: Icon(Icons.remove),
              );
            },
          ),
          SizedBox(height: 8),
          StoreConnector<AppState, VoidCallback>(
            converter: (Store<AppState> store) {
              return () => store.dispatch(IncrementAsyncAction());
            },
            builder: (context, callback) {
              return FloatingActionButton(
                heroTag: "async",
                onPressed: callback,
                backgroundColor: Colors.red,
                child: Icon(Icons.timer),
              );
            },
          ),
          SizedBox(height: 8),
          StoreConnector<AppState, VoidCallback>(
            converter: (Store<AppState> store) {
              return () => store.dispatch(ResetAction());
            },
            builder: (context, callback) {
              return FloatingActionButton(
                heroTag: "reset",
                onPressed: callback,
                backgroundColor: Colors.red,
                child: Icon(Icons.refresh),
              );
            },
          ),
        ],
      ),
    );
  }
}
