
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'HomePage.dart';
import 'Sales.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'dart:async';

import 'tv.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import 'package:date_format/date_format.dart';
import 'package:date_util/date_util.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';


import 'package:flutter_native_splash/flutter_native_splash.dart';


void main()
{
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/HomeScreen': (BuildContext context) => new LoginPage(),
      },
    );
  }
}


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();

  bool isFull = false ;
  bool isPasswordCorrect  = false;
  bool isEmailCheckCorrect = false;
  bool isShow = true;
  bool isEmailExist = false;
  bool isShowGreen = false;
  bool isShowRed = false;


  DocumentSnapshot snapshot;

  Email email;

  String username = "blpcleanalerts@gmail.com";
  String password = "qwerty@1234";


  Set<String> departments ={};
  List<String> assets = [];
  List<List<String>> finalAsset =[];
  List<Data> finalData=[];
  double sum =0;

  String dropDownValue;
  String specific;
  DateTime specificTime;

  DateTime startDate;


  getPosts()    async
  {
    getSpecific();
    getConsumed();

    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("Live_Data").where("customer", isEqualTo: "DCM").getDocuments();
    dropDownValue = qn.documents[0].data['groupid'];
    for(int i=0;i<qn.documents.length;i++)
    {

      departments.add(qn.documents[i].data['groupid']);


    }
    print(departments);
    getInitialAssets();
  }


  getInitialAssets()    async
  {
    // assets =[];
    var firestore = Firestore.instance;
    for(int j=0;j<departments.length;j++) {
      //  assets =[];
      QuerySnapshot qn = await firestore.collection("Live_Data").where("customer", isEqualTo: "DCM").where("groupid", isEqualTo: departments.elementAt(j)).getDocuments();
      print(departments.elementAt(j));


      for (int i = 0; i < qn.documents.length; i++) {
        assets.add(qn.documents[i].data['asset']);
        assets.add(qn.documents[i].data['assetcode']);
        finalAsset.add(assets);
        assets=[];



      }
      Data myData = new Data() ;
      myData.getData(departments.elementAt(j), finalAsset);
      finalData.add(myData);
      finalAsset = [];


    }
    print(finalData);
    for(var f in finalData)
      print(f.groupid);

  }
  getConsumed()  async
  {  String months = formatDate(DateTime.now(), [mm]);
  String years = formatDate(DateTime.now(), [yyyy]);
  int month = int.parse(formatDate(DateTime.now(), [mm]));
  print(month);
  int year = int.parse(formatDate(DateTime.now(), [yyyy]));
  print(year);
  var dateUtility = DateUtil();
  int total =  dateUtility.daysInMonth( month, year);
  print(total);

  startDate = DateTime.parse("${years}-${months}-01 00:00:00");

  print(startDate);


  }

  getSpecific()  async
  {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("DCM_KPI").document("SPECIFIC_ENERGY_CONSUMPTION_DAY").collection("LONI").orderBy("timestamp",descending: true).getDocuments();
    specific = qn.documents[0].data['sec'].toString();
    specificTime = qn.documents[0].data['timestamp'].toDate();
  }



  void initState()
  {
    getPosts();


    super.initState();
  }

  void sendEmail(DocumentSnapshot snapshot)  async
  {

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'DCM')
      ..recipients.add(snapshot.data['useremail'])

      ..subject = 'Password Changed :: '
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html = "<h1>Password of your email is </h1>\n<p>" + snapshot.data['password'] + "</p>";



    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());


    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(content: new Text("Password is sent to your email id"),
            backgroundColor: Colors.black

        )
    );
  }


  getEmailCheck()    async
  {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection('Customers').where("organisation" , isEqualTo: "DCM").getDocuments();

    for(int i=0;i<qn.documents.length;i++)
    {
      if(qn.documents[i].data['useremail'] == emailController.text)
      {
        isEmailCheckCorrect = true;
        snapshot = qn.documents[i];
        break;

      }
    }

    if(isEmailCheckCorrect)
    {
      isEmailCheckCorrect = false;
      sendEmail(snapshot);


    }
    else
    {
      _scaffoldKey.currentState.showSnackBar(
          new SnackBar(content: new Text("Email is incorrect"),
              backgroundColor: Colors.black
          )
      );
    }



  }




  getPassword()    async
  {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection('Customers').where("organisation" , isEqualTo: "DCM").getDocuments();

    for(int i=0;i<qn.documents.length;i++)
    {

      if(qn.documents[i].data['useremail'] == emailController.text  && qn.documents[i].data['password'] == passController.text)
      {

        isFull = true;
        break;
      }

      if(qn.documents[i].data['useremail'] == emailController.text  && qn.documents[i].data['password'] != passController.text)
      {
        isPasswordCorrect = true;
      }


    }

    if(isFull)
    {


      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage(departments,finalData,dropDownValue, sum,specific,specificTime,emailController.text, startDate)),
      );
      isFull = false;
    }
    else
    {
      if(isPasswordCorrect)
      {
        print("password is incorrect");
        _scaffoldKey.currentState.showSnackBar(
            new SnackBar(content: new Text("Password is incorrect"),
              backgroundColor: Colors.black,
            )
        );
        isPasswordCorrect = false;
      }
      else
      {
        print("Login credentials are wrong");
        _scaffoldKey.currentState.showSnackBar(
            new SnackBar(content: new Text("Login credentials are wrong"),
              backgroundColor: Colors.black,
            )
        );

      }
    }

  }

  performEmailCheck(String str) async
  {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection('Customers').where("organisation" , isEqualTo: "DCM").getDocuments();

    for(int i=0;i<qn.documents.length;i++)
    {
      if(qn.documents[i].data['useremail'] == str)
      {
        isEmailExist = true;
        break;
      }

    }
    if(isEmailExist)
    {
      isEmailExist = false;
      setState(() {
        isShowGreen = true;
        isShowRed = false;
      });
    }
    else
    {
      setState(() {
        isShowRed = true;
        isShowGreen = false;
      });
    }
    if(str == "")
    {
      setState(() {
        isShowRed = false;
        isShowGreen = false;
      });
    }

  }






  Widget _submitButton() {
    return GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(40)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.lightGreen[500], Colors.lightGreenAccent])),
        child: Text(
          'Sign In',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      onTap: ()
      {
        signIn();
      },
    );
  }




  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'Sign In',
        style: GoogleFonts.portLligatSans(
          textStyle: Theme.of(context).textTheme.display1,
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),

      ),
    );
  }


  Widget _emailPasswordWidget() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[

          new  TextFormField(

            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (val){
              if (val.length == 0)
                return "Please enter email";
              else if (!val.contains("@"))
                return "Please enter valid email";
              else
                return null;
            },

            onChanged: (String str)
            {
              performEmailCheck(str);
            },


            decoration: InputDecoration(

              labelText: 'Email id',
              icon: Icon(Icons.person),

              suffixIcon: isShowGreen? Icon(Icons.check, color: Colors.blue,) : Icon(Icons.check, color: Colors.transparent,)  ,
            ),
          ),

          /* if(isShowGreen)
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.centerRight,
            child: Text('Email exist',
                style:
                TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.lightGreen[300])),
          ),  */

          if(isShowRed)
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.centerRight,
              child: Text('Email  not exist',
                  style:
                  TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.red)),
            ),



          new  TextFormField(



            obscureText: isShow? true: false,
            controller: passController,
            validator: (val){
              if (val.length == 0)
                return "Please enter password";
              else if (val.length <= 5)
                return "Your password should be more then 6 char long";
              else
                return null;
            },

            decoration: InputDecoration(

              labelText: 'Password',
              icon:GestureDetector(child: isShow? Icon(Icons.remove_red_eye) : Icon(Icons.visibility_off),onTap:(){
                setState(() {
                  isShow = !isShow;
                });
              } ,),
            ),

          )


        ],
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,


      home: SingleChildScrollView(
        child: Container(
          height: 1000,
          color: Colors.white,
          child: Container(

            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/backgroundrot.png"), fit: BoxFit.cover)),

            child: Scaffold(
              resizeToAvoidBottomInset: false,
              resizeToAvoidBottomPadding: false,
              key: _scaffoldKey,
              backgroundColor: Colors.transparent,
              body: Center(
                child: Column(
                  children: <Widget>[

                    new SizedBox(
                      height: 100,
                    ),
                    Image.asset("assets/images/aitag.png",width: 330,),

                    new SizedBox(
                      height: 80,
                    ),
                    _title(),

                    new SizedBox(
                      height: 10,
                    ),
                    KeyboardAvoider(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        // color: Colors.white,
                        width: 330,
                        height: 330,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          border: Border.all(width: 3,color: Colors.grey[300],style: BorderStyle.solid),



                        ),
                        child: Column(

                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 20,
                            ),
                            _emailPasswordWidget(),


                            GestureDetector(
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                alignment: Alignment.centerRight,
                                child: Text('Forgot Password ?',
                                    style:
                                    TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.blue)),
                              ),
                              onTap: ()
                              {
                                getEmailCheck();
                              },
                            ),


                            SizedBox(
                              height: 20,
                            ),
                            _submitButton(),

                            Expanded(
                              flex: 2,
                              child: SizedBox(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  void signIn() async {
    if(_formKey.currentState.validate()){

      try{
        // await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passController.text);
        getPassword();
      }catch(e){
        print(e.message);
      }
    }
  }
}


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/HomeScreen');
  }

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void initState() {
    super.initState();
    startTime();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        color: Colors.white,
        child: Container(

          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/backgroundrot.png"), fit: BoxFit.cover)),


          child: new Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Container(
                child: Center(
                  child: Column(
                    children: <Widget>[

                      new SizedBox(
                        height: 120,
                      ),
                      Image.asset("assets/images/frontphoto.png",width: 300,),
                      new SizedBox(
                        height: 180,
                      ),
                      new Text("Loading..."),
                      new SizedBox(
                        height: 10,
                      ),

                      new SizedBox(
                        width: 130,
                      ),
                      new LinearPercentIndicator(
                        alignment: MainAxisAlignment.center,
                        width: 140.0,
                        lineHeight: 6.0,
                        animation: true,
                        animationDuration: 2000,
                        percent: 1.0,
                        backgroundColor: Colors.grey,
                        progressColor: Colors.lightGreenAccent,
                      ),



                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}


