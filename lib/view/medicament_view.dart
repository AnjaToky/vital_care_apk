import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vital_care/model/medicament_model.dart';
import 'package:vital_care/view_model/medicament_view_model.dart';

class MedicamentView extends ConsumerWidget {
  const MedicamentView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicamentAsync = ref.watch(medicamentViewModelProvider);
    TextEditingController nomMedicamentController = TextEditingController();
    TextEditingController dosageController = TextEditingController();
    TextEditingController frequenceController = TextEditingController();
    TextEditingController heureController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Traitements")),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Ajouter un médicament"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nomMedicamentController,
                      decoration: const InputDecoration(
                        labelText: "Nom du médicament",
                      ),
                    ),
                    TextField(
                      controller: dosageController,
                      decoration: const InputDecoration(labelText: "Dosage"),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                    ),
                    TextField(
                      controller: frequenceController,
                      decoration: const InputDecoration(labelText: "Fréquence"),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: heureController,
                      decoration: const InputDecoration(labelText: "Heure"),
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
                          heureController.text = selectedDateTime
                              .toIso8601String();
                        }
                      },
                    ),
                  ],
                ),

                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Annuler"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final nom = nomMedicamentController.text;
                      final dosageStr = dosageController.text;
                      final frequenceStr = frequenceController.text;
                      final heureStr = heureController.text;

                      // 1. On tente de convertir
                      // 1. On tente de conver
                      // 1. On tente de convertir
                      // 1. On tente de convertirtir proprement les valeurs
                      final double? dosage = double.tryParse(
                        dosageStr.replaceAll(',', '.'),
                      );
                      final int? frequence = int.tryParse(frequenceStr);

                      // Pour l'heure, attention : DateTime.parse attend "2026-03-30 10:00:00"
                      // Si heureStr n'est que "10:00", cela fera planter le programme.
                      // On utilise tryParse pour éviter le crash.
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
                        Navigator.pop(
                          context,
                        ); // Fermer le formulaire après succès
                      } else {
                        // 3. Afficher une erreur si une conversion a échoué
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Format invalide. Vérifiez les nombres et la date.",
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text("Ajouter"),
                  ),
                ],
              );
            },
          );
        },
      ),

      body: medicamentAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text("Error: $error")),

        data: (medicament) => ListView.builder(
          itemCount: medicament.length,
          itemBuilder: (context, index) {
            final m = medicament[index];
            return ListTile(
              title: Text(m.nom),
              subtitle: Text(
                "Dosage: ${m.dosage}, Fréquence: ${m.frequence}, Heure: ${m.heure}",
              ),
            );
          },
        ),
      ),
    );
  }
}
