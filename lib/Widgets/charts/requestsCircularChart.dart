
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:testing_app/Api/Request/request.dart';
import 'package:testing_app/Consts/Strings.dart';


class DatumLegendRequestsState extends StatelessWidget {

  final List<charts.Series> seriesList;
  final bool animate;

  DatumLegendRequestsState(this.seriesList, {this.animate});

  factory DatumLegendRequestsState.withSampleData() {
    return new DatumLegendRequestsState(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  factory DatumLegendRequestsState.withRealData(List<RequestElement> data) {
    return new DatumLegendRequestsState(
      _createFromData(data),
      // Disable animations for image tests.
      animate: true,
    );
  }


  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(
      seriesList,
      animate: animate,
      // Add the legend behavior to the chart to turn on legends.
      // This example shows how to optionally show measure and provide a custom
      // formatter.
      behaviors: [
        new charts.DatumLegend(
          // Positions for "start" and "end" will be left and right respectively
          // for widgets with a build context that has directionality ltr.
          // For rtl, "start" and "end" will be right and left respectively.
          // Since this example has directionality of ltr, the legend is
          // positioned on the right side of the chart.
          position: charts.BehaviorPosition.end,
          // By default, if the position of the chart is on the left or right of
          // the chart, [horizontalFirst] is set to false. This means that the
          // legend entries will grow as new rows first instead of a new column.
          horizontalFirst: false,
          // This defines the padding around each legend entry.
          cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
          // Set [showMeasures] to true to display measures in series legend.
          showMeasures: true,
          // Configure the measure value to be shown by default in the legend.
          legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
          // Optionally provide a measure formatter to format the measure value.
          // If none is specified the value is formatted as a decimal.
          measureFormatter: (num value) {

            return value == null ? '-' : requestState[value];
          },
        ),
      ],
    );
  }

   static List<charts.Series<LinearSales, int>> _createFromData(List<RequestElement> list){

    List<LinearSales> temp = new List();
    var tab =[0,0,0,0];



    if(list.isNotEmpty) {
      list.forEach((x) {
        tab[x.request.state]++;
      });

      for (int i = 0; i < 4; i++)
        temp.add(new LinearSales(i, tab[i]));
    }

    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: temp,
      )
    ];


  }



  /// Create series list with one series

  static List<charts.Series<LinearSales, int>> _createSampleData() {
    final data = [
      new LinearSales(0, 100),
      new LinearSales(1, 75),
      new LinearSales(2, 25),
      new LinearSales(3, 5),
    ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);

}