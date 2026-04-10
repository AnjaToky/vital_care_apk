import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vital_care/view/widget/bottom_nav_bar.dart';

class HistoriqueView extends ConsumerWidget {
  const HistoriqueView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    BottomNavBar bottomNavBar = BottomNavBar();
    return Scaffold(
      appBar: AppBar(title: Text("Historique Page")),
      body: Center(child: Text("Biencenue dan hisrorique page")),
      bottomNavigationBar: bottomNavBar.buildBottomNavBar(context, ref),
    );
  }
}
