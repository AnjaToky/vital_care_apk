import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vital_care/view/couleur/couleur.dart';
import 'package:vital_care/view_model/medicament_view_model.dart';

class BottomNavBar {
  Widget buildBottomNavBar(BuildContext context, WidgetRef ref) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    Widget buildItem(String route, String iconPath, {VoidCallback? onTap}) {
      final isSelected = currentRoute == route;

      return Expanded(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected
                ? Couleur.primaryColor
                : Couleur.backgroundColor,
            elevation: 0,
          ),
          onPressed: () {
            if (currentRoute != route) {
              Navigator.pushReplacementNamed(context, route);
            }
            if (onTap != null) onTap();
          },
          child: SvgPicture.asset(
            iconPath,
            color: isSelected ? Couleur.backgroundColor : Couleur.textColor,
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.only(right: 0, left: 0, top: 8, bottom: 8),
      decoration: BoxDecoration(color: Couleur.backgroundColor),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildItem(
              '/home',
              "assets/icon/home_icon.svg",
              onTap: () {
                ref
                    .read(medicamentViewModelProvider.notifier)
                    .actualiserMedicaments();
              },
            ),
            buildItem('/profil', "assets/icon/profil_icon.svg"),
            buildItem('/medicament', "assets/icon/medicament_icon.svg"),
            buildItem('/historique', "assets/icon/historique_icon.svg"),
            buildItem('/urgence', "assets/icon/urgence_icon.svg"),
          ],
        ),
      ),
    );
  }
}
