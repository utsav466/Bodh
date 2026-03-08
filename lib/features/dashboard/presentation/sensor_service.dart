import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

class SensorService {
  StreamSubscription<AccelerometerEvent>? _accelerometerSub;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSub;

  DateTime? _lastShakeTime;
  DateTime? _lastTiltTime;

  void startAccelerometer({
    required void Function() onShake,
    double shakeThreshold = 11.0,
    Duration cooldown = const Duration(seconds: 2),
  }) {
    _accelerometerSub?.cancel();

    _accelerometerSub = accelerometerEvents.listen((event) {
      final total = event.x.abs() + event.y.abs() + event.z.abs();

      if (total > shakeThreshold) {
        final now = DateTime.now();

        if (_lastShakeTime == null ||
            now.difference(_lastShakeTime!) > cooldown) {
          _lastShakeTime = now;
          onShake();
        }
      }
    });
  }

  void startGyroscope({
    required void Function(double x, double y, double z) onTilt,
    double tiltThreshold = 0.8,
    Duration cooldown = const Duration(seconds: 2),
  }) {
    _gyroscopeSub?.cancel();

    _gyroscopeSub = gyroscopeEvents.listen((event) {
      final isTilted = event.x.abs() > tiltThreshold ||
          event.y.abs() > tiltThreshold ||
          event.z.abs() > tiltThreshold;

      if (isTilted) {
        final now = DateTime.now();

        if (_lastTiltTime == null ||
            now.difference(_lastTiltTime!) > cooldown) {
          _lastTiltTime = now;
          onTilt(event.x, event.y, event.z);
        }
      }
    });
  }

  void dispose() {
    _accelerometerSub?.cancel();
    _gyroscopeSub?.cancel();
  }
}