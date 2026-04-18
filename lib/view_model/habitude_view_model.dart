//import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vital_care/model/habitude_model.dart';
import 'package:vital_care/view/couleur/couleur.dart';

final habitudeViewModel = Provider<HabitudeModel>((ref) => HabitudeModel());

class HabitudeViewModel extends AsyncNotifier<Habitude?> {
  @override
  Future<Habitude?> build() async {
    final habitudeModel = ref.watch(habitudeViewModel);
    return habitudeModel.afficherHabitude();
  }

  Future<void> ajouterHabitude(Habitude habitude) async {
    final habitudeModel = ref.read(habitudeViewModel);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await habitudeModel.ajouterHabitude(habitude);
      return habitudeModel.afficherHabitude();
    });
  }

  double calculeHydratation(double poidHabitude) {
    double hydratation = ((poidHabitude - 20) * 15) + 1500;
    return hydratation;
  }

  String hydratationInterpretation(
    double hydratationHabitude,
    double hydratation,
  ) {
    if (hydratationHabitude < hydratation) {
      return "Vous n'avez pas assez bu";
    } else if (hydratationHabitude == hydratation) {
      return "Hydratation correcte";
    } else {
      return "Vous êtes bien hydraté";
    }
  }


  

  Color hydratationColor(double hydratationHabitude, double hydratation) {
    if (hydratationHabitude < hydratation) {
      return Couleur.alertColor;
    } else {
      return Couleur.buttonSecondaryColor;
    }
  }

  Future<void> supprimerHabitude(int id) async {
    final habitudeModel = ref.read(habitudeViewModel);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await habitudeModel.supprimerHabitude(id);
      return habitudeModel.afficherHabitude();
    });
  }

  Future<void> actualiserHabitude() async {
    final habitudeModel = ref.read(habitudeViewModel);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return habitudeModel.afficherHabitude();
    });
  }
}

final habitudeViewModelProvider =
    AsyncNotifierProvider<HabitudeViewModel, Habitude?>(HabitudeViewModel.new);
