import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vital_care/view/couleur/couleur.dart';
import 'package:vital_care/view/habitude_view.dart';
import 'package:vital_care/view/home_view.dart';
import 'package:vital_care/view/widget/app_bar_view.dart';
import 'package:vital_care/view/widget/image_picker_validate.dart';
import 'package:vital_care/view/widget/text_field_view.dart';

class AjoutProfilView extends ConsumerWidget {
  const AjoutProfilView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController nomController = TextEditingController();
    TextEditingController ageController = TextEditingController();
    TextEditingController poidController = TextEditingController();
    TextEditingController tailleController = TextEditingController();
    TextEditingController allergieController = TextEditingController();
    TextEditingController traitementController = TextEditingController();
    TextFieldView textFieldView = TextFieldView();
    final formKey = GlobalKey<FormState>();
    ImagePickerValidate imagePickerValidate = ImagePickerValidate();
    AppBarView appBarView = AppBarView();

    allergieController.text = "N/A";
    traitementController.text = "N/A";

    return Scaffold(
      backgroundColor: Couleur.backgroundColor,
      appBar: appBarView.appBarPage("Créer votre profil"),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            spacing: 16,
            children: [
              Container(
                width: 233,
                height: 231,
                decoration: BoxDecoration(color: Couleur.backgroundColor),
                child: Image.asset("assets/logo/container_logo.png"),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Couleur.backgroundColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Ajouter votre profil',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Couleur.textColor,
                          ),
                        ),
                        // Nom
                        textFieldView.buildTextField(nomController, 'Nom'),

                        // Âge
                        textFieldView.buildTextField(
                          ageController,
                          'Âge',
                          TextInputType.number,
                        ),

                        // Taille
                        textFieldView.buildTextField(
                          tailleController,
                          'Taille en cm',
                          TextInputType.number,
                        ),

                        // Poids
                        textFieldView.buildTextField(
                          poidController,
                          'Poids initiale',
                          TextInputType.number,
                        ),

                        // Allergie
                        textFieldView.buildTextField(
                          allergieController,
                          'Allergie',
                        ),

                        // Traitement
                        textFieldView.buildTextField(
                          traitementController,
                          'Traitement',
                        ),

                        // Choisir une photo
                        InkWell(
                          onTap: () =>
                              imagePickerValidate.pickImage(context, ref),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Couleur.inputColor,
                              border: Border.all(
                                color: Couleur.backgroundColor,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  imagePickerValidate.selectedImage == null
                                      ? 'Choisir une photo'
                                      : 'Photo sélectionnée',
                                  style: const TextStyle(
                                    color: Couleur.textColor,
                                    fontSize: 14,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1976D2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Aperçu de l'image
                        if (imagePickerValidate.selectedImage != null) ...[
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              imagePickerValidate.selectedImage!,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],

                        // Bouton Valider
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              imagePickerValidate.valider(
                                ref,
                                context,
                                formKey,
                                nomController,
                                ageController,
                                tailleController,
                                poidController,
                                allergieController,
                                traitementController,
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => HomeView()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Couleur.butttonPrimaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Valider',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
