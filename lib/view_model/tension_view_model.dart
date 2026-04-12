import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vital_care/model/tension_model.dart';
import 'package:vital_care/view/couleur/couleur.dart';

final tensionModelProvider = Provider<TensionModel>((ref) => TensionModel());

class TensionViewModel extends AsyncNotifier<List<Tension>> {
  @override
  Future<List<Tension>> build() {
    final tensionModel = ref.watch(tensionModelProvider);
    return tensionModel.afficherTension();
  }

  Future<void> ajouterTensionList(
    double systolique,
    double diastholique,
  ) async {
    final nouvelleTension = Tension(
      tensionSystolique: systolique,
      tensionDiastolique: diastholique,
      createdAt: DateTime.now(),
    );

    await ajouterTension(nouvelleTension);
  }

  Tension? getDernierTension(List<Tension> listTension) {
    if (listTension.isEmpty) {
      return Tension(
        tensionSystolique: 0,
        tensionDiastolique: 0,
        createdAt: DateTime.now(),
      );
    }

    listTension.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return listTension.last;
  }

  double moyenneTensionSystolique(List<Tension> tensionList) {
    if (tensionList.isEmpty) return 0;

    double sommeSystolique = 0;

    for (int i = 0; i < tensionList.length; i++) {
      sommeSystolique = sommeSystolique + tensionList[i].tensionSystolique;
    }

    double moyenneTensionSystolique = sommeSystolique / tensionList.length;

    return moyenneTensionSystolique;
  }

  double moyenneTensionDiastolique(List<Tension> tensionList) {
    if (tensionList.isEmpty) return 0;

    double sommeDiastolique = 0;

    for (int i = 0; i < tensionList.length; i++) {
      sommeDiastolique = sommeDiastolique + tensionList[i].tensionDiastolique;
    }

    double moyenneTensionDiastolique = sommeDiastolique / tensionList.length;

    return moyenneTensionDiastolique;
  }

  String interpreterTension(double systolique, double diastolique) {
    if (systolique < 90 || diastolique < 60) {
      return 'Hypotension';
    } else if (systolique < 120 && diastolique < 80) {
      return 'Tension normale';
    } else if (systolique < 130 && diastolique < 80) {
      return 'Tension élevée';
    } else if (systolique < 140 || diastolique < 90) {
      return 'Hypertension stade 1';
    } else if (systolique < 180 || diastolique < 120) {
      return 'Hypertension stade 2';
    } else {
      return 'Crise hypertensive - Urgence';
    }
  }

  String moisTension(int mois) {
    switch (mois) {
      case 1:
        return "Janvier";
      case 2:
        return "Février";
      case 3:
        return "Mars";
      case 4:
        return "Avril";
      case 5:
        return "Mey";
      case 6:
        return "Juin";
      case 7:
        return "Juillet";
      case 8:
        return "Aôut";
      case 9:
        return "Septembre";
      case 10:
        return "Octobre";
      case 11:
        return "Novembre";
      case 12:
        return "Decembre";
    }
    return 'null';
  }

  Color couleurTension(double systolique, double diastolique) {
    if (systolique < 90 || diastolique < 60) return Couleur.butttonPrimaryColor;
    if (systolique < 120 && diastolique < 80) return Couleur.secondaryColor;
    if (systolique < 140 || diastolique < 90) return Colors.orange;
    if (systolique >= 180 || diastolique >= 120) return Couleur.accentColor;
    return Colors.deepOrange;
  }

  Future<void> ajouterTension(Tension tension) async {
    final tensionModel = ref.read(tensionModelProvider);
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await tensionModel.ajouterTension(tension);
      return tensionModel.afficherTension();
    });
  }

  Future<void> supprimerTension(int id) async {
    final tensioModel = ref.read(tensionModelProvider);
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await tensioModel.supprimerTension(id);
      return tensioModel.afficherTension();
    });
  }

  Future<void> actualiseTension() async {
    final tensionModel = ref.read(tensionModelProvider);
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      return tensionModel.afficherTension();
    });
  }
}

final tensionViewModelProvider =
    AsyncNotifierProvider<TensionViewModel, List<Tension>>(
      TensionViewModel.new,
    );
