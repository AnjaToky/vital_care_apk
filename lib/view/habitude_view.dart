import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vital_care/view/couleur/couleur.dart';
import 'package:vital_care/view/widget/app_bar_view.dart';
import 'package:vital_care/view/widget/bottom_nav_bar.dart';
import 'package:vital_care/view/widget/bottom_sheet_habitude.dart';
import 'package:vital_care/view/widget/container_result.dart';
import 'package:vital_care/view_model/habitude_view_model.dart';
import 'package:vital_care/view_model/imc_view_model.dart';
import 'package:vital_care/view_model/profil_view_model.dart';
import 'package:vital_care/view_model/tension_view_model.dart';

class HabitudeView extends ConsumerWidget {
  const HabitudeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitudeAsync = ref.watch(habitudeViewModelProvider);
    final profilAsync = ref.watch(profilViewModelProvider);
    final imcAsync = ref.watch(icmViewModelProvide);
    BottomNavBar bottomNavBar = BottomNavBar();
    ContainerResult containerResult = ContainerResult();
    AppBarView appBarView = AppBarView();
    return Scaffold(
      appBar: appBarView.appBarPage("Prise quotidienne"),
      backgroundColor: Couleur.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: habitudeAsync.when(
                data: (habitude) {
                  if (habitude == null) {
                    return const Center(
                      child: Text('Aucune donnée d\'habitude'),
                    );
                  }

                  return imcAsync.when(
                    data: (imc) {
                      final lastImc = ref
                          .read(icmViewModelProvide.notifier)
                          .getDernierImc(imc);

                      final poidHabitude = habitude.poidHabitude;
                      final hydratationObjetctif = ref
                          .read(habitudeViewModelProvider.notifier)
                          .calculeHydratation(poidHabitude);

                      return profilAsync.when(
                        data: (profil) {
                          return SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),

                                // Date
                                Text(
                                  '|${DateFormat('dd MMMM yyyy, HH:mm').format(habitude.createdAt)}',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    color: Couleur.textColor,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Container(
                                  height: 1,
                                  width: double.infinity,
                                  color: Couleur.textColor,
                                ),

                                SizedBox(height: 16),
                                containerResult.buildHabitudeCard(
                                  label: "Poid",
                                  value: habitude.poidHabitude.toString(),
                                  iconHabitude: "assets/icon/poid.svg",
                                  widgetColor: SizedBox(height: 0),
                                ),

                                const SizedBox(height: 16),

                                containerResult.buildHabitudeCard(
                                  label: "Hydratation (ml)",
                                  value: habitude.hydratation.toString(),
                                  iconHabitude: "assets/icon/hydratation.svg",
                                  widgetColor: containerResult.buildProgressing(
                                    valueActuelle: habitude.hydratation,
                                    valueObjectif: hydratationObjetctif,
                                    indicatorColor: ref
                                        .read(
                                          habitudeViewModelProvider.notifier,
                                        )
                                        .hydratationColor(
                                          habitude.hydratation,
                                          hydratationObjetctif,
                                        ),
                                    interpretation: ref
                                        .read(
                                          habitudeViewModelProvider.notifier,
                                        )
                                        .hydratationInterpretation(
                                          habitude.hydratation,
                                          hydratationObjetctif,
                                        ),
                                  ),
                                ),

                                const SizedBox(height: 12),
                                containerResult.buildHabitudeCard(
                                  label: "Pas",
                                  value: habitude.nbrPas.toString(),
                                  iconHabitude: "assets/icon/pas.svg",
                                  widgetColor: containerResult.buildProgressing(
                                    valueActuelle: habitude.nbrPas.toDouble(),
                                    valueObjectif: 5000,
                                    indicatorColor:
                                        Couleur.buttonSecondaryColor,
                                    interpretation: "Milay",
                                  ),
                                ),

                                const SizedBox(height: 12),
                                containerResult.buildHabitudeCard(
                                  label: "IMC",
                                  value: lastImc != null
                                      ? "${lastImc.valuerImc.toInt()}"
                                      : "0 0",
                                  iconHabitude: "assets/icon/imc.svg",
                                  widgetColor: containerResult.buildImcCard(
                                    containerColor: ref
                                        .read(icmViewModelProvide.notifier)
                                        .couleurIMC(lastImc?.valuerImc ?? 0),
                                    interpretation: ref
                                        .read(icmViewModelProvide.notifier)
                                        .interpreterIMC(
                                          lastImc?.valuerImc ?? 0,
                                        ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                containerResult.buildHabitudeCard(
                                  label: "Tension",
                                  value:
                                      '${habitude.tensionSystolique.toInt()}/${habitude.tenstionDiastolique.toInt()}',
                                  iconHabitude: "assets/icon/tension.svg",
                                  widgetColor: containerResult.buildImcCard(
                                    containerColor: ref
                                        .read(tensionViewModelProvider.notifier)
                                        .couleurTension(
                                          habitude.tensionSystolique,
                                          habitude.tenstionDiastolique,
                                        ),
                                    interpretation: ref
                                        .read(tensionViewModelProvider.notifier)
                                        .interpreterTension(
                                          habitude.tensionSystolique,
                                          habitude.tenstionDiastolique,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (err, stack) =>
                            Center(child: Text('Erreur profil: $err')),
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Center(child: Text('Erreur: $err')),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Erreur: $err')),
              ),
            ),

            // Bottom Navigation Bar
          ],
        ),
      ),
      bottomNavigationBar: bottomNavBar.buildBottomNavBar(context, ref),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Couleur.backgroundColor,
        onPressed: () {
          BottomSheetHabitude bottomSheetHabitude = BottomSheetHabitude();
          bottomSheetHabitude.showBottomSheetDialog(context, ref);
        },
        child: Icon(Icons.add, color: Couleur.butttonPrimaryColor),
      ),
    );
  }
}
