// Line chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:healthub_frontend/Model/Sleep.dart';

class SleepBarChart extends StatelessWidget {
  final List<charts.Series<Sleep, DateTime>> seriesList;
  final bool animate;

  SleepBarChart(this.seriesList, {this.animate});

  /// Creates a [LineChart] with sample data and no transition.
  factory SleepBarChart.withSleeping(sleeping) {
    return new SleepBarChart(
      _createSleepData(sleeping),
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      behaviors: [
        new charts.SelectNearest(),
        new charts.DomainHighlighter(),
        new charts.ChartTitle('Date',
            behaviorPosition: charts.BehaviorPosition.bottom,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
        new charts.ChartTitle('Hours Asleep',
            behaviorPosition: charts.BehaviorPosition.top,
            titleOutsideJustification: charts.OutsideJustification.start,
            // Set a larger inner padding than the default (10) to avoid
            // rendering the text too close to the top measure axis tick label.
            // The top tick label may extend upwards into the top margin region
            // if it is located at the top of the draw area.
            innerPadding: 18),
      ],
      defaultRenderer: new charts.BarRendererConfig<DateTime>(),
      defaultInteractions: false,
    );
  }

  static List<charts.Series<Sleep, DateTime>> _createSleepData(sleeping) {
    return [
      new charts.Series<Sleep, DateTime>(
        id: 'Sleep',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (Sleep sleep, _) => sleep.sleepingTime,
        measureFn: (Sleep sleep, _) => sleep.duration,
        data: sleeping,
      ),
    ];
  }
}
