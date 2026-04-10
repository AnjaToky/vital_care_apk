import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vital_care/view/couleur/couleur.dart';

class ContainerResult {
  Widget bouttonValider(VoidCallback valideMedic) {
    return SizedBox(
      width: 300,
      child: ElevatedButton(
        onPressed: valideMedic,
        style: ElevatedButton.styleFrom(
          backgroundColor: Couleur.buttonSecondaryColor,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Valider',
          style: TextStyle(
            color: Couleur.textSecondaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget cardMedicament(
    String nom,
    String dosage,
    String frequence,
    String heure,
    Color fontColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: fontColor, // Bleu
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Titre avec icône
          Row(
            children: [
              Text(
                nom,
                style: const TextStyle(
                  color: Couleur.textSecondaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              SvgPicture.asset(
                'assets/icon/medicament_icon.svg',
                width: 16,
                height: 16,
                colorFilter: const ColorFilter.mode(
                  Couleur.textSecondaryColor,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Heure
          Text(
            heure,
            style: TextStyle(color: Couleur.textSecondaryColor, fontSize: 12),
          ),
          const SizedBox(height: 4),

          // Dosage
          Text(
            dosage,
            style: TextStyle(color: Couleur.textSecondaryColor, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget buildHabitudeCard({
    required String label,
    required String value,
    required String heure,
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

                Text(
                  heure,
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
}
