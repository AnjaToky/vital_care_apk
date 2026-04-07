import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vital_care/view_model/habitude_view_model.dart';
import 'package:vital_care/view_model/profil_view_model.dart';

class HabitudeView extends ConsumerWidget {
  const HabitudeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitudeAsync = ref.watch(habitudeViewModelProvider);
    final profilAsync = ref.watch(profilViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
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

                  return profilAsync.when(
                    data: (profil) {
                      // Calcul IMC
                      // double imc = 0;
                      // if (profil != null && profil.taille != null) {
                      //   imc = CalculsSante.calculerIMC(
                      //     habitude.poidHabitude,
                      //     double.parse(profil.taille!),
                      //   );
                      // }

                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Titre
                            const Text(
                              'Habitude',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1976D2),
                              ),
                            ),
                            const Divider(thickness: 2),
                            const SizedBox(height: 16),

                            // Date
                            Text(
                              'Dernière mise à jour: ${DateFormat('dd MMMM yyyy, HH:mm').format(habitude.createdAt)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1976D2),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Cards
                            _buildHabitudeCard(
                              label: 'Poids',
                              value: '${habitude.poidHabitude.toInt()} kg',
                              icon: Icons.monitor_weight_outlined,
                            ),
                            const SizedBox(height: 12),

                            _buildHabitudeCard(
                              label: 'Hydratation',
                              value: '${habitude.hydratation} Litre',
                              icon: Icons.water_drop_outlined,
                            ),
                            const SizedBox(height: 12),

                            _buildHabitudeCard(
                              label: 'Pas',
                              value:
                                  '${habitude.nbrPas.toInt()}', // Tu peux ajouter ce champ à ton modèle
                              icon: Icons.directions_walk_outlined,
                            ),
                            const SizedBox(height: 12),

                            // _buildHabitudeCard(
                            //   label: 'IMC',
                            //   value: imc > 0 ? imc.toStringAsFixed(0) : 'N/A',
                            //   icon: Icons.person_outline,
                            // ),
                            const SizedBox(height: 12),

                            _buildHabitudeCard(
                              label: 'Tension',
                              value:
                                  '${habitude.tensionSystolique.toInt()}/${habitude.tenstionDiastolique.toInt()}',
                              icon: Icons.monitor_heart_outlined,
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
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Erreur: $err')),
              ),
            ),

            // Bottom Navigation Bar
            _buildBottomNavBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitudeCard({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1976D2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Icon(icon, size: 60, color: Colors.white.withOpacity(0.9)),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'Home', true, () {}),
              _buildNavItem(Icons.person_outline, 'Profil', false, () {}),
              _buildNavItem(
                Icons.medical_services_outlined,
                'Traitement',
                false,
                () {},
              ),
              _buildNavItem(Icons.history, 'Historique', false, () {}),
              _buildNavItem(
                Icons.warning_amber_outlined,
                'Urgence',
                false,
                () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1976D2) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.black87,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
