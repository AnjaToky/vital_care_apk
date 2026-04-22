import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart' show Permission, PermissionActions, PermissionStatusGetters;
import 'package:url_launcher/url_launcher.dart';
import 'package:vital_care/model/urgence_model.dart';

final urgenceViewModel = Provider<UrgenceModel>((ref) {
  return UrgenceModel();
});

class UrgenceViewModel extends AsyncNotifier<List<Urgence>> {
  @override
  Future<List<Urgence>> build() async {
    final urgenceModel = ref.read(urgenceViewModel);

    // rendre cohérent avec AsyncNotifier
    return Future.value(urgenceModel.afficherList());
  }

  // Future<void> appelerNumero(String nom, String numero) async {
  //   try {
  //     if (numero.isEmpty) {
  //       throw Exception("Numéro invalide pour $nom");
  //     }

  //     final Uri telUri = Uri.parse('tel:$numero');

  //     await launchUrl(telUri, mode: LaunchMode.externalApplication);
  //   } catch (e) {
  //     print("Erreur appel: $e");
  //   }
  // }


  Future<void> appelerNumero(String nom, String numero) async {
  try {
    if (numero.isEmpty) {
      throw Exception("Numéro invalide pour $nom");
    }

    // Demander permission
    final status = await Permission.phone.request();

    if (status.isGranted) {
      final Uri telUri = Uri.parse('tel:$numero');

      await launchUrl(
        telUri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw Exception("Permission refusée");
    }
  } catch (e) {
    print("Erreur appel direct: $e");
  }
}
}

final urgenceViewModelProvider =
    AsyncNotifierProvider<UrgenceViewModel, List<Urgence>>(
      UrgenceViewModel.new,
    );
