import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/database/app_database.dart';
import '../../../core/theme/app_theme.dart';
import 'dashboard_viewmodel.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _vm = DashboardViewModel();

  // ── Adicionar no topo da classe _DashboardPageState ──
  late final PageController _pageController;

  // ── Quantidade de serviços exibidos por página ──
  // 👇 ALTERE ESTE VALOR para mudar quantos serviços aparecem por aba
  static const int _servicosPorPagina = 3;

  int _paginaAtual = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _vm.carregar();
    _vm.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // LINHA SUPERIOR
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CARD: Serviços Pendentes
                Expanded(child: _cardPendentes()),
                const SizedBox(width: 20),
                // CARD: Resumo Financeiro
                SizedBox(width: 300, child: _cardFinanceiro()),
              ],
            ),
            const SizedBox(height: 20),
            // CARD: Gráfico
            _cardGrafico(),
          ],
        ),
      ),
    );
  }

  // ── CARD SERVIÇOS PENDENTES ──────────────────────────
  Widget _cardPendentes() {
    // ── LÓGICA DE PAGINAÇÃO ──────────────────────────────
    // 👇 Aqui os serviços são divididos em grupos de _servicosPorPagina
    final todos = _vm.todosPendentes; // lista completa sem paginação do vm
    final totalPaginas = (todos.length / _servicosPorPagina).ceil().clamp(
      1,
      999,
    );
    // ────────────────────────────────────────────────────

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.cardShadow,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Serviços pendentes',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),

          if (todos.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'Nenhum serviço pendente',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
              ),
            )
          else
            // PageView horizontal — cada página exibe _servicosPorPagina itens
            SizedBox(
              // Altura dinâmica: _servicosPorPagina × altura de cada item (≈ 57px)
              height: _servicosPorPagina * 70.0,
              child: PageView.builder(
                controller: _pageController,
                itemCount: totalPaginas,
                onPageChanged: (p) => setState(() => _paginaAtual = p),
                itemBuilder: (context, pageIndex) {
                  // ── Fatia dos serviços desta página ─────────────────
                  // 👇 Aqui acontece o slice: pega só os itens da página atual
                  final inicio = pageIndex * _servicosPorPagina;
                  final fim = (inicio + _servicosPorPagina).clamp(
                    0,
                    todos.length,
                  );
                  final itensDaPagina = todos.sublist(inicio, fim);
                  // ────────────────────────────────────────────────────

                  return Column(
                    children: itensDaPagina
                        .map((s) => _itemServico(s))
                        .toList(),
                  );
                },
              ),
            ),

          const SizedBox(height: 8),

          // Dots de paginação
          if (totalPaginas > 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(totalPaginas, (i) {
                final ativo = i == _paginaAtual;
                return GestureDetector(
                  onTap: () => _pageController.animateToPage(
                    i,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                  ),
                  child: Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ativo ? AppTheme.primary : const Color(0xFFD1D5DB),
                    ),
                  ),
                );
              }),
            ),
        ],
      ),
    );
  }

  // Item individual da lista de pendentes
  Widget _itemServico(Servico s) {
    final cor = DashboardViewModel.corTipo(s.tipoServico);
    final label = DashboardViewModel.labelTipo(s.tipoServico);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          // Ícone empresa: fundo azul claro, ícone building
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F4FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.business_outlined,
              size: 17,
              color: AppTheme.primary, // azul #2563EB
            ),
          ),
          const SizedBox(width: 12),

          // Nome do produto
          Expanded(
            child: Text(
              s.nomeProduto,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimary,
              ),
            ),
          ),

          // Dot colorido + tipo
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 6),
                decoration: BoxDecoration(shape: BoxShape.circle, color: cor),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── CARD RESUMO FINANCEIRO ───────────────────────────
  Widget _cardFinanceiro() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.cardShadow,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumo financeiro',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 20),

          // Total recebido
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total recebido',
                style: TextStyle(fontSize: 13, color: AppTheme.textPrimary),
              ),
              Text(
                _formatCurrency(_vm.totalRecebido),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.green, // verde #3DA35C
                ),
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, color: Color(0xFFF3F4F6)),
          ),

          // Total a receber
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total a receber',
                style: TextStyle(fontSize: 13, color: AppTheme.textPrimary),
              ),
              Text(
                _formatCurrency(_vm.totalAReceber),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.amber, // âmbar #F5A02F
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── CARD GRÁFICO ─────────────────────────────────────
  Widget _cardGrafico() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.cardShadow,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: título + toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _vm.tituloGrafico,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              // Toggle Serviços / Fatura
              _toggleGrafico(),
            ],
          ),
          const SizedBox(height: 20),

          // Gráfico de barras
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _vm.dadosGrafico.isEmpty
                    ? 10
                    : (_vm.dadosGrafico.reduce((a, b) => a > b ? a : b) * 1.3)
                          .clamp(1, double.infinity),
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final i = value.toInt();
                        if (i < 0 || i >= _vm.dadosGrafico.length) {
                          return const SizedBox();
                        }
                        final v = _vm.dadosGrafico[i];
                        final label = _vm.modoServicos
                            ? v.toInt().toString()
                            : 'R\$ ${v.toInt()}';
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            label,
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        final meses = [
                          '01',
                          '02',
                          '03',
                          '04',
                          '05',
                          '06',
                          '07',
                          '08',
                          '09',
                          '10',
                          '11',
                          '12',
                        ];
                        final i = value.toInt();
                        if (i < 0 || i >= meses.length) return const SizedBox();
                        final ano = DateTime.now().year;
                        return Text(
                          '${meses[i]}/$ano',
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppTheme.textSecondary,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    bottom: BorderSide(color: AppTheme.border),
                  ),
                ),
                barGroups: List.generate(12, (i) {
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: _vm.dadosGrafico[i],
                        // Cor das barras: azul #2563EB
                        color: AppTheme.primary,
                        width: 28,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(5),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Toggle Serviços / Fatura
  Widget _toggleGrafico() {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _toggleBtn('Serviços', _vm.modoServicos, () => _vm.mudarModo(true)),
          _toggleBtn('Fatura', !_vm.modoServicos, () => _vm.mudarModo(false)),
        ],
      ),
    );
  }

  Widget _toggleBtn(String label, bool ativo, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        decoration: BoxDecoration(
          // Ativo: azul #2563EB | Inativo: transparente
          color: ativo ? AppTheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            // Ativo: branco | Inativo: cinza #6B7280
            color: ativo ? Colors.white : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }

  String _formatCurrency(double value) {
    return 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }
}
