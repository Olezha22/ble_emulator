part of 'ble_emulator_bloc.dart';

abstract class BleEmulatorState extends Equatable {
  const BleEmulatorState();

  @override
  List<Object?> get props => [];
}

class BleEmulatorInitial extends BleEmulatorState {}

class BleEmulatorActivated extends BleEmulatorState {}

class BleEmulatorPaused extends BleEmulatorState {}

class BleEmulatorWaiting extends BleEmulatorState {}

class BleEmulatorError extends BleEmulatorState {
  final String errorMessage;

  const BleEmulatorError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
