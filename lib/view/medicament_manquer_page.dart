import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vital_care/model/medicament_model.dart';
import 'package:vital_care/view/couleur/couleur.dart';
import 'package:vital_care/view/widget/app_bar_view.dart';
import 'package:vital_care/view/widget/bottom_nav_bar.dart';
import 'package:vital_care/view/widget/container_result.dart';
import 'package:vital_care/view_model/medicament_view_model.dart';

class MedicamentManquerPage extends ConsumerWidget {
  const MedicamentManquerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(medicamentViewModelProvider);
    ContainerResult containerResult = ContainerResult();
    BottomNavBar bottomNavBar = BottomNavBar();
    AppBarView appBarView = AppBarView();

    return Scaffold(
      backgroundColor: Couleur.backgroundColor,
      appBar: appBarView.appBarPage("Médicaments manqués"),
      body: Column(
        children: [
          SizedBox(height: 16),
          appBarView.appBarMadicament(context, 2, Couleur.accentColor),
          data.when(
            data: (list) {
              final manques = list
                  .where((m) => m.status == MedicamentStatus.manquer)
                  .toList();

              if (manques.isEmpty) {
                return Center(child: Text("Pas de medicament en manquer"));
              }


              return Expanded(
                child: ListView.builder(
                  itemCount: manques.length,
                  itemBuilder: (context, index) {
                    final m = manques[index];
                    return Container(
                      margin: EdgeInsets.all(4),
                      child: containerResult.cardMedicament(
                        m.nom,
                        "${m.dosage} gramme",
                        "${m.frequence} fois par jour ",
                        "${m.heure.hour} h : ${m.heure.minute} ",
                        containerResult.buildIconStatus(
                          icon: "assets/icon/close.svg",
                          iconColor: Couleur.buttonAccentColor,
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
