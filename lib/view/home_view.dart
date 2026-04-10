import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vital_care/view/couleur/couleur.dart';
import 'package:vital_care/view/widget/bottom_nav_bar.dart';
import 'package:vital_care/view/widget/container_result.dart';
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

    BottomNavBar bottomNavBar = BottomNavBar();
    ContainerResult containerResult = ContainerResult();
    return Scaffold(
      backgroundColor: Couleur.backgroundColor,
      appBar: AppBar(
        backgroundColor: Couleur.backgroundColor,
        title: Text("Home Page"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/habitude_view');
            },
            icon: Icon(Icons.accessibility_rounded),
          ),
        ],
      ),
      body: medicamentAsync.when(
        data: (medicament) {
          return imcAsync.when(
            data: (imc) {
              return tensionAsync.when(
                data: (tension) {
                  final lastTension = ref
                      .read(tensionViewModelProvider.notifier)
                      .getDernierTension(tension);
                  final lastMedicament = ref
                      .read(medicamentViewModelProvider.notifier)
                      .getDernierMedic(medicament);
                  final lastimc = ref
                      .read(icmViewModelProvide.notifier)
                      .getDernierImc(imc);

                  final getImage = ref.read(profilViewModelProvider);
                  final profil = getImage.value;

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.grey[300],
                              backgroundImage: profil!.image != null
                                  ? FileImage(File(profil.image!))
                                  : null,
                              child: profil.image == null
                                  ? const Icon(
                                      Icons.person,
                                      size: 40,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 16),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profil.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${profil.name.toLowerCase()}@email.com',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Container(
                          height: 2,
                          width: double.infinity,
                          color: Couleur.butttonPrimaryColor,
                        ),
                        Column(
                          children: [
                            containerResult.cardMedicament(
                              lastMedicament!.nom,
                              "${lastMedicament.dosage} gramme",
                              "${lastMedicament.frequence} fois par jour ",
                              "${lastMedicament.heure.hour} h : ${lastMedicament.heure.minute} ",
                              Couleur.cardBackgroundColor,
                            ),

                            containerResult.bouttonValider(() {
                              ref
                                  .read(medicamentViewModelProvider.notifier)
                                  .validerMedicament(lastMedicament);
                            }),
                            SizedBox(height: 8),
                          ],
                        ),

                        SizedBox(height: 16),
                        containerResult.buildHabitudeCard(
                          label: "Tension",
                          value:
                              "${lastTension!.tensionSystolique.toInt()}/${lastTension.tensionDiastolique.toInt()}",
                          heure:
                              "${lastTension.createdAt.hour} heur : ${lastTension.createdAt.minute}",
                          icon: Icons.monitor_heart_outlined,
                        ),

                        SizedBox(height: 16),

                        containerResult.buildHabitudeCard(
                          label: "Tension",
                          value: "${lastimc!.valuerImc.toInt()}",
                          heure:
                              "${lastimc.createdAt.hour} heur : ${lastimc.createdAt.minute} minute",
                          icon: Icons.monitor_heart_outlined,
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) =>
                    Center(child: Text('Erreur profil: $err')),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Erreur profil: $err')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erreur profil: $err')),
      ),
      bottomNavigationBar: bottomNavBar.buildBottomNavBar(context, ref),
    );
  }
}
