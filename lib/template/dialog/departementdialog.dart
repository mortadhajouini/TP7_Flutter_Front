import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:tp70/entities/departement.dart';
import 'package:tp70/entities/student.dart';
import 'package:tp70/service/studentservice.dart';

import '../../entities/classe.dart';
import '../../service/classeservice.dart';
import 'package:http/http.dart' as http ;


class AddDepartementDialog extends StatefulWidget {
  final Function()? notifyParent;
  Classe? classes;

  Departement? selectedDepartement;
  AddDepartementDialog({super.key, @required this.notifyParent, this.classes, required this.selectedDepartement});
  @override
  State<AddDepartementDialog> createState() => _AddDepartementDialogState();
}

class _AddDepartementDialogState extends State<AddDepartementDialog> {
  TextEditingController nomDep = TextEditingController();
  TextEditingController nbrEtudCtrl = TextEditingController();

  String title = "Ajouter Departement";
  bool modif = false;
  late int idClasse;
  Departement? selectedDep;
  List<Departement> deps = [];




  @override
  void initState() {
    super.initState();

    // Use await to wait for the completion of the Future
    getAllDepartement().then((result) {
      // Check if the result is a List<Classe> before assigning
      if (result is List<Departement>) {
        setState(() {
          deps = result;

          // Set initial value for selectedClass
          selectedDep = deps.isNotEmpty ? deps[0] : null;
        });
      } else {
        // Handle the case where the result is not a List<Classe>
        print("Error: getAllClasses did not return a List<Classe>.");
      }
    });

    if (widget.classes != null) {
      modif = true;
      title = "Modifier Classe";
      nomDep.text = widget.classes!.nomClass;
      nbrEtudCtrl.text = widget.classes!.nbreEtud.toString();
      selectedDep = widget.classes!.departement;
    }
  }



  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text(title),
            TextFormField(
              controller: nomDep,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "Champs est obligatoire";
                }
                return null;
              },
              decoration: const InputDecoration(labelText: "Nom"),
            ),


            DropdownButtonFormField<Departement>(
              value: selectedDep,
              onChanged: (Departement? value) {
                setState(() {
                  selectedDep = value;
                });
              },

              items: deps.map((Departement dep) {
                return DropdownMenuItem<Departement>(
                  value: dep,
                  child: Text(dep.nomDep),
                );
              }).toList(),
              decoration: const InputDecoration(labelText: "Departement"),
            ),
            TextFormField(
              controller: nbrEtudCtrl,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return "Champs est obligatoire";
                }
                return null;
              },
              decoration: const InputDecoration(labelText: "Nbr etudiant"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (modif == false) {
                  await addClass(Classe(
                    nbreEtud:int.parse(nbrEtudCtrl.text),
                    departement: selectedDep,
                    nomClass: nomDep.text,
                  ));
                  widget.notifyParent!();
                } else {
                  await updateClasse(Classe(
                    codClass: widget.classes!.codClass,
                    nbreEtud:int.parse(nbrEtudCtrl.text),
                    departement: selectedDep,
                    nomClass: nomDep.text,
                  ));
                  widget.notifyParent!();
                }
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

Future<List<Departement>> getAllDepartement() async {
  Response response = await http.get(Uri.parse("http://10.0.2.2:8081/dep/all"));

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);

    // Assuming data is a list of classes
    List<Departement> deps = data.map((json) => Departement.fromJson(json)).toList();

    return deps;
  } else {
    // If the request was not successful, throw an exception or handle the error.
    throw Exception("Failed to load classes");
  }
}

