import 'package:hive/hive.dart';

part 'animal.g.dart';

@HiveType(typeId: 3)
enum OrigemAnimal {
  @HiveField(0)
  nascido,

  @HiveField(1)
  comprado,
}

@HiveType(typeId: 0)
class Animal extends HiveObject {
  @HiveField(0)
  String? nome;

  @HiveField(1)
  String? brinco;

  @HiveField(2)
  String raca;

  @HiveField(3)
  String sexo;

  @HiveField(4)
  String categoria;

  @HiveField(5)
  double peso;

  @HiveField(6)
  DateTime? dataNascimento;

  @HiveField(7)
  Map<String, double>? baseGenetica;

  @HiveField(8)
  String? paiId;

  @HiveField(9)
  String? maeId;

  @HiveField(10)
  bool ativo;

  @HiveField(11)
  DateTime dataCadastro;

  @HiveField(12)
  OrigemAnimal origem;

  @HiveField(13)
  DateTime? dataEntrada;

  @HiveField(14)
  double? pesoNascimento;

  @HiveField(15)
  double? pesoEntrada;

  /// 🔥 ID AGORA CONTROLADO
  @HiveField(16)
  String? id;

  Animal({
    this.nome,
    this.brinco,
    required this.raca,
    required this.sexo,
    required this.categoria,
    required this.peso,
    OrigemAnimal? origem,
    this.dataNascimento,
    this.dataEntrada,
    this.pesoNascimento,
    this.pesoEntrada,
    this.baseGenetica,
    this.paiId,
    this.maeId,
    this.ativo = true,
    DateTime? dataCadastro,
    this.id,
  })  : origem = origem ?? OrigemAnimal.nascido,
        dataCadastro = dataCadastro ?? DateTime.now() {

    /// 🔥 GARANTE ID UMA VEZ SÓ
    id ??= DateTime.now().millisecondsSinceEpoch.toString();
  }

  String get identificacao {
    if (nome != null && nome!.isNotEmpty) return nome!;
    if (brinco != null && brinco!.isNotEmpty) return brinco!;
    return "Animal ${key ?? ''}";
  }

  int get idadeDias {
    if (dataNascimento == null) return 0;
    return DateTime.now().difference(dataNascimento!).inDays;
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'brinco': brinco,
      'raca': raca,
      'sexo': sexo,
      'categoria': categoria,
      'peso': peso,
      'dataNascimento': dataNascimento?.toIso8601String(),
      'dataEntrada': dataEntrada?.toIso8601String(),
      'pesoNascimento': pesoNascimento,
      'pesoEntrada': pesoEntrada,
      'origem': origem.name,
      'baseGenetica': baseGenetica,
      'paiId': paiId,
      'maeId': maeId,
      'ativo': ativo,
      'dataCadastro': dataCadastro.toIso8601String(),
    };
  }

  factory Animal.fromMap(Map<String, dynamic> map, String id) {
    return Animal(
      id: id, // 🔥 SEMPRE USA O ID DO FIREBASE
      nome: map['nome'],
      brinco: map['brinco'],
      raca: map['raca'],
      sexo: map['sexo'],
      categoria: map['categoria'],
      peso: (map['peso'] ?? 0).toDouble(),
      origem: OrigemAnimal.values.firstWhere(
        (e) => e.name == map['origem'],
        orElse: () => OrigemAnimal.nascido,
      ),
      dataNascimento: map['dataNascimento'] != null
          ? DateTime.parse(map['dataNascimento'])
          : null,
      dataEntrada: map['dataEntrada'] != null
          ? DateTime.parse(map['dataEntrada'])
          : null,
      pesoNascimento: (map['pesoNascimento'] as num?)?.toDouble(),
      pesoEntrada: (map['pesoEntrada'] as num?)?.toDouble(),
      baseGenetica: map['baseGenetica'] != null
          ? Map<String, double>.from(map['baseGenetica'])
          : null,
      paiId: map['paiId'],
      maeId: map['maeId'],
      ativo: map['ativo'] ?? true,
      dataCadastro: map['dataCadastro'] != null
          ? DateTime.parse(map['dataCadastro'])
          : DateTime.now(),
    );
  }
}