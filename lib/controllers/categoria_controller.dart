import 'package:sa_mobile_formativa/models/categoria_model.dart';
import 'package:sa_mobile_formativa/services/db_helper.dart';

class CategoriaController {
  final DbHelper _dbHelper = DbHelper();

  Future<int> createCategoria(Categoria categoria) async{
    return await _dbHelper.insertCategoria(categoria);
  }

  Future<List<Categoria>> readCategorias() async{
    return await _dbHelper.getCategorias();
  }

  Future<Categoria?> readCategoriabyId(int id) async{
    return await _dbHelper.getCategoriabyId(id);
  }

  Future<int> deleteCategoria(int id) async{
    return await _dbHelper.deleteCategoria(id);
  }
}