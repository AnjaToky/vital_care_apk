import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vital_care/model/imc_model.dart';
import 'package:vital_care/view_model/habitude_view_model.dart';
import 'package:vital_care/view_model/profil_view_model.dart';

final imcModelProvider = Provider<ImcModel>((ref) => ImcModel());

class ImcViewModel extends AsyncNotifier<List<Imc>> {
  @override
  Future<List<Imc>> build() async {
    final imcModel = ref.watch(imcModelProvider);
    return imcModel.afficherImc();
  }

  Imc? getDernierImc(List<Imc> list) {
    if (list.isEmpty){
      return Imc(valuerImc: 0, createdAt: DateTime.now());
    }

    list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return list.last;
  }

  double calculeImc(double poid, double taille) {
    if (taille <= 0) throw Exception("Taille invalide");
    double tailleEnMetres = taille / 100;
    return poid / (tailleEnMetres * tailleEnMetres);
  }

  Future<void> calculerEtAjouterImc() async {
    final habitudeAsync = ref.read(habitudeViewModelProvider);
    final profilAsync = ref.read(profilViewModelProvider);

    final habitude = habitudeAsync.value;
    final profil = profilAsync.value;

    if (habitude == null || profil == null) {
      throw Exception("Données manquantes");
    }

    final imcValue = calculeImc(habitude.poidHabitude, profil.taille);

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
