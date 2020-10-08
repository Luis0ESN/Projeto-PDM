import 'package:flutter/material.dart';
import 'package:projeto_pdm/helpers/database_helper.dart';
import 'package:projeto_pdm/models/EscreveArquivos.dart';
import 'package:projeto_pdm/models/pedidos.dart';

class WidgetTelaViewPedidos extends StatefulWidget {
  @override
  _WidgetTelaViewPedidosState createState() => _WidgetTelaViewPedidosState();
}

class _WidgetTelaViewPedidosState extends State<WidgetTelaViewPedidos> {
  DatabaseHelper db = DatabaseHelper();
  List<Pedido> pedidos = List<Pedido>();

  final _revendedoraController = TextEditingController();

  @override
  void initState(){
    super.initState();
    _exibeProdutos();
  }

  _exibeProdutos({String nome}){
    db.getPedidos(nome: nome).then( (lista){
      setState(() {
        pedidos = lista;
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
        title: Text("Meus Pedidos."),
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

      /*
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
      */

    );
  }

  produtoField(){
    return Container(
      child: TextField(
        controller: _revendedoraController,
        obscureText: false,
        onChanged: (text){
          _exibeProdutos(nome: text);
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          labelText: "Pesquisar por pedido.",
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
                DataColumn(label: Text("Revendedora")),
                DataColumn(label: Text("Data de edição")),
                DataColumn(label: Text("Visualizar")),
              ], 
              rows: pedidos.map((pedido) => DataRow(
                cells: [
                  DataCell(Text(pedido.revendedora),),
                  DataCell(Text(pedido.id.toString()),),

                  DataCell(IconButton(
                    icon: Icon(Icons.view_list), 
                    onPressed: (){
                      ArquivoStorage a;
                      print(a.readFile(pedido.path));
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