import 'package:ble_emulator/bloc/ble_emulator_bloc.dart';
import 'package:ble_emulator/screens/home/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _bleEmulatorBloc = BleEmulatorBloc();
  bool isSwitched = false;

  @override
  void dispose() {
    _bleEmulatorBloc.close();
    super.dispose();
  }

  void _handleBLECommand(String command) {
    const clientId = "123";
    switch (command) {
      case 'Start':
        _bleEmulatorBloc.add(const StartBleSession(
          clientId: clientId,
          aliveTimeout: 10,
          pauseTimeout: 5,
        ));
        break;
      case 'Alive':
        _bleEmulatorBloc.add(const AliveBleSession(clientId: clientId));
        break;
      case 'Pause':
        _bleEmulatorBloc.add(const PauseBleSession(clientId: clientId));
        break;
      case 'Continue':
        _bleEmulatorBloc.add(const ContinueBleSession(clientId: clientId));
        break;
      case 'Stop':
        _bleEmulatorBloc.add(const StopBleSession(clientId: clientId));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        centerTitle: true,
        elevation: 1,
        actions: [
          IconButton(
            onPressed: () {
              context.push('/settings');
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: BlocListener<BleEmulatorBloc, BleEmulatorState>(
        bloc: _bleEmulatorBloc,
        listener: (context, state) {
          if (state is BleEmulatorError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                duration: const Duration(seconds: 2),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<BleEmulatorBloc, BleEmulatorState>(
          bloc: _bleEmulatorBloc,
          builder: (context, state) {
            String statusText;
            if (state is BleEmulatorActivated) {
              statusText = "Activated";
              isSwitched = true;
            } else if (state is BleEmulatorPaused) {
              statusText = "Paused";
              isSwitched = false;
            } else {
              statusText = "Waiting";
              isSwitched = false;
            }

            return SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  StatusCard(
                    statusText: statusText,
                  ),
                  const SizedBox(height: 15),
                  CustomSwitch(
                    isSwitched: isSwitched,
                    onChanged: (value) {
                      if (state is BleEmulatorActivated) {
                        _handleBLECommand('Stop');
                      }
                    },
                  ),
                  const SizedBox(height: 25),
                  CommandButton(
                    command: 'Start',
                    onPressed: () => _handleBLECommand('Start'),
                  ),
                  CommandButton(
                    command: 'Alive',
                    onPressed: () => _handleBLECommand('Alive'),
                  ),
                  CommandButton(
                    command: 'Pause',
                    onPressed: () => _handleBLECommand('Pause'),
                  ),
                  CommandButton(
                    command: 'Continue',
                    onPressed: () => _handleBLECommand('Continue'),
                  ),
                  CommandButton(
                    command: 'Stop',
                    onPressed: () => _handleBLECommand('Stop'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
