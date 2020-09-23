import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto_pdm/models/produto.dart';

class WidgetCadastraProduto extends StatefulWidget {

  final Produto produto;
  WidgetCadastraProduto({this.produto});

  @override
  _WidgetCadastraProdutoState createState() => _WidgetCadastraProdutoState();
}

class _WidgetCadastraProdutoState extends State<WidgetCadastraProduto> {

   final _codigoController = TextEditingController();
   final _descricaoController = TextEditingController();
   final _qtdController = TextEditingController();
   final _valorController = TextEditingController();

   bool edit = false;
   //bool _delete =  true;
   Produto _editProduto;

  @override
  void initState(){
    super.initState();

    if(widget.produto ==  null){
      //_delete = false;
      _editProduto = Produto("", "", 0, 0);
    }
    else{
      _editProduto = Produto.fromMap(widget.produto.toMap());

      _codigoController.text = _editProduto.codigo;
      _descricaoController.text = _editProduto.descricao;
      _qtdController.text = _editProduto.qtd.toString();
      _valorController.text = _editProduto.valor.toString();
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editProduto.codigo == "" ? "Novo Produto.": "Editando produto."),
        centerTitle: true,
      ),

      body: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              //SizedBox(height: 10.0), codigoField,
              TextField(
                controller: _codigoController,
                enabled: _editProduto.codigo != "" ? false : true,
                onChanged: (text){
                  edit = true;
                  _editProduto.codigo = text;
                  /*
                  setState((){
                    _editProduto.codigo = text;
                  });
                  */
                },
                obscureText: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                  labelText: "Código do produto",
                  isDense: true,
                )
              ),

              TextField(
                controller: _descricaoController,
                onChanged: (text){
                  edit = true;
                  _editProduto.descricao = text;
                },
                maxLines: 5,
                obscureText: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                  labelText: "Descrição do produto",
                  isDense: true,
                )
              ),
              
              TextField(
                controller: _qtdController,
                onChanged: (text){
                  edit = true;
                  if(text != null && text.isNotEmpty)
                  {
                    _editProduto.qtd = int.parse(text);
                  }
                  else{
                    _editProduto.qtd = 0;
                  }
                  
                },
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
              ),

              TextField(
                controller: _valorController,
                onChanged: (text){
                  edit = true;
                  if(text != null && text.isNotEmpty)
                  {
                    _editProduto.valor = double.parse(text);
                  }
                  else{
                    _editProduto.valor = 0;
                  }
                },
                keyboardType: TextInputType.number,
                obscureText: false,
                inputFormatters: [
                    //FilteringTextInputFormatter(filterPattern, allow: null)
                    BlacklistingTextInputFormatter(RegExp("[- ,]"))
                ],
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                  labelText: "Valor R\$",
                  isDense: true,
                )
              )
              
            ]
          )
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
                    /*
                    onPressed: _editProduto.codigo == "" ? () => null : {
                      Navigator.pop(context, _editProduto);
                    },
                    */

                    onPressed: widget.produto != null ? () => _confirmaExclusao() : null,
                    
                    icon: Icon(Icons.delete),
                    tooltip: "Deletar produto."
                  ),

                  IconButton(
                    onPressed: () {
                      if(_editProduto.codigo != null && _editProduto.codigo.isNotEmpty
                        && _editProduto.descricao != null && _editProduto.descricao.isNotEmpty
                        && _editProduto.qtd != null && _editProduto.qtd > 0 && _editProduto.qtd.toString().isNotEmpty
                        && _editProduto.valor != null && _editProduto.valor > 0 && _editProduto.valor.toString().isNotEmpty)
                      {
                        Navigator.pop(context, _editProduto);
                      }
                      else{
                        _exibeAviso();
                      }
                      
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

  void _exibeAviso(){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: new Text("Valores inválidos"),
          content: new Text("Existem valores inválidos."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Fechar"),
              onPressed: (){
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void _confirmaExclusao(){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("Excluir produto"),
          content: Text("Tem certeza?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancelar."),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Excluir."),
              onPressed: (){
                Navigator.of(context).pop();
                Navigator.pop(context, 'delete');
              },
            )
          ],
        );
      },
    );
  }

}