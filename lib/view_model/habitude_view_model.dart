import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vital_care/model/habitude_model.dart';

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
