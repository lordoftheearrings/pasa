import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:pasa/core/constants/app_colors.dart';
import 'package:pasa/core/top_level/di.dart';
import 'package:pasa/sugam_part/lib/ble_controller.dart';
import 'package:vibration/vibration.dart';

enum CrashState { idle, countdown, sent }

class CrashService {
  final ValueNotifier<CrashState> state = ValueNotifier<CrashState>(
    CrashState.idle,
  );

  final ValueNotifier<int> countdown = ValueNotifier<int>(30);

  Timer? _timer;

  void onCrashDetected() {
    if (state.value != CrashState.idle) return;

    countdown.value = 30;
    state.value = CrashState.countdown;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      countdown.value--;

      if (countdown.value <= 0) {
        sendSos();
      }
    });
  }

  void cancel() {
    _timer?.cancel();
    state.value = CrashState.idle;
    getIt<BleController>().cancelSOS(); // Add this line
  }

  void sendSos() {
    _timer?.cancel();
    state.value = CrashState.sent;

    // 🔥 SEND SMS / API / BACKEND HERE

    // Reset after send
    Future.delayed(const Duration(seconds: 2), () {
      state.value = CrashState.idle;
    });
  }

  void dispose() {
    _timer?.cancel();
  }
}

class CrashListener extends StatelessWidget {
  final Widget child;
  final CrashService crashService;

  const CrashListener({
    super.key,
    required this.child,
    required this.crashService,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<CrashState>(
      valueListenable: crashService.state,
      builder: (context, state, _) {
        return Stack(
          children: [
            child,
            if (state == CrashState.countdown)
              CrashOverlay(crashService: crashService),
          ],
        );
      },
    );
  }
}

class CrashOverlay extends StatefulWidget {
  final CrashService crashService;

  const CrashOverlay({super.key, required this.crashService});

  @override
  State<CrashOverlay> createState() => _CrashOverlayState();
}

class _CrashOverlayState extends State<CrashOverlay> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _vibrating = false;

  @override
  void initState() {
    super.initState();
    _startAlarm();
  }

  void _startAlarm() async {
    // 1. Start looping alarm sound
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource('alarm.mp3'));

    // 2. Start vibration loop if device supports it
    _vibrating = true;
    _vibrateLoop();
  }

  void _vibrateLoop() async {
    while (_vibrating) {
      if (await Vibration.hasVibrator()) {
        Vibration.vibrate(duration: 500); // vibrate 0.5 sec
        await Future.delayed(
          Duration(milliseconds: 700),
        ); // pause before next vibration
      } else {
        break; // device has no vibrator
      }
    }
  }

  void _stopAlarm() async {
    _vibrating = false;
    await _audioPlayer.stop();
  }

  @override
  void dispose() {
    _stopAlarm(); // stop alarm automatically when screen is removed
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Material(
        color: Colors.red.withOpacity(0.7),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                WarningIcon(),
                const SizedBox(height: 40),
                const Text(
                  "Crash Detected",
                  style: TextStyle(fontSize: 26, color: Colors.white),
                ),
                const SizedBox(height: 12),

                /// 🔥 Countdown updates correctly now
                ValueListenableBuilder<int>(
                  valueListenable: widget.crashService.countdown,
                  builder: (_, seconds, _) {
                    return Text(
                      "Sending SOS in ${seconds}s",
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    );
                  },
                ),

                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: widget.crashService.cancel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text(
                    "I'm OK, CANCEL SOS",
                    style: TextStyle(color: AppColors.black, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WarningIcon extends StatefulWidget {
  const WarningIcon({super.key});

  @override
  State<WarningIcon> createState() => _WarningIconState();
}

class _WarningIconState extends State<WarningIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.8, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: const Icon(Icons.warning, color: Colors.yellow, size: 150),
    );
  }
}
