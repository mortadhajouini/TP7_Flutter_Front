import 'dart:convert';

import 'package:http/http.dart' as http ;
import 'package:http/http.dart';

import 'package:tp70/entities/Student.dart';
import 'package:tp70/entities/classe.dart';
import 'package:tp70/entities/student.dart';

import '../entities/matiere.dart';

Future<List<Classe>> getAllClasses() async {
  try {
    Response response = await http.get(Uri.parse("http://192.168.56.1:8081/class/all"));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Classe> classes = data.map((json) => Classe.fromJson(json)).toList();
      return classes;
    } else {
      throw Exception("Failed to load classes. Status code: ${response.statusCode}");
    }
  } catch (e) {
    print("Error during the request: $e");
    throw Exception("Error during the request: $e");
  }
}

Future deleteClass(int id){
  return http.delete(Uri.parse("http://192.168.56.1:8081/class/delete?id=${id}"));
}


Future addClass(Classe classe)async
{

  Response response = await http.post(
    Uri.parse("http://192.168.56.1:8081/class/add"),
    headers: {
      "Content-type": "Application/json",
    },
    body: jsonEncode(<String, dynamic>{
      "nomClass": classe.nomClass,
      "nbreEtud": classe.nbreEtud,
      "departement": {
        "idDep": classe.departement?.idDep,
        "nomDep": classe.departement?.nomDep,
      },
    }),
  );

  return response.body;
}

Future updateClasse(Classe classe)async
{

  Response response = await http.put(
    Uri.parse("http://192.168.56.1:8081/class/update"),
    headers: {
      "Content-type": "Application/json",
    },
    body: jsonEncode(<String, dynamic>{
      "codClass": classe.codClass,
      "nomClass": classe.nomClass,
      "nbreEtud": classe.nbreEtud,
      "departement": {
        "idDep": classe.departement?.idDep,
        "nomDep": classe.departement?.nomDep,
      },
    }),
  );

  return response.body;
}

Future<List<Classe>> getClassesByMatiereQuery(int id) async {
  Response response = await http.get(
    Uri.parse("http://192.168.56.1:8081/classe/getByMatiereId"),
  );

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);

    // Assuming data is a list of students
    List<Classe> classes =
    data.map((json) => Classe.fromJson(json)).toList();

    return classes;
  } else {
    throw Exception("Failed to load classes by matiere using query");
  }
}



Future addMatiereToClasse(int classeId, int matiereId) async {
  try {
    Response response = await http.post(
      Uri.parse("http://192.168.56.1:8081/class/addMatiereToClasse"),
      headers: {
        "Content-type": "Application/x-www-form-urlencoded",
      },
      body: {
        "classeId": classeId.toString(),
        "matiereId": matiereId.toString(),
      },
    );

    return jsonDecode(response.body);
  } catch (e) {
    throw Exception("Failed to add matiere to classe: $e");
  }
}


Future<List<Matiere>> getMatieresByClassId(int classId) async {
  try {
    Response response = await http.get(
      Uri.parse("http://192.168.56.1:8081/class/getMatieresByClassId/$classId"),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Matiere> matieres = data.map((json) => Matiere.fromJson(json)).toList();
      return matieres;
    } else {
      throw Exception("Failed to load matieres for class");
    }
  } catch (e) {
    throw Exception("Failed to get matieres by class ID: $e");
  }
}
