class AnaliseItem {
  final String mensagem;
  final String nivel; // info, alerta, critico

  AnaliseItem({
    required this.mensagem,
    required this.nivel,
  });
}

class AnaliseResultado {
  final String status; // verde, amarelo, vermelho
  final int score;
  final List<AnaliseItem> problemas;
  final List<String> sugestoes;

  AnaliseResultado({
    required this.status,
    required this.score,
    required this.problemas,
    required this.sugestoes,
  });
}