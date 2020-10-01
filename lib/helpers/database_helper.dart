import 'dart:async';
import 'dart:io';
import 'package:projeto_pdm/models/pedidos.dart';
import 'package:projeto_pdm/models/produto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
  static DatabaseHelper _databaseHelper;
  static Database _database;

  //Para tabela de produtos
  String produtoTable = 'produto';
  String colCodigo = 'codigo';
  String colDescricao = 'descricao';
  String colQtd = 'qtd';
  String colValor = 'valor';

  //Para tabela de pedidos
  String pedidoTable = 'pedido';
  String colPedidoId = 'id';
  String colPedidoPath = 'path';
  String colPedidoRevendedora = 'revendedora';


  //construtor paa instanciar a classe
  DatabaseHelper.createInstance();

  factory DatabaseHelper(){
    // instancia apenas 1 vez
    if (_databaseHelper == null){
      _databaseHelper = DatabaseHelper.createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async{
    if(_database == null){
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async{
    Directory directory = await getApplicationDocumentsDirectory();

    String path = directory.path + 'meuAplicativo.db';

    var produtosDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return produtosDatabase;
  }

  void _createDb(Database db, int newVersion) async{
    await db.execute('CREATE TABLE $produtoTable($colCodigo TEXT PRIMARY KEY, '
    '$colDescricao TEXT, $colQtd INTEGER, $colValor REAL)');

    await db.execute('CREATE TABLE $pedidoTable($colPedidoId INTEGER PRIMARY KEY AUTOINCREMENT, '
    '$colPedidoPath TEXT, $colPedidoRevendedora TEXT)');
  }
  /* Para a tabela pedido */
  Future<int> insertPedido(Pedido pedido) async{
    Database db = await this.database;
    var resultado = await db.insert(pedidoTable, pedido.toMap());
    return resultado;
  }

  Future<Pedido> getPedido(int id) async{

    Database db = await this.database;

    List<Map> maps = await db.query(pedidoTable,
    columns: [colPedidoId, colPedidoPath, colPedidoRevendedora],
    where: "$colPedidoId = ?",
    whereArgs: [id] );

    if(maps.length > 0){
      return Pedido.fromMap(maps.first);
    }
    else{
      return null;
    }
  }

  Future<List<Pedido>> getPedidos({String nome}) async{
    Database db = await this.database;

      var resultado = await db.query(pedidoTable);

      List<Pedido> lista = resultado.isNotEmpty ? resultado.map(
        (c) => Pedido.fromMap(c)).toList(): [];


    if(nome != null && nome.isNotEmpty)
    {
      lista = lista.where((u) => (u.revendedora.toLowerCase().contains(nome.toLowerCase()))).toList();
    }

      return lista;
  }

  Future<int> updatePedido(Pedido pedido) async{
    var db = await this.database;

    var resultado = await db.update(pedidoTable, pedido.toMap(),
    where: '$colPedidoId = ?',
    whereArgs: [pedido.id]);

    return resultado;
  }

  Future<int> deletePedido(int id) async{
    var db = await this.database;

    int resultado = await db.delete(pedidoTable, 
    where: '$colPedidoId = ?',
    whereArgs: [id]);

    return resultado;
  }


  //incluir no banco de dados
  Future<int> insertProduto(Produto produto) async{
    Database db = await this.database;
    var resultado = await db.insert(produtoTable, produto.toMap());
    return resultado;
  }


  //retorna um produto pelo codigo
  Future<Produto> getProduto(String codigo) async{

    Database db = await this.database;

    List<Map> maps = await db.query(produtoTable,
    columns: [colCodigo, colDescricao, colQtd, colValor],
    where: "$colCodigo = ?",
    whereArgs: [codigo] );

    if(maps.length > 0){
      return Produto.fromMap(maps.first);
    }
    else{
      return null;
    }
  }

  //retorna toda a lista de produtos
  Future<List<Produto>> getProdutos({String nome}) async{
    Database db = await this.database;

      var resultado = await db.query(produtoTable);

      List<Produto> lista = resultado.isNotEmpty ? resultado.map(
        (c) => Produto.fromMap(c)).toList(): [];


    if(nome != null && nome.isNotEmpty)
    {
      lista = lista.where((u) => (u.descricao.toLowerCase().contains(nome.toLowerCase()))).toList();
    }

      return lista;
  }

  Future<List<Produto>> getProdutos2({String nome, List<Produto> produtos}) async{
    Database db = await this.database;

      var resultado = await db.query(produtoTable);

      List<Produto> lista = resultado.isNotEmpty ? resultado.map(
        (c) => Produto.fromMap(c)).toList(): [];


    if(nome != null && nome.isNotEmpty)
    {
      lista = lista.where((u) => (u.descricao.toLowerCase().contains(nome.toLowerCase()))).toList();
    }
    if(produtos != null && produtos.isNotEmpty){
      for (Produto p in produtos) {
        lista = lista.where((u) => (u.codigo != p.codigo)).toList();  
      }
    }
      return lista;
  }

  //Atualizar produto
  Future<int> updateProduto(Produto produto) async{
    var db = await this.database;

    var resultado = await db.update(produtoTable, produto.toMap(),
    where: '$colCodigo = ?',
    whereArgs: [produto.codigo]);

    return resultado;
  }


  //Deletar produto
  Future<int> deleteProduto(String codigo) async{
    var db = await this.database;

    int resultado = await db.delete(produtoTable, 
    where: '$colCodigo = ?',
    whereArgs: [codigo]);

    return resultado;
  }


  Future close() async{
    Database db = await this.database;
    db.close();
  }
}