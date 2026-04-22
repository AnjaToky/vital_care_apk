import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vital_care/model/habitude_model.dart';
import 'package:vital_care/view/couleur/couleur.dart';
import 'package:vital_care/view/widget/text_field_view.dart';
import 'package:vital_care/view_model/habitude_view_model.dart';
import 'package:vital_care/view_model/imc_view_model.dart';
import 'package:vital_care/view_model/tension_view_model.dart';

class BottomSheetHabitude {
  void showBottomSheetDialog(BuildContext context, WidgetRef ref) {
    TextEditingController pasController = TextEditingController();
    TextEditingController hydratationController = TextEditingController();
    TextEditingController poidController = TextEditingController();
    TextEditingController systoliqueController = TextEditingController();
    TextEditingController diastoliqueController = TextEditingController();
    TextFieldView textFieldView = TextFieldView();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final habitudeNotifier = ref.watch(habitudeViewModelProvider.notifier);
    final imcNotifire = ref.watch(icmViewModelProvide.notifier);
    final tensioNotifier = ref.watch(tensionViewModelProvider.notifier);
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
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
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment : CrossAxisAlignment.center,
                  spacing: 16,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Prise Quotidienne",
                      style: TextStyle(
                        color: Couleur.textColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    textFieldView.buildTextField(
                      poidController,
                      "Poids en kg",
                      TextInputType.number,
                    ),

                    textFieldView.buildTextField(
                      pasController,
                      "Nombre de pas",
                      TextInputType.number,
                    ),
                    textFieldView.buildTextField(
                      hydratationController,
                      "Hydratation (ml)",
                      TextInputType.number,
                    ),
                    textFieldView.buildTextField(
                      systoliqueController,
                      "Tension systolique",
                      TextInputType.number,
                    ),

                    textFieldView.buildTextField(
                      diastoliqueController,
                      "Tension diastolique",
                      TextInputType.number,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(150, 50),
                            backgroundColor: Couleur.inputColor,
                            foregroundColor: Couleur.textColor,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/habitude_view');
                          },
                          child: Text(
                            "Annuler",
                            style: TextStyle(
                              color: Couleur.textColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(150, 50),
                            backgroundColor: Couleur.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            final habitudeAsync = ref.read(
                              habitudeViewModelProvider,
                            );

                            if (formKey.currentState!.validate()) {
                              final habitudeValue = habitudeAsync.value;
                              if (habitudeValue != null) {
                                habitudeNotifier.supprimerHabitude(
                                  habitudeValue.id ?? 0,
                                );
                              }
                              final poisStr = poidController.text;
                              final pasStr = pasController.text;
                              final hydratationStr = hydratationController.text;
                              final systoliqueStr = systoliqueController.text;
                              final diastoliqueStr = diastoliqueController.text;

                              final poids = double.tryParse(poisStr);
                              final pas = int.tryParse(pasStr);
                              final hydratation = double.tryParse(
                                hydratationStr,
                              );
                              final systolique = int.tryParse(systoliqueStr);
                              final diastolique = int.tryParse(diastoliqueStr);

                              final habitude = Habitude(
                                poidHabitude: poids ?? 0.0,
                                nbrPas: pas ?? 0,
                                hydratation: hydratation ?? 0.0,
                                tensionSystolique:
                                    systolique?.toDouble() ?? 0.0,
                                tenstionDiastolique:
                                    diastolique?.toDouble() ?? 0.0,
                                createdAt: DateTime.now(),
                              );

                              habitudeNotifier.ajouterHabitude(habitude);
                              habitudeNotifier.actualiserHabitude();
                              imcNotifire.calculerEtAjouterImc(
                                habitude.poidHabitude,
                              );

                              tensioNotifier.ajouterTensionList(
                                habitude.tensionSystolique,
                                habitude.tenstionDiastolique,
                              );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor:
                                        Couleur.buttonSecondaryColor,
                                    content: Text(
                                      "Habitude ajoutée avec succès",
                                      style: TextStyle(
                                        color: Couleur.backgroundColor,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            "Valider",
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
              ),
            ),
          ),
        );
      },
    );
  }
}
