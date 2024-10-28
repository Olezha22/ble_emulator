import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ble_emulator/repositories/ble_emulator_repository.dart';

part 'ble_emulator_event.dart';
part 'ble_emulator_state.dart';

class BleEmulatorBloc extends Bloc<BleEmulatorEvent, BleEmulatorState> {
  final BleEmulatorRepository _bleEmulator = BleEmulatorRepository();
  Timer? _pauseTimeoutTimer;
  Timer? _aliveTimeoutTimer;

  BleEmulatorBloc() : super(BleEmulatorInitial()) {
    on<StartBleSession>(_onStart);
    on<AliveBleSession>(_onAlive);
    on<PauseBleSession>(_onPause);
    on<ContinueBleSession>(_onContinue);
    on<StopBleSession>(_onStop);
  }

  void _onStart(StartBleSession event, Emitter<BleEmulatorState> emit) {
    if (_bleEmulator.status != DeviceStatus.waiting) {
      emit(const BleEmulatorError("Failed to start"));
    }

    _bleEmulator.start(event.clientId, event.aliveTimeout, event.pauseTimeout);
    if (_bleEmulator.status == DeviceStatus.activated) {
      emit(BleEmulatorActivated());
      _startAliveTimeout(_bleEmulator.aliveTimeout!, event.clientId);
    }
  }

  void _onAlive(AliveBleSession event, Emitter<BleEmulatorState> emit) {
    if (_bleEmulator.status != DeviceStatus.activated) {
      emit(const BleEmulatorError(
          "Failed to alive because no activated connection"));
    } else if (_bleEmulator.clientId != event.clientId) {
      emit(const BleEmulatorError("Failed to Alive Client Id's is different"));
    } else {
      _bleEmulator.alive(event.clientId);
      if (_bleEmulator.status == DeviceStatus.activated) {
        emit(BleEmulatorActivated());
        _startAliveTimeout(_bleEmulator.aliveTimeout!, event.clientId);
      } else if (_bleEmulator.status == DeviceStatus.waiting) {
        emit(BleEmulatorWaiting());
      }
    }
  }

  void _onPause(PauseBleSession event, Emitter<BleEmulatorState> emit) {
    if (_bleEmulator.status != DeviceStatus.activated) {
      emit(const BleEmulatorError(
          "Failed to pause because no activated connection"));
    } else if (_bleEmulator.clientId != event.clientId) {
      emit(const BleEmulatorError("Failed to pause Client Id's is different"));
    } else {
      _bleEmulator.pause(event.clientId);
      if (_bleEmulator.status == DeviceStatus.paused) {
        emit(BleEmulatorPaused());
        _startPauseTimeout(_bleEmulator.pauseTimeout!, event.clientId);
      }
    }
  }

  void _onContinue(ContinueBleSession event, Emitter<BleEmulatorState> emit) {
    if (_bleEmulator.status != DeviceStatus.paused) {
      emit(const BleEmulatorError(
          "Failed to pause because no Paused connection"));
    } else if (_bleEmulator.clientId != event.clientId) {
      emit(const BleEmulatorError(
          "Failed to continue Client Id's is different"));
    } else {
      _bleEmulator.continueSession(event.clientId);
      if (_bleEmulator.status == DeviceStatus.activated) {
        emit(BleEmulatorActivated());
        _startAliveTimeout(_bleEmulator.aliveTimeout!, event.clientId);
      }
    }
  }

  void _onStop(StopBleSession event, Emitter<BleEmulatorState> emit) {
    if (_bleEmulator.clientId != event.clientId) {
      emit(const BleEmulatorError("Failed to stop Client Id's is different"));
      return;
    }

    _bleEmulator.stop(event.clientId);
    _cancelTimers();

    if (_bleEmulator.status == DeviceStatus.waiting) {
      emit(BleEmulatorWaiting());
    } else {
      emit(const BleEmulatorError("Failed to stop BLE session"));
    }
  }

  void _startPauseTimeout(int pauseTimeout, String clientId) {
    _cancelTimers();
    _pauseTimeoutTimer = Timer(Duration(seconds: pauseTimeout), () {
      _bleEmulator.stop(clientId);
      add(StopBleSession(clientId: clientId));
    });
  }

  void _startAliveTimeout(int aliveTimeout, String clientId) {
    _cancelTimers();
    _aliveTimeoutTimer = Timer(Duration(seconds: aliveTimeout), () {
      _bleEmulator.stop(clientId);
      add(StopBleSession(clientId: clientId));
    });
  }

  void _cancelTimers() {
    _pauseTimeoutTimer?.cancel();
    _aliveTimeoutTimer?.cancel();
  }
}
