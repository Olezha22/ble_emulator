import 'package:ble_emulator/screens/settings/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../repositories/settings_repository.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _connectionNameController = TextEditingController();
  final _uuidController = TextEditingController();
  final _settingsRepository = SettingsRepository();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _connectionNameController.dispose();
    _uuidController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final connectionName = await _settingsRepository.getConnectionName();
    final uuid = await _settingsRepository.getUUID();
    setState(() {
      _connectionNameController.text = connectionName ?? '';
      _uuidController.text = uuid ?? '';
    });
  }

  Future<void> _saveSettings( context) async {
    await _settingsRepository.saveSettings(
      _connectionNameController.text,
      _uuidController.text,
    );
    GoRouter.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
        elevation: 1,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomTextField(
                controller: _connectionNameController,
                label: "Connection name",
              ),
              const SizedBox(height: 15),
              CustomTextField(
                controller: _uuidController,
                label: "UUID",
              ),
              const SizedBox(height: 25),
              CommandButton(
                  command: "Save", onPressed: () => _saveSettings(context)),
            ],
          ),
        ),
      ),
    );
  }
}
