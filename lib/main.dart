import 'package:flutter/material.dart';
import 'core/di/service_locator.dart';
import 'core/theme/app_theme.dart';
import 'shared/widgets/app_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  setupServiceLocator();
  runApp(const StudioFlowApp());
}

class StudioFlowApp extends StatelessWidget {
  const StudioFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudioFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const AppShell(),
    );
  }
}
