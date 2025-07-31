// Packages
import 'package:flutter/material.dart';

// Screens
import 'provider/provider_counter_screen.dart';
import 'bloc/bloc_counter_screen.dart';
import 'riverpod/riverpod_counter_screen.dart';
import 'getx/getx_counter_screen.dart';
import 'redux/redux_counter_screen.dart';
import 'mobx/mobx_counter_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('State Management Comparison')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildStateManagementCard(
            context,
            'Provider',
            'Simple and officially recommended by Flutter team',
            Colors.green,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProviderCounterScreen()),
            ),
          ),
          _buildStateManagementCard(
            context,
            'BLoC',
            'Business Logic Component with streams and events',
            Colors.blue,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => BlocCounterScreen()),
            ),
          ),
          _buildStateManagementCard(
            context,
            'Riverpod',
            'Provider 2.0 with compile-time safety',
            Colors.purple,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => RiverpodCounterScreen()),
            ),
          ),
          _buildStateManagementCard(
            context,
            'GetX',
            'High performance with minimal boilerplate',
            Colors.orange,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => GetXCounterScreen()),
            ),
          ),
          _buildStateManagementCard(
            context,
            'Redux',
            'Predictable state container with single source of truth',
            Colors.red,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ReduxCounterScreen()),
            ),
          ),
          _buildStateManagementCard(
            context,
            'MobX',
            'Reactive state management with observables',
            Colors.teal,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => MobXCounterScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStateManagementCard(
    BuildContext context,
    String title,
    String description,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 60,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
