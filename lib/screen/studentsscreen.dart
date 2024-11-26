import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';

import '../entities/student.dart';
import '../entities/classe.dart';
import '../template/dialog/studentdialog.dart';

class StudentScreen extends StatefulWidget {
  @override
  _StudentScreenState createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {

  List<Classe> classes = [];
  List<Student> students = [];
  Classe? selectedClass;
  //late final Classe? selectedClasse;

  @override
  void initState() {
    super.initState();
    // Fetch classes when the screen loads
    getAllClasses().then((result) {
      if (result is List<Classe>) {
        setState(() {
          classes = result;
        });
      } else {
        print("Error: getAllClasses did not return a List<Classe>.");
      }
    });
  }

  void refresh() {
    setState(() {});
  }

  Future<void> getStudentsByClass(Classe selectedClass) async {
    Response response = await http.get(
        Uri.parse("http://192.168.56.1:8081/etudiant/getByClasseId/${selectedClass.codClass}"));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      print("JSON data received: $data"); // Add this line for debugging
      List<Student> studentsInClass = data.map((json) => Student.fromJson(json)).toList();
      setState(() {
        students = studentsInClass;
      });
    } else {
      throw Exception("Failed to load students");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Classe et etudiants'),
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
                  // Fetch students when a class is selected
                  if (selectedClass != null) {
                    getStudentsByClass(selectedClass!);
                  }
                });
              },
              items: classes.map((Classe classe) {
                return DropdownMenuItem<Classe>(
                  value: classe,
                  child: Text(classe.nomClass),
                );
              }).toList(),
              decoration: const InputDecoration(labelText: "Select a Class"),
            ),
            SizedBox(height: 16),
            Text(
              'Students in Selected Class:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(students[index].nom),
                    subtitle: Text(students[index].prenom),
                    // You can display other student information here
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
              return AddStudentDialog(
                notifyParent: refresh,
                selectedClasse: selectedClass,
              );
            },
          );
          //print("test");
        },
        child: Icon(Icons.add),
      ),
    );
  }
}



Future<List<Classe>> getAllClasses() async {
  Response response =
  await http.get(Uri.parse("http://192.168.56.1:8081/class/all"));
  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    List<Classe> classes = data.map((json) => Classe.fromJson(json)).toList();
    return classes;
  } else {
    throw Exception("Failed to load classes");
  }
}
