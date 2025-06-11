import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sa_mobile_formativa/controllers/tarefa_controller.dart';
import 'package:sa_mobile_formativa/models/tarefa_model.dart';
import 'package:sa_mobile_formativa/views/detalhe_categoria_screen.dart';



class CriarTarefaScreen  extends StatefulWidget{
  final int categoriaId;

  CriarTarefaScreen({super.key, required this.categoriaId});

  @override
  State<StatefulWidget> createState() {
    return _CriarTarefaScreenState();
  }
}

class _CriarTarefaScreenState extends State<CriarTarefaScreen>{
  //formulario
  final _formKey = GlobalKey<FormState>();
  final _tarefasControl = TarefaController();

  late String _titulo; 
  late String _descricao;
  late String _status;
  late String _prioridade;
  DateTime _selectedDate = DateTime.now(); 

  // método para Seleção da Data
  void _dataSelecionada(BuildContext context) async{
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(), 
      lastDate: DateTime(2030),
      );
    if(picked != null && picked != _selectedDate){
      setState(() {
        _selectedDate = picked;
      });
    }
  }
  
  //* salvar a Tarefa
  void _salvarTarefa() async {
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();  // salva os valores do formulário

      // correçao de data
      final DateTime dataFinal = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day
      );

      final newTarefa = 
      Tarefa(
        categoriaId: widget.categoriaId, 
        dataHora: dataFinal, 
        titulo: _titulo,
        descricao: _descricao.isEmpty ? "." : _descricao,
        status: _status,
        prioridade: _prioridade);
      
      try {
        await _tarefasControl.createTarefa(newTarefa);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Tarefa adicionada com sucesso"))
        );
        Navigator.push(context, 
          MaterialPageRoute(builder: (context)=>DetalheCategoriaScreen(categoriaId: widget.categoriaId)));
        
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Exception: $e"))
        );
      }
    }
  }

  //& buildar a tela
  @override
  Widget build(BuildContext context) {
    // formatção paradata e hora
    final DateFormat dataFormatada = DateFormat("dd/MM/yyyy");

    return Scaffold(
      appBar: AppBar(
        title: Text("Nova Tarefa"),
      ),
      body: Padding(padding: EdgeInsets.all(16),
      child: Form(key: _formKey, child: ListView(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: "Titulo"),
            validator: (value) => value!.isEmpty ? "Campo deve ser preenchido" : null,
            onSaved: (newValue) => _titulo = newValue!,
          ),
          SizedBox(height: 10,),
          Row(
              children: [
                Expanded(child: Text("Data de vencimento: ${dataFormatada.format(_selectedDate)}")),
                TextButton(onPressed: ()=>_dataSelecionada(context), child: Text("Selecionar Data"))
              ],
            ),
            SizedBox(height: 10,),
            TextFormField(
              decoration: InputDecoration(labelText: "Descrição"),
              maxLines: 3,
              onSaved: (newValue) => _descricao=newValue!,
            ),
            TextFormField(
            decoration: InputDecoration(labelText: "Status"),
            validator: (value) => value!.isEmpty ? "Campo deve ser preenchido" : null,
            onSaved: (newValue) => _status = newValue!,
            ),
            TextFormField(
            decoration: InputDecoration(labelText: "Prioridade"),
            validator: (value) => value!.isEmpty ? "Campo deve ser preenchido" : null,
            onSaved: (newValue) => _prioridade = newValue!,
            ),
            ElevatedButton(onPressed: _salvarTarefa, child: Text("Adicionar tarefa"))
          ],
        )),)
    );
  }
}