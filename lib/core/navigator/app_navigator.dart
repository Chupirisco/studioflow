import 'package:flutter/material.dart';

enum AppRota {
  dashboard,
  clientes,
  detalheCliente,
  cadastrarCliente,
  servicos,
  cadastrarServico,
  editarServico,
}

class AppNavigator extends ChangeNotifier {
  AppRota _rota = AppRota.dashboard;
  AppRota get rota => _rota;

  // Argumentos opcionais para passar dados entre telas
  Object? _args;
  Object? get args => _args;

  void navegar(AppRota rota, {Object? args}) {
    _rota = rota;
    _args = args;
    notifyListeners();
  }

  void voltar() {
    switch (_rota) {
      case AppRota.editarServico:
      case AppRota.cadastrarServico:
        navegar(AppRota.servicos);
        break;
      case AppRota.detalheCliente:
      case AppRota.cadastrarCliente:
        navegar(AppRota.clientes);
        break;
      default:
        navegar(AppRota.dashboard);
    }
  }
}
