import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/navigator/app_navigator.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/database/app_database.dart';

class ClienteFormPage extends StatefulWidget {
  final Object? args;

  const ClienteFormPage({super.key, this.args});

  @override
  State<ClienteFormPage> createState() => _ClienteFormPageState();
}

class _ClienteFormPageState extends State<ClienteFormPage> {
  // Acesso direto ao banco — não depende do ViewModel da page anterior
  final AppDatabase _db = getIt<AppDatabase>();

  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _empresaController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _descricaoController = TextEditingController();

  final _telefoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {'#': RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  bool _salvando = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _empresaController.dispose();
    _telefoneController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  Future<void> _confirmar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _salvando = true);

    await _db.insertCliente(
      ClientesCompanion(
        nome: Value(_nomeController.text.trim()),
        empresa: Value(_empresaController.text.trim()),
        telefone: Value(_telefoneController.text.trim()),
        descricao: Value(_descricaoController.text.trim()),
        ativo: const Value(true),
      ),
    );

    if (mounted) getIt<AppNavigator>().voltar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // ── CONTEÚDO ──────────────────────────────────
          SingleChildScrollView(
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
                  _buildField(
                    label: 'Nº de telefone',
                    controller: _telefoneController,
                    hint: '(00) 00000-0000',
                    keyboardType: TextInputType.phone,
                    formatters: [_telefoneMask],
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Informe o telefone';
                      }
                      if (_telefoneMask.getUnmaskedText().length < 10) {
                        return 'Telefone inválido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildField(
                    label: 'Descrição',
                    controller: _descricaoController,
                    hint: 'Algo sobre a empresa...',
                    maxLines: 8,
                    validator: null,
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          // ── BOTÃO CONFIRMAR (fixo canto inferior direito) ──
          Positioned(
            right: 24,
            bottom: 24,
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _salvando ? null : _confirmar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.green,
                  disabledBackgroundColor: AppTheme.green.withValues(
                    alpha: 0.6,
                  ),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                        'Confirmar',
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
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    List<MaskTextInputFormatter>? formatters,
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
          inputFormatters: formatters,
          maxLines: maxLines,
          validator: validator,
          style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
            filled: true,
            fillColor: AppTheme.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
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
          ),
        ),
      ],
    );
  }
}
