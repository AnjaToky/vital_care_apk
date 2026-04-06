import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vital_care/view/couleur/couleur.dart';

class ContainerResult {


  Widget cardMedicament(
    String nom,
    String dosage,
    String frequence,
    String heure,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Couleur.cardBackgroundColor, // Bleu
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
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              SvgPicture.asset(
                'assets/icon/medicament_icon.svg',
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  Couleur.textSecondaryColor,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Heure
          Text(
            heure,
            style: TextStyle(color: Couleur.textSecondaryColor, fontSize: 16),
          ),
          const SizedBox(height: 4),

          // Dosage
          Text(
            dosage,
            style: TextStyle(color: Couleur.textSecondaryColor, fontSize: 16),
          ),
          const SizedBox(height: 16),

          // Bouton Valider
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Action de validation
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Couleur.buttonSecondaryColor, // Vert
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
          ),
        ],
      ),
    );
  }

  
}