// Packages
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

// Store
import 'counter_store.dart';

class MobXCounterScreen extends StatefulWidget {
  const MobXCounterScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MobXCounterScreenState createState() => _MobXCounterScreenState();
}

class _MobXCounterScreenState extends State<MobXCounterScreen> {
  final CounterStore _counterStore = CounterStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('MobX Counter'), backgroundColor: Colors.teal),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'MobX Pattern Flow:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('1. @observable variables are reactive'),
            Text('2. @action methods modify state'),
            Text('3. @computed for derived state'),
            Text('4. Observer widget rebuilds automatically'),
            SizedBox(height: 32),

            // Observer rebuilds when observables change
            Observer(
              builder: (_) => Column(
                children: [
                  if (_counterStore.isLoading)
                    CircularProgressIndicator()
                  else
                    Text(
                      '${_counterStore.counter}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  SizedBox(height: 16),
                  Text('Status: ${_counterStore.counterStatus}'),
                  Text('Is Even: ${_counterStore.isEven}'),
                  SizedBox(height: 16),
                  Text('Observer rebuilds: ${DateTime.now().millisecond}'),
                ],
              ),
            ),

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
            onPressed: () => _counterStore.increment(),
            backgroundColor: Colors.teal,
            child: Icon(Icons.add),
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            heroTag: "decrement",
            onPressed: () => _counterStore.decrement(),
            backgroundColor: Colors.teal,
            child: Icon(Icons.remove),
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            heroTag: "async",
            onPressed: () => _counterStore.incrementAsync(),
            backgroundColor: Colors.teal,
            child: Icon(Icons.timer),
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            heroTag: "reset",
            onPressed: () => _counterStore.reset(),
            backgroundColor: Colors.teal,
            child: Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}
