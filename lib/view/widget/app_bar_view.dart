import 'package:flutter/material.dart';
import 'package:vital_care/view/couleur/couleur.dart';
import 'package:vital_care/view/historique_imc_view.dart';
import 'package:vital_care/view/historique_tension_view.dart';
import 'package:vital_care/view/medicament_manquer_page.dart';
import 'package:vital_care/view/medicament_valider_page.dart';
import 'package:vital_care/view/medicament_view.dart';

class AppBarView {
  PreferredSizeWidget appBarPage(String titre) {
    return AppBar(
      title: Text(
        titre,
        style: TextStyle(
          color: Couleur.backgroundColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      automaticallyImplyLeading: false,
      automaticallyImplyActions: false,
      backgroundColor: Couleur.cardBackgroundColor,
    );
  }

  Widget appBarMadicament(
    BuildContext context,
    int selectedIndex,
    Color carColor,
  ) {
    Widget buildButton(String text, int index, Widget page) {
      final isSelected = selectedIndex == index;

      return TextButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? carColor : Couleur.backgroundColor,
          foregroundColor: isSelected
              ? Couleur.backgroundColor
              : Couleur.textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            //side: BorderSide(color: Couleur.backgroundColor, width: 1),
          ),
        ),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        },
        child: Text(text),
      );
    }

    return Container(
      color: Couleur.backgroundColor,
      width: double.infinity,
      margin: EdgeInsets.only(right: 8, left: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildButton("En cours", 0, const MedicamentView()),
              const SizedBox(width: 8),
              buildButton("Valider", 1, const MedicamentValiderPage()),
              const SizedBox(width: 8),
              buildButton("Manquer", 2, const MedicamentManquerPage()),
            ],
          ),
          SizedBox(height: 8),
          Container(width: double.infinity, height: 1, color: carColor),

          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget appBarHistorique(
    BuildContext context,
    int selectedIndex,
    Color carColor,
    VoidCallback onTap,
  ) {
    Widget buildButton(String text, int index, Widget page) {
      final isSelected = selectedIndex == index;

      return TextButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? carColor : Couleur.backgroundColor,
          foregroundColor: isSelected
              ? Couleur.backgroundColor
              : Couleur.textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            //side: BorderSide(color: Couleur.backgroundColor, width: 1),
          ),
        ),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        },
        child: Text(text),
      );
    }

    return Container(
      color: Couleur.backgroundColor,
      width: double.infinity,
      margin: EdgeInsets.only(right: 8, left: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildButton("IMC", 0, const HistoriqueImcView()),
              const SizedBox(width: 8),
              buildButton("Tension", 1, const HistoriqueTensionView()),

              SizedBox(width: 16,),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(150, 40),
                  backgroundColor: Couleur.cardBackgroundColor,
                  foregroundColor: Couleur.backgroundColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: onTap,
                child: Text(
                  "Exporter PDF",
                  style: TextStyle(color: Couleur.backgroundColor, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Container(width: double.infinity, height: 2, color: carColor),

          SizedBox(height: 8),
        ],
      ),
    );
  }
}
