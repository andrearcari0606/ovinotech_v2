import 'package:hive/hive.dart';

part 'animal.g.dart';

@HiveType(typeId: 1)
enum OrigemAnimal {
  @HiveField(0)
  nascido,

  @HiveField(1)
  comprado,
}

@HiveType(typeId: 0)
class Animal extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String identificacao;

  @HiveField(2)
  String sexo;

  @HiveField(3)
  String raca;

  @HiveField(4)
  DateTime dataNascimento;

  @HiveField(5)
  double peso;

  @HiveField(6)
  String categoria;

  @HiveField(7)
  String origem;

  @HiveField(8)
  String? paiId;

  @HiveField(9)
  String? maeId;

  @HiveField(10)
  bool ativo;

  @HiveField(11)
  DateTime dataCadastro;

  @HiveField(12)
  double? pesoNascimento;

  @HiveField(13)
  Map<String, double>? baseGenetica;

  // NOVOS CAMPOS

  @HiveField(14)
  String status;

  @HiveField(15)
  String? lote;

  @HiveField(16)
  String? observacoes;

  @HiveField(17)
  String? fotoUrl;

  @HiveField(18)
  double? ultimoPeso;

  @HiveField(19)
  DateTime? ultimaPesagem;

  // COMPATIBILIDADE

  @HiveField(20)
  String? nome;

  @HiveField(21)
  DateTime? dataEntrada;

  @HiveField(22)
  double? pesoEntrada;

  Animal({
    String? id,

    String? identificacao,
    String? brinco,

    required this.sexo,
    required this.raca,
    required this.dataNascimento,
    required this.peso,
    required this.categoria,
    required this.origem,

    this.paiId,
    this.maeId,
    this.ativo = true,

    DateTime? dataCadastro,

    this.pesoNascimento,
    this.baseGenetica,

    // NOVOS
    this.status = 'ativo',
    this.lote,
    this.observacoes,
    this.fotoUrl,
    this.ultimoPeso,
    this.ultimaPesagem,

    // COMPATIBILIDADE
    this.nome,
    this.dataEntrada,
    this.pesoEntrada,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        dataCadastro = dataCadastro ?? DateTime.now(),
        identificacao = identificacao ?? brinco ?? '';

  // COMPATIBILIDADE COM TELAS ANTIGAS
  String get brinco => identificacao;

  int get idadeDias =>
      DateTime.now().difference(dataNascimento).inDays;

  int get idadeMeses => idadeDias ~/ 30;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'identificacao': identificacao,
      'sexo': sexo,
      'raca': raca,
      'dataNascimento': dataNascimento.toIso8601String(),
      'peso': peso,
      'categoria': categoria,
      'origem': origem,
      'paiId': paiId,
      'maeId': maeId,
      'ativo': ativo,
      'dataCadastro': dataCadastro.toIso8601String(),
      'pesoNascimento': pesoNascimento,
      'baseGenetica': baseGenetica,

      // NOVOS
      'status': status,
      'lote': lote,
      'observacoes': observacoes,
      'fotoUrl': fotoUrl,
      'ultimoPeso': ultimoPeso,
      'ultimaPesagem': ultimaPesagem?.toIso8601String(),

      // COMPATIBILIDADE
      'nome': nome,
      'dataEntrada': dataEntrada?.toIso8601String(),
      'pesoEntrada': pesoEntrada,
    };
  }

  factory Animal.fromMap(
    Map<String, dynamic> map, [
    String? documentId,
  ]) {
    return Animal(
      id: map['id'] ?? documentId,

      identificacao: map['identificacao'],

      sexo: map['sexo'] ?? '',
      raca: map['raca'] ?? '',

      dataNascimento: map['dataNascimento'] != null
          ? DateTime.parse(map['dataNascimento'])
          : DateTime.now(),

      peso: (map['peso'] ?? 0).toDouble(),

      categoria: map['categoria'] ?? '',
      origem: map['origem'] ?? '',

      paiId: map['paiId'],
      maeId: map['maeId'],

      ativo: map['ativo'] ?? true,

      dataCadastro: map['dataCadastro'] != null
          ? DateTime.parse(map['dataCadastro'])
          : DateTime.now(),

      pesoNascimento: map['pesoNascimento'] != null
          ? (map['pesoNascimento']).toDouble()
          : null,

      baseGenetica: map['baseGenetica'] != null
          ? Map<String, double>.from(map['baseGenetica'])
          : null,

      // NOVOS
      status: map['status'] ?? 'ativo',
      lote: map['lote'],
      observacoes: map['observacoes'],
      fotoUrl: map['fotoUrl'],

      ultimoPeso: map['ultimoPeso'] != null
          ? (map['ultimoPeso']).toDouble()
          : null,

      ultimaPesagem: map['ultimaPesagem'] != null
          ? DateTime.parse(map['ultimaPesagem'])
          : null,

      // COMPATIBILIDADE
      nome: map['nome'],

      dataEntrada: map['dataEntrada'] != null
          ? DateTime.parse(map['dataEntrada'])
          : null,

      pesoEntrada: map['pesoEntrada'] != null
          ? (map['pesoEntrada']).toDouble()
          : null,
    );
  }
}