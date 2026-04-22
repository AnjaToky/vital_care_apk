import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vital_care/view/couleur/couleur.dart';
import 'package:vital_care/view/widget/app_bar_view.dart';
import 'package:vital_care/view/widget/bottom_nav_bar.dart';
import 'package:vital_care/view/widget/container_result.dart';
import 'package:vital_care/view_model/urgence_view_model.dart';

class UrgenceView extends ConsumerWidget {
  const UrgenceView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final urgenceAsync = ref.watch(urgenceViewModelProvider);
    BottomNavBar bottomNavBar = BottomNavBar();
    ContainerResult containerResult = ContainerResult();
    AppBarView appBarView = AppBarView();
    return Scaffold(
      backgroundColor: Couleur.backgroundColor,
      appBar: appBarView.appBarPage("Urgence"),
      body: urgenceAsync.when(
        data: (urgence) {
          return ListView.builder(
            itemCount: urgence.length,
            itemBuilder: (context, index) {
              final u = urgence[index];
              return containerResult.cardUrgence(
                u.nomHopital,
                u.lieu,
                u.numeroTel,
                containerResult.buildIconButton(
                  onTap: () {
                    ref
                        .read(urgenceViewModelProvider.notifier)
                        .appelerNumero(u.nomHopital, u.numeroTel);
                  },
                  
                  icon: "assets/icon/call.svg",
                  couleurIcon: Couleur.buttonSecondaryColor,
                ),
              );
            },
          );
        },
        error: (e, o) => Text("erreur $e , $o"),
        loading: () => CircularProgressIndicator(),
      ),
      bottomNavigationBar: bottomNavBar.buildBottomNavBar(context, ref),
    );
  }
}
