import 'package:flutter/material.dart';
import 'package:sa_mobile_formativa/controllers/categoria_controller.dart';
import 'package:sa_mobile_formativa/models/categoria_model.dart';
import 'package:sa_mobile_formativa/views/home_screen.dart';



class CadastroCategoriaScreen  extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {

    return _CadastroCategoriaScreenState();
  }
}

class _CadastroCategoriaScreenState extends State<CadastroCategoriaScreen>{
  final _formKey = GlobalKey<FormState>(); // chave para o formulário
  final _categoriasController = CategoriaController();

  // Late, no primeiro momneto é nula, mas irá receber um valor futuramente
  late String _nome;
  late String _objetivo;

  _salvarCategoria() async{
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();
      final newCategoria = Categoria(
        nome: _nome, 
        objetivo: _objetivo);
      await _categoriasController.createCategoria(newCategoria);
      Navigator.push(context,MaterialPageRoute(builder: (context)=>HomeScreen()));
    }
  }

  //buildar a Screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cadastro de Categoria"),),
      body: Padding(padding: EdgeInsets.all(16),
      child: Form(key: _formKey, child: ListView(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: "Nome da Categoria"),
            validator: (value) => value!.isEmpty ? "Campo não preenchido" : null,
            onSaved: (newValue) => _nome = newValue!,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Objetivo da Categoria"),
            validator: (value) => value!.isEmpty ? "Campo não preenchido" : null,
            onSaved: (newValue) => _objetivo = newValue!,
          ),
          ElevatedButton(onPressed: _salvarCategoria, child: Text("Cadastrar"))
        ],
      )),),
    );
  }
}