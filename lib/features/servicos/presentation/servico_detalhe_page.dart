import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/database/app_database.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/navigator/app_navigator.dart';
import '../../../core/theme/app_theme.dart';
import 'package:drift/drift.dart' show Value;

import '../../../shared/widgets/app_bar_interna.dart';

class ServicoDetalhePage extends StatefulWidget {
  final Object? args;

  const ServicoDetalhePage({super.key, this.args});

  @override
  State<ServicoDetalhePage> createState() => _ServicoDetalhePageState();
}

class _ServicoDetalhePageState extends State<ServicoDetalhePage> {
  // Acesso direto ao banco — não depende do ViewModel da page anterior
  final AppDatabase _db = getIt<AppDatabase>();

  final _produtoCtrl = TextEditingController();
  final _valorCtrl = TextEditingController();
  final _descricaoCtrl = TextEditingController();

  int _tipoServico = 0;
  int _statusServico = 0;
  bool _salvando = false;
  late Servico _servico;
  Cliente? _cliente;

  @override
  void initState() {
    super.initState();
    final data = widget.args as Map<String, dynamic>;
    _servico = data['servico'] as Servico;

    // Cliente passado direto nos args — não precisa do vm
    _cliente = data['cliente'] as Cliente?;

    _produtoCtrl.text = _servico.nomeProduto;
    _valorCtrl.text = _servico.valor.toStringAsFixed(2).replaceAll('.', ',');
    _descricaoCtrl.text = _servico.descricao;
    _tipoServico = _servico.tipoServico;
    _statusServico = _servico.statusServico;
  }

  @override
  void dispose() {
    _produtoCtrl.dispose();
    _valorCtrl.dispose();
    _descricaoCtrl.dispose();
    super.dispose();
  }

  double _parseValor() {
    final texto = _valorCtrl.text
        .replaceAll('R\$', '')
        .replaceAll(' ', '')
        .replaceAll('.', '')
        .replaceAll(',', '.');
    return double.tryParse(texto) ?? 0.0;
  }

  Future<void> _salvar() async {
    if (_produtoCtrl.text.trim().isEmpty) return;
    setState(() => _salvando = true);

    await _db.updateServico(
      ServicosCompanion(
        id: Value(_servico.id),
        nomeProduto: Value(_produtoCtrl.text.trim()),
        tipoServico: Value(_tipoServico),
        descricao: Value(_descricaoCtrl.text.trim()),
        valor: Value(_parseValor()),
        dataCriacao: Value(_servico.dataCriacao),
        statusServico: Value(_statusServico),
        clienteId: Value(_servico.clienteId),
      ),
    );

    if (mounted) getIt<AppNavigator>().voltar();
  }

  Future<void> _confirmarExclusao() async {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.fromLTRB(28, 28, 28, 20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 15,
                  color: AppTheme.textPrimary,
                ),
                children: [
                  const TextSpan(text: 'Deseja excluir o serviço '),
                  TextSpan(
                    text: _servico.nomeProduto,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const TextSpan(text: '?'),
                ],
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Esta ação não tem volta!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Não',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(ctx);
                        await _db.deleteServico(_servico.id);
                        if (mounted) getIt<AppNavigator>().voltar();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.amber,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Sim',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          // ── TOPBAR ──────────────────────────────────
          AppBarInterna(titulo: 'Editar serviço'),

          // ── CONTEÚDO ────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _labelCampo('Empresa'),
                  const SizedBox(height: 6),
                  _campoReadOnly(_cliente?.empresa ?? '—'),
                  const SizedBox(height: 16),

                  _labelCampo('Nome do cliente'),
                  const SizedBox(height: 6),
                  _campoReadOnly(_cliente?.nome ?? '—'),
                  const SizedBox(height: 16),

                  _labelCampo('Nome do produto*'),
                  const SizedBox(height: 6),
                  _campoEditavel(_produtoCtrl, 'Ex: Embalagem linha premium'),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      SizedBox(
                        width: 160,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _labelCampo('Valor'),
                            const SizedBox(height: 6),
                            _campoValor(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _labelCampo('Status'),
                          const SizedBox(height: 6),
                          _combobox(
                            value: _statusServico,
                            cor: _statusServico == 0
                                ? AppTheme.amber
                                : AppTheme.green,
                            items: const [
                              DropdownMenuItem(
                                value: 0,
                                child: Text(
                                  'Pendente',
                                  style: TextStyle(color: AppTheme.amber),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 1,
                                child: Text(
                                  'Finalizado',
                                  style: TextStyle(color: AppTheme.green),
                                ),
                              ),
                            ],
                            onChanged: (v) =>
                                setState(() => _statusServico = v ?? 0),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _labelCampo('Tipo'),
                          const SizedBox(height: 6),
                          _combobox(
                            value: _tipoServico,
                            cor: AppTheme.textPrimary,
                            items: const [
                              DropdownMenuItem(
                                value: 0,
                                child: Text(
                                  'Criação',
                                  style: TextStyle(color: AppTheme.green),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 1,
                                child: Text(
                                  'Alteração',
                                  style: TextStyle(color: AppTheme.primary),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 2,
                                child: Text(
                                  'Correção',
                                  style: TextStyle(color: AppTheme.amber),
                                ),
                              ),
                            ],
                            onChanged: (v) =>
                                setState(() => _tipoServico = v ?? 0),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _labelCampo('Descrição'),
                  const SizedBox(height: 6),
                  _campoEditavel(_descricaoCtrl, '', maxLines: 6),
                ],
              ),
            ),
          ),

          // ── BOTÕES INFERIORES ────────────────────────
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 160,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _salvando ? null : _confirmarExclusao,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Excluir',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 180,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _salvando ? null : _salvar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _salvando
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Confirmar edição',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _labelCampo(String texto) {
    return Text(
      texto,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppTheme.textSecondary,
      ),
    );
  }

  Widget _campoReadOnly(String valor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.border),
      ),
      child: Text(
        valor,
        style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
      ),
    );
  }

  Widget _campoEditavel(
    TextEditingController ctrl,
    String hint, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
        filled: true,
        fillColor: AppTheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppTheme.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppTheme.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _campoValor() {
    return TextField(
      controller: _valorCtrl,
      keyboardType: TextInputType.number,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppTheme.textPrimary,
      ),
      inputFormatters: [_MascaraReal()],
      decoration: InputDecoration(
        prefixText: 'R\$ ',
        prefixStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimary,
        ),
        filled: true,
        fillColor: AppTheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppTheme.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppTheme.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _combobox({
    required int value,
    required Color cor,
    required List<DropdownMenuItem<int>> items,
    required void Function(int?) onChanged,
  }) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: cor,
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            size: 18,
            color: AppTheme.textSecondary,
          ),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// ── MÁSCARA DE VALOR MONETÁRIO ───────────────────────────
class _MascaraReal extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digits = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (digits.isEmpty) return newValue.copyWith(text: '');

    final value = int.parse(digits);
    final reais = value ~/ 100;
    final centavos = value % 100;
    final formatted = '$reais,${centavos.toString().padLeft(2, '0')}';

    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
