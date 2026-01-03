import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:pasa/core/enums/network_status.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity;
  final InternetConnection _internetChecker;
  final ValueNotifier<NetworkStatus> status = ValueNotifier(
    NetworkStatus.connected,
  );

  late final StreamSubscription<InternetStatus> _internetSubscription;
  late final StreamSubscription<List<ConnectivityResult>>
  _connectivitySubscription;

  ConnectivityService({
    Connectivity? connectivity,
    InternetConnection? internetChecker,
  }) : _connectivity = connectivity ?? Connectivity(),
       _internetChecker = internetChecker ?? InternetConnection() {
    _internetSubscription = _internetChecker.onStatusChange.listen((
      internetStatus,
    ) {
      if (status.value != NetworkStatus.noConnection) {
        status.value = internetStatus == InternetStatus.connected
            ? NetworkStatus.connected
            : NetworkStatus.noInternet;
      }
    });

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      results,
    ) {
      final connected = !results.contains(ConnectivityResult.none);
      if (!connected) {
        status.value = NetworkStatus.noConnection;
      } else {
        _internetChecker.hasInternetAccess.then((hasInternet) {
          status.value = hasInternet
              ? NetworkStatus.connected
              : NetworkStatus.noInternet;
        });
      }
    });

    checkInitialConnection();
  }

  Future<void> checkInitialConnection() async {
    try {
      final connectivity = await _connectivity.checkConnectivity();
      final connected = !connectivity.contains(ConnectivityResult.none);
      if (!connected) {
        status.value = NetworkStatus.noConnection;
        return;
      }
      final hasInternet = await _internetChecker.hasInternetAccess;
      status.value = hasInternet
          ? NetworkStatus.connected
          : NetworkStatus.noInternet;
    } catch (e) {
      status.value = NetworkStatus.noConnection;
    }
  }

  void dispose() {
    _internetSubscription.cancel();
    _connectivitySubscription.cancel();
  }
}
