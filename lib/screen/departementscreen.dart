import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:tp70/entities/departement.dart';
import 'dart:convert';

import '../entities/classe.dart';
import '../service/classeservice.dart';
import '../service/departementservice.dart';
import '../template/dialog/departementdialog.dart';

class DepartementScreen extends StatefulWidget {
  @override
  _DepartementScreenState createState() => _DepartementScreenState();
}

class _DepartementScreenState extends State<DepartementScreen> {
  List<Departement> deps = [];
  List<Classe> classes = [];
  Departement? selectedDep;

  @override
  void initState() {
    super.initState();
    // Fetch classes when the screen loads
    getAllDepartements().then((result) {
      if (result is List<Departement>) {
        setState(() {
          deps = result;
        });
      } else {
        print("Error: getAllDepartements did not return a List<Departement>.");
      }
    });


  }

  void refresh() {
    setState(() {});
  }

  Future<void> getClassesByDep(Departement selectedDep) async {
    Response response = await http.get(
        Uri.parse("http://192.168.56.1:8081/dep/getByIdDepartement/${selectedDep.idDep}"));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      print("JSON data received: $data");
      List<Classe> classesInDep = data.map((json) => Classe.fromJson(json)).toList();
      setState(() {
        classes = classesInDep;
      });
    } else {
      throw Exception("Failed to load classes");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Departement et classes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<Departement>(
              value: selectedDep,
              onChanged: (Departement? value) {
                setState(() {
                  selectedDep = value;
                  // Fetch students when a class is selected
                  if (selectedDep != null) {
                    getClassesByDep(selectedDep!);
                  }
                });
              },
              items: deps.map((Departement dep) {
                return DropdownMenuItem<Departement>(
                  value: dep,
                  child: Text(dep.nomDep),
                );
              }).toList(),
              decoration: const InputDecoration(labelText: "Select a departement"),
            ),
            SizedBox(height: 16),
            Text(
              'Classes in Selected Departement:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: classes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(classes[index].nomClass),
                    subtitle: Text('Number of Students: ${classes[index].nbreEtud}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AddDepartementDialog(
                                  notifyParent: refresh,
                                  selectedDepartement: selectedDep,
                                  classes: classes[index],
                                );
                              },
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await deleteClass(classes[index].codClass!);
                            refresh();
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purpleAccent,
        onPressed: () async {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddDepartementDialog(
                notifyParent: refresh,
                selectedDepartement: selectedDep,
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<List<Departement>> getAllDepartements() async {
    Response response =
    await http.get(Uri.parse("http://192.168.56.1:8081/dep/all"));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Departement> deps = data.map((json) => Departement.fromJson(json)).toList();
      return deps;
    } else {
      throw Exception("Failed to load departements");
    }
  }
}
