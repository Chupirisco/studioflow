import 'package:flutter/material.dart';
import 'package:studioflow/features/servicos/presentation/servico_detalhe_page.dart';

import '../../core/navigator/app_navigator.dart';
import '../../core/theme/app_theme.dart';
import '../../core/di/service_locator.dart';
import '../../features/clientes/presentation/cliente_detalhe_page.dart';
import '../../features/clientes/presentation/cliente_form_page.dart';
import '../../features/dashboard/presentation/dashboard_page.dart';
import '../../features/clientes/presentation/clientes_page.dart';
import '../../features/servicos/presentation/servico_form_page.dart';
import '../../features/servicos/presentation/servicos_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final _navigator = getIt<AppNavigator>();

  // Mapeia rota → índice do sidebar
  int get _sidebarIndex {
    switch (_navigator.rota) {
      case AppRota.dashboard:
        return 0;
      case AppRota.clientes:
      case AppRota.detalheCliente:
      case AppRota.cadastrarCliente:
        return 1;
      case AppRota.servicos:
      case AppRota.cadastrarServico:
      case AppRota.editarServico:
        return 2;
    }
  }

  final List<_NavItem> _navItems = const [
    _NavItem(icon: Icons.home_outlined, label: 'Dashboard'),
    _NavItem(icon: Icons.people_outline, label: 'Clientes'),
    _NavItem(icon: Icons.work_outline, label: 'Serviços'),
    _NavItem(icon: Icons.attach_money, label: 'Financeiro'),
  ];

  void _onNavTap(int index) {
    final rotas = [
      AppRota.dashboard,
      AppRota.clientes,
      AppRota.servicos,
      AppRota.dashboard, // Financeiro ainda em branco
    ];
    _navigator.navegar(rotas[index]);
  }

  Widget _buildPagina() {
    switch (_navigator.rota) {
      case AppRota.dashboard:
        return const DashboardPage();
      case AppRota.clientes:
        return const ClientesPage();
      case AppRota.detalheCliente:
        return ClienteDetalhePage(args: _navigator.args);
      case AppRota.cadastrarCliente:
        return ClienteFormPage(args: _navigator.args);
      case AppRota.servicos:
        return const ServicosPage();
      case AppRota.cadastrarServico:
        return ServicoFormPage(args: _navigator.args);
      case AppRota.editarServico:
        return ServicoDetalhePage(args: _navigator.args);
    }
  }

  @override
  void initState() {
    super.initState();
    _navigator.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _navigator.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ── TOPBAR ──────────────────────────────────
          Container(
            height: 52,
            color: AppTheme.surface,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Text(
                  'StudioFlow',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
                const Spacer(),
                Text(
                  _formatDate(DateTime.now()),
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: AppTheme.border),

          Expanded(
            child: Row(
              children: [
                // ── SIDEBAR ───────────────────────────
                Container(
                  width: 64,
                  color: AppTheme.surface,
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      ...List.generate(_navItems.length, (i) {
                        final active = _sidebarIndex == i;
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 2,
                          ),
                          child: Tooltip(
                            message: _navItems[i].label,
                            child: InkWell(
                              onTap: () => _onNavTap(i),
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: active
                                      ? AppTheme.primaryLight
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  _navItems[i].icon,
                                  size: 20,
                                  color: active
                                      ? AppTheme.primary
                                      : AppTheme.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: AppTheme.border,
                ),

                // ── CONTEÚDO CENTRAL ──────────────────
                Expanded(child: _buildPagina()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
