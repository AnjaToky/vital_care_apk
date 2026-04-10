import 'package:flutter/material.dart';

class DonneesSante {
  final double? imc;
  final String? interpretationIMC;
  final Color? couleurIMC;
  final double? tam;
  final String? interpretationTension;
  final Color? couleurTension;
  final bool? urgence;
  final double? hydratationRecommandee;
  final String? interpretationHydratation;
  final Color? couleurHydratation;

  const DonneesSante({
    this.imc,
    this.interpretationIMC,
    this.couleurIMC,
    this.tam,
    this.interpretationTension,
    this.couleurTension,
    this.urgence,
    this.hydratationRecommandee,
    this.interpretationHydratation,
    this.couleurHydratation,
  });

  // Données vides par défaut
  static const vide = DonneesSante();
}

class CalculsSante {
  static double calculerIMC(double poids, double taille) {
    if (taille <= 0) return 0;
    double tailleEnMetres = taille / 100;
    return poids / (tailleEnMetres * tailleEnMetres);
  }

  static String interpreterIMC(double imc) {
    if (imc < 18.5) return 'Insuffisance pondérale';
    if (imc < 25) return 'Poids normal';
    if (imc < 30) return 'Surpoids';
    if (imc < 35) return 'Obésité modérée';
    if (imc < 40) return 'Obésité sévère';
    return 'Obésité morbide';
  }

  static Color couleurIMC(double imc) {
    if (imc < 18.5) return Colors.orange;
    if (imc < 25) return Colors.green;
    if (imc < 30) return Colors.orange;
    return Colors.red;
  }

  static double calculerTAM(double systolique, double diastolique) {
    return (systolique + 2 * diastolique) / 3;
  }

  static String interpreterTension(double systolique, double diastolique) {
    if (systolique < 90 || diastolique < 60) {
      return 'Hypotension';
    } else if (systolique < 120 && diastolique < 80) {
      return 'Tension normale';
    } else if (systolique < 130 && diastolique < 80) {
      return 'Tension élevée';
    } else if (systolique < 140 || diastolique < 90) {
      return 'Hypertension stade 1';
    } else if (systolique < 180 || diastolique < 120) {
      return 'Hypertension stade 2';
    } else {
      return 'Crise hypertensive - Urgence';
    }
  }

  static Color couleurTension(double systolique, double diastolique) {
    if (systolique < 90 || diastolique < 60) return Colors.blue;
    if (systolique < 120 && diastolique < 80) return Colors.green;
    if (systolique < 140 || diastolique < 90) return Colors.orange;
    if (systolique >= 180 || diastolique >= 120) return Colors.red;
    return Colors.deepOrange;
  }

  static bool estUrgence(double systolique, double diastolique) {
    return systolique >= 180 || diastolique >= 120;
  }

  static double hydratationRecommandee(double poids) {
    return (poids * 0.033);
  }

  static String interpreterHydratation(
    double hydratationActuelle,
    double hydratationRecommandee,
  ) {
    double pourcentage = (hydratationActuelle / hydratationRecommandee) * 100;

    if (pourcentage < 50) return 'Déshydratation sévère ⚠️';
    if (pourcentage < 75) return 'Hydratation insuffisante';
    if (pourcentage <= 125) return 'Hydratation correcte ✅';
    return 'Hydratation excessive';
  }

  static Color couleurHydratation(
    double hydratationActuelle,
    double hydratationRecommandee,
  ) {
    double pourcentage = (hydratationActuelle / hydratationRecommandee) * 100;

    if (pourcentage < 50) return Colors.red;
    if (pourcentage < 75) return Colors.orange;
    if (pourcentage <= 125) return Colors.green;
    return Colors.blue;
  }
}
