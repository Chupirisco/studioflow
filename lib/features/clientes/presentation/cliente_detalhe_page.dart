import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/navigator/app_navigator.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/database/app_database.dart';
import '../../../shared/widgets/app_bar_interna.dart';

class ClienteDetalhePage extends StatefulWidget {
  final Object? args;

  const ClienteDetalhePage({super.key, this.args});

  @override
  State<ClienteDetalhePage> createState() => _ClienteDetalhePageState();
}

class _ClienteDetalhePageState extends State<ClienteDetalhePage> {
  // Acesso direto ao banco — não depende do ViewModel da page anterior
  final AppDatabase _db = getIt<AppDatabase>();

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nomeController;
  late final TextEditingController _empresaController;
  late final TextEditingController _telefoneController;
  late final TextEditingController _descricaoController;

  final _telefoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {'#': RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  late bool _ativo;
  bool _salvando = false;
  bool _excluindo = false;
  late Cliente _cliente;

  @override
  void initState() {
    super.initState();

    final data = widget.args as Map<String, dynamic>;
    _cliente = data['cliente'] as Cliente;

    _nomeController = TextEditingController(text: _cliente.nome);
    _empresaController = TextEditingController(text: _cliente.empresa);
    _telefoneController = TextEditingController(text: _cliente.telefone);
    _descricaoController = TextEditingController(text: _cliente.descricao);
    _ativo = _cliente.ativo;

    _telefoneMask.formatEditUpdate(
      TextEditingValue.empty,
      TextEditingValue(text: _cliente.telefone),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _empresaController.dispose();
    _telefoneController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  Future<void> _confirmarEdicao() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _salvando = true);

    await _db.updateCliente(
      ClientesCompanion(
        id: Value(_cliente.id),
        nome: Value(_nomeController.text.trim()),
        empresa: Value(_empresaController.text.trim()),
        telefone: Value(_telefoneController.text.trim()),
        descricao: Value(_descricaoController.text.trim()),
        ativo: Value(_ativo),
      ),
    );

    if (mounted) getIt<AppNavigator>().voltar();
  }

  Future<void> _excluir() async {
    setState(() => _excluindo = true);
    await _db.deleteCliente(_cliente.id);
    if (mounted) getIt<AppNavigator>().voltar();
  }

  void _mostrarModalExclusao() {
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
                  const TextSpan(text: 'Deseja excluir o cliente '),
                  TextSpan(
                    text: _cliente.nome,
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
                      onPressed: () {
                        Navigator.pop(ctx);
                        _excluir();
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
          AppBarInterna(titulo: 'Editar cliente'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildField(
                      label: 'Nome do cliente',
                      controller: _nomeController,
                      hint: 'Ex.: Fulano',
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Informe o nome'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    _buildField(
                      label: 'Nome da empresa',
                      controller: _empresaController,
                      hint: 'Ex.: Empresa Y',
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Informe a empresa'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // ── TELEFONE + COMBOBOX ATIVO ──────────
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nº de telefone',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 180,
                              child: TextFormField(
                                controller: _telefoneController,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [_telefoneMask],
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppTheme.textPrimary,
                                ),
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'Informe o telefone';
                                  }
                                  if (_telefoneMask.getUnmaskedText().length <
                                      10) {
                                    return 'Telefone inválido';
                                  }
                                  return null;
                                },
                                decoration: _inputDecoration('(00) 00000-0000'),
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Ativo: texto verde #3DA35C | Inativo: cinza #6B7280
                            Container(
                              height: 44,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.surface,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppTheme.border),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<bool>(
                                  value: _ativo,
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 18,
                                    color: AppTheme.textSecondary,
                                  ),
                                  items: [
                                    DropdownMenuItem(
                                      value: true,
                                      child: Text(
                                        'Ativo',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: _ativo
                                              ? AppTheme.green
                                              : AppTheme.textSecondary,
                                        ),
                                      ),
                                    ),
                                    const DropdownMenuItem(
                                      value: false,
                                      child: Text(
                                        'Inativo',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: AppTheme.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                  onChanged: (v) {
                                    if (v != null) setState(() => _ativo = v);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    _buildField(
                      label: 'Descrição',
                      controller: _descricaoController,
                      hint: 'Algo sobre a empresa...',
                      maxLines: 8,
                      validator: null,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── BOTÕES INFERIORES ──────────────────────────
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Botão Excluir: âmbar #F5A02F
                SizedBox(
                  width: 160,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: (_salvando || _excluindo)
                        ? null
                        : _mostrarModalExclusao,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.amber,
                      disabledBackgroundColor: AppTheme.amber.withValues(
                        alpha: 0.6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _excluindo
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
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

                // Botão Confirmar edição: verde #3DA35C
                SizedBox(
                  width: 180,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: (_salvando || _excluindo)
                        ? null
                        : _confirmarEdicao,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.green,
                      disabledBackgroundColor: AppTheme.green.withValues(
                        alpha: 0.6,
                      ),
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

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary),
          decoration: _inputDecoration(hint),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
      filled: true,
      fillColor: AppTheme.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }
}
