import 'package:pasa/core/components/messengers/app_banners.dart';
import 'package:pasa/core/enums/network_status.dart';
import 'package:pasa/core/exception/exception_messages.dart';
import 'package:pasa/core/services/connectivity_service.dart';
import 'package:pasa/core/top_level/di.dart';
import 'package:flutter/material.dart';

class ConnectivityListener extends StatefulWidget {
  final Widget child;
  const ConnectivityListener({super.key, required this.child});

  @override
  State<ConnectivityListener> createState() => _ConnectivityListenerState();
}

class _ConnectivityListenerState extends State<ConnectivityListener> {
  NetworkStatus? _previousStatus;
  bool _initialCheckDone = false;
  @override
  void initState() {
    super.initState();
    getIt<ConnectivityService>().status.addListener(_onStatusChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getIt<ConnectivityService>().checkInitialConnection();
      _previousStatus = getIt<ConnectivityService>().status.value;
      _initialCheckDone = true;
    });
  }

  void _onStatusChanged() {
    if (!mounted) return;

    final connectivity = getIt<ConnectivityService>();
    final status = connectivity.status.value;
    if (!_initialCheckDone) return;

    if (status == _previousStatus) return;
    switch (status) {
      case NetworkStatus.noConnection:
        AppBanner.showError(
          context,
          ExceptionMessages.noNetworkMessage,
          Icons.wifi_off_outlined,
          null,
        );
        break;

      case NetworkStatus.noInternet:
        AppBanner.showWarning(
          context,
          ExceptionMessages.noInternetMessage,
          Icons.cloud_off_outlined,
          null,
        );
        break;

      case NetworkStatus.connected:
        if (_previousStatus == NetworkStatus.noConnection ||
            _previousStatus == NetworkStatus.noInternet) {
          AppBanner.showSuccess(
            context,
            ExceptionMessages.yesNetworkMessage,
            Icons.wifi_outlined,
            const Duration(seconds: 1),
          );
        }
        break;
    }
    _previousStatus = status;
  }

  @override
  void dispose() {
    getIt<ConnectivityService>().status.removeListener(_onStatusChanged);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
