import 'package:flutter/material.dart';
import 'package:projeto_pdm/telaSelecaoprodutos.dart';
import 'package:projeto_pdm/models/produto.dart';

class WidgetPedido extends StatefulWidget {
  @override
  _WidgetPedidoState createState() => _WidgetPedidoState();
}

class _WidgetPedidoState extends State<WidgetPedido> {
  List<Produto> listaprodutos = List<Produto>();

  @override
  Widget build(BuildContext context) {    
    /*
    final tabelaField = Container(
      padding: EdgeInsets.fromLTRB(5, 15.0, 5, 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        //width: 200,
        children: <Widget>[
          DataTable(
            columnSpacing: 45,
          columns: [
            DataColumn(label: Text("Código")),
            DataColumn(label: Text("Qtd")),
            DataColumn(label: Text("Descrição")),
            DataColumn(label: Text("Valor")),
            DataColumn(label: Text("Remover")),
          ], 
          rows: listaprodutos.map((produto) => DataRow(
                cells: [
                  DataCell(Text(produto.codigo),),
                  DataCell(Text(produto.qtd.toString()),),
                  DataCell(Text(produto.descricao),),
                  DataCell(Text(produto.valor.toString()),),

                  DataCell(IconButton(
                    icon: Icon(Icons.delete), 
                    onPressed: (){
                      print("pressionado");
                      //_exibePaginaCadastroProdutos(produto: produto);
                    }
                  )
                  ),
                ]
              ),
              ).toList(),
          )
        ]
    )
    );
    */

    return Scaffold(
      appBar: AppBar(
        title: Text("Criar pedido"),
        centerTitle: true,
      ),

      body: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 5.0), revendedoraField(),
              Expanded(child: tabelaField()),
              
              
            ]
          )
        ),


      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed:  () {
          _exibePaginaSelecaoProdutos();
          },
      ),

      bottomNavigationBar: BottomAppBar(
        child: Container(
          height:  60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.cancel),
                    tooltip: "Cancelar ação."
                  ),

                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.save),
                    tooltip: "Salvar lista."
                  ),
            ],
          ),
        ),
        color: Colors.blue,
      ),

    );
    
  }

  void _removeProduto(Produto produto){
    setState(() {
        listaprodutos.remove(produto);
    });
  }
  void _exibePaginaSelecaoProdutos({List<Produto> produtos}) async{
    final produtoRecebido = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => WidgetTelaSelecaoProdutos(listaprodutos)));

    if(produtoRecebido != null)
    {
      setState(() {
        listaprodutos.add(produtoRecebido);
      });
      
    }
  }

  revendedoraField(){
    return Container(
      child: TextField(
      obscureText: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        labelText: "Nome da Revendedora(o)",
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
            DataColumn(label: Text("Remover")),
          ], 
          rows: listaprodutos.map((produto) => DataRow(
                cells: [
                  DataCell(Text(produto.codigo),),
                  DataCell(Text(produto.qtd.toString()),),
                  DataCell(Text(produto.descricao),),
                  DataCell(Text(produto.valor.toString()),),

                  DataCell(IconButton(
                    icon: Icon(Icons.delete), 
                    onPressed: (){
                      _removeProduto(produto);
                      //_exibePaginaCadastroProdutos(produto: produto);
                    }
                  )
                  ),
                ]
              ),
              ).toList(),
              
          )
    );
    }
}