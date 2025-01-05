class Produto {
  String? categoria;
  String? nome;
  double? preco;
  int? quantidade;
  String? imagem;

  Produto({this.categoria, this.nome, this.preco, this.quantidade,
  this.imagem});

  factory Produto.fromJson(Map<String, dynamic> json) => Produto(
    categoria: json['categoria'] as String?,
    nome: json['nome'] as String?,
    preco: (json['preco'] as num?)?.toDouble(),
    quantidade: json['quantidade'] as int?,
    imagem: json['imagem'] as String?,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'categoria': categoria,
    'nome': nome,
    'preco': preco,
    'quantidade': quantidade,
    'imagem': imagem,
  };
}