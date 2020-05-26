import 'package:flutter/material.dart';
import 'tv.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'message.dart';


class alertsComing extends StatefulWidget {
  @override
  Set<String> departments;
  List<Data> finalData;
  String dropDownValue;
  alertsComing(Set<String> departments, List<Data> finalData ,  String dropDownValue)
  {
    this.departments = departments;
    this.finalData = finalData;
    this.dropDownValue = dropDownValue;
  }

  _alertsComingState createState() => _alertsComingState();
}

class _alertsComingState extends State<alertsComing> {
  @override
  List<String> assets = [];
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
   List<Message> messages = [];

  String dropDownValue2;
  String assetCode;

  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final notification = message['notification'];
        setState(() {
          messages.add(Message(
              title: notification['title'], body: notification['body']));
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

        final notification = message['data'];
        setState(() {
          messages.add(Message(
            title: '${notification['title']}',
            body: '${notification['body']}',
          ));
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }



  Widget DropDown(BuildContext context) {
    for (var f in widget.finalData) {
      if (f.groupid == widget.dropDownValue) {
        print("loop chala");
        assets = [];
        for (int i = 0; i < f.assets.length; i++) {
          assets.add(f.assets[i][0]);
        }

        return Container(
          width: 350,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1.0, style: BorderStyle.solid),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
          ),

          child: DropdownButton<String>(

              value: dropDownValue2,

              isExpanded: true,
              onChanged: (String newValue) {
                setState(() {
                  dropDownValue2 = newValue;
                  for (int i = 0; i < f.assets.length; i++) {
                    if (f.assets[i][0] == dropDownValue2) {
                      assetCode = f.assets[i][1];
                      print(assetCode);
                      break;
                    }
                  }
                });
              },
              items: assets
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),

                );
              })
                  .toList()
          ),
        );
      }
    }
  }


  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[

            Container(
              width: 350,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.0, style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
              child: DropdownButton<String>(

                  value: widget.dropDownValue,
                  isExpanded: true,
                  style: Theme
                      .of(context)
                      .textTheme
                      .title,
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
                      child: Text(value),

                    );
                  })
                      .toList()
              ),
            ),

            new SizedBox(
              height: 20,
            ),
            DropDown(context),
            new SizedBox(
              height: 20,
            ),
            RaisedButton(
              child: Text("Apply", style: new TextStyle(color: Colors.white),),
              color: Colors.lightGreen[500],
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    TabViewAlert(assetCode)),);
              },
            ),

          ],
        ),
      ),
    );
  }
}


class TabViewAlert extends StatelessWidget {
  @override
  String assetCode;
  TabViewAlert(String assetCode)
  {
    this.assetCode = assetCode;
  }


  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
              onTap: ()
              {
                Navigator.pop(context);
              },

              child: Icon(
                Icons.arrow_back,

              ),
            ),
            bottom: TabBar(
              tabs: [
                Tab(text: 'ALERT'),
                Tab(text: 'RECOMMENDATION',),

              ],
            ),
            title: Text('Alerts and Recommendations'),
          ),
          body: TabBarView(
            children: [
                alertsPage(assetCode),
                recommendationsPage(assetCode)


            ],
          ),
        ),
      ),
    );
  }
}



class alertsPage extends StatefulWidget {
  String assetCode;
  alertsPage(String assetCode)
  {
    this.assetCode = assetCode;
  }

  @override
  _alertsPageState createState() => _alertsPageState();
}

class _alertsPageState extends State<alertsPage> {
  @override

  getPosts()  async
  {
       QuerySnapshot qn = await Firestore.instance.collection("Alerts").document("DCM").collection(widget.assetCode).where("type", isEqualTo: "Alert").getDocuments();
       return qn.documents;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[300],
        child: new FutureBuilder(
            future: getPosts(),
            builder: (_,snapshot){

              if(snapshot.connectionState == ConnectionState.waiting)
              {
              //  return new Text("loading");

            return    SpinKitWave(
                  itemBuilder: (BuildContext context, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                      ),
                    );
                  },
                );
              }
              else
              {
                return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.length,

                    itemBuilder: (_, index)
                    {
                      return Card(

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13.0),),
                        child: new ListTile(
                          contentPadding: EdgeInsets.all(20.0),
                          title:  new Text(snapshot.data[index].data['description']),


                        ),
                      );

                    }
                );

              }
            }),
      ),
    );
  }
}


class recommendationsPage extends StatefulWidget {
  String assetCode;
  recommendationsPage(String assetCode)
  {
    this.assetCode = assetCode;
  }

  @override
  _recommendationsPageState createState() => _recommendationsPageState();
}

class _recommendationsPageState extends State<recommendationsPage> {
  @override

  getPosts()  async
  {
    QuerySnapshot qn = await Firestore.instance.collection("Alerts").document("DCM").collection(widget.assetCode).where("type", isEqualTo: "Recommendation").getDocuments();
    return qn.documents;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[300],
        child: new FutureBuilder(
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
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.length,

                    itemBuilder: (_, index)
                    {
                      return Card(

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13.0),),
                        child: new ListTile(
                          contentPadding: EdgeInsets.all(20.0),
                          title:  new Text(snapshot.data[index].data['description']),


                        ),
                      );

                    }
                );

              }
            }),
      ),
    );
  }
}


