import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vital_care/view/couleur/couleur.dart';
import 'package:vital_care/view/habitude_view.dart';
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

    return Scaffold(
      backgroundColor: Couleur.backgroundColor,
      appBar: AppBar(
        backgroundColor: Couleur.backgroundColor,
        elevation: 0,
        title: Text(
          "Créer Profil",
          style: TextStyle(
            color: Couleur.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Couleur.backgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Ajouter votre profil',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1976D2),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Nom
                  textFieldView.buildLabel('Nom'),
                  textFieldView.buildTextField(nomController, 'Nom'),
                  const SizedBox(height: 16),

                  // Âge
                  textFieldView.buildLabel('Âge'),
                  textFieldView.buildTextField(
                    ageController,
                    'Âge',
                    TextInputType.number,
                  ),
                  const SizedBox(height: 16),

                  // Taille
                  textFieldView.buildLabel('Taille (m)'),
                  textFieldView.buildTextField(
                    tailleController,
                    'Taille',
                    TextInputType.number,
                  ),
                  const SizedBox(height: 16),

                  // Poids
                  textFieldView.buildLabel('Poids initial (kg)'),
                  textFieldView.buildTextField(
                    poidController,
                    'Poids',
                    TextInputType.number,
                  ),
                  const SizedBox(height: 16),

                  // Allergie
                  textFieldView.buildLabel('Allergie'),
                  textFieldView.buildTextField(allergieController, 'Allergie'),
                  const SizedBox(height: 16),

                  // Traitement
                  textFieldView.buildLabel('Traitement'),
                  textFieldView.buildTextField(
                    traitementController,
                    'Traitement',
                  ),
                  const SizedBox(height: 20),

                  // Choisir une photo
                  InkWell(
                    onTap: () => imagePickerValidate.pickImage(context, ref),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF1976D2),
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
                              color: Color(0xFF1976D2),
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

                  const SizedBox(height: 20),

                  // Bouton Valider
                  SizedBox(
                    width: double.infinity,
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
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HabitudeView()));
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
      ),
    );
  }
}
