import 'package:intl/intl.dart';

class Tarefa{
  final int? id; //pode ser nulo
  final int categoriaId; //chave estrangeita
  final DateTime dataHora;
  final String titulo;
  final String descricao;
  final String status;
  final String prioridade;

  Tarefa({
    this.id,
    required this.categoriaId,
    required this.dataHora,
    required this.titulo,
    required this.descricao,
    required this.status,
    required this.prioridade
  });

  // toMap : Obj => BD
  Map<String,dynamic> toMap() => {
    "id":id,
    "categoria_id":categoriaId,
    "data_vencimento": dataHora.toIso8601String(),
    "titulo":titulo,
    "descricao":descricao,
    "status":status,
    "prioridade":prioridade
  };

  //fromMap() : BD => obj
  factory Tarefa.fromMap(Map<String,dynamic> map) => 
    Tarefa(
      id: map["id"] as int,
      categoriaId: map["categoria_id"] as int, 
      dataHora: DateTime.parse(map["data_vencimento"] as String), 
      titulo: map["titulo"] as String, 
      descricao: map["descricao"] as String,
      status: map["status"] as String,
      prioridade: map["prioridade"] as String);

  // método de conversão de DAta e hora para formato BR (intl)
  String get dataHoraLocal {
    final local = DateFormat("dd/MM/yyyy");
    return local.format(dataHora);
  }
}