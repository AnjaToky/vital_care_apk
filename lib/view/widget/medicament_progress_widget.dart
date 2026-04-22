import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vital_care/view/couleur/couleur.dart';

class MedicamentProgressWidget extends StatefulWidget {
  final DateTime dateActuelle;
  final DateTime dateObjectif;

  const MedicamentProgressWidget({
    super.key,
    required this.dateActuelle,
    required this.dateObjectif,
  });

  @override
  State<MedicamentProgressWidget> createState() =>
      _MedicamentProgressWidgetState();
}

class _MedicamentProgressWidgetState extends State<MedicamentProgressWidget> {
  Timer? _timer;
  double _value = 0.0;

  // Ta logique de couleur intégrée directement
  Color get _indicatorColor {
    final pourCent = _value * 100;
    if (pourCent > 80) return Couleur.accentColor;
    if (pourCent > 60) return Couleur.alertColor;
    if (pourCent > 40) return Couleur.buttonSecondaryColor;
    if (pourCent > 20) return Couleur.butttonPrimaryColor;
    return Couleur.cardBackgroundColor;
  }

  @override
  void initState() {
    super.initState();
    _calculerValeur();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _calculerValeur());
    });
  }
  
  void _calculerValeur() {
    final totalDuration =
        widget.dateObjectif.difference(widget.dateActuelle).inSeconds;
    final elapsed =
        DateTime.now().difference(widget.dateActuelle).inSeconds;

    _value = totalDuration == 0
        ? 0.0
        : (elapsed / totalDuration).clamp(0.0, 1.0);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final valuePourCent = _value * 100;

    return Container(
      color: Couleur.backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                color: Couleur.backgroundColor,
                width: 150,
                child: LinearProgressIndicator(
                  value: _value,
                  minHeight: 16,
                  backgroundColor: Couleur.inputColor,
                  color: _indicatorColor, // ✅ couleur dynamique
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Text(
                " : ${valuePourCent.toInt()}%",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _indicatorColor, // ✅
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}