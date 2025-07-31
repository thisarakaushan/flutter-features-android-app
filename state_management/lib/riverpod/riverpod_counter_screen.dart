// Packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Riverpod
import 'counter_riverpod.dart';

class RiverpodCounterScreen extends ConsumerWidget {
  const RiverpodCounterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counterAsync = ref.watch(counterProvider);
    final simpleCounter = ref.watch(simpleCounterProvider);
    final doubledCounter = ref.watch(counterDoubledProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Riverpod Counter'),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Riverpod Pattern Flow:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('1. Providers hold state'),
            Text('2. ref.watch() listens to changes'),
            Text('3. ref.read() for one-time access'),
            Text('4. Automatic disposal & dependency injection'),
            SizedBox(height: 32),

            // AsyncValue handling
            counterAsync.when(
              data: (counter) => Text(
                'Async Counter: $counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              loading: () => CircularProgressIndicator(),
              error: (error, stack) => Text('Error: $error'),
            ),

            SizedBox(height: 16),
            Text('Simple Counter: $simpleCounter'),
            Text('Doubled Counter: $doubledCounter'),

            SizedBox(height: 16),
            Text('Consumer rebuilds: ${DateTime.now().millisecond}'),

            SizedBox(height: 32),
            Text('This text never rebuilds'),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "increment",
            onPressed: () => ref.read(counterProvider.notifier).increment(),
            backgroundColor: Colors.purple,
            child: Icon(Icons.add),
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            heroTag: "decrement",
            onPressed: () => ref.read(counterProvider.notifier).decrement(),
            backgroundColor: Colors.purple,
            child: Icon(Icons.remove),
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            heroTag: "async",
            onPressed: () =>
                ref.read(counterProvider.notifier).incrementAsync(),
            backgroundColor: Colors.purple,
            child: Icon(Icons.timer),
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            heroTag: "reset",
            onPressed: () => ref.read(counterProvider.notifier).reset(),
            backgroundColor: Colors.purple,
            child: Icon(Icons.refresh),
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            heroTag: "simple_inc",
            onPressed: () => ref.read(simpleCounterProvider.notifier).state++,
            backgroundColor: Colors.purple,
            child: Icon(Icons.plus_one),
          ),
        ],
      ),
    );
  }
}
