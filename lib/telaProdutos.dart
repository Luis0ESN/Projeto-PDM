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

  final _codigoController = TextEditingController();

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
    _exibeProdutos();
  }

  _exibeProdutos({String nome}){
    db.getProdutos(nome: nome).then( (lista){
      setState(() {
        produtos = lista;
      });
    });
    /*
    if(_codigoController.toString() == ""){
    db.getProdutos().then( (lista){
      setState(() {
        produtos = lista;
      });
    });
  }
  else{
    db.getProduto(_codigoController.toString()).then( (lista){
      setState(() {
        produtos = lista;
      });
    });
  }
  */
  }

  @override
  Widget build(BuildContext context) {

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
              SizedBox(height: 0), produtoField(),
              Expanded(child: tabelaField()),
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
                      _exibePaginaCadastroProdutos();
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

  produtoField(){
    return Container(
      child: TextField(
        controller: _codigoController,
        obscureText: false,
        onChanged: (text){
          _exibeProdutos(nome: text);
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          labelText: "Pesquisar por produto.",
          isDense: true,
        )
      )
    );
  }

  SingleChildScrollView tabelaField(){
    return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                
                columnSpacing: 24,
              columns: [
                DataColumn(label: Text("Código")),
                DataColumn(label: Text("Qtd")),
                DataColumn(label: Text("Descrição")),
                DataColumn(label: Text("Valor")),
                DataColumn(label: Text("Editar")),
              ], 
              rows: produtos.map((produto) => DataRow(
                cells: [
                  DataCell(Text(produto.codigo),),
                  DataCell(Text(produto.qtd.toString()),),
                  DataCell(Text(produto.descricao),),
                  DataCell(Text(produto.valor.toString()),),

                  DataCell(IconButton(
                    icon: Icon(Icons.edit), 
                    onPressed: (){
                      _exibePaginaCadastroProdutos(produto: produto);
                    }
                  )
                  ),
                ]
              ),
              ).toList(),
              ),
          );
  }
  
  void _exibePaginaCadastroProdutos({Produto produto}) async{
    final produtoRecebido = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => WidgetCadastraProduto(produto: produto)));

        if(produtoRecebido != null){
          if(produtoRecebido == 'delete'){
            //print('deletando');
            await db.deleteProduto(produto.codigo);
          }
          else{
            if(produto != null){
              //print('alterando');
              await db.updateProduto(produtoRecebido);
            }
            else{
              //print('inserindo');
              await db.insertProduto(produtoRecebido);
            }
          }
          

          _exibeProdutos();
        }
  }
}