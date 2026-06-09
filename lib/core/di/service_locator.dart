import 'package:get_it/get_it.dart';
import '../database/app_database.dart';
import '../navigator/app_navigator.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingleton<AppDatabase>(AppDatabase());
  // Singleton pois controla navegação global
  getIt.registerSingleton<AppNavigator>(AppNavigator());
}
