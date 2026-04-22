import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vital_care/model/profil_model.dart';
import 'package:vital_care/view/couleur/couleur.dart';
import 'package:vital_care/view_model/profil_view_model.dart';

class ImagePickerValidate {
  File? _selectedImage;
  File? get selectedImage => _selectedImage;

  //Utilise le ViewModel pour sélectionner l'image
  Future<void> pickImage(BuildContext context, WidgetRef ref) async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(
                Icons.camera_alt,
                color: Couleur.butttonPrimaryColor,
              ),
              title: const Text('Prendre une photo'),
              onTap: () {
                Navigator.pop(context);
                _getImage(ImageSource.camera, ref);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: Couleur.butttonPrimaryColor,
              ),
              title: const Text('Choisir de la galerie'),
              onTap: () {
                Navigator.pop(context);
                _getImage(ImageSource.gallery, ref);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getImage(ImageSource source, WidgetRef ref) async {
    //Appelle le ViewModel
    final viewModel = ref.read(profilViewModelProvider.notifier);
    final image = await viewModel.prendreImage(source);

    if (image != null) {
      _selectedImage = image;
      //Affiche un aperçu ou une confirmation
      //print('Image sélectionnée : ${image.path}');
    } else {
      //print('Aucune image sélectionnée');
    }
  }

  Future<void> valider(
    WidgetRef ref,
    BuildContext context,
    GlobalKey<FormState> formKey,
    TextEditingController nomController,
    TextEditingController ageController,
    TextEditingController tailleController,
    TextEditingController poidsController,
    TextEditingController allergieController,
    TextEditingController traitementController,
  ) async {
    if (formKey.currentState!.validate()) {
      final nom = nomController.text;
      final ageStr = ageController.text;
      final tailleStr = tailleController.text;
      final poidStr = poidsController.text;
      final allergie = allergieController.text;
      final traitement = traitementController.text;

      final int? age = int.tryParse(ageStr);
      final double? poids = double.tryParse(poidStr.replaceAll(',', '.'));
      final double? taille = double.tryParse(tailleStr.replaceAll(',', '.'));

      final profil = Profil(
        name: nom,
        age: age!,
        taille: taille!,
        poids: poids!,
        allergies: allergie,
        traitements: traitement,
        image: _selectedImage?.path, // Chemin de l'image
      );

      //Sauvegarde via le ViewModel
      await ref.read(profilViewModelProvider.notifier).ajouterProfil(profil);

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Profil enregistré')));
        Navigator.pop(context);
      }
    }
  }
}
