import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vital_care/model/medicament_model.dart';

final medicamentViewModel = Provider<MedicamentModel>(
  (ref) => MedicamentModel(),
);

class MedicamentViewModel extends AsyncNotifier<List<Medicament>> {
  @override
  Future<List<Medicament>> build() async {
    final medicamentModel = ref.watch(medicamentViewModel);
    return medicamentModel.afficherMedicaments();
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
