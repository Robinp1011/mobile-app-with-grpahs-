

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dataOutput.dart';
import 'tv.dart';
import 'SecondScreen.dart';
import 'package:date_format/date_format.dart';

import 'package:marquee_widget/marquee_widget.dart';
import 'package:date_util/date_util.dart';
import 'afterLoni.dart';

class HomePage extends StatefulWidget {
  @override

  Set<String> departments;
  List<Data> finalData;
  String dropDownValue;
  double sum;
  String specific;
  DateTime specificTime;

  String email;

  DateTime startDate;




  HomePage(Set<String> departments, List<Data> finalData ,  String dropDownValue, double sum, String specific, DateTime specificTime,String email, DateTime startDate)
  {
    this.departments = departments;
    this.finalData = finalData;
    this.dropDownValue = dropDownValue;
    this.sum = sum;
    this.specific = specific;
    this.specificTime = specificTime;

    this.email = email;
    this.startDate = startDate;

  }

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override

  double sum=0;
  String totalPowGeneration;
  String totalEnerConsumption;

  String powerUnit;
  String energyUnit;
  String assetCode;
  DateTime startDate;
  DateTime endDate;

String monthEnerConsumed;
String exportToGrid;
String endDateString = "";

String  percentageChange;
double percentChangeDou;
  String dropDownValue;


  getLive(String dropDownValueLive) async
  {
      if(dropDownValueLive == "Loni")
        {
          assetCode = "DCM_LONI_17374801";


          QuerySnapshot qn = await Firestore.instance.collection("DCM_EMS").where('assetcode' , isEqualTo: assetCode).getDocuments();


          String months = formatDate(DateTime.now(), [mm]);
          String years = formatDate(DateTime.now(), [yyyy]);
          int month = int.parse(formatDate(DateTime.now(), [mm]));
          print(month);
          int year = int.parse(formatDate(DateTime.now(), [yyyy]));
          print(year);
          var dateUtility = DateUtil();
          int total =  dateUtility.daysInMonth( month, year);
          print(total);
          startDate = DateTime.parse("${years}-${months}-01 00:00:00");





          var firestore = Firestore.instance;
          QuerySnapshot qn2 = await firestore.collection("DCM_EMS").document("DCM_LONI_17374801").collection("crush").orderBy("timestamp", descending: true).where("timestamp", isGreaterThanOrEqualTo: Timestamp.fromDate(startDate)).getDocuments();

          endDate  = qn2.documents[0].data['timestamp'].toDate();


          setState(() {

            totalPowGeneration = qn.documents[0].data['livetags'][0]['value'].toString();
            totalEnerConsumption  = qn.documents[0].data['livetags'][1]['value'].toString();

            powerUnit = qn.documents[0].data['livetags'][0]['unit'];
            energyUnit = qn.documents[0].data['livetags'][1]['unit'];

            monthEnerConsumed = qn.documents[0].data['currentMonth'].toString();
            exportToGrid = qn.documents[0].data['currentMonthExport'].toString();

            percentageChange = qn.documents[0].data['percentChange'].toString();
            percentChangeDou = double.parse(percentageChange);

          //  endDate  = qn2.documents[0].data['timestamp'].toDate();

            endDateString= formatDate(endDate, [d,'-',M]);



            for(int i=0;i<qn2.documents.length;i++)
            {
              sum = sum + qn2.documents[i].data['totalcrush'];
            }


          });
        }

      //   if data of other 2 factories come then remove this if condition code and add 2 more condition on the top that is

       //  if(dropdownvalue = Hariwan )  assetcode = Har...     and if(dro..) = rupapur   then assetcode = rupapur...


      if(dropDownValueLive == "Hariawan" || dropDownValueLive == "Rupapur")
        {


          totalPowGeneration =  "";
          totalEnerConsumption  = "";

          powerUnit = "";
          energyUnit = "";

          monthEnerConsumed = "";
          exportToGrid = "";
          sum =0;
          percentageChange = "";
          percentChangeDou = null;



          endDateString= "";

        }


  }
  @override
  void initState()
  {
       dropDownValue = "Loni";
      getLive(dropDownValue);
    super.initState();
  }





  Widget build(BuildContext context) {
    return Scaffold(
      body:

      SingleChildScrollView(
        child: new Container(
          color: Colors.black,
          child: Column(
            children: <Widget>[
              new SizedBox(
                height: 20,
              ),

              Container(
                 child: Row(

                   children: <Widget>[
                     new SizedBox(
                       width: 10,
                     ),
                     Image.asset('assets/images/Bitmap.png'),
                     new SizedBox(
                       width: 10,
                     ),
                     Column(
                       children: <Widget>[
                         new Text("DCM SHRIRAM IEES", style: new TextStyle(color: Colors.white, fontSize: 18),),
                         new Text(widget.email, style: new TextStyle(color: Colors.lightGreen),)
                       ],
                     )

                   ],
                 ),
              ),
              new SizedBox(
                height: 10,
              ),

              Row(
                children: <Widget>[
                  new SizedBox(
                    width: 20,
                  ),
                  Container(
                    height: 26,
                      width: 60,
                      alignment: Alignment.center,
                      color: Colors.lightGreen,
                      child: Column(
                        children: <Widget>[

                          new Text("Live",style: new TextStyle(fontSize: 18),),

                        ],
                      )
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  child: Marquee(
                    child:Row(
                      children: <Widget>[
                        new Text("Total Power Generation =  ", style: new TextStyle(color: Colors.lightBlue),),
                        new Text(" ${totalPowGeneration}  ${powerUnit}",style: new TextStyle(color: Colors.white),),

                        new SizedBox(
                          width: 40,
                        ),

                        new Text("Total Energy Consumption =  ", style: new TextStyle(color: Colors.lightBlue),),
                        new Text(" ${totalEnerConsumption}  ${energyUnit}",style: new TextStyle(color: Colors.white),),
                      ],
                    ),
                   // scrollAxis: Axis.horizontal,
                  // textDirection : TextDirection.rtl,
                   //animationDuration: Duration(seconds: 1),
                   // backDuration: Duration(milliseconds: 0),
                   pauseDuration: Duration(milliseconds: 100),
                   // directionMarguee: DirectionMarguee.oneDirection,

                  ),
                ),
              ),



              new SizedBox(
                height: 20,
              ),
              Image.asset('assets/images/loniplant.png', height: 200, width: 200,),
              
              new SizedBox(
                height: 10,
              ),
              
              Center(child:
             new  Theme(
               data: Theme.of(context).copyWith(
                 canvasColor: Colors.black,
               ),

             child   : DropdownButton<String>(

                    value:dropDownValue,
                 focusColor:Colors.black,
                    onChanged: (String newValue) {
                      getLive(newValue);
                      setState(() {
                        dropDownValue = newValue;




                      });

                    },
                    items: ['Loni','Hariawan','Rupapur']

                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: new TextStyle(color: Colors.lightGreen),),

                      );
                    })
                        .toList()
                ),
              ),
              ),

              new SizedBox(
                height: 20,
              ),



              StreamBuilder(
                stream: Firestore.instance.collection('DCM_EMS').snapshots(),
                builder: (context, snapshot){
                  if(!snapshot.hasData)  return Text('loadign data');
                  return Column(
                    children: <Widget>  [

                      Row(
                        children: <Widget>[

                          new SizedBox(
                            width: 10,
                          ),

                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                color: Colors.grey[900],
                              ),
                              child: Column(
                                children: <Widget>[
                                  new SizedBox(
                                    height: 6,
                                  ),
                                  new Text("Energy Consumed", style: new TextStyle(color: Colors.lightBlue),),
                                  Row(
                                    children: <Widget>[
                                      new Text("${monthEnerConsumed } MWh ",style: new TextStyle(color: Colors.white),),


                                      if(percentChangeDou == null)
                                        new Text("")
                                      else
                                        Row(
                                          children: <Widget>[
                                            new Icon(Icons.arrow_downward,color: percentChangeDou < 0 ? Colors.red : Colors.lightGreen,size: 10,),
                                            new Text(percentageChange.toString(), style: new TextStyle(color: percentChangeDou < 0 ? Colors.red : Colors.lightGreen,fontSize: 10),),
                                          ],
                                        ),
                                    ],
                                  ),


                                  Row(
                                    children: <Widget>[

                                      Expanded(child: new  Text(formatDate(widget.startDate, [d,'-',M]), style: new TextStyle(color: Colors.white,fontSize: 11),)),
                                      Expanded(child: new Text("to", style: new TextStyle(color: Colors.white,fontSize: 11),)),
                                      Expanded(child: new  Text(formatDate(DateTime.now(), [d,'-',M]), style: new TextStyle(color: Colors.white,fontSize: 11),))
                                    ],
                                  ),
                                  new Text("As compared to previous MTD", style: new TextStyle(color:Colors.white,fontSize: 8),),

                                  new SizedBox(
                                    height: 6,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          new SizedBox(
                            width: 10,
                          ),

                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                color: Colors.grey[900],
                              ),
                              child: Column(
                                children: <Widget>[
                                  new SizedBox(
                                    height: 6,
                                  ),
                                  new Text("Export to Grid", style: new TextStyle(color: Colors.lightBlue),),
                                  new Text("${exportToGrid}  MWh",style: new TextStyle(color: Colors.white),),

                                  Row(
                                    children: <Widget>[

                                      Expanded(child: new  Text(formatDate(widget.startDate, [d,'-',M]), style: new TextStyle(color: Colors.white,fontSize: 11),)),
                                      Expanded(child: new Text("to", style: new TextStyle(color: Colors.white,fontSize: 11),)),
                                      Expanded(child: new  Text(formatDate(DateTime.now(), [d,'-',M]), style: new TextStyle(color: Colors.white,fontSize: 11),))


                                    ],
                                  ),

                                  new Text("As compared to previous MTD", style: new TextStyle(color:Colors.white,fontSize: 8),),

                                  new SizedBox(
                                    height: 6,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          new SizedBox(
                            width: 10,
                          ),

                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                color: Colors.grey[900],
                              ),
                              child: Column(
                                children: <Widget>[
                                  new SizedBox(
                                    height: 6,
                                  ),
                                  new Text("Total Crush", style: new TextStyle(color: Colors.lightBlue),),
                                  new Text("${sum} Tonnes",style: new TextStyle(color: Colors.white),),
                                  Row(
                                    children: <Widget>[

                                      Expanded(child: new  Text(formatDate(widget.startDate, [d,'-',M]), style: new TextStyle(color: Colors.white,fontSize: 11),)),
                                      Expanded(child: new Text(" to ", style: new TextStyle(color: Colors.white, fontSize: 11),)),
                                      Expanded(child: new  Text(endDateString, style: new TextStyle(color: Colors.white,fontSize: 11),))
                                    ],
                                  ),
                                  new SizedBox(
                                    height: 6,
                                  ),
                                ],
                              ),
                            ),
                          ),


                          new SizedBox(
                            width: 10,
                          ),


                        ],
                      ),


                      Padding(
                        padding: const EdgeInsets.only(left: 8,right: 8),
                        child: new Container(

                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: new Text("Factory Name",style: new TextStyle(color: Colors.lightGreen),),
                              ),
                              Expanded(
                                child: new Text("Location",style: new TextStyle(color: Colors.lightGreen),),
                              ),
                              Expanded (
                                child: new Text("Energy Consumed this month",style: new TextStyle(color: Colors.lightGreen),),
                              ),
                              new IconButton(icon: new Icon(Icons.arrow_forward,color: Colors.black,),onPressed: null, ),
                            ],
                          ),

                        ),
                      ),

                     new SizedBox(
                       height: 10,
                     ),

                      Padding(
                        padding:const EdgeInsets.only(left: 13,right: 13,bottom: 8),
                        child: new Container(
                         // color:Colors.grey[900],
              //    width: MediaQuery.of(context).size.width,
                //  padding: EdgeInsets.symmetric(vertical: 0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Colors.grey[900],
                  ),

                          child: Column(
                            children: <Widget>[
                              new SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: <Widget>[

                                  Expanded(
                                    child: new Text(" DCM LONI",style: new TextStyle(color: Colors.white),),
                                  ),
                                  Expanded(
                                    child: new Text(snapshot.data.documents[1]['description'],style: new TextStyle(color: Colors.white),),
                                  ),
                                  Expanded (
                                    child: new Text("${snapshot.data.documents[1]['currentMonth'].toString()} MWh",style: new TextStyle(color: Colors.white),),
                                  ),
                               new IconButton(icon: new Icon(Icons.arrow_forward,color: Colors.white,),onPressed: ()
                                 {
                                   Navigator.push(
                                     context,
                                     MaterialPageRoute(builder: (context) => afterLoni(widget.departments,widget.finalData,widget.dropDownValue)),
                                   );



                                 }, ),

                                ],
                              ),
                              new SizedBox(
                                height: 5,
                              ),
                            ],
                          ),

                        ),
                      ),


                      GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 13,right: 13,bottom: 8),
                          child: new Container(

                        //    width: MediaQuery.of(context).size.width,
                          //  padding: EdgeInsets.symmetric(vertical: 7),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                              color: Colors.grey[900],
                            ),

                            child: Column(
                              children: <Widget>[
                                new SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: new Text(" DCM HARIAWAN",style: new TextStyle(color: Colors.white),),
                                    ),
                                    Expanded(child: new Text(snapshot.data.documents[0]['description'],style: new TextStyle(color: Colors.white),)),
                                    Expanded (
                                      child: new Text("0 MWh",style: new TextStyle(color: Colors.white),),
                                    ),
                                    new IconButton(icon: new Icon(Icons.arrow_forward,color: Colors.white,),onPressed: null, ),
                                  ],
                                ),
                                new SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),

                          ),
                        ),
                      ),


                      GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 13,right: 13),
                          child: new Container(

                       //     width: MediaQuery.of(context).size.width,
                       //     padding: EdgeInsets.symmetric(vertical: 7),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                              color: Colors.grey[900],
                            ),

                            child: Column(
                              children: <Widget>[
                                new SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: new Text(" DCM RUPAPUR",style: new TextStyle(color: Colors.white),),
                                    ),
                                    Expanded(
                                      child: new Text(snapshot.data.documents[2]['description'],style: new TextStyle(color: Colors.white),),
                                    ),
                                    Expanded (
                                      child: new Text("0 MWh",style: new TextStyle(color: Colors.white),),
                                    ),
                                    new IconButton(icon: new Icon(Icons.arrow_forward,color: Colors.white,),onPressed: null, ),
                                  ],
                                ),
                                new SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),

                          ),
                        ),
                      ),
                      new SizedBox(
                        height: 10,
                      ),



                  /*   new Container(
                        color:Colors.grey[900],
                        child: Column(
                          children: <Widget>[
                            new SizedBox(
                              height: 6,
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: new Text("SEC = ${widget.specific}",style: new TextStyle(color: Colors.white),),
                                ),
                                Expanded(
                                  child: new Text("Time = ${formatDate(widget.specificTime, [yyyy, '-', M, '-', d])}",style: new TextStyle(color: Colors.white),),
                                ),

                              ],
                            ),
                            new SizedBox(
                              height: 6,
                            ),
                          ],
                        ),

                      ),  */

                    ],
                  );
                },
              )




            ],
          ),
        ),
      ),
    );
  }
}
