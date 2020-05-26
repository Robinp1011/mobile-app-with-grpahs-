import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'user.dart';
import 'dart:math';
import 'package:date_format/date_format.dart';

class productionData extends StatefulWidget {
  @override
  _productionDataState createState() => _productionDataState();
}

class _productionDataState extends State<productionData> {
  @override


   Future getPosts()  async
  {
    QuerySnapshot qn =  await Firestore.instance.collection("DCM_EMS").document("DCM_LONI_17374801").collection("crush").orderBy("timestamp", descending: true).getDocuments();
    return qn.documents;
  }



  Widget build(BuildContext context) {

    return Scaffold(


      floatingActionButton: FloatingActionButton(
        onPressed: () {


          Navigator.push(context, MaterialPageRoute(builder: (context) => addProductionData()),);


        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
        elevation: 2.0,
      ),

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
                            title: new Row(
                             children: <Widget>[
                               Expanded(child: new Text(snapshot.data[index].data['assetcode'])),
                               new SizedBox(
                                 width: 3,
                               ),
                               Expanded(child: new Text(formatDate(snapshot.data[index].data['timestamp'].toDate(), [yyyy, '-', mm, '-', dd]))),
                               new SizedBox(
                                 width: 3,
                               ),

                               Expanded(child: new Text(snapshot.data[index].data['totalcrush'].toString()))


                             ],
                            ),
                          onTap:()=>{

                          Navigator.push(context, MaterialPageRoute(builder: (context) => editProductionData(snapshot.data[index])),)

                        } ,

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


class addProductionData extends StatefulWidget {
  @override
  _addProductionDataState createState() => _addProductionDataState();
}

class _addProductionDataState extends State<addProductionData> {
  @override

  var finaldate;
   int unique;
   int totalcrush;
    User user;
  TextEditingController shiftaController = new TextEditingController();
  TextEditingController shiftbController = new TextEditingController();
  TextEditingController shiftcController = new TextEditingController();
  TextEditingController wholedayController = new TextEditingController();
  TextEditingController totalcrushController = new TextEditingController();
  Random rando = new Random();



  void callDatePicker() async {
    var order = await getDate();
    setState(() {
      finaldate = order;
    });
  }

  addUserLate() {
       unique = rando.nextInt(1000000);


         if(wholedayController.text =="") {

        wholedayController.text = "&";

         }



     print("chala re baba");

       if(wholedayController.text =="&")

        { user = new User(int.parse(shiftaController.text),int.parse(shiftbController.text) , int.parse(shiftcController.text), null, int.parse(totalcrushController.text),finaldate,unique);  }
       else
       {   user = new User(null,null, null, int.parse(wholedayController.text), int.parse(totalcrushController.text), finaldate,unique);  }


    try {
      print("aya ky ander");
      Firestore.instance.runTransaction(
            (Transaction transaction) async {
          await Firestore.instance
              .collection("DCM_EMS")
              .document("DCM_LONI_17374801").collection("crush").document()
              .setData(user.toJson());

        },
      );
    } catch (e) {
      print(e.toString());
    }
  }



  Future<DateTime> getDate() {
    // Imagine that this function is
    // more complex and slow.
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Sugar Manufacturing"),
        backgroundColor: Colors.lightGreen[500],
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Container(
            height: 1200,
            child:Column(
              children: <Widget>[

                Container(
                  decoration: BoxDecoration(color: Colors.grey[200]),
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: finaldate == null ? Text("Date",textScaleFactor: 2.0,) : Text("$finaldate",textScaleFactor: 2.0,),
                ),
                new RaisedButton(
                  onPressed: callDatePicker,
                  color: Colors.blueAccent,
                  child:
                  new Text('Pick Date', style: TextStyle(color: Colors.white)),
                ),
                new SizedBox(
                  height: 10,
                ),

                new Text("Shift A", style: new TextStyle(fontSize: 19, fontWeight: FontWeight.bold),),
                new TextField(
                  controller:shiftaController,
                  keyboardType: TextInputType.number,
               onSubmitted: (String str)
                  {
                    setState(() {
                      print("submit chala");
                      totalcrushController.text = str;
                    });
                  },


                  decoration: new InputDecoration(
                      border: OutlineInputBorder(),
                   ),




                ),
                new SizedBox(
                  height: 10,
                ),
                new Text("Shift B", style: new TextStyle(fontSize: 19, fontWeight: FontWeight.bold),),
                new TextField(
                  controller: shiftbController,
                  keyboardType: TextInputType.number,

                  onSubmitted: (String str)
                  {
                    setState(() {
                      totalcrush =int.parse(str) + int.parse(totalcrushController.text);
                      totalcrushController.text = totalcrush.toString();
                    });
                  },

                  decoration: new InputDecoration(
                      border: OutlineInputBorder(),
                     ),

                ),
                new SizedBox(
                  height: 10,
                ),
                new Text("Shift C", style: new TextStyle(fontSize: 19, fontWeight: FontWeight.bold),),
                new TextField(
                  controller:  shiftcController,
                  keyboardType: TextInputType.number,
                  onSubmitted: (String str)
                  {
                    setState(() {
                      totalcrush =int.parse(str) + int.parse(totalcrushController.text);
                      totalcrushController.text = totalcrush.toString();
                    });
                  },



                  decoration: new InputDecoration(
                      border: OutlineInputBorder(),
                     ),

                ),
                new SizedBox(
                  height: 10,
                ),
                new Text("Whole Day", style: new TextStyle(fontSize: 19, fontWeight: FontWeight.bold),),
                new TextField(
                  controller: wholedayController,
                  keyboardType: TextInputType.number,
                  onSubmitted: (String str)
                  {
                    setState(() {

                      totalcrushController.text = str;
                    });
                  },



                  decoration: new InputDecoration(
                      border: OutlineInputBorder(),
                     ),

                ),
                new SizedBox(
                  height: 10,
                ),
                new Text("Total Crush", style: new TextStyle(fontSize: 19, fontWeight: FontWeight.bold),),
                new TextField(
                  controller:  totalcrushController,
                  keyboardType: TextInputType.number,
                  decoration: new InputDecoration(
                      border: OutlineInputBorder(),
                     ),

                ),
                new SizedBox(
                  height: 10,
                ),


                new RaisedButton(
                  color: Colors.deepPurpleAccent,
                  onPressed: (){


                    addUserLate();
                    Navigator.pop(context, true);
                  },
                  child: new Text("Submit",style: new TextStyle(fontSize: 15, color: Colors.white),),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}



class editProductionData extends StatefulWidget {
  @override
  DocumentSnapshot post;
  editProductionData(DocumentSnapshot post)
  {
    this.post = post;
  }

  _editProductionDataState createState() => _editProductionDataState();
}

class _editProductionDataState extends State<editProductionData> {
  @override

  var finaldate;
  int unique;
  int totalcrush;

  String reference;
  User user;
  TextEditingController shiftaController = new TextEditingController();
  TextEditingController shiftbController = new TextEditingController();
  TextEditingController shiftcController = new TextEditingController();
  TextEditingController wholedayController = new TextEditingController();
  TextEditingController totalcrushController = new TextEditingController();
  Random rando = new Random();

  void initState() {
    super.initState();
    shiftaController = new TextEditingController(text: widget.post.data['shifta'].toString());
    shiftbController = new TextEditingController(text: widget.post.data['shiftb'].toString());
    shiftcController = new TextEditingController(text: widget.post.data['shiftc'].toString());
    wholedayController = new TextEditingController(text: widget.post.data['wholeday'].toString());
    totalcrushController = new TextEditingController(text: widget.post.data['totalcrush'].toString());
    finaldate = widget.post.data['timestamp'].toDate();

    if(wholedayController.text == "null")
      wholedayController.text = "";

    if(shiftaController.text == "null")
      shiftaController.text = "";

    if(shiftbController.text == "null")
      shiftbController.text = "";

    if(shiftcController.text == "null")
      shiftcController.text = "";

    if(totalcrushController.text == "null")
      totalcrushController.text = "";



  }

  void callDatePicker() async {
    var order = await getDate();
    setState(() {
      finaldate = order;
    });
  }

  addUserLate() {
    reference = widget.post.documentID.toString();
    unique = rando.nextInt(1000000);


      if(wholedayController.text =="") {

        wholedayController.text = "&";

      }



    if(wholedayController.text =="&")

    { user = new User(int.parse(shiftaController.text),int.parse(shiftbController.text) , int.parse(shiftcController.text), null, int.parse(totalcrushController.text),finaldate,unique);  }
    else
    {   user = new User(null,null, null, int.parse(wholedayController.text), int.parse(totalcrushController.text), finaldate,unique);  }


    try {
      print("aya ky ander");
      Firestore.instance.runTransaction(
            (Transaction transaction) async {
          await Firestore.instance
              .collection("DCM_EMS")
              .document("DCM_LONI_17374801").collection("crush").document(reference)
              .setData(user.toJson());

        },
      );
    } catch (e) {
      print(e.toString());
    }
  }



  Future<DateTime> getDate() {
    // Imagine that this function is
    // more complex and slow.
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Sugar Manufacturing"),
        backgroundColor: Colors.lightGreen[500],
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Container(
            height: 1200,
            child:Column(
              children: <Widget>[

                Container(
                  decoration: BoxDecoration(color: Colors.grey[200]),
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: finaldate == null ? Text("Date",textScaleFactor: 2.0,) : Text("$finaldate",textScaleFactor: 2.0,),
                ),
                new RaisedButton(
                  onPressed: callDatePicker,
                  color: Colors.blueAccent,
                  child:
                  new Text('Pick Date', style: TextStyle(color: Colors.white)),
                ),
                new SizedBox(
                  height: 10,
                ),

                new Text("Shift A", style: new TextStyle(fontSize: 19, fontWeight: FontWeight.bold),),
                new TextField(
                    controller:shiftaController,
                    enabled: shiftaController.text == "" ? false : true,

                    keyboardType: TextInputType.number,
                    onSubmitted: (String str)
                    {
                      setState(() {
                        print("submit chala");
                        totalcrushController.text = str;
                      });
                    },


                    decoration: new InputDecoration(
                      border: OutlineInputBorder(),
                    )


                ),
                new SizedBox(
                  height: 10,
                ),
                new Text("Shift B", style: new TextStyle(fontSize: 19, fontWeight: FontWeight.bold),),
                new TextField(
                  controller: shiftbController,
                  enabled: shiftbController.text == "" ? false : true,

                  keyboardType: TextInputType.number,


                  onSubmitted: (String str)
                  {
                    setState(() {
                      totalcrush =int.parse(str) + int.parse(totalcrushController.text);
                      totalcrushController.text = totalcrush.toString();
                    });
                  },

                  decoration: new InputDecoration(
                    border: OutlineInputBorder(),
                  ),

                ),
                new SizedBox(
                  height: 10,
                ),
                new Text("Shift C", style: new TextStyle(fontSize: 19, fontWeight: FontWeight.bold),),
                new TextField(
                  controller:  shiftcController,

                  enabled: shiftcController.text == "" ? false : true,
                  keyboardType: TextInputType.number,

                  onSubmitted: (String str)
                  {
                    setState(() {
                      totalcrush =int.parse(str) + int.parse(totalcrushController.text);
                      totalcrushController.text = totalcrush.toString();
                    });
                  },


                  onEditingComplete: ()
                  {

                    setState(() {
                      totalcrush = int.parse(totalcrushController.text) + int.parse(shiftcController.text);
                      totalcrushController.text = totalcrush.toString();
                    });

                  },

                  decoration: new InputDecoration(
                    border: OutlineInputBorder(),
                  ),

                ),
                new SizedBox(
                  height: 10,
                ),
                new Text("Whole Day", style: new TextStyle(fontSize: 19, fontWeight: FontWeight.bold),),
                new TextField(
                  controller: wholedayController,
                  keyboardType: TextInputType.number,
                  enabled: wholedayController.text == "" ? false : true,

                  onSubmitted: (String str)
                  {
                    setState(() {

                      totalcrushController.text = str;
                    });
                  },

                  decoration: new InputDecoration(
                    border: OutlineInputBorder(),
                  ),

                ),
                new SizedBox(
                  height: 10,
                ),
                new Text("Total Crush", style: new TextStyle(fontSize: 19, fontWeight: FontWeight.bold),),
                new TextField(
                  controller:  totalcrushController,
                  keyboardType: TextInputType.number,
                  enabled: totalcrushController.text == "" ? false : true,

                  decoration: new InputDecoration(
                    border: OutlineInputBorder(),
                  ),

                ),
                new SizedBox(
                  height: 10,
                ),


                new RaisedButton(
                  color: Colors.deepPurpleAccent,
                  onPressed: (){


                    addUserLate();
                    Navigator.pop(context, true);
                  },
                  child: new Text("Submit",style: new TextStyle(fontSize: 15, color: Colors.white),),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}




