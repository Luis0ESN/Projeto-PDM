import 'package:flutter/material.dart';
import 'package:projeto_pdm/telaProdutos.dart';
void main() {
  runApp(
    MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Primeira tela",
      theme: ThemeData(primaryColor:  Colors.blue),
      home: WidgetTelaProdutos(),
    );
  }
}