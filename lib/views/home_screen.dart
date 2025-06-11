import 'package:flutter/material.dart';
import 'package:sa_mobile_formativa/controllers/categoria_controller.dart';
import 'package:sa_mobile_formativa/models/categoria_model.dart';
import 'package:sa_mobile_formativa/views/cadastro_categoria_screen.dart';
import 'package:sa_mobile_formativa/views/detalhe_categoria_screen.dart';

class HomeScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  //atributos
  final CategoriaController _categoriaController = CategoriaController();
  List<Categoria> _categorias = [];
  bool _isLoading = true;  // enquanto carrega info do BD

  @override
  void initState() {  //* método para rodar antes de tudo
    super.initState();
    _carregarDados();
  }

  _carregarDados() async{
    setState(() {
      _isLoading = true;
    });
    try {
      _categorias = await _categoriaController.readCategorias();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Exception: $e")));
    }finally{ //execução obrigatória
      setState(() {
        _isLoading = false;
      });
    }
  }

  //buildar a tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Categorias - Tarefas"),),
      body: _isLoading
      ? Center(child: CircularProgressIndicator(),)
      : Padding(
        padding: EdgeInsets.all(16), child: ListView.builder(
          itemCount: _categorias.length, itemBuilder: (context,index){
            final categoria = _categorias[index];
            return ListTile(
              title: Text("${categoria.nome}"),
              subtitle: Text("${categoria.objetivo}"),
              //* on tap -> para navegar para o categoria
              onTap: () => Navigator.push(context, 
                    MaterialPageRoute(builder: (context)=>DetalheCategoriaScreen(categoriaId: categoria.id!))),
              //* onLongPress -> delete da categoria
            );  // item da lista
          }),
          ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Adicionar nova categoria",
        child: Icon(Icons.add),
        onPressed: () async  {
          await Navigator.push(context, 
            MaterialPageRoute(builder: (context) => CadastroCategoriaScreen()));
        },
      ),
    );
  }
}