

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'HomePage.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:f_datetimerangepicker/f_datetimerangepicker.dart';
import 'Sales.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';

import 'package:charts_flutter/src/text_element.dart';
import 'package:charts_flutter/src/text_style.dart' as style;


class DetailPage extends StatefulWidget {

   DateTime startDate;
   DateTime endDate;
   DocumentSnapshot snapshot;
   DetailPage(DateTime startDate, DateTime endDate, DocumentSnapshot snapshot)
   {
     this.startDate = startDate;
     this.endDate = endDate;
     this.snapshot = snapshot;


   }


  @override

  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {



  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: new AppBar(
        title:  new Text("Tags", style: new TextStyle(color: Colors.white, fontSize: 28),),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child:

        Column(
          children: <Widget>[


            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  //   scrollDirection: Axis.vertical,
                  itemCount: widget.snapshot.data['tags'].length,

                  itemBuilder: (_, index)
                  {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8, left: 8),
                      child: Column(
                        children: <Widget>[
                          Card(
                             color: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),),
                            child: GestureDetector(
                              child: new ListTile(


                                title: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Text("${widget.snapshot.data['tags'][index]['tag']} ", style: new TextStyle(color: Colors.white,fontSize: 16),),
                                    new Text(" ${widget.snapshot.data['tags'][index]['value'].toString()}   ${widget.snapshot.data['tags'][index]['unit'].toString()}"
                                      ,style: new TextStyle(color: Colors.lightGreen, fontSize: 12), ),
                                  ],
                                ),

                              ),
                              onTap: ()
                              {


                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SalesHomePage(widget.snapshot.data['assetcode'],widget.snapshot.data['tags'][index]['tag'],widget.startDate,widget.endDate)),
                                );
                              },

                            ),

                          ),

                          Container(
                              margin: const EdgeInsets.only(left: 8, right: 8),
                              child: Divider(
                                color: Colors.grey[700],
                                height: 36,
                              )),
                        ],
                      ),
                    );
                  }
              ),
            ),
          ],
        ),
           ),

    );

  }
}




class SalesHomePage extends StatefulWidget {
  @override
  String code;
  String tag;
  DateTime StartDate;
  DateTime EndDate;
  SalesHomePage(String code,String tag, DateTime StartDate, DateTime EndDate)
  {
    this.code = code;
    this.tag = tag;
    this.StartDate = StartDate;
    this.EndDate = EndDate;
  }

  _SalesHomePageState createState() {
    return _SalesHomePageState();
  }
}

class _SalesHomePageState extends State<SalesHomePage> {
  List<charts.Series<ChartData, DateTime>> _seriesBarData;
  List<charts.Series<ChartData, DateTime>> _seriesBarData2;
  List<ChartData> mydata;

  List<ChartData> mydata2;

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
          height: 150.0,
          child: new charts.TimeSeriesChart(
              _seriesBarData,
            animate: true,
            selectionModels: [
              new charts.SelectionModelConfig(
                type: charts.SelectionModelType.info,
                changedListener: _onSelectionChanged,
              )
            ],
          )),
    ];

    // If there is a selection, then include the details.
    if (_time != null) {
      children.add(new Padding(
          padding: new EdgeInsets.only(top: 5.0),
          child: new Text(_time.toString())));
    }
    _measures?.forEach((String series, num value) {
      children.add(new Text('${series}: ${value}'));
    });

    return new Column(children: children);
  }



  _generateData(mydata, mydata2) {
    _seriesBarData = List<charts.Series<ChartData, DateTime>>();
    _seriesBarData.add(
      charts.Series(
        domainFn: (ChartData sales, _) => sales.xValue,
        measureFn: (ChartData sales, _) => sales.yValue,

        id: widget.tag,
        data: mydata,
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
      stream: Firestore.instance.collection('DCM').document(widget.code).collection("ENERGY_METERS").where("defaultTimestamp", isLessThanOrEqualTo: Timestamp.fromDate(widget.EndDate)).where("defaultTimestamp", isGreaterThanOrEqualTo: Timestamp.fromDate(widget.StartDate)).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        }
        else {
          print("vhala");

          List<ChartData> sales = <ChartData>[];
          List<ChartData> sales2 = <ChartData>[];

          print(snapshot.data.documents.length);
          for(int index=0;index<snapshot.data.documents.length;index++)
          {       print(index);
          DocumentSnapshot documentSnapshot = snapshot.data.documents[index];
          print(documentSnapshot.documentID);
          sales.add(ChartData.fromSnapshot(documentSnapshot, widget.tag));

          sales2.add(ChartData.fromSnapshot(documentSnapshot, "V1"));


            //  print(sales.toString());
          }
          return _buildChart(context, sales, sales2);
        }
      },
    );


  }
  Widget _buildChart(BuildContext context, List<ChartData> saledata, List<ChartData> saledata2) {
    mydata = saledata;
    mydata2 = saledata2;


    _generateData(mydata, mydata2);
    Orientation orientation = MediaQuery.of(context).orientation;
    if(orientation == Orientation.portrait)
      {
       return Container(
         color: Colors.black,
         width: MediaQuery.of(context).size.width,
         height: MediaQuery.of(context).size.height,
          child: Center(
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    new SizedBox(
                      height: 15,
                    ),

                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: <Widget>[
                          GestureDetector(child: Image.asset("assets/images/back.png")
                            ,
                            onTap: ()
                            {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),


                    Container(
                      color: Colors.grey[900],
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Stack(
                          children: <Widget>[
                            Row(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                new Text("DCM LONI", style: new TextStyle(color: Colors.white, fontSize: 22,),),


                                // Image.asset("assets/images/alerts.png"),
                              ],
                            ),


                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Image.asset("assets/images/alerts.png"),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),


                    //  new Text("Date Time Range", style:  new TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                    new SizedBox(
                      height: 10,
                    ),


                    new Text("Rotate the screen to view graph"),
                  ],
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Image.asset("assets/images/nicback.png"),
                  ],
                )
              ],
            ),
          ),
        );
      }
    else

    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                 widget.code,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.tag,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: Container(
                  child:

                   charts.TimeSeriesChart(_seriesBarData,
                    animate: true,

                    //   animationDuration: Duration(seconds:5),
                    behaviors: [

                      new charts.ChartTitle('Time',
                          behaviorPosition: charts.BehaviorPosition.bottom,
                          titleOutsideJustification:
                          charts.OutsideJustification.middleDrawArea),
                      new charts.ChartTitle(widget.tag,
                          behaviorPosition: charts.BehaviorPosition.start,
                          titleOutsideJustification:
                          charts.OutsideJustification.middleDrawArea),
                      new charts.PanAndZoomBehavior(),
                     // new charts.SeriesLegend(),

                      LinePointHighlighter(symbolRenderer: CustomCircleSymbolRenderer())

                    ],

                    selectionModels: [
                      SelectionModelConfig(changedListener: (SelectionModel model) {
                        if (model.hasDatumSelection)
                          pointerValue = model.selectedSeries[0]
                              .measureFn(model.selectedDatum[0].index)
                              .toString();



                           datevalue= DateFormat('MM/dd/yyyy HH:mm:ss').format(model.selectedSeries[0]
                               .domainFn(model.selectedDatum[0].index)).toString();
                           tag = widget.tag;
                      })
                    ],



                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomCircleSymbolRenderer extends CircleSymbolRenderer {
  @override
  void paint(ChartCanvas canvas, Rectangle bounds,
      {List dashPattern,
        Color fillColor,
        Color strokeColor,
        double strokeWidthPx}) {
    super.paint(canvas, bounds,
        dashPattern: dashPattern,
        fillColor: fillColor,
        strokeColor: strokeColor,
        strokeWidthPx: strokeWidthPx);
    canvas.drawRect(
        Rectangle(bounds.left - 5, bounds.top - 30, bounds.width + 10,
            bounds.height + 10),
        fill: Color.white);
    var textStyle = style.TextStyle();
    textStyle.color = Color.black;
    textStyle.fontSize = 15;
    canvas.drawText(
        TextElement("${_SalesHomePageState.tag}:   ${_SalesHomePageState.pointerValue}  \nTime: ${_SalesHomePageState.datevalue}   ", style: textStyle),


        (bounds.left).round(),
        (bounds.top - 28).round());
  }

}





