import 'package:sa_mobile_formativa/models/tarefa_model.dart';
import 'package:sa_mobile_formativa/services/db_helper.dart';

class TarefaController {
  final _dbHelper = DbHelper();

  createTarefa(Tarefa tarefa) async {
    return _dbHelper.insertTarefa(tarefa);
  }

  readTarefaByCategoria(int categoriaId) async {
    return _dbHelper.getTarefaByCategoriaId(categoriaId);
  }

  deleteTarefa(int id) async {
    return _dbHelper.deleteTarefa(id);
  }



  Future<int> atualizarStatus(int id, String status) async {
  return await _dbHelper.updateTarefaStatus(id, status);
  }
}