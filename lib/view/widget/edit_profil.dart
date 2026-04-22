import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vital_care/view/couleur/couleur.dart';
import 'package:vital_care/view/widget/text_field_view.dart';
import 'package:vital_care/view_model/profil_view_model.dart';

class EditProfil {
  File? _selectedImage;
  File? get selectedImage => _selectedImage;
  TextEditingController ageController = TextEditingController();
  TextEditingController allergieController = TextEditingController();
  TextEditingController traitementController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextFieldView textFieldView = TextFieldView();

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
    final viewModel = ref.read(profilViewModelProvider.notifier);
    final image = await viewModel.prendreImage(source);

    if (image == null) return;

    _selectedImage = image;

    //Récupère le profil depuis le state du AsyncNotifier
    final profilState = ref.read(profilViewModelProvider);

    profilState.whenData((profilExistant) async {
      if (profilExistant == null) return;

      //copyWith pour modifier seulement l'image
      final profilModifie = profilExistant.copyWith(image: image.path);

      await viewModel.modifierProfil(profilModifie);
    });
  }

  void editAge(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        ageController.text = ref
            .read(profilViewModelProvider)
            .value!
            .age
            .toString();
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Couleur.backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      Text(
                        "Modifier âge",
                        style: TextStyle(
                          color: Couleur.textColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Form(
                        key: formKey,
                        child: textFieldView.buildTextField(
                          ageController,
                          "Age",
                          TextInputType.number,
                        ),
                      ),

                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(150, 50),
                              backgroundColor: Couleur.inputColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(8),
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "Annuler",
                              style: TextStyle(
                                color: Couleur.textColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          TextButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Couleur.primaryColor,
                              fixedSize: Size(150, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(8),
                              ),
                            ),
                            onPressed: () {
                              final viewModel = ref.read(
                                profilViewModelProvider.notifier,
                              );
                              final int? age = int.tryParse(ageController.text);
                              final profilState = ref.read(
                                profilViewModelProvider,
                              );
                              profilState.whenData((profilExistant) async {
                                if (profilExistant == null) return;

                                final profilModifie = profilExistant.copyWith(
                                  age: age,
                                );

                                await viewModel.modifierProfil(profilModifie);
                              });

                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Ajouter",
                              style: TextStyle(
                                color: Couleur.backgroundColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void editAllergie(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        allergieController.text = ref
            .read(profilViewModelProvider)
            .value!
            .allergies
            .toString();
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Couleur.backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      Text(
                        "Modifier allergie",
                        style: TextStyle(
                          color: Couleur.textColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Form(
                        key: formKey,
                        child: textFieldView.buildTextField(
                          allergieController,
                          "Allergie",
                        ),
                      ),

                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(150, 50),
                              backgroundColor: Couleur.inputColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(8),
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "Annuler",
                              style: TextStyle(
                                color: Couleur.textColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          TextButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Couleur.primaryColor,
                              fixedSize: Size(150, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(8),
                              ),
                            ),
                            onPressed: () {
                              final viewModel = ref.read(
                                profilViewModelProvider.notifier,
                              );

                              final profilState = ref.read(
                                profilViewModelProvider,
                              );
                              profilState.whenData((profilExistant) async {
                                if (profilExistant == null) return;

                                final profilModifie = profilExistant.copyWith(
                                  allergies: allergieController.text,
                                );

                                await viewModel.modifierProfil(profilModifie);
                              });

                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Ajouter",
                              style: TextStyle(
                                color: Couleur.backgroundColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void editTraitement(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        traitementController.text = ref
            .read(profilViewModelProvider)
            .value!
            .traitements
            .toString();
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Couleur.backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      Text(
                        "Modifier traitement",
                        style: TextStyle(
                          color: Couleur.textColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Form(
                        key: formKey,
                        child: textFieldView.buildTextField(
                          traitementController,
                          "Traitement",
                        ),
                      ),

                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(150, 50),
                              backgroundColor: Couleur.inputColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(8),
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "Annuler",
                              style: TextStyle(
                                color: Couleur.textColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          TextButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Couleur.primaryColor,
                              fixedSize: Size(150, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(8),
                              ),
                            ),
                            onPressed: () {
                              final viewModel = ref.read(
                                profilViewModelProvider.notifier,
                              );

                              final profilState = ref.read(
                                profilViewModelProvider,
                              );
                              profilState.whenData((profilExistant) async {
                                if (profilExistant == null) return;

                                final profilModifie = profilExistant.copyWith(
                                  traitements: traitementController.text,
                                );

                                await viewModel.modifierProfil(profilModifie);
                              });

                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Ajouter",
                              style: TextStyle(
                                color: Couleur.backgroundColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
