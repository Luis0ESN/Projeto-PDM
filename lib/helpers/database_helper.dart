import 'dart:async';
import 'dart:io';
import 'package:projeto_pdm/models/produto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String produtoTable = 'produto';
  String colCodigo = 'codigo';
  String colDescricao = 'descricao';
  String colQtd = 'qtd';
  String colValor = 'valor';


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

    String path = directory.path + 'produtos.db';

    var produtosDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return produtosDatabase;
  }

  void _createDb(Database db, int newVersion) async{
    await db.execute('CREATE TABLE $produtoTable($colCodigo TEXT PRIMARY KEY, '
    '$colDescricao TEXT, $colQtd INTEGER, $colValor REAL)');
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
  Future<List<Produto>> getProdutos() async{
    Database db = await this.database;

    var resultado = await db.query(produtoTable);

    List<Produto> lista = resultado.isNotEmpty ? resultado.map(
      (c) => Produto.fromMap(c)).toList(): [];

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