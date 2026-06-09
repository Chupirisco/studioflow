import 'package:flutter/material.dart';
import 'package:studioflow/core/styles/box_shadow.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/navigator/app_navigator.dart';
import '../../../core/theme/app_theme.dart';
import 'clientes_viewmodel.dart';
import '../../../core/database/app_database.dart';

class ClientesPage extends StatefulWidget {
  const ClientesPage({super.key});

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  final _vm = ClientesViewModel();
  final _buscaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _vm.carregar();
    _vm.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _vm.dispose();
    _buscaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // ── BARRA DE AÇÕES ───────────────────────────
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: TextField(
                    controller: _buscaController,
                    onChanged: _vm.buscar,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textPrimary,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Pesquisar',
                      hintStyle: TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        size: 18,
                        color: AppTheme.textSecondary,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              Container(
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<FiltroCliente>(
                    value: _vm.filtro,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      size: 18,
                      color: AppTheme.textSecondary,
                    ),
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textPrimary,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: FiltroCliente.todos,
                        child: Text('Todos'),
                      ),
                      DropdownMenuItem(
                        value: FiltroCliente.ativos,
                        child: Text('Ativos'),
                      ),
                      DropdownMenuItem(
                        value: FiltroCliente.inativos,
                        child: Text('Inativos'),
                      ),
                    ],
                    onChanged: (v) {
                      if (v != null) _vm.mudarFiltro(v);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),

              SizedBox(
                height: 42,
                child: ElevatedButton.icon(
                  // Navega para tela de cadastro via AppNavigator
                  onPressed: () =>
                      getIt<AppNavigator>().navegar(AppRota.cadastrarCliente),
                  icon: const Icon(Icons.add, size: 16, color: Colors.white),
                  label: const Text(
                    'Cadastrar',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── GRID DE CLIENTES ─────────────────────────
          Expanded(
            child: _vm.carregando
                ? const Center(child: CircularProgressIndicator())
                : _vm.clientes.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhum cliente encontrado.',
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                  )
                : GridView.builder(
                    clipBehavior: Clip.none,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.6,
                        ),
                    itemCount: _vm.clientes.length,
                    itemBuilder: (context, i) =>
                        _CardCliente(cliente: _vm.clientes[i], vm: _vm),
                  ),
          ),
        ],
      ),
    );
  }
}

// ── CARD COM HOVER ───────────────────────────────────────
class _CardCliente extends StatefulWidget {
  final Cliente cliente;
  final ClientesViewModel vm;

  const _CardCliente({required this.cliente, required this.vm});

  @override
  State<_CardCliente> createState() => _CardClienteState();
}

class _CardClienteState extends State<_CardCliente> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.cliente;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: GestureDetector(
          // Navega para detalhe/edição via AppNavigator
          onTap: () => getIt<AppNavigator>().navegar(
            AppRota.detalheCliente,
            args: {'cliente': c}, // removido 'vm': widget.vm
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _hovered
                    ? AppTheme.primary.withValues(alpha: 0.35)
                    : AppTheme.border,
              ),
              boxShadow: _hovered ? [sombreamento()] : AppTheme.cardShadow,
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: ícone + nome empresa
                Row(
                  children: [
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
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        c.empresa,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                Text(
                  c.nome,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  c.telefone,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),

                Expanded(
                  child: Text(
                    c.descricao,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),

                // Badge status
                // Ativo: borda/texto verde #3DA35C | Inativo: cinza
                Align(
                  alignment: AlignmentGeometry.centerRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      boxShadow: [sombreamento()],
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      c.ativo ? 'Ativo' : 'Inativo',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: c.ativo ? AppTheme.green : AppTheme.amber,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
