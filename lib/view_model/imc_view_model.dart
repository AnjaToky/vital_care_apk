import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vital_care/model/imc_model.dart';
import 'package:vital_care/view/couleur/couleur.dart';
import 'package:vital_care/view_model/profil_view_model.dart';

final imcModelProvider = Provider<ImcModel>((ref) => ImcModel());

class ImcViewModel extends AsyncNotifier<List<Imc>> {
  @override
  Future<List<Imc>> build() async {
    final imcModel = ref.watch(imcModelProvider);
    return imcModel.afficherImc();
  }

  Imc? getDernierImc(List<Imc> list) {
    if (list.isEmpty) {
      return Imc(valuerImc: 0, createdAt: DateTime.now());
    }

    list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return list.last;
  }

  double moyenneImc(List<Imc> imcList) {
    double somme = 0;
    for (int i = 0; i < imcList.length; i++) {
      somme = somme + imcList[i].valuerImc;
    }

    double moyenneImc = somme / imcList.length;

    return moyenneImc;
  }

  double calculeImc(double poid, double taille) {
    if (taille <= 0) throw Exception("Taille invalide");
    double tailleEnMetres = taille / 100;
    return poid / (tailleEnMetres * tailleEnMetres);
  }

  String interpreterIMC(double imc) {
    if (imc < 18.5) return 'Insuffisance pondérale';
    if (imc < 25) return 'Poids normal';
    if (imc < 30) return 'Surpoids';
    if (imc < 35) return 'Obésité modérée';
    if (imc < 40) return 'Obésité sévère';
    return 'Obésité morbide';
  }

  Color couleurIMC(double imc) {
    if (imc < 18.5) return Colors.orange;
    if (imc < 25) return Couleur.secondaryColor;
    if (imc < 30) return Colors.orange;
    return Couleur.accentColor;
  }

  String moisImc(int mois) {
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

  Future<void> calculerEtAjouterImc(double poidHabitude) async {
    final profilAsync = ref.read(profilViewModelProvider);
    final profil = profilAsync.value;

    if (profil == null) {
      throw Exception("Données manquantes");
    }

    double imcValue = calculeImc(poidHabitude, profil.taille);

    final nouvelImc = Imc(valuerImc: imcValue, createdAt: DateTime.now());

    await ajouterImc(nouvelImc);
  }

  Future<void> ajouterImc(Imc imc) async {
    final imcModel = ref.read(imcModelProvider);
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await imcModel.ajouterImc(imc);
      return imcModel.afficherImc();
    });
  }

  Future<void> supprimerImc(int id) async {
    final imcModel = ref.read(imcModelProvider);
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await imcModel.supprimerImc(id);
      return imcModel.afficherImc();
    });
  }

  Future<void> actualiseImc() async {
    final imcModel = ref.read(imcModelProvider);
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      return imcModel.afficherImc();
    });
  }
}

final icmViewModelProvide = AsyncNotifierProvider<ImcViewModel, List<Imc>>(
  ImcViewModel.new,
);
