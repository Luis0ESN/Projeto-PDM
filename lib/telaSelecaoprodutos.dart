import 'package:flutter/material.dart';
import 'package:projeto_pdm/helpers/database_helper.dart';
import 'package:projeto_pdm/models/produto.dart';

class WidgetTelaSelecaoProdutos extends StatefulWidget {

  final List<Produto> produtosAux;
  WidgetTelaSelecaoProdutos(this.produtosAux);

  @override
  _WidgetTelaSelecaoProdutosState createState() => _WidgetTelaSelecaoProdutosState();
}

class _WidgetTelaSelecaoProdutosState extends State<WidgetTelaSelecaoProdutos> {
  DatabaseHelper db = DatabaseHelper();
  List<Produto> produtos = List<Produto>();

  final _codigoController = TextEditingController();

  @override
  void initState(){
    super.initState();
    _exibeProdutos(p: widget.produtosAux);
  }


  _exibeProdutos({String nome, List<Produto> p}){
    db.getProdutos2(nome: nome, produtos: p).then( (lista){
      setState((){
        produtos = lista;
      });
    });

    /*
    if(widget.produtosAux.isNotEmpty)
    {
      print(widget.produtosAux);
      //print(produtos);
      for (var item in widget.produtosAux) {
        setState((){
          print(  'test');
          //print(produtos);
          produtos.remove(item);
          //print(produtos);
        });
      }
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

    );
  }

  produtoField(){
    return Container(
      child: TextField(
        controller: _codigoController,
        obscureText: false,
        onChanged: (text){
          _exibeProdutos(nome: text, p: widget.produtosAux);
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
                DataColumn(label: Text("Adicionar")),
              ], 
              rows: produtos.map((produto) => DataRow(
                cells: [
                  DataCell(Text(produto.codigo),),
                  DataCell(Text(produto.qtd.toString()),),
                  DataCell(Text(produto.descricao),),
                  DataCell(Text(produto.valor.toString()),),

                  DataCell(IconButton(
                    icon: Icon(Icons.add), 
                    onPressed: (){
                      //print(produto);
                      Navigator.pop(context, produto);
                      //_exibePaginaCadastroProdutos(produto: produto);
                    }
                  )
                  ),
                ]
              ),
              ).toList(),
              ),
          );
  }
  
}