import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:tp70/entities/student.dart';
import 'package:tp70/service/studentservice.dart';

import '../../entities/classe.dart';
import '../../entities/matiere.dart';
import '../../screen/matieresscreen.dart';
import '../../service/classeservice.dart';
import 'package:http/http.dart' as http ;


class AddMatiereDialog extends StatefulWidget {
  final Function()? notifyParent;

  const AddMatiereDialog({super.key, @required this.notifyParent, Matiere? selectedClasse});

  @override
  State<AddMatiereDialog> createState() => _AddClassDialogState();
}

class _AddClassDialogState extends State<AddMatiereDialog> {
  TextEditingController nomCtrl = TextEditingController();
  TextEditingController nbrEtudCtrl = TextEditingController();
  Matiere? selectedMatiere;
  List<Matiere> matieres = [];

  @override
  void initState() {
    super.initState();

    // Fetch matieres and set default selected value
    getAllMatieres().then((result) {
      if (result is List<Matiere>) {
        setState(() {
          matieres = result;

          // Set initial value for selectedMatiere
          selectedMatiere = matieres.isNotEmpty ? matieres[0] : null;
        });
      } else {
        print("Error: getAllMatieres did not return a List<Matiere>.");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text("Ajouter Classe"),
            TextFormField(
              controller: nomCtrl,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "Champ obligatoire";
                }
                return null;
              },
              decoration: const InputDecoration(labelText: "Nom Classe"),
            ),
            TextFormField(
              controller: nbrEtudCtrl,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "Champ obligatoire";
                }
                return null;
              },
              decoration: const InputDecoration(labelText: "Nombre d'Etudiants"),
            ),
            ElevatedButton(
              onPressed: () async {
                await addClass(Classe(
                  nbreEtud: int.parse(nbrEtudCtrl.text),
                  nomClass: nomCtrl.text,
                ));
                widget.notifyParent!();
                Navigator.pop(context);
              },
              child: const Text("Ajouter"),
            ),
          ],
        ),
      ),
    );
  }
}

Future<List<Matiere>> getAllMatieres() async {
  try {
    http.Response response =
    await http.get(Uri.parse("http://10.0.2.2:8081/matiere/all"));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Matiere> matieres =
      data.map((json) => Matiere.fromJson(json)).toList();
      return matieres;
    } else {
      print("Failed to load matieres. Status code: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception(
          "Failed to load matieres. Status code: ${response.statusCode}");
    }
  } catch (e) {
    print("Error during the request: $e");
    throw Exception("Error during the request: $e");
  }
}

Future<void> addClass(Classe classe) async {
  try {
    await http.post(
      Uri.parse("http://10.0.2.2:8081/class/add"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(classe.toJson()),
    );
  } catch (e) {
    print("Error during the request: $e");
    throw Exception("Error during the request: $e");
  }
}

