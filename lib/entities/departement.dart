
class Departement {

  int idDep;
  String nomDep;

  Departement({
    required this.idDep,
    required this.nomDep,
  });

  // Factory method to create a Classe object from JSON
  factory Departement.fromJson(Map<String, dynamic> json) {
    return Departement(
      idDep: json['idDep'],
      nomDep: json['nomDep'],

    );
  }

  // Add a method to convert the Classe object to JSON
  Map<String, dynamic> toJson() {
    return {
      'idDep': idDep,
      'nomDep': nomDep,
    };
  }

  @override
  String toString() {
    return nomDep;
  }
}
