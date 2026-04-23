import 'dart:io';

import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:vital_care/model/imc_model.dart';
import 'package:vital_care/model/medicament_model.dart';
import 'package:vital_care/model/profil_model.dart';
import 'package:vital_care/model/tension_model.dart';

class FonctionPdf {
  Future<File> generateHealthPdf({
    required Profil? profil,
    required List<Imc> imcList,
    required List<Medicament> medicaments,
    required List<Tension> tension,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(margin: const pw.EdgeInsets.all(24)),
        build: (context) => [
          pw.Center(
            child: pw.Text(
              "RAPPORT DE SANTÉ",
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            "Profil",
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.Divider(),
          pw.Text("Nom : ${profil!.name}"),
          pw.Text("Âge : ${profil.age}"),
          pw.Text("Taille : ${profil.taille} m"),
          pw.Text("Poids : ${profil.poids} kg"),
          pw.SizedBox(height: 20),
          pw.Text(
            "📊 Historique IMC",
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.Divider(),
          pw.Table.fromTextArray(
            headers: ["Date", "IMC"],
            data: imcList
                .map(
                  (imc) => [
                    imc.createdAt.toString().split(" ")[0],
                    imc.valuerImc.toStringAsFixed(2),
                  ],
                )
                .toList(),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            "📊 Historique Tension",
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.Divider(),
          pw.Table.fromTextArray(
            headers: ["Date", "Systolique", "Diastolique"],
            data: tension
                .map(
                  (t) => [
                    t.createdAt.toString().split(" ")[0],
                    t.tensionSystolique.toStringAsFixed(2),
                    t.tensionDiastolique.toStringAsFixed(2),
                  ],
                )
                .toList(),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            "💊 Médicaments",
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.Divider(),
          pw.Table.fromTextArray(
            headers: ["Nom", "Dosage", "Fréquence", "Heure", "Statut"],
            data: medicaments
                .map(
                  (m) => [
                    m.nom,
                    "${m.dosage} mg",
                    m.frequence,
                    m.heure.hour,
                    if (m.status == MedicamentStatus.enAttente)
                      "En Attente"
                    else if (m.status == MedicamentStatus.valider)
                      "Valider"
                    else
                      "Manquer",
                  ],
                )
                .toList(),
          ),
          pw.SizedBox(height: 20),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              "Généré le : ${DateTime.now().toString().split(' ')[0]}",
              style: pw.TextStyle(fontSize: 10),
            ),
          ),
        ],
      ),
    );

    // ================= SAVE FILE =================
    final file = await _saveToDownloads(pdf);
    await OpenFilex.open(file.path);
    return file;
  }

  // ================= MÉTHODE SAUVEGARDE =================
  Future<File> _saveToDownloads(pw.Document pdf) async {
    final bytes = await pdf.save();

    if (Platform.isAndroid) {
      try {
        // Demande permission
        await Permission.storage.request();
        await Permission.manageExternalStorage.request();

        // ✅ Utilise getExternalStorageDirectories au lieu de getExternalStorageDirectory
        final dirs = await getExternalStorageDirectories(
          type: StorageDirectory.downloads,
        );

        if (dirs != null && dirs.isNotEmpty) {
          final file = File("${dirs.first.path}/rapport_sante.pdf");

          if (!await dirs.first.exists()) {
            await dirs.first.create(recursive: true);
          }

          await file.writeAsBytes(bytes);
          print("✅ PDF sauvegardé : ${file.path}");
          return file;
        }
      } catch (e) {
        print("❌ Erreur dossier externe : $e");
      }

      // ✅ Fallback absolu — toujours accessible sans permission
      try {
        final dir = await getApplicationDocumentsDirectory();
        final file = File("${dir.path}/rapport_sante.pdf");
        await file.writeAsBytes(bytes);
        print("PDF sauvegardé (fallback) : ${file.path}");
        return file;
      } catch (e) {
        print("Erreur fallback : $e");
        rethrow;
      }
    } else if (Platform.isIOS) {
      final dir = await getApplicationDocumentsDirectory();
      final file = File("${dir.path}/rapport_sante.pdf");
      await file.writeAsBytes(bytes);
      return file;
    }

    throw Exception("Plateforme non supportée");
  }
}
