import 'departement.dart';
import 'matiere.dart';

class Classe {
  int nbreEtud;
  String nomClass;
  int ?codClass;
  Departement? departement; // Include departement property

  Classe({
    required this.nbreEtud,
    required this.nomClass,
    this.codClass,
    this.departement, // Initialize departement property
  });

  // Factory method to create a Classe object from JSON
  factory Classe.fromJson(Map<String, dynamic> json) {
    return Classe(
      nbreEtud: json['nbreEtud'],
      nomClass: json['nomClass'],
      codClass: json['codClass'],
    );
  }

  // Add a method to convert the Classe object to JSON
  Map<String, dynamic> toJson() {
    return {
      'nbreEtud': nbreEtud,
      'nomClass': nomClass,
      'codClass': codClass,
    };
  }

  @override
  String toString() {
    return nomClass;
  }
}
