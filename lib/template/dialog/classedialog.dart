import 'package:flutter/material.dart';
import 'package:tp70/entities/classe.dart';
import 'package:tp70/entities/matiere.dart';
import 'package:tp70/service/classeservice.dart';
import 'package:tp70/service/matiereservice.dart';

class ClassDialog extends StatefulWidget {
  final Function()? notifyParent;
  final Function(Classe selectedClass, Matiere selectedMatiere) onClassSelected;
  final Classe? classe;

  ClassDialog({Key? key, required this.notifyParent, required this.onClassSelected, required this.classe})
      : super(key: key);

  @override
  _ClassDialogState createState() => _ClassDialogState();
}

class _ClassDialogState extends State<ClassDialog> {
  TextEditingController nomCtrl = TextEditingController();
  TextEditingController nbrCtrl = TextEditingController();
  Classe? selectedClass;
  Matiere? selectedMatiere;
  List<Classe> classes = [];
  List<Matiere> matieres = [];

  String title = "Ajouter Classe";
  bool modif = false;
  late int idClasse;

  @override
  void initState() {
    super.initState();
    if (widget.classe != null) {
      modif = true;
      title = "Modifier Classe";
      nomCtrl.text = widget.classe!.nomClass;
      nbrCtrl.text = widget.classe!.nbreEtud.toString();
      idClasse = widget.classe!.codClass!;
    }
    // Load the list of classes when the widget initializes
    getAllClasses().then((result) {
      if (result is List<Classe>) {
        setState(() {
          classes = result;
        });
      } else {
        print("Error: getAllClasses did not return a List<Classe>.");
      }
    });
    // Load the list of matieres when the widget initializes
    getAllMatieres().then((result) {
      if (result is List<Matiere>) {
        setState(() {
          matieres = result;
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
            Text(title),

            DropdownButtonFormField<Classe>(
              value: selectedClass,
              onChanged: (Classe? value) {
                setState(() {
                  selectedClass = value;
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
            DropdownButtonFormField<Matiere>(
              value: selectedMatiere,
              onChanged: (Matiere? value) {
                setState(() {
                  selectedMatiere = value;
                });
              },
              items: matieres.map((Matiere matiere) {
                return DropdownMenuItem<Matiere>(
                  value: matiere,
                  child: Text(matiere.nomMatiere),
                );
              }).toList(),
              decoration: const InputDecoration(labelText: "Sélectionner une matière"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (modif == false) {
                  // Use addMatiereToClasse instead of addClass
                  await addMatiereToClasse(selectedClass!.codClass!, selectedMatiere!.idMatiere!);
                  widget.notifyParent!();
                } else {
                  await updateClasse(Classe(
                    nbreEtud: int.parse(nbrCtrl.text),
                    nomClass: nomCtrl.text,
                    codClass: idClasse,
                  ));
                  widget.notifyParent!();
                }

                // If onClassSelected is not null, call it with the selected class and matiere
                if (widget.onClassSelected != null) {
                  // Create a Classe object with the updated data
                  Classe selectedClass = Classe(
                    nbreEtud: int.parse(nbrCtrl.text),
                    nomClass: nomCtrl.text,
                    codClass: idClasse,
                  );
                  widget.onClassSelected(selectedClass, selectedMatiere!);
                }

                Navigator.pop(context);
              },
              child: const Text("Ajouter"),
            )

          ],
        ),
      ),
    );
  }
}



