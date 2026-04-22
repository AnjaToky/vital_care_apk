class Urgence {
  String nomHopital;
  String lieu;
  String numeroTel;

  Urgence({required this.nomHopital,required this.lieu, required this.numeroTel});
}

class UrgenceModel {
  final List<Urgence> _listeHopital = [
    Urgence(
      nomHopital: "Polyclinique d'Ilafy",
      lieu: "Ilafy",
      numeroTel: "0385713464",
    ),
    Urgence(
      nomHopital: "CDU",
      lieu: "Lot II U 97 Cité Planton Ampahibe",
      numeroTel: "0000000",
    ),
    Urgence(nomHopital: "Suroit Ambulance",lieu: "Antananarivo", numeroTel: "00000000"),
    Urgence(nomHopital: "Mpitsabo Mikambana",lieu: "Tsiadana", numeroTel: "000000000"),
    Urgence(nomHopital:"Médical Plus", lieu: "Ankaditoho", numeroTel: "0000000"),
    Urgence(nomHopital: "Assistance Plus", lieu: "Ivato", numeroTel: "0000000"),
    Urgence(nomHopital: "Espace Médical", lieu: "Ambodivona", numeroTel: "0000000"),
    Urgence(nomHopital: "Hôpital Befelatanana", lieu: "Mahamasina", numeroTel: "000000000")
  ];

  List<Urgence> afficherList() {
    return _listeHopital;
  }
}
