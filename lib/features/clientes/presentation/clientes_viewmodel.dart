import 'package:flutter/material.dart';
import '../../../core/database/app_database.dart';
import '../../../core/di/service_locator.dart';

enum FiltroCliente { todos, ativos, inativos }

class ClientesViewModel extends ChangeNotifier {
  final AppDatabase _db = getIt<AppDatabase>();

  List<Cliente> _todos = [];
  List<Cliente> _filtrados = [];
  List<Cliente> get clientes => _filtrados;

  FiltroCliente _filtro = FiltroCliente.todos;
  FiltroCliente get filtro => _filtro;

  String _busca = '';

  bool _carregando = false;
  bool get carregando => _carregando;

  Future<void> carregar() async {
    _carregando = true;
    notifyListeners();

    _todos = await _db.getAllClientes();
    _aplicarFiltros();

    _carregando = false;
    notifyListeners();
  }

  void buscar(String texto) {
    _busca = texto.toLowerCase();
    _aplicarFiltros();
    notifyListeners();
  }

  void mudarFiltro(FiltroCliente filtro) {
    _filtro = filtro;
    _aplicarFiltros();
    notifyListeners();
  }

  void _aplicarFiltros() {
    var lista = _todos;

    // Filtro ativo/inativo
    if (_filtro == FiltroCliente.ativos) {
      lista = lista.where((c) => c.ativo).toList();
    } else if (_filtro == FiltroCliente.inativos) {
      lista = lista.where((c) => !c.ativo).toList();
    }

    // Filtro de busca por nome ou empresa
    if (_busca.isNotEmpty) {
      lista = lista.where((c) {
        return c.nome.toLowerCase().contains(_busca) ||
            c.empresa.toLowerCase().contains(_busca);
      }).toList();
    }

    _filtrados = lista;
  }

  Future<void> inserir(ClientesCompanion cliente) async {
    await _db.insertCliente(cliente);
    await carregar();
  }

  Future<void> atualizar(ClientesCompanion cliente) async {
    await _db.updateCliente(cliente);
    await carregar();
  }

  Future<void> excluir(int id) async {
    await _db.deleteCliente(id);
    await carregar();
  }
}
