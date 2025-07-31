// Packages
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:get/get.dart';
import 'package:provider/provider.dart' as provider;
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';

// Screens
import 'home_screen.dart';

//
import 'provider/counter_provider.dart';
import 'bloc/counter_bloc.dart';
import 'getx/counter_controller.dart';
import 'redux/app_state.dart';
import 'redux/counter_reducer.dart';

void main() {
  // Initialize GetX controller
  Get.put(CounterController());

  // Create Redux store
  final store = Store<AppState>(appReducer, initialState: AppState(counter: 0));

  runApp(
    // Redux wrapper at top since it requires a child
    StoreProvider<AppState>(
      store: store,
      child: MultiProvider(
        providers: [
          // Provider
          provider.ChangeNotifierProvider(create: (_) => CounterProvider()),

          // BLoC
          BlocProvider(create: (_) => CounterBloc()),
        ],
        child: riverpod.ProviderScope(
          // Riverpod wrapper
          child: MyApp(), // MyApp stays here
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // GetX wrapper
      debugShowCheckedModeBanner: false,
      title: 'State Management Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      home: HomeScreen(),
    );
  }
}
