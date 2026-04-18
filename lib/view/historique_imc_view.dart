import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:vital_care/model/imc_model.dart';
import 'package:vital_care/view/couleur/couleur.dart';
import 'package:vital_care/view/pdf/fonction_pdf.dart';
import 'package:vital_care/view/widget/app_bar_view.dart';
import 'package:vital_care/view/widget/bottom_nav_bar.dart';
import 'package:vital_care/view/widget/container_result.dart';
import 'package:vital_care/view_model/imc_view_model.dart';
import 'package:vital_care/view_model/medicament_view_model.dart';
import 'package:vital_care/view_model/profil_view_model.dart';
import 'package:vital_care/view_model/tension_view_model.dart';

class HistoriqueImcView extends ConsumerWidget {
  const HistoriqueImcView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imcHistorique = ref.watch(icmViewModelProvide);
    ContainerResult containerResult = ContainerResult();
    AppBarView appBarView = AppBarView();
    BottomNavBar bottomNavBar = BottomNavBar();

    return Scaffold(
      backgroundColor: Couleur.backgroundColor,
      appBar: appBarView.appBarPage("Historique"),

      body: Center(
        child: Container(
          color: Couleur.backgroundColor,
          //margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 16),

                  appBarView.appBarHistorique(
                    context,
                    0,
                    Couleur.cardBackgroundColor,
                  ),
                  SizedBox(height: 16),

                  const Text(
                    'Évolution de l\'IMC',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  imcHistorique.when(
                    data: (imcList) {
                      final imcMoyenneAlter = ref.read(
                        icmViewModelProvide.notifier,
                      );
                      final imcMoyenne = imcMoyenneAlter.moyenneImc(imcList);
                      final imcColor = imcMoyenneAlter.couleurIMC(imcMoyenne);
                      final imcInterpretation = imcMoyenneAlter.interpreterIMC(
                        imcMoyenne,
                      );

                      final imcDate = imcMoyenneAlter.moisImc(
                        DateTime.now().month,
                      );
                      if (imcList.isEmpty) {
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
                            child: LineChart(_buildIMCChartData(imcList)),
                          ),

                          SizedBox(height: 16),
                          containerResult.buildHabitudeCard(
                            label: "Moyenn IMC",
                            value: "${imcMoyenne.toInt()}",
                            //heure:
                                //"${DateTime.now().day}/${imcDate.toString()}/${DateTime.now().year}",
                            iconHabitude: "assets/icon/imc.svg",
                            widgetColor: containerResult.buildImcCard(containerColor: imcColor, interpretation: imcInterpretation)
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
                elevation:1,
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

  LineChartData _buildIMCChartData(List<Imc> imcList) {
    // Trier par date
    imcList.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    // Créer les points
    List<FlSpot> spots = [];
    for (int i = 0; i < imcList.length; i++) {
      spots.add(FlSpot(i.toDouble(), imcList[i].valuerImc));
    }

    // Trouver min/max pour l'axe Y
    double minY = imcList
        .map((e) => e.valuerImc)
        .reduce((a, b) => a < b ? a : b);
    double maxY = imcList
        .map((e) => e.valuerImc)
        .reduce((a, b) => a > b ? a : b);

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 5,
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
              if (value.toInt() >= 0 && value.toInt() < imcList.length) {
                final date = imcList[value.toInt()].createdAt;
                return Padding(
                  padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                  child: Text(
                    DateFormat('dd/MM \n HH:mm').format(date),
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
      maxX: (imcList.length - 1).toDouble(),
      minY: (minY - 2).floorToDouble(),
      maxY: (maxY + 2).ceilToDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: const Color(0xFF2196F3),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: Colors.white,
                strokeWidth: 2,
                strokeColor: const Color(0xFF2196F3),
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            color: const Color(0xFF2196F3).withOpacity(0.2),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((spot) {
              final date = imcList[spot.x.toInt()].createdAt;
              return LineTooltipItem(
                'IMC: ${spot.y.toStringAsFixed(1)}\n${DateFormat('dd/MM/yyyy').format(date)}',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }
}
