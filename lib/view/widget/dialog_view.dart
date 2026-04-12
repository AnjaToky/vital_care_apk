import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vital_care/model/medicament_model.dart';
import 'package:vital_care/view/couleur/couleur.dart';
import 'package:vital_care/view/widget/text_field_view.dart';
import 'package:vital_care/view_model/medicament_view_model.dart';

class DialogView {
  void showDialogMadicaments(BuildContext context, WidgetRef ref) {
    TextEditingController nomMedicamentController = TextEditingController();
    TextEditingController dosageController = TextEditingController();
    TextEditingController frequenceController = TextEditingController();
    TextEditingController heureController = TextEditingController();
    TextFieldView textFieldView = TextFieldView();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Couleur.backgroundColor,
          title: Text(
            "Ajouter un médicament",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Couleur.primaryColor,
            ),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              textFieldView.buildTextField(
                nomMedicamentController,
                "Medicamnt",
              ),

              SizedBox(height: 8),

              textFieldView.buildTextField(
                dosageController,
                'Dosage',
                TextInputType.number,
              ),

              SizedBox(height: 8),

              textFieldView.buildTextField(
                frequenceController,
                'Fréquence',
                TextInputType.number,
              ),

              SizedBox(height: 8),

              TextField(
                controller: heureController,

                decoration: InputDecoration(
                  hintText: "Heur",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Couleur.backgroundColor,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Couleur.primaryColor,
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Couleur.primaryColor,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Couleur.primaryColor,
                      width: 2,
                    ),
                  ),
                ),

                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    final now = DateTime.now();
                    final selectedDateTime = DateTime(
                      now.year,
                      now.month,
                      now.day,
                      pickedTime.hour,
                      pickedTime.minute,
                    );
                    heureController.text = selectedDateTime.toIso8601String();
                  }
                },
              ),
            ],
          ),

          actions: [
            TextButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Couleur.accentColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(8),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Annuler",
                style: TextStyle(color: Couleur.backgroundColor),
              ),
            ),
            TextButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Couleur.secondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(8),
                ),
              ),
              onPressed: () {
                final nom = nomMedicamentController.text;
                final dosageStr = dosageController.text;
                final frequenceStr = frequenceController.text;
                final heureStr = heureController.text;

                final double? dosage = double.tryParse(
                  dosageStr.replaceAll(',', '.'),
                );
                final int? frequence = int.tryParse(frequenceStr);

                // Pour l'heure, attention : DateTime.parse attend "2026-03-30 10:00:00"
                // Si heureStr
                final DateTime? heure = DateTime.tryParse(heureStr);

                // 2. Vérification complète avant d'ajouter
                if (nom.isNotEmpty &&
                    dosage != null &&
                    frequence != null &&
                    heure != null) {
                  ref
                      .read(medicamentViewModelProvider.notifier)
                      .ajouterMedicament(
                        Medicament(
                          nom: nom,
                          dosage: dosage, // Maintenant c'est un double
                          frequence: frequence, // Maintenant c'est un int
                          heure: heure, // Maintenant c'est un DateTime
                        ),
                      );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Couleur.secondaryColor,
                      content: Text(
                        "Medicament ajouter",
                        style: TextStyle(color: Couleur.backgroundColor),
                      ),
                    ),
                  );
                  Navigator.pop(context); // Fermer le formulaire après succès
                } else {
                  // 3. Afficher une erreur si une conversion a échoué
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Couleur.buttonAccentColor,
                      content: Text(
                        "Format invalide. Vérifiez les nombres et la date.",
                        style: TextStyle(color: Couleur.backgroundColor),
                      ),
                    ),
                  );
                }
              },
              child: const Text("Ajouter", style: TextStyle(color: Couleur.backgroundColor),),
            ),
          ],
        );
      },
    );
  }
}
