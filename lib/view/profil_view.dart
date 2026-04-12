import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vital_care/view/couleur/couleur.dart';
import 'package:vital_care/view/widget/app_bar_view.dart';
import 'package:vital_care/view/widget/bottom_nav_bar.dart';
import 'package:vital_care/view/widget/container_result.dart';
import 'dart:io';

import 'package:vital_care/view_model/profil_view_model.dart';

class ProfilView extends ConsumerWidget {
  const ProfilView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profilAsync = ref.watch(profilViewModelProvider);
    BottomNavBar bottomNavBar = BottomNavBar();
    ContainerResult containerResult = ContainerResult();
    AppBarView appBarView = AppBarView();

    return Scaffold(
      backgroundColor: Couleur.backgroundColor,
      appBar: appBarView.appBarPage("Profil"),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Couleur.backgroundColor,
              child: Column(children: [
                  
                ],
              ),
            ),
            Expanded(
              child: profilAsync.when(
                data: (profil) {
                  if (profil == null) {
                    return const Center(
                      child: Text(
                        'Aucun profil trouvé',
                        style: TextStyle(color: Couleur.backgroundColor),
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Couleur.backgroundColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 2,
                            width: double.infinity,
                            color: Couleur.butttonPrimaryColor,
                          ),
                          const SizedBox(height: 24),

                          // Photo et info utilisateur
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: Couleur.backgroundColor,
                                backgroundImage: profil.image != null
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
                          const SizedBox(height: 24),
                          Container(
                            height: 2,
                            width: double.infinity,
                            color: Couleur.butttonPrimaryColor,
                          ),
                          const SizedBox(height: 24),

                          // Cards d'informations
                          containerResult.buildInfoCard('Nom', profil.name),
                          const SizedBox(height: 12),

                          containerResult.buildInfoCard('Âge', '${profil.age}'),
                          const SizedBox(height: 12),

                          containerResult.buildInfoCard('Poid (kg)', '${profil.poids}'),
                          const SizedBox(height: 12),

                          containerResult.buildInfoCard('Taille (cm)', '${profil.taille}'),
                          const SizedBox(height: 12),

                          containerResult.buildInfoCard('Allergie', profil.allergies),
                          const SizedBox(height: 12),

                          containerResult.buildInfoCard('Traitement', profil.traitements),
                        ],
                      ),
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Text(
                    'Erreur: $error',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ),

            // Bottom Navigation
          ],
        ),
      ),
      bottomNavigationBar: bottomNavBar.buildBottomNavBar(context, ref),
    );
  }
}
