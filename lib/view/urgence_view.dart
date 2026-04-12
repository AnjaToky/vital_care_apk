import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vital_care/view/couleur/couleur.dart';
import 'package:vital_care/view/widget/bottom_nav_bar.dart';
import 'package:vital_care/view/widget/container_result.dart';
import 'package:vital_care/view_model/medicament_view_model.dart';
import 'package:vital_care/view_model/profil_view_model.dart';

class UrgenceView extends ConsumerWidget {
  const UrgenceView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profilAsync = ref.watch(profilViewModelProvider);
    final medicamentAsync = ref.watch(medicamentViewModelProvider);
    BottomNavBar bottomNavBar = BottomNavBar();
    ContainerResult containerResult = ContainerResult();

    return Scaffold(
      backgroundColor: Couleur.backgroundColor,
      appBar: AppBar(
        backgroundColor: Couleur.backgroundColor,
        title: Text("Urgence Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: profilAsync.when(
            data: (profil) {
              return medicamentAsync.when(
                data: (medicament) {
                  final lastMedicament = ref
                      .read(medicamentViewModelProvider.notifier)
                      .getDernierMedic(medicament);
                  final nomProfil = profilAsync.value;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      containerResult.buildInfoCard("Nom", nomProfil!.name),
                      SizedBox(height: 16),
                      containerResult.buildInfoCard("Age", "${nomProfil.age}"),
                      SizedBox(height: 16),

                      containerResult.cardMedicament(
                        lastMedicament.nom,
                        "${lastMedicament.dosage}",
                        "${lastMedicament.frequence}",
                        "${lastMedicament.heure.hour} heur : ${lastMedicament.heure.minute}",
                        Couleur.cardBackgroundColor,
                      ),
                    ],
                  );
                },
                error: (o, s) => Text("erreur"),
                loading: () => Text("Loading"),
              );
            },
            error: (o, s) => Text("erreur"),
            loading: () => Text("Loading"),
          ),
        ),
      ),
      bottomNavigationBar: bottomNavBar.buildBottomNavBar(context, ref),
    );
  }
}
