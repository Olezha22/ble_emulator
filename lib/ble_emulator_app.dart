import 'package:ble_emulator/routes/router.dart';
import 'package:flutter/material.dart';

class BleEmulatorApp extends StatelessWidget {
  const BleEmulatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
