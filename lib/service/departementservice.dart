import 'dart:convert';

import 'package:http/http.dart' as http ;
import 'package:http/http.dart';

import 'package:tp70/entities/Student.dart';
import 'package:tp70/entities/classe.dart';
import 'package:tp70/entities/departement.dart';
import 'package:tp70/entities/student.dart';

Future getAllDepartements() async{

  Response response =await  http.get(Uri.parse("http://192.168.56.1:8081/dep/all"));
  return jsonDecode(response.body);

}

Future deleteDepartement(int id){
  return http.delete(Uri.parse("http://192.168.56.1:8081/dep/delete?id=${id}"));
}


Future addDepartement(Departement dep)async
{

  Response response = await http.post(Uri.parse("http://192.168.56.1:8081/dep/add"),
      headers:{
        "Content-type":"Application/json"
      },body:jsonEncode(<String,dynamic>{
        "nomDep":dep.nomDep,
      }
      ));

  return response.body;
}

Future updateDepartement(Departement dep)async
{

  Response response = await http.put(Uri.parse("http://192.168.56.1:8081/dep/update"),
      headers:{
        "Content-type":"Application/json"
      },body:jsonEncode(<String,dynamic>{
        "idDep":dep.idDep,
        "nomDep":dep.nomDep,
      }
      ));

  return response.body;
}

Future<List<Departement>> getClassesByDepartementQuery(int id) async {
  Response response = await http.get(
    Uri.parse("http://192.168.56.1:8081/dep/getByIdDepartement"),
  );

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);

    // Assuming data is a list of students
    List<Departement> deps =
    data.map((json) => Departement.fromJson(json)).toList();

    return deps;
  } else {
    throw Exception("Failed to load classes by departement using query");
  }
}