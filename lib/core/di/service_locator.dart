import 'package:get_it/get_it.dart';
import '../database/app_database.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Banco de dados — singleton
  getIt.registerSingleton<AppDatabase>(AppDatabase());
}
