import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vital_care/model/medicament_model.dart';
import 'package:vital_care/view/couleur/couleur.dart';
import 'package:vital_care/view/widget/app_bar_view.dart';
import 'package:vital_care/view/widget/bottom_nav_bar.dart';
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
    BottomNavBar bottomNavBar = BottomNavBar();
    AppBarView appBarView = AppBarView();

    return Scaffold(
      backgroundColor: Couleur.backgroundColor,
      appBar: appBarView.appBarPage("Traitement"),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Couleur.backgroundColor,
        child: const Icon(Icons.add, color: Couleur.cardBackgroundColor),
        onPressed: () {
          dialogView.showDialogMadicaments(context, ref);
        },
      ),

      body: Column(
        children: [
          SizedBox(height: 16,),
          appBarView.appBarMadicament(context, 0, Couleur.cardBackgroundColor),
          medicamentAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text("Error: $error")),
            data: (medicament) {
              ref
                  .read(medicamentViewModelProvider.notifier)
                  .verifierMedicamentsManques(medicament);

              final enAttente = medicament
                  .where((m) => m.status == MedicamentStatus.enAttente)
                  .toList();

              return Expanded(
                child: ListView.builder(
                  itemCount: enAttente.length,
                  itemBuilder: (context, index) {
                    final m = enAttente[index];

                    Color cardColor;
                    switch (m.status) {
                      case MedicamentStatus.valider:
                        cardColor = Couleur.secondaryColor;
                        break;
                      case MedicamentStatus.manquer:
                        cardColor = Couleur.accentColor;
                        break;
                      default:
                        cardColor = Couleur.primaryColor;
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            containerResult.cardMedicament(
                              m.nom,
                              "${m.dosage} gramme",
                              "${m.frequence} fois par jour ",
                              "${m.heure.hour} h : ${m.heure.minute} ",
                              Couleur.cardBackgroundColor,
                            ),

                            containerResult.bouttonValider(
                              () {
                                ref
                                    .read(medicamentViewModelProvider.notifier)
                                    .validerMedicament(m);
                              },
                              Couleur.buttonSecondaryColor,
                              300,
                              "Valider",
                            ),
                            SizedBox(height: 16),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),

      bottomNavigationBar: bottomNavBar.buildBottomNavBar(context, ref),
    );
  }
}
