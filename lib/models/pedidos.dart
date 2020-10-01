class Pedido{
  int id;
  String path;
  String revendedora;


  Pedido(this.id, this.path, this.revendedora);

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      'id': id,
      'path': path,
      'revendedora': revendedora,
    };
    return map;
  }

  Pedido.fromMap(Map<String, dynamic> map){
    id = map['id'];
    path = map['path'];
    revendedora = map['revendedora'];
  }

  @override
  String toString(){
    return "Pedido => (id: $id, path: $path, revendedora: $revendedora)";
  }
}