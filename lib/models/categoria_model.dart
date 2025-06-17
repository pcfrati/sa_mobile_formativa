//& categoria model

class Categoria{

  //& atributos
  final int? id;  // nulo pois quem fornece o id é o BD autoincrimental
  final String nome;
  final String objetivo;

  //& métodos -> construtor
  Categoria({
    this.id,
    required this.nome,
    required this.objetivo,
  });

  //Métodos de Conversão de OBJ <=> BD
  //toMap: obj => BD
  Map<String,dynamic> toMap() {
    return{
      "id":id,
      "nome": nome,
      "objetivo": objetivo
    };
  }

  //fromMap: BD => Obj
  factory Categoria.fromMap(Map<String,dynamic> map){
    return Categoria(
      id: map["id"] as int,
      nome: map["nome"] as String, 
      objetivo: map["objetivo"] as String);
  }
}