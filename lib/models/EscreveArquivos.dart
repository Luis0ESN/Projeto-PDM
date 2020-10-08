import 'package:projeto_pdm/helpers/database_helper.dart';
import 'package:projeto_pdm/models/pedidos.dart';
import 'package:projeto_pdm/models/produto.dart';

import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class ArquivoStorage {
  //DateTime _date = DateTime.now();
  String _date = DateTime.now().toString();
  final String date;
  final String revendedora;
  final List<Produto> listaprodutos;

  DatabaseHelper db = DatabaseHelper();
  ArquivoStorage(this.revendedora, this.listaprodutos, this.date);

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final name = "${revendedora}_${_date}.txt";
    final path = await _localPath;
    return File("$path/$name");
  }

  Future<String> readFile(path) async {
    try{
      final file = File("$path");
      String contents = await file.readAsString();

      return contents;
    } catch (e){
      return "";
    }
  }

  Future<File> writeFile() async{
    final file = await _localFile;

    final name = "${revendedora}_${_date}.txt";
    final path = await _localPath;

    print( "$path/$name");
    print('\n');
    print('\n');


    int _id;

    Pedido pedido = Pedido(_id, "$path/$name", "$revendedora");
    await db.insertPedido(pedido);

    file.writeAsString('Revendedora: ${revendedora}\n');
    file.writeAsString('Data de entrega: ${date}\n');
    for (var p in listaprodutos) {
      file.writeAsString('${p.toString()}\n');
    }

    return file;
  }


}