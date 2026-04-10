import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:vital_care/view/ajout_habitude.dart';
import 'package:vital_care/view/ajout_profil_view.dart';
import 'package:vital_care/view/auth_guard_view.dart';
import 'package:vital_care/view/biometric_auth_view.dart';
import 'package:vital_care/view/habitude_view.dart';
import 'package:vital_care/view/historique_view.dart';
import 'package:vital_care/view/home_view.dart';
import 'package:vital_care/view/profil_view.dart';
import 'package:vital_care/view/medicament_view.dart';
import 'package:vital_care/view/urgence_view.dart';

void main() {
  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vital Care',
      home: ProfilView(),
      //initialRoute: '/profil',
      routes: {
        '/profil': (context) => ProfilView(),
        '/ajout_profil': (context) => AjoutProfilView(),
        '/medicament': (context) => MedicamentView(),
        '/habitude_view': (context) => HabitudeView(),
        '/ajout_habitude': (context) => AjoutHabitude(),
        '/home': (context) => HomeView(),
        '/urgence': (context) => UrgenceView(),
        '/historique': (context) => HistoriqueView(),
        '/biometrie': (context) =>
            const AuthGuardView(child: BiometricAuthView()),
      },
    );
  }
}
