import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vital_care/model/habitude_model.dart';
import 'package:vital_care/view/couleur/couleur.dart';
import 'package:vital_care/view/widget/app_bar_view.dart';
import 'package:vital_care/view/widget/text_field_view.dart';
import 'package:vital_care/view_model/habitude_view_model.dart';
import 'package:vital_care/view_model/imc_view_model.dart';
import 'package:vital_care/view_model/tension_view_model.dart';

class AjoutHabitude extends ConsumerWidget {
  const AjoutHabitude({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController pasController = TextEditingController();
    TextEditingController hydratationController = TextEditingController();
    TextEditingController poidController = TextEditingController();
    TextEditingController systoliqueController = TextEditingController();
    TextEditingController diastoliqueController = TextEditingController();
    TextFieldView textFieldView = TextFieldView();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    AppBarView appBarView = AppBarView();
    final habitudeNotifier = ref.watch(habitudeViewModelProvider.notifier);
    final imcNotifire = ref.watch(icmViewModelProvide.notifier);
    final tensioNotifier = ref.watch(tensionViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: Couleur.backgroundColor,
      appBar: appBarView.appBarPage("Prise quotidienne"),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            decoration: BoxDecoration(color: Couleur.backgroundColor),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    textFieldView.ligneBleu(),
                    textFieldView.buildLabel("Poids atuelle"),
                    textFieldView.buildTextField(
                      poidController,
                      "Poids en kg",
                      TextInputType.number,
                    ),

                    const SizedBox(height: 16),

                    textFieldView.ligneBleu(),
                    textFieldView.buildLabel("Nombre de pas Aujourd'hui"),
                    textFieldView.buildTextField(
                      pasController,
                      "Nombre de pas",
                      TextInputType.number,
                    ),

                    const SizedBox(height: 16),

                    textFieldView.ligneBleu(),
                    textFieldView.buildLabel("Hydratation Aujourd'hui"),
                    textFieldView.buildTextField(
                      hydratationController,
                      "Quantité d'eau en litre",
                      TextInputType.number,
                    ),

                    textFieldView.ligneBleu(),
                    textFieldView.buildLabel("Tension systolique"),
                    textFieldView.buildTextField(
                      systoliqueController,
                      "Tension systolique",
                      TextInputType.number,
                    ),

                    const SizedBox(height: 16),

                    textFieldView.ligneBleu(),
                    textFieldView.buildLabel("Tension diastolique"),
                    textFieldView.buildTextField(
                      diastoliqueController,
                      "Tension diastolique",
                      TextInputType.number,
                    ),

                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            //minimumSize: const Size(50),
                            backgroundColor: Couleur.accentColor,
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
                            Navigator.pushNamed(context, '/habitude_view');
                          },
                          child: Text("Annuler"),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            //minimumSize: const Size(double.infinity, 50),
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
                            final habitude = habitudeAsync.value;
                            if (habitude != null) {
                              habitudeNotifier.supprimerHabitude(habitude.id!);
                            }

                            if (formKey.currentState!.validate()) {
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
                              Navigator.pushNamed(context, '/habitude_view');
                            }
                          },
                          child: Text("Valider"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
