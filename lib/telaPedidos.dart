import 'package:flutter/material.dart';

class WidgetPedido extends StatefulWidget {
  @override
  _WidgetPedidoState createState() => _WidgetPedidoState();
}

class _WidgetPedidoState extends State<WidgetPedido> {

  @override
  Widget build(BuildContext context) {

    final nomeRevendedoraField = Container(
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
          ], 
          rows: [],
          )
        ]
    )
    );


    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar produtos"),
        centerTitle: true,
      ),

      body: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 5.0), nomeRevendedoraField,
              SizedBox(height: 10.0), tabelaField,
              
              
            ]
          )
        ),


      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed:  () {print("Pressionado");},
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
}