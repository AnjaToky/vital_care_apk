import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vital_care/view/couleur/couleur.dart';
import 'package:vital_care/view/widget/container_result.dart';
import 'package:vital_care/view/widget/dialog_view.dart';
import 'package:vital_care/view_model/medicament_view_model.dart';

class MedicamentView extends ConsumerWidget {
  const MedicamentView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicamentAsync = ref.watch(medicamentViewModelProvider);
    ContainerResult containerResult = ContainerResult();
    DialogView dialogView = DialogView();

    return Scaffold(
      backgroundColor: Couleur.backgroundColor,
      appBar: AppBar(
        title: const Text("Traitements"),
        actions: [
          ElevatedButton(
            style: ButtonStyle(elevation: WidgetStatePropertyAll(0)),
            onPressed: () {},
            child: Text("Valider"),
          ),
          SizedBox(width: 5),
          ElevatedButton(onPressed: () {}, child: Text("Manquer")),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          dialogView.showDialogMadicaments(context, ref);
        },
      ),

      body: medicamentAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text("Error: $error")),
        data: (medicament) => ListView.builder(
          itemCount: medicament.length,
          itemBuilder: (context, index) {
            final m = medicament[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: containerResult.cardMedicament(
                m.nom,
                "${m.heure.hour} h : ${m.heure.minute} min",
                "${m.dosage} gramme",
                "${m.frequence} fois par jour"
              )
            );
          },
        ),
      ),
    );
  }
}