import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/intl.dart';
import 'package:f_datetimerangepicker/f_datetimerangepicker.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'tv.dart';
import 'package:search_choices/search_choices.dart';
import 'loadProdData.dart';


class loadPage extends StatefulWidget {
  @override
  Set<String> departments;
  List<Data> finalData;
  String dropDownValue;

  loadPage(Set<String> departments, List<Data> finalData, String dropDownValue)
  {
    this.departments = departments;
    this.finalData = finalData;
    this.dropDownValue = dropDownValue;
  }



  _loadPageState createState() => _loadPageState();
}

class _loadPageState extends State<loadPage> {
  @override

  DateTime _endDate = DateTime.now();
  DateTime _startDate = DateTime.now().subtract(Duration(hours: 2));

  List<charts.Series<ChartData, DateTime>> _seriesBarData = [];

  String timingDropDown;
  String dropDownValue2;
  String assetCode;
  List<String> assets =[] ;
  List<int> multiplechoices =[];
  List<String> assetCodes = [];
  List<String> assetNames = [];
  List<String> timing = ["Active_Consumption_Day", "Active_Consumption_Hourly","Active_Consumption_in_Evening_Shift",
                           "Active_Consumption_in_Morning_Shift","Active_Consumption_in_Night_Shift"];

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


  getGraph() async
  {
      _seriesBarData = [];
    for (int i = 0; i < assetCodes.length; i++) {
      var firestore = Firestore.instance;
      QuerySnapshot qn = await firestore.collection("DCM_KPI").document(
          timingDropDown).collection(assetCodes[i]).where(
          "timestamp", isLessThanOrEqualTo: Timestamp.fromDate(_endDate))
          .where(
          "timestamp", isGreaterThanOrEqualTo: Timestamp.fromDate(_startDate))
          .getDocuments();

      List<ChartData> sales = <ChartData>[];


      print(qn.documents.length);
      for (int index = 0; index < qn.documents.length; index++) {
        print(index);
        DocumentSnapshot documentSnapshot = qn.documents[index];
        print(documentSnapshot.documentID);
        sales.add(ChartData.fromSnapshot(documentSnapshot));
      }

      _seriesBarData.add(
        charts.Series(
          domainFn: (ChartData sales, _) => sales.xValue,
          measureFn: (ChartData sales, _) => sales.yValue,

          id: assetNames[i],
          data: sales,
          // labelAccessorFn: (ChartData row, _) => "${row.xValue}",
        ),
      );

    }


    Navigator.push(context, MaterialPageRoute(builder: (context) => loadProdGraph(_seriesBarData)),);
  }


  Widget DropDown(BuildContext context) {

    for(var f in widget.finalData) {

      if (f.groupid == widget.dropDownValue) {
        print("loop chala");
        assets =[];
        for(int i=0;i<f.assets.length;i++)
        {
          assets.add(f.assets[i][0]);
        }

        return Padding(
          padding: const EdgeInsets.only(right: 20, left: 20),
          child: Container(

            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1.0, style: BorderStyle.solid, color: Colors.grey[700]),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
            ),

            child: Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Colors.black,
              ),
              child: SearchChoices.multiple(

                  selectedItems: multiplechoices,
                  hint: new Text("Select Asset", style: new TextStyle(color: Colors.white),),
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down,color: Colors.lightGreen,),
                  underline: Container(
                    color: Colors.black,
                  ),


                  selectedValueWidgetFn: (item) {
                    return Container(
                        transform: Matrix4.translationValues(-10,0,0),
                        alignment: Alignment.centerLeft,
                        child: (Text(item.toString() ,overflow: TextOverflow.ellipsis, style: new TextStyle(color: Colors.white),)));
                  },

                  displayClearIcon:false,

                  onChanged: (value) {
                    setState(() {
                      assetCodes =[];
                      assetNames = [];
                     multiplechoices = value;
                     print(multiplechoices);
                      //getEnergyConsumed();

                      for(int i=0;i<multiplechoices.length;i++)
                        {
                           for(int j=0;j<f.assets.length;j++)
                             {
                               if(f.assets[j][0] == assets[multiplechoices[i]])
                                 {
                                   assetCodes.add(f.assets[j][1]);
                                   assetNames.add(f.assets[j][0]);
                                   break;
                                 }
                             }
                        }
                      print(assetCodes);


                    });
                  },
                  items: assets
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,),

                    );
                  })
                      .toList()
              ),
            ),
          ),
        );

      }
    }

  }





  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: new AppBar(
        title: new Text("Load page"),
      ),

      body: Container(
        child: Column(
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
              height: 20,
            ),


            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: Container(
                //   width:  350,
                // color: Colors.white,
                decoration: ShapeDecoration(
                  //color: Colors.white,
                  shape: RoundedRectangleBorder(

                    side: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.grey[700]),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Colors.black,
                  ),
                  child: SearchChoices.single(

                      value:widget.dropDownValue,
                      isExpanded: true,
                      // style: Theme.of(context).textTheme.title,
                      icon: Icon(Icons.arrow_drop_down,color: Colors.lightGreen,),
                      underline:  Container(
                        color: Colors.black,
                      ),

                      selectedValueWidgetFn: (item) {
                        return Container(
                            transform: Matrix4.translationValues(-10,0,0),
                            alignment: Alignment.centerLeft,
                            child: (Text(item.toString() ,overflow: TextOverflow.ellipsis, style: new TextStyle(color: Colors.white),)));
                      },

                      displayClearIcon: false,
                      onChanged: (String newValue) {

                        setState(() {
                          widget.dropDownValue = newValue;
                          multiplechoices = [];
                          assetCodes =[];


                        });

                      },


                      items: widget.departments

                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                          ),

                        );
                      })
                          .toList()
                  ),
                ),
              ),
            ),

            new SizedBox(
              height: 20,
            ),

            DropDown(context),

            new SizedBox(
              height: 20,
            ),

            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: Container(
                //   width:  350,
                // color: Colors.white,
                decoration: ShapeDecoration(
                  //color: Colors.white,
                  shape: RoundedRectangleBorder(

                    side: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.grey[700]),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Colors.black,
                  ),
                  child: SearchChoices.single(

                      value:timingDropDown,
                      isExpanded: true,
                      // style: Theme.of(context).textTheme.title,
                      icon: Icon(Icons.arrow_drop_down,color: Colors.lightGreen,),
                      underline:  Container(
                        color: Colors.black,
                      ),

                      selectedValueWidgetFn: (item) {
                        return Container(
                            transform: Matrix4.translationValues(-10,0,0),
                            alignment: Alignment.centerLeft,
                            child: (Text(item.toString() ,overflow: TextOverflow.ellipsis, style: new TextStyle(color: Colors.white),)));
                      },

                      displayClearIcon: false,
                      onChanged: (String newValue) {

                        setState(() {
                          timingDropDown = newValue;
                            print(timingDropDown);

                        });

                      },


                      items: timing

                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                          ),

                        );
                      })
                          .toList()
                  ),
                ),
              ),
            ),



            new SizedBox(
              height: 20,
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

                Navigator.push(context, MaterialPageRoute(builder: (context) => loaderPage(_startDate, _endDate,assetCodes, assetNames, timingDropDown)),);
              },
            ),

          ],
        ),
      ),
    );
  }
}


class loaderPage extends StatefulWidget {
  @override

  DateTime startDate;
  DateTime endDate;
  List<String> assetCodes;
  List<String> assetNames;
  String timingDropDown;

  loaderPage( DateTime startDate, DateTime endDate, List<String> assetCodes,
      List<String> assetNames, String timingDropDown)
  {

    this.startDate = startDate;
    this.endDate = endDate;
    this.assetCodes = assetCodes;
    this.assetNames = assetNames;
    this.timingDropDown = timingDropDown;
  }


  _loaderPageState createState() => _loaderPageState();
}

class _loaderPageState extends State<loaderPage> {
  @override

  List<charts.Series<ChartData, DateTime>> _seriesBarData = [];
  bool istrue = false;

  getGraph() async
  {
    _seriesBarData = [];
    for (int i = 0; i < widget.assetCodes.length; i++) {
      var firestore = Firestore.instance;
      QuerySnapshot qn = await firestore.collection("DCM_KPI").document(
          widget.timingDropDown).collection(widget.assetCodes[i]).where(
          "timestamp", isLessThanOrEqualTo: Timestamp.fromDate(widget.endDate))
          .where(
          "timestamp", isGreaterThanOrEqualTo: Timestamp.fromDate(widget.startDate))
          .getDocuments();

      List<ChartData> sales = <ChartData>[];


      print(qn.documents.length);
      for (int index = 0; index < qn.documents.length; index++) {
        print(index);
        DocumentSnapshot documentSnapshot = qn.documents[index];
        print(documentSnapshot.documentID);
        sales.add(ChartData.fromSnapshot(documentSnapshot));
      }

      _seriesBarData.add(
        charts.Series(
          domainFn: (ChartData sales, _) => sales.xValue,
          measureFn: (ChartData sales, _) => sales.yValue,

          id: widget.assetNames[i],
          data: sales,
          // labelAccessorFn: (ChartData row, _) => "${row.xValue}",
        ),
      );

    }

    setState(() {
      istrue = true;
    });


   // Navigator.push(context, MaterialPageRoute(builder: (context) => loadProdGraph(_seriesBarData)),);
  }


  void initState()
  {
    super.initState();
    getGraph();
  }


  DateTime _time;
  Map<String, num> _measures;

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
          height: MediaQuery.of(context).size.height/1.3,
          child: new charts.TimeSeriesChart(
            _seriesBarData,

            defaultRenderer: new charts.BarRendererConfig<DateTime>(

              groupingType: charts.BarGroupingType.stacked,
            ),
            animate: true,
            selectionModels: [
              new charts.SelectionModelConfig(
                type: charts.SelectionModelType.info,
                changedListener: _onSelectionChanged,
              )
            ],

            behaviors: [

              new charts.PanAndZoomBehavior(),
              new charts.SeriesLegend(

                position: charts.BehaviorPosition.top,
                outsideJustification: charts.OutsideJustification.endDrawArea,
                horizontalFirst: false,
                desiredMaxRows: 2,
                cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
                entryTextStyle: charts.TextStyleSpec(
                    color: charts.Color(r: 127, g: 63, b: 191),
                    fontFamily: 'Georgia',
                    fontSize: 11),

              ),


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



  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        child:  Center(
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              istrue?build2(context):
              CircularProgressIndicator(),
            ],
          ) ,
        )


      )
    );
  }
}



class loadProdGraph extends StatefulWidget {
  @override
  List<charts.Series<ChartData, DateTime>> _seriesBarData;

  loadProdGraph(List<charts.Series<ChartData, DateTime>> _seriesBarData)
  {
    this._seriesBarData = _seriesBarData;
  }


  _loadProdGraphState createState() => _loadProdGraphState();
}

class _loadProdGraphState extends State<loadProdGraph> {
  @override


  DateTime _time;
  Map<String, num> _measures;

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
          height: MediaQuery.of(context).size.height/1.3,
          child: new charts.TimeSeriesChart(
            widget._seriesBarData,

            defaultRenderer: new charts.BarRendererConfig<DateTime>(

              groupingType: charts.BarGroupingType.stacked,
            ),
            animate: true,
            selectionModels: [
              new charts.SelectionModelConfig(
                type: charts.SelectionModelType.info,
                changedListener: _onSelectionChanged,
              )
            ],

            behaviors: [

              new charts.PanAndZoomBehavior(),
              new charts.SeriesLegend(

                position: charts.BehaviorPosition.top,
                outsideJustification: charts.OutsideJustification.endDrawArea,
                horizontalFirst: false,
                desiredMaxRows: 2,
                cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
                entryTextStyle: charts.TextStyleSpec(
                    color: charts.Color(r: 127, g: 63, b: 191),
                    fontFamily: 'Georgia',
                    fontSize: 11),

              ),


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





  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: build2(context),
      ),
    );
  }
}

