import 'package:flutter/material.dart';
import '../../core/di/service_locator.dart';
import '../../core/navigator/app_navigator.dart';
import '../../core/theme/app_theme.dart';

/// AppBar interna reutilizável — aparece nas telas de detalhe/formulário
/// mantendo topbar e sidebar sempre visíveis no AppShell.
///
/// Uso básico:
/// ```dart
/// AppBarInterna(titulo: 'Editar serviço')
/// ```
///
/// Uso com ações customizadas no lado direito:
/// ```dart
/// AppBarInterna(
///   titulo: 'Novo cliente',
///   acoes: [
///     IconButton(...)
///   ],
/// )
/// ```
///
/// Para esconder o botão de voltar (ex: tela raiz de uma seção):
/// ```dart
/// AppBarInterna(titulo: 'Dashboard', mostrarVoltar: false)
/// ```
class AppBarInterna extends StatelessWidget {
  /// Texto exibido como título da página
  final String titulo;

  /// Se true, exibe o botão de voltar (seta) no lado esquerdo
  /// Por padrão é true
  final bool mostrarVoltar;

  /// Widgets opcionais exibidos no lado direito da AppBar
  /// Ex: botões de ação, ícones, badges
  final List<Widget>? acoes;

  /// Subtítulo opcional exibido abaixo do título (menor e cinza)
  final String? subtitulo;

  const AppBarInterna({
    super.key,
    required this.titulo,
    this.mostrarVoltar = true,
    this.acoes,
    this.subtitulo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── BARRA PRINCIPAL ──────────────────────────
        Container(
          height: 52,
          // Fundo branco — igual ao topbar global
          color: AppTheme.surface,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              // ── LADO ESQUERDO: botão voltar + título ──
              if (mostrarVoltar) ...[
                // Botão voltar — navega via AppNavigator (não usa Navigator.pop)
                IconButton(
                  onPressed: () => getIt<AppNavigator>().voltar(),
                  icon: const Icon(Icons.arrow_back_ios_new, size: 16),
                  color: AppTheme.textSecondary,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'Voltar',
                ),
                const SizedBox(width: 12),
              ],

              // Título + subtítulo opcional
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  // Subtítulo — só renderiza se fornecido
                  if (subtitulo != null) ...[
                    const SizedBox(height: 1),
                    Text(
                      subtitulo!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),

              const Spacer(),

              // ── LADO DIREITO: ações opcionais ─────────
              // Adicione widgets aqui via parâmetro 'acoes'
              // Ex: botões salvar, deletar, filtros, etc.
              if (acoes != null)
                Row(mainAxisSize: MainAxisSize.min, children: acoes!),
            ],
          ),
        ),

        // Divisor inferior — separa a AppBar do conteúdo da página
        const Divider(height: 1, thickness: 1, color: AppTheme.border),
      ],
    );
  }
}
