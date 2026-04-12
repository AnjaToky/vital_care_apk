import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vital_care/view/couleur/couleur.dart';
import 'package:vital_care/view/widget/app_bar_view.dart';
import 'package:vital_care/view/widget/bottom_nav_bar.dart';
import 'package:vital_care/view_model/habitude_view_model.dart';
import 'package:vital_care/view_model/imc_view_model.dart';
import 'package:vital_care/view_model/profil_view_model.dart';

class HabitudeView extends ConsumerWidget {
  const HabitudeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitudeAsync = ref.watch(habitudeViewModelProvider);
    final profilAsync = ref.watch(profilViewModelProvider);
    final imcAsync = ref.watch(icmViewModelProvide);
    BottomNavBar bottomNavBar = BottomNavBar();
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
                                  'Dernière mise à jour: ${DateFormat('dd MMMM yyyy, HH:mm').format(habitude.createdAt)}',
                                  style: const TextStyle(
                                    fontSize: 18,
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

                                _buildHabitudeCard(
                                  label: 'IMC',
                                  value: lastImc != null
                                      ? '${lastImc.valuerImc.toInt()}'
                                      : '--',
                                  icon: Icons.person_outlined,
                                ),
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
        onPressed: () => Navigator.pushNamed(context, '/ajout_habitude'),
        child: Icon(Icons.add, color: Couleur.butttonPrimaryColor),
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
        color: Couleur.cardBackgroundColor,
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
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Couleur.backgroundColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Couleur.backgroundColor,
                  ),
                ),
              ],
            ),
          ),
          Icon(icon, size: 30, color: Couleur.backgroundColor),
        ],
      ),
    );
  }
}
