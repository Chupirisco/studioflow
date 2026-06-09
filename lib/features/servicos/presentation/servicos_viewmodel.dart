import 'package:flutter/material.dart';
import '../../../core/database/app_database.dart';
import '../../../core/di/service_locator.dart';

enum FiltroServico { todos, pendentes, finalizados }

class ServicosViewModel extends ChangeNotifier {
  final AppDatabase _db = getIt<AppDatabase>();

  List<Servico> _todos = [];
  List<Servico> _filtrados = [];
  List<Cliente> _clientes = [];

  List<Servico> get servicos => _filtrados;
  List<Cliente> get clientes => _clientes;

  FiltroServico _filtro = FiltroServico.todos;
  FiltroServico get filtro => _filtro;

  String _busca = '';
  bool _carregando = false;
  bool get carregando => _carregando;

  Future<void> carregar() async {
    _carregando = true;
    notifyListeners();
    _todos = await _db.getAllServicos();
    _clientes = await _db.getAllClientes();
    _aplicarFiltros();
    _carregando = false;
    notifyListeners();
  }

  void buscar(String texto) {
    _busca = texto.toLowerCase();
    _aplicarFiltros();
    notifyListeners();
  }

  void mudarFiltro(FiltroServico filtro) {
    _filtro = filtro;
    _aplicarFiltros();
    notifyListeners();
  }

  void _aplicarFiltros() {
    var lista = _todos;

    if (_filtro == FiltroServico.pendentes) {
      lista = lista.where((s) => s.statusServico == 0).toList();
    } else if (_filtro == FiltroServico.finalizados) {
      lista = lista.where((s) => s.statusServico == 1).toList();
    }

    if (_busca.isNotEmpty) {
      lista = lista.where((s) {
        final clienteDoServico = _clientes.firstWhere(
          (c) => c.id == s.clienteId,
          orElse: () => Cliente(
            id: -1,
            nome: '',
            empresa: '',
            telefone: '',
            descricao: '',
            ativo: false,
          ),
        );
        return s.nomeProduto.toLowerCase().contains(_busca) ||
            clienteDoServico.nome.toLowerCase().contains(_busca) ||
            clienteDoServico.empresa.toLowerCase().contains(_busca);
      }).toList();
    }

    _filtrados = lista;
  }

  Cliente? getCliente(int clienteId) {
    try {
      return _clientes.firstWhere((c) => c.id == clienteId);
    } catch (_) {
      return null;
    }
  }

  Future<void> inserir(ServicosCompanion servico) async {
    await _db.insertServico(servico);
    await carregar();
  }

  Future<void> atualizar(ServicosCompanion servico) async {
    await _db.updateServico(servico);
    await carregar();
  }

  Future<void> excluir(int id) async {
    await _db.deleteServico(id);
    await carregar();
  }
}
