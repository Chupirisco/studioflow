// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ClientesTable extends Clientes with TableInfo<$ClientesTable, Cliente> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _empresaMeta = const VerificationMeta(
    'empresa',
  );
  @override
  late final GeneratedColumn<String> empresa = GeneratedColumn<String>(
    'empresa',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _telefoneMeta = const VerificationMeta(
    'telefone',
  );
  @override
  late final GeneratedColumn<String> telefone = GeneratedColumn<String>(
    'telefone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descricaoMeta = const VerificationMeta(
    'descricao',
  );
  @override
  late final GeneratedColumn<String> descricao = GeneratedColumn<String>(
    'descricao',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ativoMeta = const VerificationMeta('ativo');
  @override
  late final GeneratedColumn<bool> ativo = GeneratedColumn<bool>(
    'ativo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("ativo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nome,
    empresa,
    telefone,
    descricao,
    ativo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clientes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Cliente> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
        _nomeMeta,
        nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta),
      );
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('empresa')) {
      context.handle(
        _empresaMeta,
        empresa.isAcceptableOrUnknown(data['empresa']!, _empresaMeta),
      );
    } else if (isInserting) {
      context.missing(_empresaMeta);
    }
    if (data.containsKey('telefone')) {
      context.handle(
        _telefoneMeta,
        telefone.isAcceptableOrUnknown(data['telefone']!, _telefoneMeta),
      );
    } else if (isInserting) {
      context.missing(_telefoneMeta);
    }
    if (data.containsKey('descricao')) {
      context.handle(
        _descricaoMeta,
        descricao.isAcceptableOrUnknown(data['descricao']!, _descricaoMeta),
      );
    } else if (isInserting) {
      context.missing(_descricaoMeta);
    }
    if (data.containsKey('ativo')) {
      context.handle(
        _ativoMeta,
        ativo.isAcceptableOrUnknown(data['ativo']!, _ativoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Cliente map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Cliente(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome'],
      )!,
      empresa: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}empresa'],
      )!,
      telefone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telefone'],
      )!,
      descricao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descricao'],
      )!,
      ativo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}ativo'],
      )!,
    );
  }

  @override
  $ClientesTable createAlias(String alias) {
    return $ClientesTable(attachedDatabase, alias);
  }
}

class Cliente extends DataClass implements Insertable<Cliente> {
  final int id;
  final String nome;
  final String empresa;
  final String telefone;
  final String descricao;
  final bool ativo;
  const Cliente({
    required this.id,
    required this.nome,
    required this.empresa,
    required this.telefone,
    required this.descricao,
    required this.ativo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    map['empresa'] = Variable<String>(empresa);
    map['telefone'] = Variable<String>(telefone);
    map['descricao'] = Variable<String>(descricao);
    map['ativo'] = Variable<bool>(ativo);
    return map;
  }

  ClientesCompanion toCompanion(bool nullToAbsent) {
    return ClientesCompanion(
      id: Value(id),
      nome: Value(nome),
      empresa: Value(empresa),
      telefone: Value(telefone),
      descricao: Value(descricao),
      ativo: Value(ativo),
    );
  }

  factory Cliente.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Cliente(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      empresa: serializer.fromJson<String>(json['empresa']),
      telefone: serializer.fromJson<String>(json['telefone']),
      descricao: serializer.fromJson<String>(json['descricao']),
      ativo: serializer.fromJson<bool>(json['ativo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
      'empresa': serializer.toJson<String>(empresa),
      'telefone': serializer.toJson<String>(telefone),
      'descricao': serializer.toJson<String>(descricao),
      'ativo': serializer.toJson<bool>(ativo),
    };
  }

  Cliente copyWith({
    int? id,
    String? nome,
    String? empresa,
    String? telefone,
    String? descricao,
    bool? ativo,
  }) => Cliente(
    id: id ?? this.id,
    nome: nome ?? this.nome,
    empresa: empresa ?? this.empresa,
    telefone: telefone ?? this.telefone,
    descricao: descricao ?? this.descricao,
    ativo: ativo ?? this.ativo,
  );
  Cliente copyWithCompanion(ClientesCompanion data) {
    return Cliente(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      empresa: data.empresa.present ? data.empresa.value : this.empresa,
      telefone: data.telefone.present ? data.telefone.value : this.telefone,
      descricao: data.descricao.present ? data.descricao.value : this.descricao,
      ativo: data.ativo.present ? data.ativo.value : this.ativo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Cliente(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('empresa: $empresa, ')
          ..write('telefone: $telefone, ')
          ..write('descricao: $descricao, ')
          ..write('ativo: $ativo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nome, empresa, telefone, descricao, ativo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cliente &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.empresa == this.empresa &&
          other.telefone == this.telefone &&
          other.descricao == this.descricao &&
          other.ativo == this.ativo);
}

class ClientesCompanion extends UpdateCompanion<Cliente> {
  final Value<int> id;
  final Value<String> nome;
  final Value<String> empresa;
  final Value<String> telefone;
  final Value<String> descricao;
  final Value<bool> ativo;
  const ClientesCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.empresa = const Value.absent(),
    this.telefone = const Value.absent(),
    this.descricao = const Value.absent(),
    this.ativo = const Value.absent(),
  });
  ClientesCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
    required String empresa,
    required String telefone,
    required String descricao,
    this.ativo = const Value.absent(),
  }) : nome = Value(nome),
       empresa = Value(empresa),
       telefone = Value(telefone),
       descricao = Value(descricao);
  static Insertable<Cliente> custom({
    Expression<int>? id,
    Expression<String>? nome,
    Expression<String>? empresa,
    Expression<String>? telefone,
    Expression<String>? descricao,
    Expression<bool>? ativo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (empresa != null) 'empresa': empresa,
      if (telefone != null) 'telefone': telefone,
      if (descricao != null) 'descricao': descricao,
      if (ativo != null) 'ativo': ativo,
    });
  }

  ClientesCompanion copyWith({
    Value<int>? id,
    Value<String>? nome,
    Value<String>? empresa,
    Value<String>? telefone,
    Value<String>? descricao,
    Value<bool>? ativo,
  }) {
    return ClientesCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      empresa: empresa ?? this.empresa,
      telefone: telefone ?? this.telefone,
      descricao: descricao ?? this.descricao,
      ativo: ativo ?? this.ativo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (empresa.present) {
      map['empresa'] = Variable<String>(empresa.value);
    }
    if (telefone.present) {
      map['telefone'] = Variable<String>(telefone.value);
    }
    if (descricao.present) {
      map['descricao'] = Variable<String>(descricao.value);
    }
    if (ativo.present) {
      map['ativo'] = Variable<bool>(ativo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientesCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('empresa: $empresa, ')
          ..write('telefone: $telefone, ')
          ..write('descricao: $descricao, ')
          ..write('ativo: $ativo')
          ..write(')'))
        .toString();
  }
}

class $ServicosTable extends Servicos with TableInfo<$ServicosTable, Servico> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServicosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nomeProdutoMeta = const VerificationMeta(
    'nomeProduto',
  );
  @override
  late final GeneratedColumn<String> nomeProduto = GeneratedColumn<String>(
    'nome_produto',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipoServicoMeta = const VerificationMeta(
    'tipoServico',
  );
  @override
  late final GeneratedColumn<int> tipoServico = GeneratedColumn<int>(
    'tipo_servico',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descricaoMeta = const VerificationMeta(
    'descricao',
  );
  @override
  late final GeneratedColumn<String> descricao = GeneratedColumn<String>(
    'descricao',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valorMeta = const VerificationMeta('valor');
  @override
  late final GeneratedColumn<double> valor = GeneratedColumn<double>(
    'valor',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataCriacaoMeta = const VerificationMeta(
    'dataCriacao',
  );
  @override
  late final GeneratedColumn<DateTime> dataCriacao = GeneratedColumn<DateTime>(
    'data_criacao',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusServicoMeta = const VerificationMeta(
    'statusServico',
  );
  @override
  late final GeneratedColumn<int> statusServico = GeneratedColumn<int>(
    'status_servico',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _clienteIdMeta = const VerificationMeta(
    'clienteId',
  );
  @override
  late final GeneratedColumn<int> clienteId = GeneratedColumn<int>(
    'cliente_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nomeProduto,
    tipoServico,
    descricao,
    valor,
    dataCriacao,
    statusServico,
    clienteId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'servicos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Servico> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome_produto')) {
      context.handle(
        _nomeProdutoMeta,
        nomeProduto.isAcceptableOrUnknown(
          data['nome_produto']!,
          _nomeProdutoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nomeProdutoMeta);
    }
    if (data.containsKey('tipo_servico')) {
      context.handle(
        _tipoServicoMeta,
        tipoServico.isAcceptableOrUnknown(
          data['tipo_servico']!,
          _tipoServicoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tipoServicoMeta);
    }
    if (data.containsKey('descricao')) {
      context.handle(
        _descricaoMeta,
        descricao.isAcceptableOrUnknown(data['descricao']!, _descricaoMeta),
      );
    } else if (isInserting) {
      context.missing(_descricaoMeta);
    }
    if (data.containsKey('valor')) {
      context.handle(
        _valorMeta,
        valor.isAcceptableOrUnknown(data['valor']!, _valorMeta),
      );
    } else if (isInserting) {
      context.missing(_valorMeta);
    }
    if (data.containsKey('data_criacao')) {
      context.handle(
        _dataCriacaoMeta,
        dataCriacao.isAcceptableOrUnknown(
          data['data_criacao']!,
          _dataCriacaoMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dataCriacaoMeta);
    }
    if (data.containsKey('status_servico')) {
      context.handle(
        _statusServicoMeta,
        statusServico.isAcceptableOrUnknown(
          data['status_servico']!,
          _statusServicoMeta,
        ),
      );
    }
    if (data.containsKey('cliente_id')) {
      context.handle(
        _clienteIdMeta,
        clienteId.isAcceptableOrUnknown(data['cliente_id']!, _clienteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clienteIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Servico map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Servico(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nomeProduto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nome_produto'],
      )!,
      tipoServico: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tipo_servico'],
      )!,
      descricao: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descricao'],
      )!,
      valor: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}valor'],
      )!,
      dataCriacao: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}data_criacao'],
      )!,
      statusServico: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status_servico'],
      )!,
      clienteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cliente_id'],
      )!,
    );
  }

  @override
  $ServicosTable createAlias(String alias) {
    return $ServicosTable(attachedDatabase, alias);
  }
}

class Servico extends DataClass implements Insertable<Servico> {
  final int id;
  final String nomeProduto;
  final int tipoServico;
  final String descricao;
  final double valor;
  final DateTime dataCriacao;
  final int statusServico;
  final int clienteId;
  const Servico({
    required this.id,
    required this.nomeProduto,
    required this.tipoServico,
    required this.descricao,
    required this.valor,
    required this.dataCriacao,
    required this.statusServico,
    required this.clienteId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome_produto'] = Variable<String>(nomeProduto);
    map['tipo_servico'] = Variable<int>(tipoServico);
    map['descricao'] = Variable<String>(descricao);
    map['valor'] = Variable<double>(valor);
    map['data_criacao'] = Variable<DateTime>(dataCriacao);
    map['status_servico'] = Variable<int>(statusServico);
    map['cliente_id'] = Variable<int>(clienteId);
    return map;
  }

  ServicosCompanion toCompanion(bool nullToAbsent) {
    return ServicosCompanion(
      id: Value(id),
      nomeProduto: Value(nomeProduto),
      tipoServico: Value(tipoServico),
      descricao: Value(descricao),
      valor: Value(valor),
      dataCriacao: Value(dataCriacao),
      statusServico: Value(statusServico),
      clienteId: Value(clienteId),
    );
  }

  factory Servico.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Servico(
      id: serializer.fromJson<int>(json['id']),
      nomeProduto: serializer.fromJson<String>(json['nomeProduto']),
      tipoServico: serializer.fromJson<int>(json['tipoServico']),
      descricao: serializer.fromJson<String>(json['descricao']),
      valor: serializer.fromJson<double>(json['valor']),
      dataCriacao: serializer.fromJson<DateTime>(json['dataCriacao']),
      statusServico: serializer.fromJson<int>(json['statusServico']),
      clienteId: serializer.fromJson<int>(json['clienteId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nomeProduto': serializer.toJson<String>(nomeProduto),
      'tipoServico': serializer.toJson<int>(tipoServico),
      'descricao': serializer.toJson<String>(descricao),
      'valor': serializer.toJson<double>(valor),
      'dataCriacao': serializer.toJson<DateTime>(dataCriacao),
      'statusServico': serializer.toJson<int>(statusServico),
      'clienteId': serializer.toJson<int>(clienteId),
    };
  }

  Servico copyWith({
    int? id,
    String? nomeProduto,
    int? tipoServico,
    String? descricao,
    double? valor,
    DateTime? dataCriacao,
    int? statusServico,
    int? clienteId,
  }) => Servico(
    id: id ?? this.id,
    nomeProduto: nomeProduto ?? this.nomeProduto,
    tipoServico: tipoServico ?? this.tipoServico,
    descricao: descricao ?? this.descricao,
    valor: valor ?? this.valor,
    dataCriacao: dataCriacao ?? this.dataCriacao,
    statusServico: statusServico ?? this.statusServico,
    clienteId: clienteId ?? this.clienteId,
  );
  Servico copyWithCompanion(ServicosCompanion data) {
    return Servico(
      id: data.id.present ? data.id.value : this.id,
      nomeProduto: data.nomeProduto.present
          ? data.nomeProduto.value
          : this.nomeProduto,
      tipoServico: data.tipoServico.present
          ? data.tipoServico.value
          : this.tipoServico,
      descricao: data.descricao.present ? data.descricao.value : this.descricao,
      valor: data.valor.present ? data.valor.value : this.valor,
      dataCriacao: data.dataCriacao.present
          ? data.dataCriacao.value
          : this.dataCriacao,
      statusServico: data.statusServico.present
          ? data.statusServico.value
          : this.statusServico,
      clienteId: data.clienteId.present ? data.clienteId.value : this.clienteId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Servico(')
          ..write('id: $id, ')
          ..write('nomeProduto: $nomeProduto, ')
          ..write('tipoServico: $tipoServico, ')
          ..write('descricao: $descricao, ')
          ..write('valor: $valor, ')
          ..write('dataCriacao: $dataCriacao, ')
          ..write('statusServico: $statusServico, ')
          ..write('clienteId: $clienteId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nomeProduto,
    tipoServico,
    descricao,
    valor,
    dataCriacao,
    statusServico,
    clienteId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Servico &&
          other.id == this.id &&
          other.nomeProduto == this.nomeProduto &&
          other.tipoServico == this.tipoServico &&
          other.descricao == this.descricao &&
          other.valor == this.valor &&
          other.dataCriacao == this.dataCriacao &&
          other.statusServico == this.statusServico &&
          other.clienteId == this.clienteId);
}

class ServicosCompanion extends UpdateCompanion<Servico> {
  final Value<int> id;
  final Value<String> nomeProduto;
  final Value<int> tipoServico;
  final Value<String> descricao;
  final Value<double> valor;
  final Value<DateTime> dataCriacao;
  final Value<int> statusServico;
  final Value<int> clienteId;
  const ServicosCompanion({
    this.id = const Value.absent(),
    this.nomeProduto = const Value.absent(),
    this.tipoServico = const Value.absent(),
    this.descricao = const Value.absent(),
    this.valor = const Value.absent(),
    this.dataCriacao = const Value.absent(),
    this.statusServico = const Value.absent(),
    this.clienteId = const Value.absent(),
  });
  ServicosCompanion.insert({
    this.id = const Value.absent(),
    required String nomeProduto,
    required int tipoServico,
    required String descricao,
    required double valor,
    required DateTime dataCriacao,
    this.statusServico = const Value.absent(),
    required int clienteId,
  }) : nomeProduto = Value(nomeProduto),
       tipoServico = Value(tipoServico),
       descricao = Value(descricao),
       valor = Value(valor),
       dataCriacao = Value(dataCriacao),
       clienteId = Value(clienteId);
  static Insertable<Servico> custom({
    Expression<int>? id,
    Expression<String>? nomeProduto,
    Expression<int>? tipoServico,
    Expression<String>? descricao,
    Expression<double>? valor,
    Expression<DateTime>? dataCriacao,
    Expression<int>? statusServico,
    Expression<int>? clienteId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nomeProduto != null) 'nome_produto': nomeProduto,
      if (tipoServico != null) 'tipo_servico': tipoServico,
      if (descricao != null) 'descricao': descricao,
      if (valor != null) 'valor': valor,
      if (dataCriacao != null) 'data_criacao': dataCriacao,
      if (statusServico != null) 'status_servico': statusServico,
      if (clienteId != null) 'cliente_id': clienteId,
    });
  }

  ServicosCompanion copyWith({
    Value<int>? id,
    Value<String>? nomeProduto,
    Value<int>? tipoServico,
    Value<String>? descricao,
    Value<double>? valor,
    Value<DateTime>? dataCriacao,
    Value<int>? statusServico,
    Value<int>? clienteId,
  }) {
    return ServicosCompanion(
      id: id ?? this.id,
      nomeProduto: nomeProduto ?? this.nomeProduto,
      tipoServico: tipoServico ?? this.tipoServico,
      descricao: descricao ?? this.descricao,
      valor: valor ?? this.valor,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      statusServico: statusServico ?? this.statusServico,
      clienteId: clienteId ?? this.clienteId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nomeProduto.present) {
      map['nome_produto'] = Variable<String>(nomeProduto.value);
    }
    if (tipoServico.present) {
      map['tipo_servico'] = Variable<int>(tipoServico.value);
    }
    if (descricao.present) {
      map['descricao'] = Variable<String>(descricao.value);
    }
    if (valor.present) {
      map['valor'] = Variable<double>(valor.value);
    }
    if (dataCriacao.present) {
      map['data_criacao'] = Variable<DateTime>(dataCriacao.value);
    }
    if (statusServico.present) {
      map['status_servico'] = Variable<int>(statusServico.value);
    }
    if (clienteId.present) {
      map['cliente_id'] = Variable<int>(clienteId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServicosCompanion(')
          ..write('id: $id, ')
          ..write('nomeProduto: $nomeProduto, ')
          ..write('tipoServico: $tipoServico, ')
          ..write('descricao: $descricao, ')
          ..write('valor: $valor, ')
          ..write('dataCriacao: $dataCriacao, ')
          ..write('statusServico: $statusServico, ')
          ..write('clienteId: $clienteId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ClientesTable clientes = $ClientesTable(this);
  late final $ServicosTable servicos = $ServicosTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [clientes, servicos];
}

typedef $$ClientesTableCreateCompanionBuilder =
    ClientesCompanion Function({
      Value<int> id,
      required String nome,
      required String empresa,
      required String telefone,
      required String descricao,
      Value<bool> ativo,
    });
typedef $$ClientesTableUpdateCompanionBuilder =
    ClientesCompanion Function({
      Value<int> id,
      Value<String> nome,
      Value<String> empresa,
      Value<String> telefone,
      Value<String> descricao,
      Value<bool> ativo,
    });

class $$ClientesTableFilterComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get empresa => $composableBuilder(
    column: $table.empresa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telefone => $composableBuilder(
    column: $table.telefone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descricao => $composableBuilder(
    column: $table.descricao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get ativo => $composableBuilder(
    column: $table.ativo,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ClientesTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nome => $composableBuilder(
    column: $table.nome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get empresa => $composableBuilder(
    column: $table.empresa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telefone => $composableBuilder(
    column: $table.telefone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descricao => $composableBuilder(
    column: $table.descricao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get ativo => $composableBuilder(
    column: $table.ativo,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ClientesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientesTable> {
  $$ClientesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get empresa =>
      $composableBuilder(column: $table.empresa, builder: (column) => column);

  GeneratedColumn<String> get telefone =>
      $composableBuilder(column: $table.telefone, builder: (column) => column);

  GeneratedColumn<String> get descricao =>
      $composableBuilder(column: $table.descricao, builder: (column) => column);

  GeneratedColumn<bool> get ativo =>
      $composableBuilder(column: $table.ativo, builder: (column) => column);
}

class $$ClientesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClientesTable,
          Cliente,
          $$ClientesTableFilterComposer,
          $$ClientesTableOrderingComposer,
          $$ClientesTableAnnotationComposer,
          $$ClientesTableCreateCompanionBuilder,
          $$ClientesTableUpdateCompanionBuilder,
          (Cliente, BaseReferences<_$AppDatabase, $ClientesTable, Cliente>),
          Cliente,
          PrefetchHooks Function()
        > {
  $$ClientesTableTableManager(_$AppDatabase db, $ClientesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nome = const Value.absent(),
                Value<String> empresa = const Value.absent(),
                Value<String> telefone = const Value.absent(),
                Value<String> descricao = const Value.absent(),
                Value<bool> ativo = const Value.absent(),
              }) => ClientesCompanion(
                id: id,
                nome: nome,
                empresa: empresa,
                telefone: telefone,
                descricao: descricao,
                ativo: ativo,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nome,
                required String empresa,
                required String telefone,
                required String descricao,
                Value<bool> ativo = const Value.absent(),
              }) => ClientesCompanion.insert(
                id: id,
                nome: nome,
                empresa: empresa,
                telefone: telefone,
                descricao: descricao,
                ativo: ativo,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ClientesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClientesTable,
      Cliente,
      $$ClientesTableFilterComposer,
      $$ClientesTableOrderingComposer,
      $$ClientesTableAnnotationComposer,
      $$ClientesTableCreateCompanionBuilder,
      $$ClientesTableUpdateCompanionBuilder,
      (Cliente, BaseReferences<_$AppDatabase, $ClientesTable, Cliente>),
      Cliente,
      PrefetchHooks Function()
    >;
typedef $$ServicosTableCreateCompanionBuilder =
    ServicosCompanion Function({
      Value<int> id,
      required String nomeProduto,
      required int tipoServico,
      required String descricao,
      required double valor,
      required DateTime dataCriacao,
      Value<int> statusServico,
      required int clienteId,
    });
typedef $$ServicosTableUpdateCompanionBuilder =
    ServicosCompanion Function({
      Value<int> id,
      Value<String> nomeProduto,
      Value<int> tipoServico,
      Value<String> descricao,
      Value<double> valor,
      Value<DateTime> dataCriacao,
      Value<int> statusServico,
      Value<int> clienteId,
    });

class $$ServicosTableFilterComposer
    extends Composer<_$AppDatabase, $ServicosTable> {
  $$ServicosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nomeProduto => $composableBuilder(
    column: $table.nomeProduto,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tipoServico => $composableBuilder(
    column: $table.tipoServico,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descricao => $composableBuilder(
    column: $table.descricao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get valor => $composableBuilder(
    column: $table.valor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get statusServico => $composableBuilder(
    column: $table.statusServico,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get clienteId => $composableBuilder(
    column: $table.clienteId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ServicosTableOrderingComposer
    extends Composer<_$AppDatabase, $ServicosTable> {
  $$ServicosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nomeProduto => $composableBuilder(
    column: $table.nomeProduto,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tipoServico => $composableBuilder(
    column: $table.tipoServico,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descricao => $composableBuilder(
    column: $table.descricao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get valor => $composableBuilder(
    column: $table.valor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get statusServico => $composableBuilder(
    column: $table.statusServico,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get clienteId => $composableBuilder(
    column: $table.clienteId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ServicosTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServicosTable> {
  $$ServicosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nomeProduto => $composableBuilder(
    column: $table.nomeProduto,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tipoServico => $composableBuilder(
    column: $table.tipoServico,
    builder: (column) => column,
  );

  GeneratedColumn<String> get descricao =>
      $composableBuilder(column: $table.descricao, builder: (column) => column);

  GeneratedColumn<double> get valor =>
      $composableBuilder(column: $table.valor, builder: (column) => column);

  GeneratedColumn<DateTime> get dataCriacao => $composableBuilder(
    column: $table.dataCriacao,
    builder: (column) => column,
  );

  GeneratedColumn<int> get statusServico => $composableBuilder(
    column: $table.statusServico,
    builder: (column) => column,
  );

  GeneratedColumn<int> get clienteId =>
      $composableBuilder(column: $table.clienteId, builder: (column) => column);
}

class $$ServicosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ServicosTable,
          Servico,
          $$ServicosTableFilterComposer,
          $$ServicosTableOrderingComposer,
          $$ServicosTableAnnotationComposer,
          $$ServicosTableCreateCompanionBuilder,
          $$ServicosTableUpdateCompanionBuilder,
          (Servico, BaseReferences<_$AppDatabase, $ServicosTable, Servico>),
          Servico,
          PrefetchHooks Function()
        > {
  $$ServicosTableTableManager(_$AppDatabase db, $ServicosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServicosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServicosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServicosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nomeProduto = const Value.absent(),
                Value<int> tipoServico = const Value.absent(),
                Value<String> descricao = const Value.absent(),
                Value<double> valor = const Value.absent(),
                Value<DateTime> dataCriacao = const Value.absent(),
                Value<int> statusServico = const Value.absent(),
                Value<int> clienteId = const Value.absent(),
              }) => ServicosCompanion(
                id: id,
                nomeProduto: nomeProduto,
                tipoServico: tipoServico,
                descricao: descricao,
                valor: valor,
                dataCriacao: dataCriacao,
                statusServico: statusServico,
                clienteId: clienteId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nomeProduto,
                required int tipoServico,
                required String descricao,
                required double valor,
                required DateTime dataCriacao,
                Value<int> statusServico = const Value.absent(),
                required int clienteId,
              }) => ServicosCompanion.insert(
                id: id,
                nomeProduto: nomeProduto,
                tipoServico: tipoServico,
                descricao: descricao,
                valor: valor,
                dataCriacao: dataCriacao,
                statusServico: statusServico,
                clienteId: clienteId,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ServicosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ServicosTable,
      Servico,
      $$ServicosTableFilterComposer,
      $$ServicosTableOrderingComposer,
      $$ServicosTableAnnotationComposer,
      $$ServicosTableCreateCompanionBuilder,
      $$ServicosTableUpdateCompanionBuilder,
      (Servico, BaseReferences<_$AppDatabase, $ServicosTable, Servico>),
      Servico,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ClientesTableTableManager get clientes =>
      $$ClientesTableTableManager(_db, _db.clientes);
  $$ServicosTableTableManager get servicos =>
      $$ServicosTableTableManager(_db, _db.servicos);
}
