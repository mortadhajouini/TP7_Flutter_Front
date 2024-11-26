import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';

import '../entities/matiere.dart';
import '../entities/classe.dart';
import '../service/classeservice.dart';
import '../template/dialog/classedialog.dart';
import '../template/dialog/matieredialog.dart';

class MatiereScreen extends StatefulWidget {
  @override
  _MatiereScreenState createState() => _MatiereScreenState();
}

class _MatiereScreenState extends State<MatiereScreen> {
  List<Matiere> matieres = [];
  List<Classe> classes = [];
  Classe? selectedClass;

  @override
  void initState() {
    super.initState();
    // Fetch classes when the screen loads
    getAllClasse().then((result) {
      if (result is List<Classe>) {
        setState(() {
          classes = result;
        });
      } else {
        print("Error: getAllClasse did not return a List<Classe>.");
      }
    });
  }

  void refresh() {
    setState(() {});
  }

  Future<void> getMatieresByClassId(Classe selectedClasse) async {
    Response response = await http.get(
        Uri.parse("http://192.168.56.1:8081/class/getMatieresByClassId/${selectedClasse.codClass}"));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Matiere> matieresInClasse = data.map((json) => Matiere.fromJson(json)).toList();
      setState(() {
        matieres = matieresInClasse;
      });
    } else {
      throw Exception("Failed to load matieres in classe");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Matieres et classes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<Classe>(
              value: selectedClass,
              onChanged: (Classe? value) {
                setState(() {
                  selectedClass = value;
                  if (selectedClass != null) {
                    getMatieresByClassId(selectedClass!);
                  }
                });
              },
              items: classes.map((Classe classe) {
                return DropdownMenuItem<Classe>(
                  value: classe,
                  child: Text(classe.nomClass),
                );
              }).toList(),
              decoration: const InputDecoration(labelText: "Sélectionner une classe"),
            ),
            SizedBox(height: 16),
            Text(
              'Matieres avec cette classe:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: matieres.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(matieres[index].nomMatiere),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:
          FloatingActionButton(
            backgroundColor: Colors.purpleAccent,
            onPressed: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ClassDialog(
                    notifyParent: refresh,
                    onClassSelected: (selectedClass, selectedMatiere) {
                      // Implement your logic to add matiere to the selected class

                    },
                    classe: null,
                  );
                },
              );
            },
            child: Icon(Icons.add),
          ),
    );
  }
}

Future<List<Classe>> getAllClasse() async {
  try {
    Response response = await http.get(Uri.parse("http://192.168.56.1:8081/class/all"));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Classe> classes = data.map((json) => Classe.fromJson(json)).toList();
      return classes;
    } else {
      print("Failed to load classes. Status code: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception("Failed to load classes. Status code: ${response.statusCode}");
    }
  } catch (e) {
    print("Error during the request: $e");
    throw Exception("Error during the request: $e");
  }
}
