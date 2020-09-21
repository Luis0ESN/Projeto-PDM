class Produto{
  String codigo;
  String descricao;
  int qtd;
  double valor;


  Produto(this.codigo, this.descricao, this.qtd, this.valor);

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      'codigo': codigo,
      'descricao': descricao,
      'qtd':  qtd,
      'valor': valor,
    };
    return map;
  }

  Produto.fromMap(Map<String, dynamic> map){
    codigo = map['codigo'];
    descricao = map['descricao'];
    qtd = map['qtd'];
    valor = map['valor'];
  }

  @override
  String toString(){
    return "Produto => (codigo: $codigo, descricao: $descricao, qtd: $qtd, valor: $valor)";
  }
}