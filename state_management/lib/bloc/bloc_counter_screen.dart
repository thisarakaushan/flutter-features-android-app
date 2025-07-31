// Packages
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// BLoC
import 'counter_bloc.dart';

// Events
import 'counter_event.dart';

// States
import 'counter_state.dart';

class BlocCounterScreen extends StatelessWidget {
  const BlocCounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('BLoC Counter'), backgroundColor: Colors.blue),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'BLoC Pattern Flow:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('1. UI dispatches Events'),
            Text('2. BLoC processes Events'),
            Text('3. BLoC emits new States'),
            Text('4. UI listens to State changes'),
            SizedBox(height: 32),

            // BlocBuilder rebuilds on state changes
            BlocBuilder<CounterBloc, CounterState>(
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
                    Text('BlocBuilder rebuilds: ${DateTime.now().millisecond}'),
                  ],
                );
              },
            ),

            SizedBox(height: 32),
            Text('This text never rebuilds'),

            SizedBox(height: 16),
            // BlocListener for side effects (like showing snackbars)
            BlocListener<CounterBloc, CounterState>(
              listener: (context, state) {
                if (state.counter == 10) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Counter reached 10!')),
                  );
                }
              },
              child: Container(), // Empty child for listener
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "increment",
            onPressed: () =>
                context.read<CounterBloc>().add(CounterIncremented()),
            backgroundColor: Colors.blue,
            child: Icon(Icons.add),
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            heroTag: "decrement",
            onPressed: () =>
                context.read<CounterBloc>().add(CounterDecremented()),
            backgroundColor: Colors.blue,
            child: Icon(Icons.remove),
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            heroTag: "async",
            onPressed: () =>
                context.read<CounterBloc>().add(CounterIncrementedAsync()),
            backgroundColor: Colors.blue,
            child: Icon(Icons.timer),
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            heroTag: "reset",
            onPressed: () => context.read<CounterBloc>().add(CounterReset()),
            backgroundColor: Colors.blue,
            child: Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}
