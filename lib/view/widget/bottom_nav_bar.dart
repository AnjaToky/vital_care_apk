import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vital_care/view/couleur/couleur.dart';
import 'package:vital_care/view_model/medicament_view_model.dart';

class BottomNavBar {
  Widget buildBottomNavBar(BuildContext context, WidgetRef ref) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    Widget buildItem(
      String route,
      String iconPath,
      String label, {
      VoidCallback? onTap,
    }) {
      final isSelected = currentRoute == route;

      return Expanded(
        child: GestureDetector(
          onTap: () {
            if (currentRoute != route) {
              Navigator.pushReplacementNamed(context, route);
            }
            if (onTap != null) onTap();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? Couleur.primaryColor
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  iconPath,
                  height: 22,
                  color: isSelected
                      ? Couleur.backgroundColor
                      : Couleur.textColor,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected
                        ? Couleur.backgroundColor
                        : Couleur.textColor,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        color: Couleur.backgroundColor, // fond comme ton image
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            buildItem(
              '/home',
              "assets/icon/home_icon.svg",
              "Home",
              onTap: () {
                ref
                    .read(medicamentViewModelProvider.notifier)
                    .actualiserMedicaments();
              },
            ),
            buildItem('/profil', "assets/icon/profil_icon.svg", "Profil"),
            buildItem('/medicament', "assets/icon/medicament_icon.svg", "Traitement"),
            buildItem('/historique', "assets/icon/historique_icon.svg", "Historique"),
            buildItem('/urgence', "assets/icon/urgence_icon.svg", "Urgence"),
          ],
        ),
      ),
    );
  }
}