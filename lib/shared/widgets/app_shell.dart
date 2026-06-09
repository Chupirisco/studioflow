import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../features/dashboard/presentation/dashboard_page.dart';
import '../../features/clientes/presentation/clientes_page.dart';
import '../../features/servicos/presentation/servicos_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    DashboardPage(),
    ClientesPage(),
    ServicosPage(),
    Placeholder(), // Financeiro — em branco por enquanto
  ];

  // Itens do sidebar
  // ícone: Material Icons (substituir por Fluent Icons futuramente)
  final List<_NavItem> _navItems = const [
    _NavItem(icon: Icons.home_outlined, label: 'Dashboard'),
    _NavItem(icon: Icons.people_outline, label: 'Clientes'),
    _NavItem(icon: Icons.work_outline, label: 'Serviços'),
    _NavItem(icon: Icons.attach_money, label: 'Financeiro'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ── TOPBAR ──────────────────────────────────────
          Container(
            height: 52,
            color: AppTheme.surface,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                // Logo: texto StudioFlow azul #2563EB
                const Text(
                  'StudioFlow',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
                const Spacer(),
                // Data atual
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

          // Divisor topbar
          const Divider(height: 1, thickness: 1, color: AppTheme.border),

          // ── MAIN AREA ────────────────────────────────────
          Expanded(
            child: Row(
              children: [
                // ── SIDEBAR ───────────────────────────────
                Container(
                  width: 64,
                  color: AppTheme.surface,
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      ...List.generate(_navItems.length, (i) {
                        final active = _selectedIndex == i;
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 2,
                          ),
                          child: Tooltip(
                            message: _navItems[i].label,
                            child: InkWell(
                              onTap: () => setState(() => _selectedIndex = i),
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  // Ativo: fundo azul claro #EEF2FF
                                  // Inativo: transparente
                                  color: active
                                      ? AppTheme.primaryLight
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  _navItems[i].icon,
                                  size: 20,
                                  // Ativo: azul #2563EB | Inativo: cinza #6B7280
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

                // Divisor sidebar
                const VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: AppTheme.border,
                ),

                // ── CONTEÚDO ──────────────────────────────
                Expanded(child: _pages[_selectedIndex]),
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
