import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> isConnected() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  // ignore: unrelated_type_equality_checks
  return connectivityResult != ConnectivityResult.none;
}

// network health - check (ping)
