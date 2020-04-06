// Line chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:healthub_frontend/Model/Activity.dart';

class ActivityBarChart extends StatelessWidget {
  final List<charts.Series<Activity, DateTime>> seriesList;
  final bool animate;

  ActivityBarChart(this.seriesList, {this.animate});

  /// Creates a [LineChart] with sample data and no transition.
  factory ActivityBarChart.withActivities(activities) {
    return new ActivityBarChart(
      _createActivityData(activities),
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
        new charts.ChartTitle('Calories Burned',
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

  static List<charts.Series<Activity, DateTime>> _createActivityData(activity) {
    return [
      new charts.Series<Activity, DateTime>(
        id: 'Activities',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (Activity activity, _) => activity.date,
        measureFn: (Activity activity, _) => activity.caloriBurned,
        data: activity,
      ),
    ];
  }
}
