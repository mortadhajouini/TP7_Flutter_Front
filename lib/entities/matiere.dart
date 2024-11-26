
class Matiere {
  int nbreHeure;
  String nomMatiere;
  int? idMatiere;



  Matiere(this.nbreHeure, this.nomMatiere, [this.idMatiere]);

  // Factory method to create a Classe object from JSON
  factory Matiere.fromJson(Map<String, dynamic> json) {
    return Matiere(
      json['nbreHeure'],
      json['nomMatiere'],
      json['idMatiere'],
    );
  }

  // Add a method to convert the Classe object to JSON
  Map<String, dynamic> toJson() {
    return {
      'nbreHeure': nbreHeure,
      'nomMatiere': nomMatiere,
      'idMatiere': idMatiere,
    };
  }

  @override
  String toString() {
    return nomMatiere;
  }
}
