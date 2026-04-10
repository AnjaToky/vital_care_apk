import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vital_care/view/couleur/couleur.dart';
import 'package:vital_care/view/widget/bottom_nav_bar.dart';
import 'dart:io';

import 'package:vital_care/view_model/profil_view_model.dart';

class ProfilView extends ConsumerWidget {
  const ProfilView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profilAsync = ref.watch(profilViewModelProvider);
    BottomNavBar bottomNavBar = BottomNavBar();

    return Scaffold(
      backgroundColor: Couleur.backgroundColor,
      appBar: AppBar(
        backgroundColor: Couleur.backgroundColor,
        title: const Text(
          'Profil',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Couleur.primaryColor,
          ),
        ),
      ),
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
                          _buildInfoCard('Nom', profil.name),
                          const SizedBox(height: 12),

                          _buildInfoCard('Âge', '${profil.age}'),
                          const SizedBox(height: 12),

                          _buildInfoCard('Poid (kg)', '${profil.poids}'),
                          const SizedBox(height: 12),

                          _buildInfoCard('Taille (cm)', '${profil.taille}'),
                          const SizedBox(height: 12),

                          _buildInfoCard('Allergie', profil.allergies),
                          const SizedBox(height: 12),

                          _buildInfoCard('Traitement', profil.traitements),
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

  Widget _buildInfoCard(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1976D2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
