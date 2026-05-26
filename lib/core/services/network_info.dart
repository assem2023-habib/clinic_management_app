import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkInfo {
  static final Connectivity _connectivity = Connectivity();

  static Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  static Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;
}
