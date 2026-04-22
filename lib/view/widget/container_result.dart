import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vital_care/view/couleur/couleur.dart';

class ContainerResult {
  Widget buildIconButton({
    required VoidCallback onTap,
    required Color couleurIcon,
    required String icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: couleurIcon,
          borderRadius: BorderRadius.circular(8),
        ),
        child: SvgPicture.asset(icon, color: Couleur.backgroundColor),
      ),
    );
  }

  Widget buildIconStatus({required String icon, required Color iconColor}) {
    return Container(
      decoration: BoxDecoration(color: Couleur.backgroundColor),
      child: SvgPicture.asset(icon, color: iconColor, width: 16, height: 16),
    );
  }

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

  Widget cardUrgence(
    String nom,
    String lieu,
    String telephone,
    Widget iconWidget,
  ) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Couleur.backgroundColor,
        border: Border(bottom: BorderSide(width: 1, color: Couleur.textColor)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: Couleur.backgroundColor, // Bleu
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
                        color: Couleur.textColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SvgPicture.asset(
                      'assets/icon/hopital.svg',
                      width: 16,
                      height: 16,
                      colorFilter: const ColorFilter.mode(
                        Couleur.textColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // Dosage
                Text(
                  lieu,
                  style: TextStyle(color: Couleur.textColor, fontSize: 16),
                ),
                const SizedBox(height: 4),

                // Dosage
                Text(
                  telephone,
                  style: TextStyle(color: Couleur.textColor, fontSize: 16),
                ),
              ],
            ),
          ),
          iconWidget,
        ],
      ),
    );
  }


  Widget cardMedicament(
    String nom,
    String dosage,
    String dateFin,
    String heure,
    Widget iconWidget,
    Widget progressWidget,
  ) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Couleur.backgroundColor,
        border: Border(bottom: BorderSide(width: 1, color: Couleur.textColor)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: Couleur.backgroundColor, // Bleu
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
                        color: Couleur.textColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SvgPicture.asset(
                      'assets/icon/medicament_icon.svg',
                      width: 16,
                      height: 16,
                      colorFilter: const ColorFilter.mode(
                        Couleur.textColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Heure
                Row(
                  children: [
                    Text(
                      "Heur de prise : ",
                      style: TextStyle(
                        color: Couleur.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      heure,
                      style: TextStyle(color: Couleur.textColor, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Dosage
                Row(
                  children: [
                    Text(
                      "Dosage : ",
                      style: TextStyle(
                        color: Couleur.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      dosage,
                      style: TextStyle(color: Couleur.textColor, fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(height: 16,),
                progressWidget,
              ],
            ),
          ),
          iconWidget,
        ],
      ),
    );
  }

  Widget buildProgressing({
    required double valueActuelle,
    required double valueObjectif,
    required Color indicatorColor,
    required String interpretation,
  }) {
    double value = valueActuelle / valueObjectif;
    double valuePourCent = value * 100;
    return Container(
      color: Couleur.backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                color: Couleur.backgroundColor,
                width: 150,
                child: LinearProgressIndicator(
                  semanticsValue: "50M",
                  value: value,
                  minHeight: 16,
                  backgroundColor: Couleur.inputColor,
                  color: indicatorColor,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Text(
                " : ${valuePourCent.toInt()}%",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: indicatorColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            interpretation,
            style: TextStyle(
              color: indicatorColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildImcCard({
    required Color containerColor,
    required interpretation,
  }) {
    return Container(
      color: Couleur.backgroundColor,
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: containerColor,
              borderRadius: BorderRadius.circular(34),
            ),
          ),

          SizedBox(width: 16),

          Text(
            interpretation,
            style: TextStyle(fontSize: 16, color: Couleur.textColor),
          ),
        ],
      ),
    );
  }

  Widget buildHabitudeCard({
    required String label,
    required String value,
    required String iconHabitude,
    required Widget widgetColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Couleur.backgroundColor,
        border: Border(bottom: BorderSide(color: Couleur.textColor, width: 1)),
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
                    fontWeight: FontWeight.bold,
                    color: Couleur.textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 32,
                    color: Couleur.textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                widgetColor,
              ],
            ),
          ),
          SvgPicture.asset(
            iconHabitude,
            height: 40,
            width: 32,
            color: Couleur.textColor,
          ),
        ],
      ),
    );
  }

  Widget buildInfoCard(String label, String value, Widget bouttonEdit) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Couleur.backgroundColor,
        border: Border(bottom: BorderSide(color: Couleur.textColor, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Couleur.backgroundColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Couleur.textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Couleur.textColor,
                  ),
                ),
              ],
            ),
          ),
          bouttonEdit,
        ],
      ),
    );
  }

  Widget buildIconHomeCard(String iconCard, String value) {
    return Row(
      children: [
        SvgPicture.asset(
          iconCard,
          height: 24,
          width: 24,
          color: Couleur.textColor,
        ),
        SizedBox(width: 10),
        Text(value, style: TextStyle(color: Couleur.textColor, fontSize: 16)),
      ],
    );
  }

  Widget buildHomeCard({
    required String titre,
    required int nbrMedicament,
    required double nbrPas,
    required double hydratation,
    required double hydratationObjetctif,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Couleur.homeCard,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Couleur de l'ombre
            spreadRadius: 2, // Étendue de l'ombre
            blurRadius: 10, // Flou de l'ombre
            offset: Offset(0, 5), // Position (x, y) - ici 5 pixels vers le bas
          ),
        ],
      ),
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titre,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Couleur.textColor,
            ),
          ),
          SizedBox(height: 16),
          buildIconHomeCard(
            "assets/icon/medicament_icon.svg",
            "Medicament : $nbrMedicament en atente",
          ),

          SizedBox(height: 16),

          buildIconHomeCard(
            "assets/icon/hydratation.svg",
            "Hydratation : $hydratation/$hydratationObjetctif",
          ),
          SizedBox(height: 16),

          buildIconHomeCard("assets/icon/pas.svg", "Pas : $nbrPas/5000"),
        ],
      ),
    );
  }

  Widget buildHomeHabitude({
    required String titre,
    required String value,
    required Color cardColor,
  }) {
    return Container(
      padding: EdgeInsets.all(8),
      width: 150,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Couleur de l'ombre
            spreadRadius: 2, // Étendue de l'ombre
            blurRadius: 10, // Flou de l'ombre
            offset: Offset(0, 5), // Position (x, y) - ici 5 pixels vers le bas
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titre,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 2),
          Container(
            height: 1,
            width: double.infinity,
            color: Couleur.textColor,
          ),

          SizedBox(height: 8),

          Text(
            value,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
