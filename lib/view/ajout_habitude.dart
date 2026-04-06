import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vital_care/view/couleur/couleur.dart';
import 'package:vital_care/view/widget/text_field_view.dart';

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
    return Scaffold(
      backgroundColor: Couleur.backgroundColor,
      appBar: AppBar(
        title: Text(
          "Prise quotidienne",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Couleur.primaryColor,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            decoration: BoxDecoration(color: Couleur.backgroundColor),
            child: SingleChildScrollView(
              child: Form(
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
