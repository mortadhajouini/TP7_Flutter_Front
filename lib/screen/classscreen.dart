import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tp70/service/classeservice.dart';
import 'package:tp70/template/dialog/classedialog.dart';
import 'package:tp70/template/navbar.dart';

import '../entities/classe.dart';
import '../template/dialog/matieredialog.dart';
class ClasseScreen extends StatefulWidget {
  @override
  _ClasseScreenState createState() => _ClasseScreenState();
}

class _ClasseScreenState extends State<ClasseScreen> {
  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar('classes'),
      body: FutureBuilder<List<Classe>>(
        future: getAllClasses(),
        builder: (BuildContext context, AsyncSnapshot<List<Classe>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final classes = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: classes.length,
              itemBuilder: (BuildContext context, int index) {
                final classe = classes[index];
                return Slidable(
                  key: Key(classe.codClass.toString()),
                  startActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ClassDialog(
                                notifyParent: refresh,
                                onClassSelected: (selectedClass, selectedMatiere) {
                                  if (selectedClass != null) {
                                    addMatiereToClasse(selectedClass.codClass ?? 0, 0);
                                    refresh();
                                  }
                                },
                                classe: null,
                              );
                            },
                          );
                        },
                        backgroundColor: Color(0xFF21B7CA),
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Edit',
                      ),
                    ],
                  ),
                  endActionPane: ActionPane(
                    motion: ScrollMotion(),
                    dismissible: DismissiblePane(onDismissed: () async {
                      await deleteClass(classe.codClass ?? 0);
                      setState(() {
                        classes.removeAt(index);
                      });
                    }),
                    children: [Container()],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text("Classe: "),
                                Text(
                                  classe.nomClass,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 2.0),
                              ],
                            ),
                            Text("Nombre etudiants: ${classe.nbreEtud}"),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(child: Text("No data available"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purpleAccent,
        onPressed: () async {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddMatiereDialog(
                notifyParent: refresh,
                selectedClasse: null,
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),

    );
  }
}
