import 'package:flutter/material.dart';
import 'package:vital_care/view/couleur/couleur.dart';

class TextFieldView {
  Widget ligneBleu() {
    return Container(
      height: 2,
      width: double.infinity,
      color: Couleur.primaryColor,
      margin: const EdgeInsets.symmetric(vertical: 16),
    );
  }

  Widget buildTextField(
    TextEditingController controller,
    String label, [
    TextInputType keyboardType = TextInputType.text,
  ]) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Couleur.textColor,fontSize: 16),
        hintStyle: TextStyle(color: Couleur.textColor),
        filled: true,
        fillColor: Couleur.inputColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Couleur.textColor, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Couleur.backgroundColor, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Couleur.primaryColor, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ce champ est requis';
        }
        return null;
      },
    );
  }
}
