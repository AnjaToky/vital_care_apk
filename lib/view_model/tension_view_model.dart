import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vital_care/model/tension_model.dart';
import 'package:vital_care/view_model/habitude_view_model.dart';

final tensionModelProvider = Provider<TensionModel>((ref) => TensionModel());

class TensionViewModel extends AsyncNotifier<List<Tension>> {
  @override
  Future<List<Tension>> build() {
    final tensionModel = ref.watch(tensionModelProvider);
    return tensionModel.afficherTension();
  }

  Future<void> ajouterTensionList() async {
    final habitudeAsync = ref.read(habitudeViewModelProvider);

    final habitude = habitudeAsync.value;

    if (habitude == null) {
      throw Exception("Données manquante");
    }

    final nouvelleTension = Tension(
      tensionSystolique: habitude.tensionSystolique,
      tensionDiastolique: habitude.tenstionDiastolique,
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
