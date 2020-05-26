

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'tv.dart';
import 'package:flutter_timer/flutter_timer.dart';
import 'dart:async';
import 'package:f_datetimerangepicker/f_datetimerangepicker.dart';
import 'package:intl/intl.dart';
import 'dataOutput.dart';
import 'SecondScreen.dart';
import 'productionData.dart';
import 'alerts.dart';
import 'dart:math';

import 'package:direct_select_flutter/generated/i18n.dart';
import 'package:direct_select_flutter/direct_select_container.dart';
import 'package:direct_select_flutter/direct_select_item.dart';
import 'package:direct_select_flutter/direct_select_list.dart';

import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class MyApp extends StatelessWidget {
  @override
  Set<String> departments;
  List<Data> finalData;
  String dropDownValue;
  MyApp(Set<String> departments, List<Data> finalData ,  String dropDownValue)
  {
    this.departments = departments;
    this.finalData = finalData;
    this.dropDownValue = dropDownValue;
  }




  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green[500],
            title: TabBar(
              isScrollable: true,
              indicatorColor: Colors.lightGreenAccent,
              tabs: [
                Tab(text: 'Monitor'),
                Tab(text: 'SLD',),
                Tab(text: 'Production Data',),

                Tab(text: 'Alerts are coming',),




              ],
            ),

          ),
          body: TabBarView(
            children: [

              SecondScreen(departments,finalData,dropDownValue),
              dataOutput(),
              productionData(),
              alertsComing(departments,finalData,dropDownValue)


            ],
          ),
        ),
      ),
    );
  }
}




class dataOutput extends StatefulWidget {
  @override
  _dataOutputState createState() => _dataOutputState();
}

class _dataOutputState extends State<dataOutput> {
  @override
    String comstatus;

  Future  getPosts()  async
  {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("Live_Data").where("customer", isEqualTo: "DCM").getDocuments();
    return qn.documents;
  }



  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[300],

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child:  new FutureBuilder(
              future: getPosts(),
              builder: (_,snapshot){

                if(snapshot.connectionState == ConnectionState.waiting)
                {
                  return new Text("loading");
                }
                else
                {
                  return ListView.builder(
                      shrinkWrap: true,
                      // scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.length,

                      itemBuilder: (_, index)
                      {
                           for(int i=0;i<snapshot.data[index].data['tags'].length;i++)
                             {
                               if(snapshot.data[index].data['tags'][i]['tag'] == 'COM_STATUS')
                                 {
                                   comstatus = snapshot.data[index].data['tags'][i]['value'].toString();
                                 }
                             }

                        return Card(


                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13.0),),
                          child: GestureDetector(
                            child: new ListTile(
                              contentPadding: EdgeInsets.all(20.0),

                              title: Row(
                                children: <Widget>[
                                  Container(
                                    height: 15,
                                    width:15,
                                    decoration: BoxDecoration(

                                        color: comstatus == "0"? Colors.red : Colors.green,

                                        shape: BoxShape.circle
                                    ),
                                  ),

                                  new SizedBox(
                                    width: 10,
                                  ),
                                  new Text(snapshot.data[index].data['asset']),
                                ],
                              ),

                                    subtitle: new Column(
                                   children: <Widget>[
                                     new SizedBox(
                                       height: 10,
                                     ),



                                       Column(
                                         children: <Widget>[
                                         for(int i=0;i<snapshot.data[index].data['tags'].length;i++)
                                           if(snapshot.data[index].data['tags'][i]['tag'] == "V1")
                                         if(snapshot.data[index].data['tags'][i]['value'] < 100)
                                           Row(
                                             children: <Widget>[
                                               Expanded(child: new Text("V")),
                                               Expanded(child: new Text((snapshot.data[index].data['tags'][i]['value']  *1000).toString())),
                                             ],
                                           )
                                          else
                                           Row(
                                             children: <Widget>[
                                               Expanded(child: new Text("V")),
                                               Expanded(child: new Text((snapshot.data[index].data['tags'][i]['value']).toString())),
                                             ],
                                           ),

                                           for(int i=0;i<snapshot.data[index].data['tags'].length;i++)
                                             if(snapshot.data[index].data['tags'][i]['tag'] == "L1")
                                           Row(
                                             children: <Widget>[
                                               Expanded(child: new Text("A")),
                                               Expanded(child: new Text(snapshot.data[index].data['tags'][i]['value'].toString())),
                                             ],
                                           ),

                                           for(int i=0;i<snapshot.data[index].data['tags'].length;i++)
                                             if(snapshot.data[index].data['tags'][i]['tag'] == "PF1")
                                           Row(
                                             children: <Widget>[
                                               Expanded(child: new Text("PF")),
                                               Expanded(child: new Text(snapshot.data[index].data['tags'][i]['value'].toString())),
                                             ],
                                           ),

                                           for(int i=0;i<snapshot.data[index].data['tags'].length;i++)
                                             if(snapshot.data[index].data['tags'][i]['tag'] == "POWER")
                                           Row(
                                             children: <Widget>[
                                               Expanded(child: new Text("KW")),
                                               Expanded(child: new Text(snapshot.data[index].data['tags'][i]['value'].toString())),
                                             ],
                                           ),

                                           for(int i=0;i<snapshot.data[index].data['tags'].length;i++)
                                             if(snapshot.data[index].data['tags'][i]['tag'] == "APPARENT_POWER")
                                           Row(
                                             children: <Widget>[
                                               Expanded(child: new Text("KVA")),
                                               Expanded(child: new Text(snapshot.data[index].data['tags'][10]['value'].toString())),
                                             ],
                                           ),

                                         ],
                                       ),

                                   ],
                              ),



                            ),

                          ),
                        );
                      }
                  );
                }
              }),
        ),
      ),
    );
  }
}







class SecondScreen extends StatefulWidget {
  @override
  Set<String> departments;
  List<Data> finalData;
  String dropDownValue;
  SecondScreen(Set<String> departments, List<Data> finalData ,  String dropDownValue)
  {
    this.departments = departments;
    this.finalData = finalData;
    this.dropDownValue = dropDownValue;
  }

  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override



  String dropDownValue2;
  String assetCode;
  double totalEnergyConsumption = 0;
  double cost =0;
  double trimcost;

  List<String> assets =[] ;


  DocumentSnapshot snapshot;

  getPosts()  async
  {
    print("apun chala re");
  var firestore = Firestore.instance;
  QuerySnapshot qn = await firestore.collection("Live_Data").where("customer", isEqualTo: "DCM").getDocuments();

  for(int i=0;i<qn.documents.length;i++)
  {    print("apun chala re");
  if(qn.documents[i].data['assetcode'] == assetCode)
  { snapshot = qn.documents[i];
  print(snapshot);
  break;
  }
  }

  }

  getEnergyConsumed()  async
  {
       totalEnergyConsumption =0;
    print("apun chala re");
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("DCM_KPI").document("Active_Consumption_Hourly").collection(assetCode).where("timestamp", isLessThanOrEqualTo: Timestamp.fromDate(_endDate)).where("timestamp", isGreaterThanOrEqualTo: Timestamp.fromDate(_startDate)).getDocuments();

    for(int i=0;i<qn.documents.length;i++)
    {
         setState(() {
           totalEnergyConsumption = totalEnergyConsumption + qn.documents[i].data['consumption'];
         });

    }
    print(totalEnergyConsumption.toString());
    getCost();
  }

  getCost()  async
  {
    cost =0;
    print("apun chala re");
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("DCM_EMS").getDocuments();


    setState(() {
      cost = totalEnergyConsumption * qn.documents[1].data['eb_unit_price'];
      trimcost = double.parse(cost.toStringAsFixed(2));
    });

      getPosts();
  }




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
              child: DropdownButton<String>(

                  value: dropDownValue2,
           hint: new Text("Select Asset", style: new TextStyle(color: Colors.white),),
                 isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down,color: Colors.lightGreen,),
                  underline: Container(
                    color: Colors.black,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                        dropDownValue2 = newValue;
                        for(int i=0;i<f.assets.length;i++)
                        {
                            if(f.assets[i][0] == dropDownValue2)
                            {  assetCode = f.assets[i][1];
                               print(assetCode);
                               break;
                            }
                        }

                        getEnergyConsumed();


                    });
                  },
                  items: assets
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: new TextStyle(color: Colors.white),),

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

      body: SingleChildScrollView(
        child: Container(

      //    width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height,
          height: 1000,

          color: Colors.black,
          child:
          Center(
            child: Column(
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


                Padding(
                  padding: const EdgeInsets.only(right: 15, left: 15),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color:  Colors.grey[700]
                       ),

                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[

                            new SizedBox(
                              height: 8,
                            ),

                            new Text("Energy Consumed", style: new TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 20),),
                            new Text(totalEnergyConsumption.toString(), style: new TextStyle(color: Colors.white),),

                            new SizedBox(
                              height: 8,
                            ),
                          ],
                        ),

                        Container(height: 35, child: VerticalDivider(color: Colors.black, width: 10,)),
                        Column(
                          children: <Widget>[

                            new SizedBox(
                              height: 8,
                            ),
                            new Text("Energy Cost", style: new TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 20),),
                            new Text(trimcost.toString(), style: new TextStyle(color: Colors.white),),

                            new SizedBox(
                              height: 8,
                            ),
                          ],
                        )
                      ],

                    ),
                  ),
                ),

                new SizedBox(
                  height: 30,
                ),

                new Container(
                    margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                    child: Divider(
                      color: Colors.grey[700],
                      height: 50,
                    )),

                new SizedBox(
                  height: 30,
                ),

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


               // new Text("Department", style:  new TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                new SizedBox(
                  height: 18,
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
                      child: DropdownButton<String>(

                          value:widget.dropDownValue,
                          isExpanded: true,
                         // style: Theme.of(context).textTheme.title,
                          icon: Icon(Icons.arrow_drop_down,color: Colors.lightGreen,),
                          underline:  Container(
                            color: Colors.black,
                          ),
                          onChanged: (String newValue) {

                            setState(() {
                             widget.dropDownValue = newValue;
                             dropDownValue2 = null;


                            });

                          },
                          items: widget.departments

                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: new TextStyle( color: Colors.white
                              ),),

                            );
                          })
                              .toList()
                      ),
                    ),
                  ),
                ),

             //   MealSelector(data: widget.departments.toList()),


              //  new Text("Asset", style:  new TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),

 /*  for(var f in widget.finalData)

    if (f.groupid == widget.dropDownValue)

        Container(

          width:  350,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1.0, style: BorderStyle.solid),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
          ),

          child: DropdownButton<String>(

    value: dropDownValue2,
              isExpanded: true,
              style: Theme.of(context).textTheme.title,

    onChanged: (String newValue) {
    setState(() {
    dropDownValue2 = newValue;
    });
    },
    items: f.assets
              .map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
    value: value,
    child: Text(value),

    );
    })
              .toList()
    ),
        ),     */

                new SizedBox(
                  height: 18,
                ),
 DropDown(context),
                new SizedBox(
                  height: 35,
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

                Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(_startDate,_endDate,snapshot)),);


              },
            ),

                new SizedBox(
                  height: 20,
                ),

                Image.asset("assets/images/nicback.png"),


              ],
            ),
          ),

        ),
      ),


    );
  }
}



class MealSelector extends StatelessWidget {
  final buttonPadding = const EdgeInsets.fromLTRB(0, 8, 0, 0);

  final List<String> data;


  MealSelector({@required this.data});

  @override
  Widget build(BuildContext context) {
    return DirectSelectContainer(

      child: Column(
        children: [

          Padding(
            padding: buttonPadding,
            child: Container(
              decoration: _getShadowDecoration(),
              child: Card(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                          child: Padding(
                              child: DirectSelectList<String>(
                                values: data,
                                defaultItemIndex: 0,
                                itemBuilder: (String value) =>
                                    getDropDownMenuItem(value),
                                focusedItemDecoration: _getDslDecoration(),
                              ),
                              padding: EdgeInsets.only(left: 12))),
                      Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: _getDropdownIcon(),
                      )
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }

  DirectSelectItem<String> getDropDownMenuItem(String value) {
    return DirectSelectItem<String>(
        itemHeight: 56,
        value: value,
        itemBuilder: (context, value) {
          return Text(value);
        });
  }

  _getDslDecoration() {
    return BoxDecoration(
      border: BorderDirectional(
        bottom: BorderSide(width: 1, color: Colors.black12),
        top: BorderSide(width: 1, color: Colors.black12),
      ),
    );
  }

  BoxDecoration _getShadowDecoration() {
    return BoxDecoration(
      boxShadow: <BoxShadow>[
        new BoxShadow(
          color: Colors.black.withOpacity(0.06),
          spreadRadius: 4,
          offset: new Offset(0.0, 0.0),
          blurRadius: 15.0,
        ),
      ],
    );
  }

  Icon _getDropdownIcon() {
    return Icon(
      Icons.unfold_more,
      color: Colors.blueAccent,
    );
  }
}



class BasicDateTimeField extends StatelessWidget {
  final format = DateFormat("yyyy-MM-dd HH:mm");
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text('Basic date & time field (${format.pattern})'),
      DateTimeField(
        format: format,
        onShowPicker: (context, currentValue) async {
          final date = await showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100),

          );
          if (date != null) {
            final time = await showTimePicker(
              context: context,
              initialTime:
              TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            );
            return DateTimeField.combine(date, time);
          } else {
            return currentValue;
          }
        },
        onFieldSubmitted: (DateTime date){
          print(date);

        },
      ),
    ]);
  }
}