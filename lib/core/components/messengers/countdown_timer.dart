import 'dart:async';
import 'package:pasa/core/components/text/app_text.dart';
import 'package:pasa/core/constants/app_textstyles.dart';
import 'package:flutter/material.dart';

class CountdownController {
  VoidCallback? _restart;
  VoidCallback? _start;

  void _bind(VoidCallback start, VoidCallback restart) {
    _start = start;
    _restart = restart;
  }

  void start() => _start?.call();
  void restart() => _restart?.call();
}

class CountdownTimer extends StatefulWidget {
  final Duration initialDuration;
  final VoidCallback onTimerEnd;
  final bool autoStart;
  final CountdownController? controller;

  const CountdownTimer({
    super.key,
    required this.initialDuration,
    required this.onTimerEnd,
    this.autoStart = true,
    this.controller,
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Duration _remainingTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.initialDuration;

    widget.controller?._bind(start, restart);

    if (widget.autoStart) start();
  }

  void start() {
    if (_timer?.isActive ?? false) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingTime.inSeconds == 0) {
        _timer?.cancel();
        widget.onTimerEnd();
      } else {
        setState(() => _remainingTime -= const Duration(seconds: 1));
      }
    });
  }

  void restart() {
    _timer?.cancel();
    setState(() => _remainingTime = widget.initialDuration);
    start();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = _remainingTime.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    final seconds = _remainingTime.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    return AppText(
      label: "⏱ $minutes:$seconds",
      style: AppTextStyles.greyedOutText,
    );
  }
}
