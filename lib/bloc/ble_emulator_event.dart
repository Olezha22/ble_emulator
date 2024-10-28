part of 'ble_emulator_bloc.dart';

abstract class BleEmulatorEvent extends Equatable {
  const BleEmulatorEvent();

  @override
  List<Object?> get props => [];
}


class StartBleSession extends BleEmulatorEvent {
  final String clientId;
  final int aliveTimeout;
  final int pauseTimeout;

  const StartBleSession({
    required this.clientId,
    required this.aliveTimeout,
    required this.pauseTimeout,
  });

  @override
  List<Object?> get props => [clientId, aliveTimeout, pauseTimeout];
}


class AliveBleSession extends BleEmulatorEvent {
  final String clientId;

  const AliveBleSession({required this.clientId});

  @override
  List<Object?> get props => [clientId];
}


class PauseBleSession extends BleEmulatorEvent {
  final String clientId;

  const PauseBleSession({required this.clientId});

  @override
  List<Object?> get props => [clientId];
}


class ContinueBleSession extends BleEmulatorEvent {
  final String clientId;

  const ContinueBleSession({required this.clientId});

  @override
  List<Object?> get props => [clientId];
}

class StopBleSession extends BleEmulatorEvent {
  final String clientId;

  const StopBleSession({required this.clientId});

  @override
  List<Object?> get props => [clientId];
}
