import 'package:flutter/material.dart';
import 'package:sa_mobile_formativa/controllers/categoria_controller.dart';
import 'package:sa_mobile_formativa/controllers/tarefa_controller.dart';
import 'package:sa_mobile_formativa/models/categoria_model.dart';
import 'package:sa_mobile_formativa/models/tarefa_model.dart';
import 'package:sa_mobile_formativa/views/criar_tarefa_screen.dart';




class DetalheCategoriaScreen extends StatefulWidget{
  final int categoriaId;  

  DetalheCategoriaScreen({
    super.key,
    required this.categoriaId
  });

  @override
  State<StatefulWidget> createState() {
    return _DetalheCategoriaScreenState();
  }
}

// build da tela
class _DetalheCategoriaScreenState extends State<DetalheCategoriaScreen>{
  final _categoriaControl = CategoriaController();
  final _tarefaControl = TarefaController();

  Categoria? _categoria;  // pode ser nulo

  List<Tarefa> _tarefas = [];

  bool _isLoading = true;

  // carregar as info initState
  @override
  void initState() {

    super.initState();
    _carregarDados();
  }

  void _carregarDados() async {
    setState(() {
      _isLoading = true;
      _tarefas = [];
    });
    try {
      _categoria = await _categoriaControl.readCategoriabyId(widget.categoriaId);
      _tarefas = await _tarefaControl.readTarefaByCategoria(widget.categoriaId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Exception: $e"))
      );
    } finally{
      setState(() {
        _isLoading = false;
      });
    }
  }

  //build da Tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detalhe da Categoria"),),
      body: _isLoading
        ? Center(child: CircularProgressIndicator())
        : _categoria == null 
          ? Center(child: Text("Erro ao carregar a categoria, verifique o ID"),) 
          : Padding(padding: EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, 
          children: [ 
            Text("Nome: ${_categoria!.nome}",style: TextStyle(fontSize: 20),),
              Text("Objetivo: ${_categoria!.objetivo}"),
              Divider(),
              Text("Tarefas:", style: TextStyle(fontSize: 18),),
              //operador Ternário
              _tarefas.isEmpty ? Center(child: Text("Não existem tarefas"),) : Expanded(child:
              ListView.builder(
                itemCount: _tarefas.length,
                itemBuilder: (context, index) {
                  final tarefa = _tarefas[index];
                  final concluida = tarefa.status.toLowerCase() == "concluída";

                  return ListTile(
                    leading: Checkbox(
                      value: concluida,
                      onChanged: (bool? value) async {
                        final novoStatus = value! ? "concluída" : "pendente";
                        await _tarefaControl.atualizarStatus(tarefa.id!, novoStatus);

                        setState(() {
                          _tarefas[index] = Tarefa(
                            id: tarefa.id,
                            categoriaId: tarefa.categoriaId,
                            dataHora: tarefa.dataHora,
                            titulo: tarefa.titulo,
                            descricao: tarefa.descricao,
                            status: novoStatus,
                            prioridade: tarefa.prioridade
                          );
                        });
                      },
                    ),
                    title: Text(
                      tarefa.titulo,
                      style: TextStyle(
                        decoration: concluida ? TextDecoration.lineThrough : TextDecoration.none,
                      ),
                    ),
                    subtitle: Text(tarefa.dataHoraLocal),
                  );
                },
              )

              )
            ],
          ),) ,
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          await Navigator.push(context, 
            MaterialPageRoute(builder: (context)=> CriarTarefaScreen(categoriaId: widget.categoriaId)));
          _carregarDados();
        },
        child: Icon(Icons.add),
      ), 
    );
  }
}