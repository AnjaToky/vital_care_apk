import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vital_care/model/medicament_model.dart';
import 'package:vital_care/view/couleur/couleur.dart';
import 'package:vital_care/view/widget/app_bar_view.dart';
import 'package:vital_care/view/widget/bottom_nav_bar.dart';
import 'package:vital_care/view/widget/container_result.dart';
import 'package:vital_care/view_model/medicament_view_model.dart';

class MedicamentValiderPage extends ConsumerWidget {
  const MedicamentValiderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(medicamentViewModelProvider);
    AppBarView appBarView = AppBarView();
    ContainerResult containerResult = ContainerResult();
    BottomNavBar bottomNavBar = BottomNavBar();

    return Scaffold(
      backgroundColor: Couleur.backgroundColor,
      appBar: appBarView.appBarPage("Médicaments validés"),
      body: Column(
        children: [
          SizedBox(height: 16),
          appBarView.appBarMadicament(context, 1, Couleur.buttonSecondaryColor),
          data.when(
            data: (list) {
              final valides = list
                  .where((m) => m.status == MedicamentStatus.valider)
                  .toList();
              if (valides.isEmpty) {
                return Center(child: Text("Pas de medicament en valider"));
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: valides.length,
                  itemBuilder: (context, index) {
                    final m = valides[index];
                    return Container(
                      margin: EdgeInsets.all(4),
                      child: containerResult.cardMedicament(
                        m.nom,
                        "${m.dosage} gramme",
                        "${m.frequence} fois par jour ",
                        "${m.heure.hour} h : ${m.heure.minute} ",

                        containerResult.buildIconStatus(
                          icon: "assets/icon/check.svg",
                          iconColor: Couleur.secondaryColor,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
            loading: () => CircularProgressIndicator(),
            error: (e, _) => Text("Erreur"),
          ),
        ],
      ),

      bottomNavigationBar: bottomNavBar.buildBottomNavBar(context, ref),
    );
  }
}
