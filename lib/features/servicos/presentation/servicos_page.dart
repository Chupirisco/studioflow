import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/navigator/app_navigator.dart';
import '../../../core/styles/box_shadow.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/database/app_database.dart';
import 'servicos_viewmodel.dart';

class ServicosPage extends StatefulWidget {
  const ServicosPage({super.key});

  @override
  State<ServicosPage> createState() => _ServicosPageState();
}

class _ServicosPageState extends State<ServicosPage> {
  final _vm = ServicosViewModel();
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
                  child: DropdownButton<FiltroServico>(
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
                        value: FiltroServico.todos,
                        child: Text('Todos'),
                      ),
                      DropdownMenuItem(
                        value: FiltroServico.pendentes,
                        child: Text('Pendentes'),
                      ),
                      DropdownMenuItem(
                        value: FiltroServico.finalizados,
                        child: Text('Finalizados'),
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
                  onPressed: () =>
                      getIt<AppNavigator>().navegar(AppRota.cadastrarServico),
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

          // ── GRID DE SERVIÇOS ─────────────────────────
          Expanded(
            child: _vm.carregando
                ? const Center(child: CircularProgressIndicator())
                : _vm.servicos.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhum serviço encontrado.',
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                  )
                : GridView.builder(
                    clipBehavior: Clip.none,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 400,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          mainAxisExtent: 250,
                        ),
                    itemCount: _vm.servicos.length,
                    itemBuilder: (context, i) =>
                        _CardServico(servico: _vm.servicos[i], vm: _vm),
                  ),
          ),
        ],
      ),
    );
  }
}

// ── CARD COM HOVER ───────────────────────────────────────
class _CardServico extends StatefulWidget {
  final Servico servico;
  final ServicosViewModel vm;

  const _CardServico({required this.servico, required this.vm});

  @override
  State<_CardServico> createState() => _CardServicoState();
}

class _CardServicoState extends State<_CardServico> {
  bool _hovered = false;

  static const _tipoLabel = ['Criação', 'Alteração', 'Correção'];
  static const _tipoColor = [AppTheme.green, AppTheme.primary, AppTheme.amber];

  String _formatarData(DateTime dt) => DateFormat('dd/MM/yyyy').format(dt);

  String _formatarValor(double v) =>
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(v);

  @override
  Widget build(BuildContext context) {
    final s = widget.servico;
    final cliente = widget.vm.getCliente(s.clienteId);
    final isPendente = s.statusServico == 0;
    final tipoColor = _tipoColor[s.tipoServico.clamp(0, 2)];
    final tipoLabel = _tipoLabel[s.tipoServico.clamp(0, 2)];

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: GestureDetector(
          onTap: () => getIt<AppNavigator>().navegar(
            AppRota.editarServico,
            args: {'servico': s, 'cliente': widget.vm.getCliente(s.clienteId)},
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
              // Padronizado com clientes_page: usa sombreamento()
              boxShadow: _hovered ? [sombreamento()] : AppTheme.cardShadow,
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── HEADER ─────────────────────────────
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
                        color: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        cliente?.empresa ?? '—',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Tipo do serviço com ponto colorido
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: tipoColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          tipoLabel,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // ── DADOS ───────────────────────────────
                Text(
                  cliente?.nome ?? '—',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  s.nomeProduto,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  _formatarData(s.dataCriacao),
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _formatarValor(s.valor),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),

                // ── DESCRIÇÃO ───────────────────────────
                Expanded(
                  child: Text(
                    s.descricao,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),

                // ── FOOTER: STATUS ──────────────────────
                // Padronizado com clientes_page: badge com background + borderRadius 5
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      boxShadow: [sombreamento()],
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      isPendente ? 'Pendente' : 'Finalizado',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        // Pendente: âmbar #F5A02F | Finalizado: verde #3DA35C
                        color: isPendente ? AppTheme.amber : AppTheme.green,
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
