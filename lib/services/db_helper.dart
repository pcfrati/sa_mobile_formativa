import 'package:path/path.dart';
import 'package:sa_mobile_formativa/models/tarefa_model.dart';
import 'package:sa_mobile_formativa/models/categoria_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';




class DbHelper {
  static Database? _database;
  
  static final DbHelper _instance = DbHelper._internal();
  
  DbHelper._internal();
  factory DbHelper() => _instance;

  Future<Database> get database  async{
    if (_database != null){
      return _database!;
    }else{
      _database =  await _initDatabase();
      return _database!;
    }
  }

  Future<Database> _initDatabase() async{
    final dbPath = await getDatabasesPath();
    final path = join(dbPath,"mobileformativa.db");  

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreateDB
    );
  }

  Future<void> _onCreateDB(Database db, int version) async{

    await db.execute(
      """CREATE TABLE IF NOT EXISTS categorias(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      objetivo TEXT NOT NULL
      )"""
    );
    print("tabela categorias criada");

    await db.execute(
      """CREATE TABLE IF NOT EXISTS tarefas(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      categoria_id INTEGER NOT NULL,
      data_vencimento TEXT NOT NULL,
      titulo TEXT NOT NULL,
      descricao TEXT,
      status TEXT NOT NULL,
      prioridade TEXT,
      FOREIGN KEY (categoria_id) REFERENCES categorias(id) ON DELETE CASCADE
      )"""
    );
    print("tabela tarefas criada");
  }

  Future<int> insertCategoria(Categoria categoria) async{
    final db = await database;
    return await db.insert("categorias", categoria.toMap());
  }
  
  Future<List<Categoria>> getCategorias() async{
    final db = await database;
    final List<Map<String,dynamic>> maps = await db.query("categorias");
    return maps.map((e)=>Categoria.fromMap(e)).toList();
  }

  Future<Categoria?> getCategoriabyId(int id) async{
    final db = await database;
    final List<Map<String,dynamic>> maps = 
      await db.query("categorias", where: "id=?", whereArgs: [id]);
    if(maps.isNotEmpty){
      return Categoria.fromMap(maps.first);
    }else{
      return null;
    }
  }

  Future<int> deleteCategoria(int id) async{
    final db = await database;
    return await db.delete("categorias", where: "id=?",whereArgs: [id]);
  }

  





  Future<int> insertTarefa(Tarefa tarefa) async{
    final db = await database;
    return await db.insert("tarefas", tarefa.toMap());
  }

  Future<List<Tarefa>> getTarefaByCategoriaId(int categoriaId) async{
    final db = await database;
    final List<Map<String,dynamic>> maps = await db.query(
      "tarefas",
      where: "categoria_id = ?",
      whereArgs: [categoriaId],
      orderBy: "data_vencimento ASC"
    );

    return maps.map((e)=>Tarefa.fromMap(e)).toList();
  }

  Future<int> deleteTarefa(int id) async{
    final db = await database;
    return await db.delete("tarefas", where: "id=?", whereArgs: [id]);
  }




  Future<int> updateTarefaStatus(int id, String status) async {
    final db = await database;
    return await db.update(
      'tarefas',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}