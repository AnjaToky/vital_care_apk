import 'dart:async';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vital_care/model/medicament_model.dart';
import 'package:vital_care/view/couleur/couleur.dart';

final medicamentViewModel = Provider<MedicamentModel>(
  (ref) => MedicamentModel(),
);

class MedicamentViewModel extends AsyncNotifier<List<Medicament>> {
  @override
  Future<List<Medicament>> build() async {
    final medicamentModel = ref.watch(medicamentViewModel);
    return medicamentModel.afficherMedicaments();
  }

  Future<void> validerMedicament(Medicament medicament) async {
    final model = ref.read(medicamentViewModel);
    medicament.status = MedicamentStatus.valider;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await model.modifierMedicament(medicament);
      return model.afficherMedicaments();
    });
  }

  void verifierMedicamentsManques(List<Medicament> list) {
    final now = DateTime.now();

    for (var medic in list) {
      if (medic.status == MedicamentStatus.enAttente &&
          medic.heure.isBefore(now)) {
        medic.status = MedicamentStatus.manquer;
        ref.read(medicamentViewModel).modifierMedicament(medic);
        ref.read(medicamentViewModel).afficherMedicaments();
      }
    }
  }

  Medicament getDernierMedic(List<Medicament> listMadicament) {
    // 1. Filtrer les médicaments en attente
    final enAttente = listMadicament
        .where((m) => m.status == MedicamentStatus.enAttente)
        .toList();

    // 2. Vérifier si vide
    if (enAttente.isEmpty) {
      return Medicament(
        nom: "Pas de medicament",
        dosage: 0,
        frequence: 0,
        heure: DateTime.now(),
        createAt: DateTime.now(),
      );
    }

    // 3. Trier
    enAttente.sort((a, b) => a.heure.compareTo(b.heure));

    // 4. Retourner le plus proche
    return enAttente.first;
  }

  Future<void> ajouterMedicament(Medicament medicament) async {
    final medicamentModel = ref.read(medicamentViewModel);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await medicamentModel.ajouterMedicament(medicament);
      return medicamentModel.afficherMedicaments();
    });
  }

  Future<void> supprimerMedicament(int id) async {
    final medicamentModel = ref.read(medicamentViewModel);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await medicamentModel.supprimerMedicament(id);
      return medicamentModel.afficherMedicaments();
    });
  }

  Future<void> modifierMedicament(Medicament medicament) async {
    final medicamentModel = ref.read(medicamentViewModel);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await medicamentModel.modifierMedicament(medicament);
      return medicamentModel.afficherMedicaments();
    });
  }

  Future<void> actualiserMedicaments() async {
    final medicamentModel = ref.read(medicamentViewModel);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return medicamentModel.afficherMedicaments();
    });
  }
}

final medicamentViewModelProvider =
    AsyncNotifierProvider<MedicamentViewModel, List<Medicament>>(
      MedicamentViewModel.new,
    );
