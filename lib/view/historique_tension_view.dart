import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vital_care/model/tension_model.dart';
import 'package:vital_care/view/couleur/couleur.dart';
import 'package:vital_care/view/pdf/fonction_pdf.dart';
import 'package:vital_care/view/widget/app_bar_view.dart';
import 'package:vital_care/view/widget/bottom_nav_bar.dart';
import 'package:vital_care/view/widget/container_result.dart';
import 'package:vital_care/view_model/imc_view_model.dart';
import 'package:vital_care/view_model/medicament_view_model.dart';
import 'package:vital_care/view_model/profil_view_model.dart';
import 'package:vital_care/view_model/tension_view_model.dart';

class HistoriqueTensionView extends ConsumerWidget {
  const HistoriqueTensionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tensionHistorique = ref.watch(tensionViewModelProvider);
    AppBarView appBarView = AppBarView();
    BottomNavBar bottomNavBar = BottomNavBar();
    ContainerResult containerResult = ContainerResult();

    return Scaffold(
      backgroundColor: Couleur.backgroundColor,
      appBar: appBarView.appBarPage("Historique"),
      body: Container(
        color: Couleur.backgroundColor,
        //margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 16),

                appBarView.appBarHistorique(
                  context,
                  1,
                  Couleur.cardBackgroundColor,
                ),
                SizedBox(height: 16),

                const Text(
                  'Évolution de la Tension',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                // Légende
                Row(
                  children: [
                    _buildLegend(Colors.red, 'Systolique'),
                    const SizedBox(width: 16),
                    _buildLegend(Colors.blue, 'Diastolique'),
                  ],
                ),
                const SizedBox(height: 20),
                tensionHistorique.when(
                  data: (tensionList) {
                    final tensionAlter = ref.read(
                      tensionViewModelProvider.notifier,
                    );
                    final systolique = tensionAlter.moyenneTensionSystolique(
                      tensionList,
                    );
                    final diastolique = tensionAlter.moyenneTensionDiastolique(
                      tensionList,
                    );
                    final tensionDate = tensionAlter.moisTension(
                      DateTime.now().month,
                    );

                    final intepretation = tensionAlter.interpreterTension(
                      systolique,
                      diastolique,
                    );
                    final couleurTension = tensionAlter.couleurTension(
                      systolique,
                      diastolique,
                    );

                    if (tensionList.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: Text('Aucune donnée disponible'),
                        ),
                      );
                    }

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 250,
                          child: LineChart(_buildTensionChartData(tensionList)),
                        ),

                        SizedBox(height: 16),

                        containerResult.buildHabitudeCard(
                          label: "Moyenne Tension",
                          value: "${systolique.toInt()}/${diastolique.toInt()}",
                          //heure:
                          //"${DateTime.now().day}/${tensionDate.toString()}",
                          iconHabitude: "assets/icon/tension.svg",
                          widgetColor: containerResult.buildImcCard(
                            containerColor: couleurTension,
                            interpretation: intepretation,
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (error, stack) =>
                      Center(child: Text('Erreur: $error')),
                ),
              ],
            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Couleur.backgroundColor,

        onPressed: () async {
          try {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );

            final profilAsync = ref.watch(profilViewModelProvider);
            final imcAsync = ref.watch(icmViewModelProvide);
            final medicamentAsync = ref.watch(medicamentViewModelProvider);
            final tensionasync = ref.watch(tensionViewModelProvider);
            FonctionPdf pdf = FonctionPdf();

            profilAsync.when(
              data: (profil) {
                return imcAsync.when(
                  data: (imcList) {
                    return medicamentAsync.when(
                      data: (medicamentEnAtente) {
                        return tensionasync.when(
                          data: (tensionList) {
                            pdf.generateHealthPdf(
                              profil: profil,
                              imcList: imcList,
                              medicaments: medicamentEnAtente,
                              tension: tensionList,
                            );
                          },
                          error: (e, s) => "",
                          loading: () => "",
                        );
                      },
                      error: (e, s) => "",
                      loading: () => "",
                    );
                  },
                  error: (e, s) => "",
                  loading: () => "",
                );
              },
              error: (e, s) => "",
              loading: () => "",
            );

            Navigator.pop(context); // fermer loader

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                elevation: 1,
                backgroundColor: Couleur.buttonSecondaryColor,
                content: Text(
                  "PDF généré avec succès ",
                  style: TextStyle(color: Couleur.backgroundColor),
                ),
              ),
            );
          } catch (e) {
            Navigator.pop(context);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Couleur.accentColor,
                content: Text(
                  "Erreur lors de l'export",
                  style: TextStyle(color: Couleur.backgroundColor),
                ),
              ),
            );
          }
        },
        icon: Icon(Icons.download),
        label: Text("Exporter PDF", style: TextStyle(color: Couleur.textColor)),
      ),

      bottomNavigationBar: bottomNavBar.buildBottomNavBar(context, ref),
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Container(width: 20, height: 3, color: color),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  LineChartData _buildTensionChartData(List<Tension> tensionList) {
    // Trier par date
    tensionList.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    // Créer les points pour systolique
    List<FlSpot> spotsSystolique = [];
    for (int i = 0; i < tensionList.length; i++) {
      spotsSystolique.add(
        FlSpot(i.toDouble(), tensionList[i].tensionSystolique),
      );
    }

    // Créer les points pour diastolique
    List<FlSpot> spotsDiastolique = [];
    for (int i = 0; i < tensionList.length; i++) {
      spotsDiastolique.add(
        FlSpot(i.toDouble(), tensionList[i].tensionDiastolique),
      );
    }

    // Trouver min/max pour l'axe Y
    List<double> allValues = [
      ...tensionList.map((e) => e.tensionSystolique),
      ...tensionList.map((e) => e.tensionDiastolique),
    ];
    double minY = allValues.reduce((a, b) => a < b ? a : b);
    double maxY = allValues.reduce((a, b) => a > b ? a : b);

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(color: Colors.grey.withOpacity(0.3), strokeWidth: 1);
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              if (value.toInt() >= 0 && value.toInt() < tensionList.length) {
                final date = tensionList[value.toInt()].createdAt;
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    DateFormat('dd/MM \n HH/mm').format(date),
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              }
              return const Text('');
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toStringAsFixed(0),
                style: const TextStyle(fontSize: 12),
              );
            },
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      minX: 0,
      maxX: (tensionList.length - 1).toDouble(),
      minY: (minY - 10).floorToDouble(),
      maxY: (maxY + 10).ceilToDouble(),
      lineBarsData: [
        // Ligne Systolique (rouge)
        LineChartBarData(
          spots: spotsSystolique,
          isCurved: true,
          color: Colors.red,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: Colors.white,
                strokeWidth: 2,
                strokeColor: Colors.red,
              );
            },
          ),
          belowBarData: BarAreaData(show: false),
        ),
        // Ligne Diastolique (bleue)
        LineChartBarData(
          spots: spotsDiastolique,
          isCurved: true,
          color: Colors.blue,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: Colors.white,
                strokeWidth: 2,
                strokeColor: Colors.blue,
              );
            },
          ),
          belowBarData: BarAreaData(show: false),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((spot) {
              final date = tensionList[spot.x.toInt()].createdAt;
              final isSystolique = spot.barIndex == 0;
              return LineTooltipItem(
                '${isSystolique ? "Sys" : "Dia"}: ${spot.y.toStringAsFixed(0)}\n${DateFormat('dd/MM/yyyy').format(date)}',
                TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: isSystolique ? 12 : 11,
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }
}
