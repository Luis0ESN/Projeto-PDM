import 'package:flutter/material.dart';
import 'package:projeto_pdm/helpers/database_helper.dart';
import 'package:projeto_pdm/models/produto.dart';

import 'telaCadastroprodutos.dart';
import 'telaPedidos.dart';

class WidgetTelaProdutos extends StatefulWidget {
  @override
  _WidgetTelaProdutosState createState() => _WidgetTelaProdutosState();
}

class _WidgetTelaProdutosState extends State<WidgetTelaProdutos> {
  DatabaseHelper db = DatabaseHelper();
  List<Produto> produtos = List<Produto>();

  /*
  _listaProdutos(BuildContext context, int index){
    return GestureDetector(
      child: Card(
        child: Padding(padding: EdgeInsets.all(10),
        child:Row(
          children: <Widget>[
              Text(produtos[index].codigo ?? ""),
              Text(produtos[index].descricao ?? ""),
              Text(produtos[index].qtd.toString() ?? ""),
              Text(produtos[index].valor.toString() ?? "")
          ],
        )
        )
      ),
    );
  }
  */

  @override
  void initState(){
    super.initState();

    /*
    Produto p1 = Produto('x1abc', 'roupa1', 2, 40.9);
    db.insertProduto(p1);

    Produto p2 = Produto('23abc', 'roupa2', 4, 50);
    db.insertProduto(p2);
    
    db.getProdutos().then( (lista){
      print(lista);
    });
    */

    db.getProdutos().then( (lista){
      setState(() {
        produtos = lista;
      });
    });
    
  }

  @override
  Widget build(BuildContext context) {

    final produtoField = Container(
      child: TextField(
        obscureText: false,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          labelText: "Pesquisar por produto.",
          isDense: true,
        )
      )
    );

    final tabelaField = Container(
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        //width: 200,
        children: <Widget>[ 
          DataTable(
            
            columnSpacing: 25.5,
          columns: [
            DataColumn(label: Text("Código")),
            DataColumn(label: Text("Qtd")),
            DataColumn(label: Text("Descrição")),
            DataColumn(label: Text("Valor")),
            DataColumn(label: Text("Delete")),
          ], 
          rows: produtos.map((produto) => DataRow(
            cells: [
              DataCell(Text(produto.codigo),),
              DataCell(Text(produto.qtd.toString()),),
              DataCell(Text(produto.descricao),),
              DataCell(Text(produto.valor.toString()),),

              DataCell(IconButton(
                icon: Icon(Icons.delete), 
                onPressed: (){
                  //Deleta o produto
                  db.deleteProduto(produto.codigo);

                  //Pega a nova lista
                  db.getProdutos().then( (lista){
                  setState(() {
                    produtos = lista;
                    });
                  });

                }
              )
              ),
            ]
          ),
          ).toList(),
          ),
        ]
    )
    );



    return Scaffold(
      appBar: AppBar(
        title: Text("Meus produtos"),
        centerTitle: true,
      ),

      
      body: Container(
        color: Colors.white,
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 0), produtoField,
              SizedBox(height: 0), tabelaField,
            ]
          )
      ),
      

      /*
      body: ListView.builder(
      padding: EdgeInsets.all(5),
      itemCount: produtos.length,
      itemBuilder: (context, index){
        return _listaProdutos(context,index);
      }
    ),
    */

      bottomNavigationBar: BottomAppBar(
        child: Container(
          height:  60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
                  IconButton(
                    onPressed: (null),
                    icon: Icon(Icons.search),
                    tooltip: "Pesquisar pelos meus produtos."
                  ),

                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => WidgetCadastraProduto()));
                    },
                    icon: Icon(Icons.add),
                    tooltip: "Cadastrar novo produto."
                  ),

                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => WidgetPedido()));
                    },
                    icon: Icon(Icons.playlist_add),
                    tooltip: "Fazer listas de pedidos"
                  ),
            ],
          ),
        ),
        color: Colors.blue,
      ),

    );
  }
}