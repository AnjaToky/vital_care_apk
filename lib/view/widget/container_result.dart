import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vital_care/view/couleur/couleur.dart';

class ContainerResult {
  Widget bouttonValider(
    VoidCallback valideMedic,
    Color buttonColor,
    double buttonWidth,
    String titre,
  ) {
    return SizedBox(
      width: buttonWidth,
      child: ElevatedButton(
        onPressed: valideMedic,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          titre,
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
    required Color backColor,
    required String interpertation,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backColor,
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
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Couleur.backgroundColor,
                  ),
                ),

                Text(
                  heure,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Couleur.backgroundColor,
                  ),
                ),

                Text(
                  interpertation,
                  style: TextStyle(
                    color: Couleur.backgroundColor,
                    fontSize: 16,
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

  Widget buildInfoCard(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Couleur.cardBackgroundColor,
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
