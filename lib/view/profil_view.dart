import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vital_care/view/couleur/couleur.dart';
import 'package:vital_care/view/widget/app_bar_view.dart';
import 'package:vital_care/view/widget/bottom_nav_bar.dart';
import 'package:vital_care/view/widget/container_result.dart';
import 'package:vital_care/view/widget/edit_profil.dart';
import 'package:vital_care/view/widget/image_picker_validate.dart';
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
    EditProfil editProfil = EditProfil();

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
                          // Photo et info utilisateur
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Couleur.backgroundColor,
                              border: Border(
                                bottom: BorderSide(
                                  width: 1,
                                  color: Couleur.textColor,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: Couleur.backgroundColor,
                                        borderRadius: BorderRadius.circular(8),
                                        image:
                                            profil.image != null &&
                                                profil.image!.isNotEmpty
                                            ? DecorationImage(
                                                image: FileImage(
                                                  File(profil.image!),
                                                ),
                                                fit: BoxFit.cover,
                                              )
                                            : null,
                                      ),
                                      child:
                                          (profil.image == null ||
                                              profil.image!.isEmpty)
                                          ? const Icon(
                                              Icons.person,
                                              size: 40,
                                              color: Colors.white,
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 16),

                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          profil.name,
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Couleur.textColor,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Profil santer',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                containerResult.buildIconButton(
                                  onTap: () {
                                    editProfil.pickImage(context, ref);
                                  },
                                  couleurIcon: Couleur.cardBackgroundColor,
                                  icon: "assets/icon/edit.svg",
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Cards d'informations
                          containerResult.buildInfoCard(
                            'Nom',
                            profil.name,
                            SizedBox(),
                          ),
                          const SizedBox(height: 12),

                          containerResult.buildInfoCard(
                            'Âge',
                            '${profil.age}',
                            containerResult.buildIconButton(
                              onTap: () {editProfil.editAge(context, ref);},
                              couleurIcon: Couleur.cardBackgroundColor,
                              icon: "assets/icon/edit.svg",
                            ),
                          ),
                          const SizedBox(height: 12),

                          containerResult.buildInfoCard(
                            'Poid (kg)',
                            '${profil.poids}',
                            SizedBox(),
                          ),
                          const SizedBox(height: 12),

                          containerResult.buildInfoCard(
                            'Taille (cm)',
                            '${profil.taille}',
                            SizedBox(),
                          ),
                          const SizedBox(height: 12),

                          containerResult.buildInfoCard(
                            'Allergie',
                            profil.allergies,
                            containerResult.buildIconButton(
                              onTap: () {
                                editProfil.editAllergie(context, ref);
                              },
                              couleurIcon: Couleur.cardBackgroundColor,
                              icon: "assets/icon/edit.svg",
                            ),
                          ),
                          const SizedBox(height: 12),

                          containerResult.buildInfoCard(
                            'Traitement',
                            profil.traitements,
                            containerResult.buildIconButton(
                              onTap: () {editProfil.editTraitement(context, ref);},
                              couleurIcon: Couleur.cardBackgroundColor,
                              icon: "assets/icon/edit.svg",
                            ),
                          ),
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
