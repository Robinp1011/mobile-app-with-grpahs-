
import 'package:flutter/material.dart';
import 'tv.dart';
import 'SecondScreen.dart';
import 'productionData.dart';
import 'alerts.dart';
import 'energyForecast.dart';
import 'loadProduction.dart';
class afterLoni extends StatefulWidget {
  @override
  Set<String> departments;
  List<Data> finalData;
  String dropDownValue;
  afterLoni(Set<String> departments, List<Data> finalData ,  String dropDownValue)
  {
    this.departments = departments;
    this.finalData = finalData;
    this.dropDownValue = dropDownValue;
  }

  _afterLoniState createState() => _afterLoniState();
}

class _afterLoniState extends State<afterLoni> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: 1000,

       //   width: MediaQuery.of(context).size.width,
        //  height: MediaQuery.of(context).size.height,
          color: Colors.black,
          child: Column(
         //   mainAxisAlignment: MainAxisAlignment.start,
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



              GridView.count(

                crossAxisCount: 3,
                padding: const EdgeInsets.all(20.0),
                crossAxisSpacing: 20.0,
                mainAxisSpacing: 20.0,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: <Widget>[

                  GestureDetector(child: Container(child: Column(
                    children: <Widget>[
                      Expanded(child: Image.asset("assets/images/monitor.png")),

                      Expanded(child: new Text("Monitor", style: new TextStyle(color: Colors.grey[400]),)),
                    ],
                  ))
                  , onTap: ()
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SecondScreen(widget.departments,widget.finalData,widget.dropDownValue)),
                      );

                    },
                  ),

                  GestureDetector(child: Container(
                    child: Column(
                      children: <Widget>[

                        Expanded(child: Image.asset("assets/images/insight.png")),
                        Expanded(child: new Text("Insights", style: new TextStyle(color: Colors.grey[400] ),)),
                      ],
                    ),
                  )
                    , onTap: ()
                    {


                    },
                  ),

                  GestureDetector(child: Container(
                    child: Column(
                      children: <Widget>[

                        Expanded(child: Image.asset("assets/images/sld.png")),
                        Expanded(child: new Text("SLD", style: new TextStyle(color: Colors.grey[400]),)),
                      ],
                    ),
                  )
                    , onTap: ()
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => dataOutput()),
                      );

                    },
                  ),


                  GestureDetector(child: Container(
                    child: Column(
                      children: <Widget>[

                        Expanded(child: Image.asset("assets/images/forcast.png")),
                        Expanded(child: new Text("Energy Forecast", style: new TextStyle(color: Colors.grey[400] ),)),
                      ],
                    ),
                  )
                    , onTap: ()
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => basePage()),
                      );
                    },
                  ),

                  GestureDetector(child: Container(
                    child: Column(
                      children: <Widget>[

                        Expanded(child: Image.asset("assets/images/load.png")),
                        Expanded(child: new Text("Load Profile", style: new TextStyle(color: Colors.grey[400] ),)),
                      ],
                    ),
                  )
                    , onTap: ()
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => loadPage(widget.departments,widget.finalData,widget.dropDownValue)),
                      );
                    },
                  ),

                  GestureDetector(child: Container(
                    child: Column(
                      children: <Widget>[

                        Expanded(child: Image.asset("assets/images/production.png")),
                        Expanded(child: new Text("Production Data", style: new TextStyle(color: Colors.grey[400] ),)),
                      ],
                    ),
                  )
                    , onTap: ()
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => productionData()),
                      );

                    },
                  ),


                  GestureDetector(child: Container(
                    child: Column(
                      children: <Widget>[

                        Expanded(child: Image.asset("assets/images/operation.png")),
                        Expanded(child: new Text("Operation Hours", style: new TextStyle(color: Colors.grey[400] ),)),
                      ],
                    ),
                  )
                    , onTap: ()
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => productionData()),
                      );

                    },
                  ),

                ],
              ),



         /*     Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(child: GestureDetector(child: new Text("Production Data", style: new TextStyle(color: Colors.grey[400], fontSize: 24, ),)
                    , onTap: ()
                      {
                         Navigator.push(
                                       context,
                                       MaterialPageRoute(builder: (context) => productionData()),
                                     );

                      },
                    )),

                    Expanded(child: GestureDetector
                      (child: new Text("Alerts", style: new TextStyle(color: Colors.grey[400], fontSize: 24),),
                      onTap: ()
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => alertsComing(widget.departments,widget.finalData,widget.dropDownValue)),
                        );

                      },
                    )),
                  ],
                ),
              )   */
              Image.asset("assets/images/nicback.png"),

            ],
          ),
        ),
      ),
    );
  }
}

