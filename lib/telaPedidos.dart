import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto_pdm/helpers/database_helper.dart';
import 'package:projeto_pdm/models/EscreveArquivos.dart';
import 'package:projeto_pdm/telaSelecaoprodutos.dart';
import 'package:projeto_pdm/models/produto.dart';

class WidgetPedido extends StatefulWidget {
  @override
  _WidgetPedidoState createState() => _WidgetPedidoState();
}

class _WidgetPedidoState extends State<WidgetPedido> {
  DatabaseHelper db = DatabaseHelper();
  List<Produto> listaprodutos = List<Produto>();

  //final _revendedoraController = TextEditingController();
  DateTime _date;
  String _revendedora;
  @override
  void initState(){
    super.initState();
    _revendedora = '';
    
  }
  Widget build(BuildContext context) {    
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
              SizedBox(height: 5.0), datetimeField(),
              Expanded(child: tabelaField()),
              
              
            ]
          )
        ),

      
      floatingActionButton: Container(
        height: 25,
        width: 25,
        child: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed:  () {
            _exibePaginaSelecaoProdutos();
            },
        ),
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
                      ArquivoStorage arquivo = ArquivoStorage(_revendedora, listaprodutos, _date.toString());
                      arquivo.writeFile();

                      //Navigator.pop(context);
                      print(listaprodutos);
                      print(_revendedora);
                      print(_date);
                      print('\n');
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

  void _exibeAviso(String texto){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: new Text(texto),
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

  void _avisoAlteracao(Produto produto){
    Produto _editProduto = Produto.fromMap(produto.toMap());
    final _qtdController = TextEditingController();
    final _valorController = TextEditingController();
    _qtdController.text = _editProduto.qtd.toString();
    _valorController.text = _editProduto.valor.toString();

    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: new Text("Editando produto"),
          content: Container(
            height: 100,
            child: Column(children: [
              TextField(
                  controller: _qtdController,
                  onChanged: (text){
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
              ],),
          ),
          actions: <Widget>[
            Row(children: [
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
                _removeProduto(produto);
              },
            ),
            FlatButton(
              child: Text("Alterar."),
              onPressed: (){
                db.getProduto(produto.codigo).then((original){
                  if(_editProduto.qtd != null && _editProduto.qtd > 0 && _editProduto.qtd.toString().isNotEmpty
                    && _editProduto.qtd <= original.qtd
                    && _editProduto.valor != null && _editProduto.valor > 0 && _editProduto.valor.toString().isNotEmpty)
                  {
                  Navigator.of(context).pop();
                  setState(() {
                      produto.qtd = _editProduto.qtd;
                      produto.valor = _editProduto.valor;
                      listaprodutos = listaprodutos;
                  });
                  }
                  else{
                    if(_editProduto.qtd <= original.qtd){
                    _exibeAviso('Valores inválidos.');
                  }
                    else{
                    _exibeAviso('Valores inválidos.\nQuantidade insuficiente.');
                  }
                  }
                  });
                
                
              },
            ),

            ],)

          ],
        );
      },
    );
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
      onChanged: (text){

        setState(() {
          _revendedora = text;
        });
        
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        labelText: "Nome da Revendedora(o)",
        isDense: true,
      )
    )
    );
  }

  datetimeField(){
    return Container(
      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      child: Row(
        children: <Widget>[
          Text(_date == null ? "Escolha a data de fechamento.": _date.toString()),
          IconButton(
            onPressed: () {
              showDatePicker(context: context, initialDate: DateTime.now(),
               firstDate: DateTime.now(), lastDate: DateTime(2100)).then((date){
                 setState(() {
                   _date = date;
                 });
               });
            },
            icon: Icon(Icons.calendar_today),
            tooltip: "Selecione uma data."
          ),
        ],
      ),
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
                  DataCell(Text(produto.codigo)),
                  DataCell(Text(produto.qtd.toString())),
                  DataCell(Text(produto.descricao)),
                  DataCell(Text(produto.valor.toString())),
                  DataCell(IconButton(
                    icon: Icon(Icons.edit), 
                    onPressed: (){
                      //_removeProduto(produto);
                      _avisoAlteracao(produto);
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