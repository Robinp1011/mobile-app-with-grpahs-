import 'package:flutter/material.dart';



class signInScreen extends StatefulWidget {
  @override
  _signInScreenState createState() => _signInScreenState();
}

class _signInScreenState extends State<signInScreen> {
  @override
  TextEditingController emailController = new TextEditingController();

  TextEditingController passController = new TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
        color: Colors.black,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            children: <Widget>[
              new SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(left:15.0, right: 15),
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

              new SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right:15),
                child: Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Text("Sign in", style: new TextStyle(color: Colors.white, fontSize: 28),),


                    // Image.asset("assets/images/alerts.png"),
                  ],
                ),
              ),

              new SizedBox(
                height: 20,
              ),

              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: new  TextFormField(
                  style:  new TextStyle(color: Colors.white),
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



                  decoration: InputDecoration(

                      border:OutlineInputBorder(
                        //  borderSide: BorderSide(color: Colors.grey[700])


                      ),
                      //  alignLabelWithHint: true,
                      //   labelText: 'Email id',
                      filled: true,
                      fillColor: Colors.grey[900],
                      hintText: 'Email Address',
                      hintStyle: new TextStyle(color: Colors.grey[400])

                  ),
                ),
              ),

              new SizedBox(
                height: 10,
              ),

              Padding(
                padding: const EdgeInsets.only(left:15, right: 15),
                child: new  TextFormField(


                  style:  new TextStyle(color: Colors.white),
                  //   obscureText: isShow? true: false,
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
                      border: OutlineInputBorder(),

                      filled: true,
                      fillColor: Colors.grey[900],
                      //   labelText: 'Password',
                      hintText: 'Password',
                      hintStyle: new TextStyle(color: Colors.grey[400])
                  ),

                ),
              ),

              new SizedBox(
                height: 20,
              ),

              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: GestureDetector(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    //padding: EdgeInsets.symmetric(vertical: 15),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(40)),

                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Colors.lightGreen[500], Colors.lightGreenAccent])),
                    child: Column(
                      children: <Widget>[

                        new SizedBox(
                          height: 13,
                        ),
                        Text(
                          'Sign In',
                          style: TextStyle(fontSize: 24, color: Colors.white),
                        ),

                        new SizedBox(
                          height: 13,
                        ),
                      ],
                    ),
                  ),
                  onTap: ()
                  {

                  },
                ),
              ),

              new SizedBox(
                height: 10,
              ),

              GestureDetector(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  //   alignment: Alignment.centerRight,
                  child: Text('Forgot Password ?',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                onTap: ()
                {

                },
              ),


            ],
          ),
        ),
      ),
    );
  }
}



class forgetPassword extends StatefulWidget {
  @override
  _forgetPasswordState createState() => _forgetPasswordState();
}

class _forgetPasswordState extends State<forgetPassword> {
  @override

  TextEditingController emailController = new TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
        color: Colors.black,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            children: <Widget>[
              new SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(left:15.0, right: 15),
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

              new SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right:15),
                child: Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Text("Reset Password", style: new TextStyle(color: Colors.white, fontSize: 28),),


                    // Image.asset("assets/images/alerts.png"),
                  ],
                ),
              ),

              new SizedBox(
                height: 25,
              ),

              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: new  TextFormField(
                  style:  new TextStyle(color: Colors.white),
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



                  decoration: InputDecoration(

                      border:OutlineInputBorder(
                        //  borderSide: BorderSide(color: Colors.grey[700])


                      ),
                      //  alignLabelWithHint: true,
                      //   labelText: 'Email id',
                      filled: true,
                      fillColor: Colors.grey[900],
                      hintText: 'Email Address',
                      hintStyle: new TextStyle(color: Colors.grey[400])

                  ),
                ),
              ),


              new SizedBox(
                height: 25,
              ),

              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: GestureDetector(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    //padding: EdgeInsets.symmetric(vertical: 15),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(40)),

                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Colors.lightGreen[500], Colors.lightGreenAccent])),
                    child: Column(
                      children: <Widget>[

                        new SizedBox(
                          height: 13,
                        ),
                        Text(
                          'Reset your password',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),

                        new SizedBox(
                          height: 13,
                        ),
                      ],
                    ),
                  ),
                  onTap: ()
                  {

                  },
                ),
              ),



            ],
          ),
        ),
      ),
    );
  }
}



class createNewAccount extends StatefulWidget {
  @override
  _createNewAccountState createState() => _createNewAccountState();
}

class _createNewAccountState extends State<createNewAccount> {
  @override
  TextEditingController emailController = new TextEditingController();

  TextEditingController passController = new TextEditingController();

  TextEditingController nameController = new TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      body:  new Container(
        color: Colors.black,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            children: <Widget>[
              new SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(left:15.0, right: 15),
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

              new SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right:15),
                child: Row(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Text("Create new account", style: new TextStyle(color: Colors.white, fontSize: 28),),


                    // Image.asset("assets/images/alerts.png"),
                  ],
                ),
              ),

              new SizedBox(
                height: 25,
              ),

              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: new  TextFormField(
                  style:  new TextStyle(color: Colors.white),
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  validator: (val){
                    if (val.length == 0)
                      return "Please enter name";

                    else
                      return null;
                  },



                  decoration: InputDecoration(

                      border:OutlineInputBorder(
                        //  borderSide: BorderSide(color: Colors.grey[700])


                      ),
                      //  alignLabelWithHint: true,
                      //   labelText: 'Email id',
                      filled: true,
                      fillColor: Colors.grey[900],
                      hintText: 'Name',
                      hintStyle: new TextStyle(color: Colors.grey[400])

                  ),
                ),
              ),

              new SizedBox(
                height: 10,
              ),

              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: new  TextFormField(
                  style:  new TextStyle(color: Colors.white),
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



                  decoration: InputDecoration(

                      border:OutlineInputBorder(
                        //  borderSide: BorderSide(color: Colors.grey[700])


                      ),
                      //  alignLabelWithHint: true,
                      //   labelText: 'Email id',
                      filled: true,
                      fillColor: Colors.grey[900],
                      hintText: 'Email Address',
                      hintStyle: new TextStyle(color: Colors.grey[400])

                  ),
                ),
              ),

              new SizedBox(
                height: 10,
              ),

              Padding(
                padding: const EdgeInsets.only(left:15, right: 15),
                child: new  TextFormField(


                  style:  new TextStyle(color: Colors.white),
                  //   obscureText: isShow? true: false,
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
                      border: OutlineInputBorder(),

                      filled: true,
                      fillColor: Colors.grey[900],
                      //   labelText: 'Password',
                      hintText: 'Password',
                      hintStyle: new TextStyle(color: Colors.grey[400])
                  ),

                ),
              ),

              new SizedBox(
                height: 25,
              ),

              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: GestureDetector(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    //padding: EdgeInsets.symmetric(vertical: 15),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(40)),

                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Colors.lightGreen[500], Colors.lightGreenAccent])),
                    child: Column(
                      children: <Widget>[

                        new SizedBox(
                          height: 13,
                        ),
                        Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),

                        new SizedBox(
                          height: 13,
                        ),
                      ],
                    ),
                  ),
                  onTap: ()
                  {

                  },
                ),
              ),




            ],
          ),
        ),
      ),
    );
  }
}


