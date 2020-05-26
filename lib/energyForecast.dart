import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:charts_flutter/flutter.dart';

import 'package:intl/intl.dart';
import 'package:f_datetimerangepicker/f_datetimerangepicker.dart';
import 'forecastData.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class basePage extends StatefulWidget {
  @override
  _basePageState createState() => _basePageState();
}

class _basePageState extends State<basePage> {
  @override

  DateTime _endDate = DateTime.now();
  DateTime _startDate = DateTime.now().subtract(Duration(hours: 2));

  Future displayDateRangePicker(BuildContext context) async {
    DateTimeRangePicker(
        startText: "From",
        endText: "To",
        doneText: "Done",
        cancelText: "Cancel",
        interval: 5,

        initialStartTime: DateTime.now(),
        initialEndTime: DateTime.now().add(Duration(days: 20)),
        mode: DateTimeRangePickerMode.dateAndTime,
        onConfirm: (start, end) {
          setState(() {
            _startDate = start;
            _endDate = end;
          });


        }).showPicker(context);



  }


  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: new AppBar(
        title: new Text("Energy Forecast"),

      ),
      body: Container(

        child:Column(
          children: <Widget>[


            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: GestureDetector(
                child: Container(
                  decoration: ShapeDecoration(
                    //color: Colors.white,
                    shape: RoundedRectangleBorder(

                      side: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.grey[700]),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new SizedBox(
                          height: 12,
                        ),
                        Text(" ${DateFormat('MM/dd/yyyy HH:mm:ss').format(_startDate).toString()} to ${DateFormat('MM/dd/yyyy HH:mm:ss').format(_endDate).toString()}", style: new TextStyle(color: Colors.white, fontSize: 16),),
                        // Expanded(child: Text(" ${DateFormat('MM/dd/yyyy HH:mm:ss').format(_endDate).toString()}")),

                        new SizedBox(
                          height: 18,
                        ),
                      ],
                    ),
                  ),
                ),

                onTap: () async
                {
                  await displayDateRangePicker(context);
                  print(_startDate);
                  print(_endDate);
                },
              ),
            ),


            new SizedBox(
              height: 50,
            ),


            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.only(right: 15, left: 15),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(40)),

                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Colors.lightGreen[500], Colors.lightGreenAccent])),
                  child: Text(
                    'Apply',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
              onTap: ()
              {

                Navigator.push(context, MaterialPageRoute(builder: (context) => energyForecastPage(_startDate,_endDate)),);


              },
            ),

          ],
        ),
      ),
    );
  }
}





class energyForecastPage extends StatefulWidget {
  @override


  DateTime StartDate;
  DateTime EndDate;
  energyForecastPage( DateTime StartDate, DateTime EndDate)
  {

    this.StartDate = StartDate;
    this.EndDate = EndDate;
  }

  _energyForecastPageState createState() {
    return _energyForecastPageState();
  }
}

class _energyForecastPageState extends State<energyForecastPage> {
  List<charts.Series<ChartData, DateTime>> _seriesBarData;
  List<charts.Series<ChartData, DateTime>> _seriesBarData2;
  List<ChartData> mydata;

  List<ChartData> mydata2;

  List<ChartData> mydata3;

  static String v1value;
  static String pointerValue;
  static String datevalue;
  static String tag;



  DateTime _time;
  Map<String, num> _measures;

  // Listens to the underlying selection changes, and updates the information
  // relevant to building the primitive legend like information under the
  // chart.
  _onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;
    print("chala mein");
    DateTime time;
    final measures = <String, num>{};

    // We get the model that updated with a list of [SeriesDatum] which is
    // simply a pair of series & datum.
    //
    // Walk the selection updating the measures map, storing off the sales and
    // series name for each selection point.
    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum.xValue;
      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        measures[datumPair.series.displayName] = datumPair.datum.yValue;
      });
    }

    // Request a build.
    setState(() {
      _time = time;
      _measures = measures;
    });
  }

  @override
  Widget build2(BuildContext context) {
    // The children consist of a Chart and Text widgets below to hold the info.
    final children = <Widget>[
      new SizedBox(
          height: MediaQuery.of(context).size.height/1.25,
          child: new charts.TimeSeriesChart(
            _seriesBarData,
            animate: true,
            selectionModels: [
              new charts.SelectionModelConfig(
                type: charts.SelectionModelType.info,
                changedListener: _onSelectionChanged,
              )
            ],

            behaviors: [

              new charts.PanAndZoomBehavior(),
              new charts.SeriesLegend(),


            ],
          )),
    ];

    // If there is a selection, then include the details.
    if (_time != null) {
      children.add(new Padding(
          padding: new EdgeInsets.only(top: 5.0),
          child: new Text(" Time :  ${DateFormat('MM/dd/yyyy HH:mm:ss').format(_time).toString()}")));
    }
    _measures?.forEach((String series, num value) {
      children.add(new Text('${series} : ${value}'));
    });

    return new Column(children: children);
  }



  _generateData(mydata, mydata2, mydata3) {
    _seriesBarData = List<charts.Series<ChartData, DateTime>>();
    _seriesBarData.add(
      charts.Series(
        domainFn: (ChartData sales, _) => sales.xValue,
        measureFn: (ChartData sales, _) => sales.yValue,

        id: 'Actual Value',
        data: mydata,
        // labelAccessorFn: (ChartData row, _) => "${row.xValue}",
      ),
    );


    _seriesBarData.add(
      charts.Series(
        domainFn: (ChartData sales, _) => sales.xValue,
        measureFn: (ChartData sales, _) => sales.yValue,

        id: 'Forecast Value',
        data: mydata2,
        // labelAccessorFn: (ChartData row, _) => "${row.xValue}",
      ),
    );


    _seriesBarData.add(
      charts.Series(
        domainFn: (ChartData sales, _) => sales.xValue,
        measureFn: (ChartData sales, _) => sales.yValue,

        id: 'Deviation',
        data: mydata3,
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
       // labelAccessorFn: (ChartData row, _) => "${row.xValue}",
      ),
    );


  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _buildBody(context),

    );
  }

  Widget _buildBody(BuildContext context) {
    return   StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('DCM_SLDC').document('2020-02-12').collection("Live").where("timestamp", isLessThanOrEqualTo: Timestamp.fromDate(widget.EndDate)).where("timestamp", isGreaterThanOrEqualTo: Timestamp.fromDate(widget.StartDate)).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        }
        else {
          print("vhala");

          List<ChartData> sales = <ChartData>[];
          List<ChartData> sales2 = <ChartData>[];

          List<ChartData> sales3 = <ChartData>[];

          print(snapshot.data.documents.length);
          for(int index=0;index<snapshot.data.documents.length;index++)
          {       print(index);
          DocumentSnapshot documentSnapshot = snapshot.data.documents[index];
          print(documentSnapshot.documentID);
          sales.add(ChartData.fromSnapshot(documentSnapshot,"actualValue"));

          sales2.add(ChartData.fromSnapshot(documentSnapshot, "forecastValue"));
          sales3.add(ChartData.fromSnapshot(documentSnapshot, "fo"));



            //  print(sales.toString());
          }
          return _buildChart(context, sales, sales2, sales3);
        }
      },
    );


  }
  Widget _buildChart(BuildContext context, List<ChartData> saledata, List<ChartData> saledata2, List<ChartData> saledata3) {
    mydata = saledata;
    mydata2 = saledata2;
    mydata3 = saledata3;


    _generateData(mydata, mydata2, mydata3);


      return Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                Text(
                  "Energy Forecast",
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),

                SizedBox(
                  height: 10.0,
                ),
                Expanded(
                  child: build2(context)
                ),
              ],
            ),
          ),
        ),
      );
  }
}
