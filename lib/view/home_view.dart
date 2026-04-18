import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vital_care/model/medicament_model.dart';
import 'package:vital_care/view/couleur/couleur.dart';
import 'package:vital_care/view/widget/app_bar_view.dart';
import 'package:vital_care/view/widget/bottom_nav_bar.dart';
import 'package:vital_care/view/widget/container_result.dart';
import 'package:vital_care/view_model/habitude_view_model.dart';
import 'package:vital_care/view_model/imc_view_model.dart';
import 'package:vital_care/view_model/medicament_view_model.dart';
import 'package:vital_care/view_model/profil_view_model.dart';
import 'package:vital_care/view_model/tension_view_model.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicamentAsync = ref.watch(medicamentViewModelProvider);
    final imcAsync = ref.watch(icmViewModelProvide);
    final tensionAsync = ref.watch(tensionViewModelProvider);
    final habitudeAsync = ref.watch(habitudeViewModelProvider);
    final profilAsync = ref.watch(profilViewModelProvider);

    BottomNavBar bottomNavBar = BottomNavBar();
    AppBarView appBarView = AppBarView();
    ContainerResult containerResult = ContainerResult();

    return Scaffold(
      backgroundColor: Couleur.backgroundColor,
      appBar: appBarView.appBarPage("Home"),
      body: medicamentAsync.when(
        data: (medicament) {
          return imcAsync.when(
            data: (imc) {
              return tensionAsync.when(
                data: (tension) {
                  final habitude = habitudeAsync.value;
                  final profil = profilAsync.value;

                  // Valeurs sécurisées
                  final poidHabitude = habitude?.poidHabitude ?? 0.0;
                  final hydratation = habitude?.hydratation ?? 0.0;
                  final nbrPas = habitude?.nbrPas ?? 0;

                  final hydratationObjectif = ref
                      .read(habitudeViewModelProvider.notifier)
                      .calculeHydratation(poidHabitude);

                  final lastTension = tension.isNotEmpty
                      ? ref
                            .read(tensionViewModelProvider.notifier)
                            .getDernierTension(tension)
                      : null;

                  final lastimc = imc.isNotEmpty
                      ? ref
                            .read(icmViewModelProvide.notifier)
                            .getDernierImc(imc)
                      : null;

                  final nbrMedicament = medicament
                      .where((m) => m.status == MedicamentStatus.enAttente)
                      .length;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),

                        Text(
                          "Bienvenue",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Couleur.textColor,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          profil?.name ?? "Utilisateur",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Couleur.textColor,
                          ),
                        ),

                        const SizedBox(height: 16),

                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Couleur.buttonSecondaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "Prenez soin de votre corps, c'est le seul endroit où vous devez vivre",
                            style: TextStyle(
                              color: Couleur.backgroundColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        //  Suivi
                        containerResult.buildHomeCard(
                          titre: "Votre Suivie",
                          nbrMedicament: nbrMedicament,
                          nbrPas: nbrPas.toDouble(),
                          hydratation: hydratation,
                          hydratationObjetctif: hydratationObjectif,
                        ),

                        const SizedBox(height: 16),

                        containerResult.bouttonValider(
                          () {
                            Navigator.pushNamed(context, '/habitude_view');
                          },
                          Couleur.butttonPrimaryColor,
                          double.infinity,
                          "Prise Quotidien",
                        ),

                        const SizedBox(height: 16),

                        Text(
                          "Dernier prise",
                          style: TextStyle(
                            color: Couleur.textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),

                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            containerResult.buildHomeHabitude(
                              titre: "Tension",
                              value: lastTension == null
                                  ? "0/0"
                                  : "${lastTension.tensionSystolique.toInt()}/${lastTension.tensionDiastolique.toInt()}",
                              cardColor: lastTension == null
                                  ? Couleur.buttonSecondaryColor
                                  : ref
                                        .read(tensionViewModelProvider.notifier)
                                        .couleurTension(
                                          lastTension.tensionSystolique,
                                          lastTension.tensionDiastolique,
                                        ),
                            ),

                            const SizedBox(width: 16),

                            containerResult.buildHomeHabitude(
                              titre: "Pas",
                              value: nbrPas.toString(),
                              cardColor: Couleur.buttonSecondaryColor,
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            containerResult.buildHomeHabitude(
                              titre: "IMC",
                              value:
                                  lastimc?.valuerImc.toInt().toString() ?? "0",
                              cardColor: lastimc == null
                                  ? Couleur.buttonSecondaryColor
                                  : ref
                                        .read(icmViewModelProvide.notifier)
                                        .couleurIMC(lastimc.valuerImc),
                            ),

                            const SizedBox(width: 16),

                            containerResult.buildHomeHabitude(
                              titre: "Hydratation",
                              value: hydratation.toString(),
                              cardColor: ref
                                  .read(habitudeViewModelProvider.notifier)
                                  .hydratationColor(
                                    hydratation,
                                    hydratationObjectif,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Erreur: $err')),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Erreur: $err')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erreur: $err')),
      ),
      bottomNavigationBar: bottomNavBar.buildBottomNavBar(context, ref),
    );
  }
}
