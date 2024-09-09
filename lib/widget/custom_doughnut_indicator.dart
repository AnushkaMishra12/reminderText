import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class CustomDoughnutIndicator extends StatelessWidget {
  final String label;
  final double badPercentage;
  final double goodPercentage;
  final double excellentPercentage;
  final double averagePercentage;

  const CustomDoughnutIndicator({
    super.key,
    required this.label,
    required this.badPercentage,
    required this.goodPercentage,
    required this.excellentPercentage,
    required this.averagePercentage,
  });

  @override
  Widget build(BuildContext context) {
    const colorBad = Colors.red;
    const colorGood = Colors.green;
    const colorExcellent = Colors.blue;
    const colorAverage = Colors.orangeAccent;

    return Column(
      children: [
        SizedBox(
          width: 115,
          height: 110,
          child: PieChart(
            dataMap: {
              "Bad": badPercentage,
              "Good": goodPercentage,
              "Excellent": excellentPercentage,
              "Average": averagePercentage,
              "Remaining": 100 -
                  (badPercentage +
                      goodPercentage +
                      excellentPercentage +
                      averagePercentage),
            },
            colorList: [
              colorBad,
              colorGood,
              colorExcellent,
              colorAverage,
              Colors.grey.withOpacity(0.3),
            ],
            chartType: ChartType.ring,
            ringStrokeWidth: 15,
            centerText: label,
            centerTextStyle: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black),
            legendOptions: const LegendOptions(showLegends: false),
            chartValuesOptions: const ChartValuesOptions(
              showChartValues: false,
              showChartValuesInPercentage: false,
            ),
          ),
        ),
      ],
    );
  }
}
