import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WidgetCadastraProduto extends StatefulWidget {
  @override
  _WidgetCadastraProdutoState createState() => _WidgetCadastraProdutoState();
}

class _WidgetCadastraProdutoState extends State<WidgetCadastraProduto> {
  @override
  Widget build(BuildContext context) {

    final codigoField = Container(
      //width: 200,
      child: TextField(
      obscureText: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        labelText: "Código do produto",
        isDense: true,
      )
    )
    );

    final descricaoField = Container(
      //width: 200,
      child: TextField(
      maxLines: 5,
      obscureText: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        labelText: "Descrição do produto",
        isDense: true,
      )
    )
    );


final qtdField = Container(
      //width: 200,
      child: TextField(
        keyboardType: TextInputType.number,
        obscureText: false,
        inputFormatters: [
          WhitelistingTextInputFormatter.digitsOnly
          ],
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          labelText: "Quantidade",
          isDense: true,
        )
    )
    );

final valorField = Container(
      //width: 200,
      child: TextField(
        keyboardType: TextInputType.number,
        obscureText: false,
        inputFormatters: [
            BlacklistingTextInputFormatter(RegExp("[- ,]"))
        ],
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          labelText: "Valor R\$",
          isDense: true,
        )
    )
    );


    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar produtos"),
        centerTitle: true,
      ),

      body: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10.0), codigoField,
              SizedBox(height: 10.0), descricaoField,
              SizedBox(height: 10.0), qtdField,
              SizedBox(height: 10.0), valorField,
              
              
            ]
          )
        ),


      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_a_photo),
        onPressed:  (null),
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
                    tooltip: "Salvar produto."
                  ),
            ],
          ),
        ),
        color: Colors.blue,
      ),

    );
    
  }
}