import 'dart:async';

enum DeviceStatus { waiting, activated, paused }

class BleEmulatorRepository {
  String? clientId;
  int? aliveTimeout;
  int? pauseTimeout;
  Timer? _aliveTimer;
  Timer? _pauseTimer;
  DeviceStatus status = DeviceStatus.waiting;

  

  void _setStatus(DeviceStatus currentStatus) {
    status = currentStatus;
  }

  void start(String clientId, int aliveTimeout, int pauseTimeout) {
    this.clientId = clientId;
    this.aliveTimeout = aliveTimeout;
    this.pauseTimeout = pauseTimeout;

    _setStatus(DeviceStatus.activated);
  }

  Future<void> alive(String clientId) async {
    _startAliveTimer();
  }

  void pause(String clientId) {
    _setStatus(DeviceStatus.paused);
    _pauseTimer = Timer(Duration(seconds: pauseTimeout!), () {
      stop(clientId);
    });
    _aliveTimer?.cancel();
  }

  void continueSession(String clientId) {
    _setStatus(DeviceStatus.activated);
    _pauseTimer?.cancel();
  }

  void stop(String clientId) {
    _setStatus(DeviceStatus.waiting);
    _aliveTimer?.cancel();
    _pauseTimer?.cancel();
  }

  void _startAliveTimer() {
    _aliveTimer?.cancel();
    _aliveTimer = Timer(Duration(seconds: aliveTimeout!), () {
      stop(clientId!);
    });
  }
}