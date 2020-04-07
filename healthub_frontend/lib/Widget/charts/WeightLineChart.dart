// Line chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:healthub_frontend/Model/Weight.dart';

class WeightLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  WeightLineChart(this.seriesList, {this.animate});

  /// Creates a [LineChart] with sample data and no transition.
  factory WeightLineChart.withWeights(weights) {
    return new WeightLineChart(
      _createWeightsData(weights),
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(seriesList,
        animate: animate,
        behaviors: [
          new charts.ChartTitle('Date',
              behaviorPosition: charts.BehaviorPosition.bottom,
              titleOutsideJustification:
                  charts.OutsideJustification.middleDrawArea),
          new charts.ChartTitle('Weight',
              behaviorPosition: charts.BehaviorPosition.top,
              titleOutsideJustification: charts.OutsideJustification.start,
              // Set a larger inner padding than the default (10) to avoid
              // rendering the text too close to the top measure axis tick label.
              // The top tick label may extend upwards into the top margin region
              // if it is located at the top of the draw area.
              innerPadding: 18),
        ],
        defaultRenderer: new charts.LineRendererConfig(includePoints: true));
  }

  static List<charts.Series<Weight, DateTime>> _createWeightsData(weights) {
    return [
      new charts.Series<Weight, DateTime>(
        id: 'Weights',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Weight weight, _) => weight.timestamp,
        measureFn: (Weight weight, _) => weight.weight,
        data: weights,
      ),
    ];
  }
}
