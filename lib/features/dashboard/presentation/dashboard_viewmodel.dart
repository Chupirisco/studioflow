import 'package:flutter/material.dart';
import '../../../core/database/app_database.dart';
import '../../../core/di/service_locator.dart';

class DashboardViewModel extends ChangeNotifier {
  final AppDatabase _db = getIt<AppDatabase>();

  List<Servico> _servicosPendentes = [];
  List<Servico> get servicosPendentes => _servicosPendentes;

  // Expõe a lista completa sem paginação (usada pelo PageView do card)
  List<Servico> get todosPendentes => _servicosPendentes;

  double _totalRecebido = 0;
  double get totalRecebido => _totalRecebido;

  double _totalAReceber = 0;
  double get totalAReceber => _totalAReceber;

  // Dados do gráfico por mês
  List<double> _dadosGrafico = List.filled(12, 0);
  List<double> get dadosGrafico => _dadosGrafico;

  // true = exibindo serviços | false = exibindo fatura
  bool _modoServicos = true;
  bool get modoServicos => _modoServicos;

  String get tituloGrafico =>
      _modoServicos ? 'Serviços por mês' : 'Fatura por mês';

  // Paginação dos serviços pendentes
  int _paginaAtual = 0;
  int get paginaAtual => _paginaAtual;
  static const int itensPorPagina = 4;

  int get totalPaginas =>
      (_servicosPendentes.length / itensPorPagina).ceil().clamp(1, 999);

  List<Servico> get servicosPaginados {
    final start = _paginaAtual * itensPorPagina;
    final end = (start + itensPorPagina).clamp(0, _servicosPendentes.length);
    if (start >= _servicosPendentes.length) return [];
    return _servicosPendentes.sublist(start, end);
  }

  Future<void> carregar() async {
    final todos = await _db.getAllServicos();
    final pendentes = await _db.getServicosPendentes();

    _servicosPendentes = pendentes;
    _totalRecebido = await _db.getTotalRecebido();
    _totalAReceber = await _db.getTotalAReceber();

    _atualizarGrafico(todos);
    _paginaAtual = 0;
    notifyListeners();
  }

  void mudarModo(bool modoServicos) {
    _modoServicos = modoServicos;
    _carregarGraficoComModo();
    notifyListeners();
  }

  Future<void> _carregarGraficoComModo() async {
    final todos = await _db.getAllServicos();
    _atualizarGrafico(todos);
    notifyListeners();
  }

  void _atualizarGrafico(List<Servico> todos) {
    final ano = DateTime.now().year;
    _dadosGrafico = List.generate(12, (i) {
      final mes = i + 1;
      final doMes = todos.where(
        (s) => s.dataCriacao.year == ano && s.dataCriacao.month == mes,
      );
      if (_modoServicos) {
        return doMes.length.toDouble();
      } else {
        return doMes.fold<double>(0, (sum, s) => sum + s.valor);
      }
    });
  }

  void proximaPagina() {
    if (_paginaAtual < totalPaginas - 1) {
      _paginaAtual++;
      notifyListeners();
    }
  }

  void paginaAnterior() {
    if (_paginaAtual > 0) {
      _paginaAtual--;
      notifyListeners();
    }
  }

  // Rótulo do tipo de serviço
  // 0=Criação cor verde #3DA35C
  // 1=Alteração cor azul #2563EB
  // 2=Correção cor âmbar #F5A02F
  static String labelTipo(int tipo) {
    switch (tipo) {
      case 0:
        return 'Criação';
      case 1:
        return 'Alteração';
      case 2:
        return 'Correção';
      default:
        return '';
    }
  }

  static Color corTipo(int tipo) {
    switch (tipo) {
      case 0:
        return const Color(0xFF3DA35C); // verde — Criação
      case 1:
        return const Color(0xFF2563EB); // azul — Alteração
      case 2:
        return const Color(0xFFF5A02F); // âmbar — Correção
      default:
        return const Color(0xFF6B7280);
    }
  }
}
