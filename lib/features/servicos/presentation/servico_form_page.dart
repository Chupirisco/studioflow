import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/navigator/app_navigator.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/database/app_database.dart';
import '../../../shared/widgets/app_bar_interna.dart';

class ServicoFormPage extends StatefulWidget {
  final Object? args;

  const ServicoFormPage({super.key, this.args});

  @override
  State<ServicoFormPage> createState() => _ServicoFormPageState();
}

class _ServicoFormPageState extends State<ServicoFormPage> {
  // Acesso direto ao banco — não depende do ViewModel da page anterior
  final AppDatabase _db = getIt<AppDatabase>();

  final _formKey = GlobalKey<FormState>();

  final _empresaBuscaController = TextEditingController();
  final _nomeClienteController = TextEditingController();
  final _nomeProdutoController = TextEditingController();
  final _valorController = TextEditingController(text: '0,00');
  final _descricaoController = TextEditingController();

  Cliente? _clienteSelecionado;
  List<Cliente> _todosClientes = [];
  List<Cliente> _empresasFiltradas = [];
  final _empresaFocusNode = FocusNode();

  int _statusServico = 0;
  int _tipoServico = 0;
  OverlayEntry? _overlayEntry;
  var _empresaFieldKey = GlobalKey();

  bool _salvando = false;
  bool _carregandoClientes = true;

  @override
  void initState() {
    super.initState();
    _carregarClientes();
  }

  Future<void> _carregarClientes() async {
    final clientes = await _db.getAllClientes();
    setState(() {
      _todosClientes = clientes.where((c) => c.ativo).toList();
      _empresasFiltradas = List.from(_todosClientes);
      _carregandoClientes = false;
    });
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _empresaBuscaController.dispose();
    _nomeClienteController.dispose();
    _nomeProdutoController.dispose();
    _valorController.dispose();
    _descricaoController.dispose();
    _empresaFocusNode.dispose();
    _empresaFieldKey = GlobalKey();
    super.dispose();
  }

  // ── LÓGICA DO COMBOBOX DE EMPRESA ────────────────────
  void _abrirOverlay() {
    _fecharOverlay();

    final renderBox =
        _empresaFieldKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (_) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 4,
        width: size.width,
        child: Material(
          color: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxHeight: 264),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.border),
              boxShadow: AppTheme.cardShadow,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 6),
              itemCount: _empresasFiltradas.length,
              itemBuilder: (_, i) {
                final c = _empresasFiltradas[i];
                final isSelected = _clienteSelecionado?.id == c.id;
                return InkWell(
                  onTap: () => _selecionarEmpresa(c),
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    color: isSelected
                        ? AppTheme.primaryLight
                        : Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c.empresa,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? AppTheme.primary
                                : AppTheme.textPrimary,
                          ),
                        ),
                        Text(
                          c.nome,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _fecharOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _filtrarEmpresas(String texto) {
    setState(() {
      _empresasFiltradas = _todosClientes
          .where((c) => c.empresa.toLowerCase().contains(texto.toLowerCase()))
          .toList();
    });
    _abrirOverlay();
  }

  void _selecionarEmpresa(Cliente cliente) {
    setState(() {
      _clienteSelecionado = cliente;
      _empresaBuscaController.text = cliente.empresa;
      _nomeClienteController.text = cliente.nome;
      _empresasFiltradas = List.from(_todosClientes);
    });
    _fecharOverlay();
    _empresaFocusNode.unfocus();
  }

  // ── MÁSCARA DE VALOR ─────────────────────────────────
  void _onValorChanged(String value) {
    final digits = value.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.isEmpty) {
      _valorController.value = const TextEditingValue(
        text: '0,00',
        selection: TextSelection.collapsed(offset: 4),
      );
      return;
    }
    final intVal = int.parse(digits);
    final reais = intVal ~/ 100;
    final centavos = intVal % 100;
    final formatted =
        '${_formatarReais(reais)},${centavos.toString().padLeft(2, '0')}';
    _valorController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _formatarReais(int valor) {
    if (valor == 0) return '0';
    final s = valor.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) buffer.write('.');
      buffer.write(s[i]);
      count++;
    }
    return buffer.toString().split('').reversed.join();
  }

  double _valorNumerico() {
    final digits = _valorController.text.replaceAll(RegExp(r'[^\d]'), '');
    if (digits.isEmpty) return 0.0;
    return int.parse(digits) / 100.0;
  }

  // ── CONFIRMAR ────────────────────────────────────────
  Future<void> _confirmar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_clienteSelecionado == null) return;

    setState(() => _salvando = true);

    await _db.insertServico(
      ServicosCompanion(
        nomeProduto: Value(_nomeProdutoController.text.trim()),
        tipoServico: Value(_tipoServico),
        descricao: Value(_descricaoController.text.trim()),
        valor: Value(_valorNumerico()),
        dataCriacao: Value(DateTime.now()),
        statusServico: Value(_statusServico),
        clienteId: Value(_clienteSelecionado!.id),
      ),
    );

    if (mounted) getIt<AppNavigator>().voltar();
  }

  @override
  Widget build(BuildContext context) {
    if (_carregandoClientes) {
      return const Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // ── CONTEÚDO ──────────────────────────────────
          ListView(
            padding: EdgeInsets.zero,

            children: [
              // ── TOPBAR ──────────────────────────────────
              AppBarInterna(titulo: 'Cadastrar serviço'),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── EMPRESA (autocomplete) ─────────────
                      _buildLabel('Empresa'),
                      const SizedBox(height: 6),
                      _buildEmpresaField(),
                      const SizedBox(height: 16),

                      // ── NOME DO CLIENTE (read-only) ─────────
                      _buildLabel('Nome do cliente'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _nomeClienteController,
                        readOnly: true,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                        ),
                        decoration: _inputDecoration('').copyWith(
                          fillColor: AppTheme.background,
                          hintText: '',
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ── NOME DO PRODUTO ────────────────────
                      _buildLabel('Nome do produto'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _nomeProdutoController,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textPrimary,
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Informe o nome do produto'
                            : null,
                        decoration: _inputDecoration('Ex.: Café premium'),
                      ),
                      const SizedBox(height: 16),

                      // ── LINHA: VALOR | STATUS | TIPO ────────
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Valor'),
                              const SizedBox(height: 6),
                              SizedBox(
                                width: 160,
                                child: TextFormField(
                                  controller: _valorController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  onChanged: _onValorChanged,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppTheme.textPrimary,
                                  ),
                                  decoration: _inputDecoration('').copyWith(
                                    prefixText: 'R\$ ',
                                    prefixStyle: const TextStyle(
                                      fontSize: 13,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Status'),
                              const SizedBox(height: 6),
                              _buildDropdownField(
                                value: _statusServico,
                                items: const [
                                  DropdownMenuItem(
                                    value: 0,
                                    child: Text('Pendente'),
                                  ),
                                  DropdownMenuItem(
                                    value: 1,
                                    child: Text('Finalizado'),
                                  ),
                                ],
                                onChanged: (v) {
                                  if (v != null) {
                                    setState(() => _statusServico = v);
                                  }
                                },
                                valueColor: _statusServico == 0
                                    ? AppTheme.amber
                                    : AppTheme.green,
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Tipo'),
                              const SizedBox(height: 6),
                              _buildDropdownField(
                                value: _tipoServico,
                                items: const [
                                  DropdownMenuItem(
                                    value: 0,
                                    child: Text('Criação'),
                                  ),
                                  DropdownMenuItem(
                                    value: 1,
                                    child: Text('Alteração'),
                                  ),
                                  DropdownMenuItem(
                                    value: 2,
                                    child: Text('Correção'),
                                  ),
                                ],
                                onChanged: (v) {
                                  if (v != null)
                                    setState(() => _tipoServico = v);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ── DESCRIÇÃO ──────────────────────────
                      _buildLabel('Descrição'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _descricaoController,
                        maxLines: 8,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textPrimary,
                        ),
                        decoration: _inputDecoration('Algo sobre o serviço...'),
                      ),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ── BOTÃO CONFIRMAR ────────────────────────────
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

  // ── CAMPO EMPRESA COM AUTOCOMPLETE ───────────────────
  Widget _buildEmpresaField() {
    return TextFormField(
      key: _empresaFieldKey,
      controller: _empresaBuscaController,
      focusNode: _empresaFocusNode,
      onChanged: _filtrarEmpresas,
      onTap: () {
        _empresasFiltradas = List.from(_todosClientes);
        _abrirOverlay();
      },
      onEditingComplete: () {
        Future.delayed(const Duration(milliseconds: 150), _fecharOverlay);
        _empresaFocusNode.unfocus();
      },
      validator: (_) =>
          _clienteSelecionado == null ? 'Selecione uma empresa' : null,
      style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary),
      decoration: _inputDecoration('Selecione uma empresa').copyWith(
        suffixIcon: const Icon(
          Icons.keyboard_arrow_down,
          size: 18,
          color: AppTheme.textSecondary,
        ),
      ),
    );
  }

  // ── DROPDOWN GENÉRICO ────────────────────────────────
  Widget _buildDropdownField<T>({
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    Color? valueColor,
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
        child: DropdownButton<T>(
          value: value,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            size: 18,
            color: AppTheme.textSecondary,
          ),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: valueColor ?? AppTheme.textPrimary,
          ),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }

  // ── HELPERS ──────────────────────────────────────────
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppTheme.textPrimary,
      ),
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
