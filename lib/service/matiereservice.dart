import 'dart:convert';

import 'package:http/http.dart' as http ;
import 'package:http/http.dart';

import 'package:tp70/entities/Student.dart';
import 'package:tp70/entities/matiere.dart';
import 'package:tp70/entities/student.dart';

Future<List<Matiere>> getAllMatieres() async {
  try {
    Response response = await http.get(Uri.parse("http://192.168.56.1:8081/matiere/all"));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Matiere> matieres = data.map((json) => Matiere.fromJson(json)).toList();
      return matieres;
    } else {
      throw Exception("Failed to load matieres. Status code: ${response.statusCode}");
    }
  } catch (e) {
    print("Error during the request: $e");
    throw Exception("Error during the request: $e");
  }
}

Future deleteMatiere(int id){
  return http.delete(Uri.parse("http://192.168.56.1:8081/matiere/delete?id=${id}"));
}


Future addMatiere(Matiere matiere)async
{

  Response response = await http.post(Uri.parse("http://192.168.56.1:8081/matiere/add"),
      headers:{
        "Content-type":"Application/json"
      },body:jsonEncode(<String,dynamic>{
        "nomMatiere":matiere.nomMatiere,
        "nbreHeure":matiere.nbreHeure
      }
      ));

  return response.body;
}

Future updateMatiere(Matiere matiere)async
{

  Response response = await http.put(Uri.parse("http://192.168.56.1:8081/matiere/update"),
      headers:{
        "Content-type":"Application/json"
      },body:jsonEncode(<String,dynamic>{
        "idMatiere":matiere.idMatiere,
        "nomMatiere":matiere.nomMatiere,
        "nbreHeure":matiere.nbreHeure
      }
      ));

  return response.body;
}