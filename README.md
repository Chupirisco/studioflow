# StudioFlow

Aplicação desktop para Windows desenvolvida para auxiliar profissionais criativos, especialmente **designers de embalagens**, no gerenciamento de clientes, serviços e controle financeiro.

> Funciona 100% offline — todos os dados ficam salvos localmente no seu computador.

---

## Funcionalidades

### Dashboard
- Visualização dos serviços pendentes com paginação
- Resumo financeiro (total recebido e total a receber)
- Gráfico de serviços ou faturamento por mês com alternância entre os modos

### Clientes
- Cadastro, edição e exclusão de clientes
- Campos: nome, empresa, telefone, descrição e status (ativo/inativo)
- Filtro por status e busca por nome ou empresa
- Visualização em grade de cards

### Serviços
- Cadastro, edição e exclusão de serviços
- Campos: empresa, nome do cliente, nome do produto, valor, tipo, status e descrição
- Tipos de serviço: Criação, Alteração e Correção
- Status: Pendente ou Finalizado
- Filtro por status e busca por produto ou cliente
- Visualização em grade de cards com efeito hover

---

## Stack

| Camada | Tecnologia |
|---|---|
| Linguagem | Dart |
| Framework | Flutter 3.x |
| Banco de dados | SQLite (via Drift) |
| Gerenciamento de estado | ChangeNotifier + Provider |
| Injeção de dependência | GetIt |
| Plataforma | Windows Desktop |

---

## Estrutura do projeto

```
lib/
├── core/
│   ├── database/        # AppDatabase, tabelas e queries (Drift)
│   ├── di/              # Service locator (GetIt)
│   ├── navigator/       # Navegação interna (AppNavigator)
│   └── theme/           # Design system (cores, sombras, tipografia)
├── features/
│   ├── dashboard/       # Tela inicial com resumo e gráfico
│   ├── clientes/        # CRUD de clientes
│   └── servicos/        # CRUD de serviços
└── shared/
    └── widgets/         # Componentes reutilizáveis (AppShell, AppBarInterna)
```

---

## Design System

| Elemento | Valor |
|---|---|
| Background | `#F5F5F7` |
| Surface (cards) | `#FFFFFF` |
| Borda | `#E5E7EB` |
| Texto principal | `#111827` |
| Texto secundário | `#6B7280` |
| Azul (primário) | `#2563EB` |
| Verde (recebido / ativo) | `#3DA35C` |
| Âmbar (pendente / a receber) | `#F5A02F` |

---

## Pré-requisitos

- Flutter SDK `>=3.0.0`
- Windows 10 ou superior
- Visual Studio Build Tools 2022 com suporte ao desenvolvimento Desktop

---

## Como rodar

```bash
# Clone o repositório
git clone https://github.com/seu-usuario/studioflow.git
cd studioflow

# Instale as dependências
flutter pub get

# ⚠️ IMPORTANTE — Gere os arquivos do banco de dados antes de rodar
# O Drift usa geração de código. Sem esse passo o app não compila.
dart run build_runner build --delete-conflicting-outputs

# Rode o app
flutter run -d windows
```

> **Observação sobre o banco de dados:**
> O StudioFlow usa o [Drift](https://drift.simonbinder.eu/) como ORM para SQLite.
> O Drift depende de geração de código — o arquivo `app_database.g.dart` **não está versionado** e precisa ser gerado localmente.
> Sempre que modificar as tabelas em `app_database.dart`, rode novamente:
> ```bash
> dart run build_runner build --delete-conflicting-outputs
> ```

---

## Onde os dados ficam salvos

Os dados são salvos localmente em:

```
C:\Users\<usuario>\AppData\Roaming\<app-id>\studioflow\studioflow.db
```

---

## Licença

Projeto pessoal — uso livre.
