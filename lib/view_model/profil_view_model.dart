import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vital_care/model/profil_model.dart';

final profilViewModel = Provider<ProfilModel>((ref) => ProfilModel());

class ProfilViewModel extends AsyncNotifier<Profil?> {
  ImagePicker picker = ImagePicker();
  @override
  Future<Profil?> build() async {
    final profilModel = ref.watch(profilViewModel);
    return profilModel.afficherProfil();
  }

  Future<File?> prendreImage(ImageSource source) async {
    try {
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      print('Erreur sélection image: $e');
      return null;
    }
  }

  Future<void> ajouterProfil(Profil profil) async {
    final profilModel = ref.read(profilViewModel);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await profilModel.ajouterProfil(profil);
      return profilModel.afficherProfil();
    });
  }

  Future<void> modifierProfil(Profil profil) async {
    final profilModel = ref.read(profilViewModel);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await profilModel.modifierProfil(profil);
      return profilModel.afficherProfil();
    });
  }

  Future<void> afficherProfil() async {
    final profilModel = ref.read(profilViewModel);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return profilModel.afficherProfil();
    });
  }

  Future<void> actualiserProfils() async {
    final profilModel = ref.read(profilViewModel);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return profilModel.afficherProfil();
    });
  }
}

final profilViewModelProvider = AsyncNotifierProvider<ProfilViewModel, Profil?>(
  (ProfilViewModel.new),
);
