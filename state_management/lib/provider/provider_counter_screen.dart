// Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Providers
import '../provider/counter_provider.dart';

// Analysis
// import '../analysis/performance_monitor.dart';

class ProviderCounterScreen extends StatelessWidget {
  const ProviderCounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Provider Counter'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Provider Pattern Flow:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('1. ChangeNotifier holds state'),
            Text('2. Consumer listens to changes'),
            Text('3. notifyListeners() triggers rebuild'),
            SizedBox(height: 32),

            // Consumer rebuilds only when counter changes
            Consumer<CounterProvider>(
              builder: (context, counterProvider, child) {
                return Column(
                  children: [
                    if (counterProvider.isLoading)
                      CircularProgressIndicator()
                    else
                      Text(
                        '${counterProvider.counter}',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    SizedBox(height: 16),
                    Text('Consumer rebuilds: ${DateTime.now().millisecond}'),
                  ],
                );
              },
            ),

            SizedBox(height: 32),

            // This part doesn't rebuild unnecessarily
            Text('This text never rebuilds'),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "increment",
            onPressed: () => context.read<CounterProvider>().increment(),
            backgroundColor: Colors.green,
            child: Icon(Icons.add),
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            heroTag: "decrement",
            onPressed: () => context.read<CounterProvider>().decrement(),
            backgroundColor: Colors.green,
            child: Icon(Icons.remove),
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            heroTag: "async",
            onPressed: () => context.read<CounterProvider>().incrementAsync(),
            backgroundColor: Colors.green,
            child: Icon(Icons.timer),
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            heroTag: "reset",
            onPressed: () => context.read<CounterProvider>().reset(),
            backgroundColor: Colors.green,
            child: Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}
