import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vital_care/view/couleur/couleur.dart';
import 'package:vital_care/view/widget/bottom_nav_bar.dart';

class UrgenceView extends ConsumerWidget {
  const UrgenceView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    BottomNavBar bottomNavBar = BottomNavBar();
    return Scaffold(
      backgroundColor: Couleur.backgroundColor,
      appBar: AppBar(backgroundColor: Couleur.backgroundColor, title: Text("Urgence Page")),
      body: Center(child: Text("Biencenue dan Urgence page")),
      bottomNavigationBar: bottomNavBar.buildBottomNavBar(context, ref),
    );
  }
}
