import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// comando para gerar o código drift: dart run build_runner build

// Tabela de Clientes
class Clientes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text()();
  TextColumn get empresa => text()();
  TextColumn get telefone => text()();
  TextColumn get descricao => text()();
  BoolColumn get ativo => boolean().withDefault(const Constant(true))();
}

// Tabela de Serviços
class Servicos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nomeProduto => text()();
  // tipoServico: 0=Criacao, 1=Alteracao, 2=Correcao
  IntColumn get tipoServico => integer()();
  TextColumn get descricao => text()();
  RealColumn get valor => real()();
  DateTimeColumn get dataCriacao => dateTime()();
  // statusServico: 0=Pendente, 1=Finalizado
  IntColumn get statusServico => integer().withDefault(const Constant(0))();
  IntColumn get clienteId => integer().references(Clientes, #id)();
}

@DriftDatabase(tables: [Clientes, Servicos])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    // LazyDatabase permite usar async para resolver o caminho dinamicamente
    // sem precisar mudar o construtor do AppDatabase
    return LazyDatabase(() async {
      // Retorna o AppData\Roaming do usuário atual
      // Resultado: C:\Users\<usuario>\AppData\Roaming\com.studioflow\studioflow
      final dir = await getApplicationSupportDirectory();

      // Garante que a pasta existe antes de criar o banco
      if (!await Directory(dir.path).exists()) {
        await Directory(dir.path).create(recursive: true);
      }

      final dbPath = p.join(dir.path, 'studioflow.db');
      return NativeDatabase(File(dbPath));
    });
  }

  // ── CLIENTES ──────────────────────────────────────────
  Future<List<Cliente>> getAllClientes() =>
      (select(clientes)..orderBy([(c) => OrderingTerm.asc(c.nome)])).get();

  Future<Cliente?> getClienteById(int id) =>
      (select(clientes)..where((c) => c.id.equals(id))).getSingleOrNull();

  Future<int> insertCliente(ClientesCompanion cliente) =>
      into(clientes).insert(cliente);

  Future<bool> updateCliente(ClientesCompanion cliente) =>
      update(clientes).replace(cliente);

  Future<int> deleteCliente(int id) =>
      (delete(clientes)..where((c) => c.id.equals(id))).go();

  // ── SERVIÇOS ──────────────────────────────────────────
  Future<List<Servico>> getAllServicos() => (select(
    servicos,
  )..orderBy([(s) => OrderingTerm.desc(s.dataCriacao)])).get();

  Future<List<Servico>> getServicosPendentes() =>
      (select(servicos)
            ..where((s) => s.statusServico.equals(0))
            ..orderBy([(s) => OrderingTerm.desc(s.dataCriacao)]))
          .get();

  Future<int> insertServico(ServicosCompanion servico) =>
      into(servicos).insert(servico);

  Future<bool> updateServico(ServicosCompanion servico) =>
      update(servicos).replace(servico);

  Future<int> deleteServico(int id) =>
      (delete(servicos)..where((s) => s.id.equals(id))).go();

  // ── DASHBOARD ─────────────────────────────────────────

  // Total recebido = serviços com statusServico == 1 (Finalizado)
  Future<double> getTotalRecebido() async {
    final rows = await (select(
      servicos,
    )..where((s) => s.statusServico.equals(1))).get();
    return rows.fold<double>(0.0, (sum, s) => sum + s.valor);
  }

  // Total a receber = serviços com statusServico == 0 (Pendente)
  Future<double> getTotalAReceber() async {
    final rows = await (select(
      servicos,
    )..where((s) => s.statusServico.equals(0))).get();
    return rows.fold<double>(0.0, (sum, s) => sum + s.valor);
  }
}
