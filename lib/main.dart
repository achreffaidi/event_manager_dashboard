import 'dart:convert';
import 'dart:html' as html;
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing_app/Consts/Strings.dart';
import 'package:testing_app/screens/AddEventsUI.dart';
import 'package:testing_app/screens/DashboardEventsUI.dart';

import 'screens/EventStaffUI.dart';

void main() {
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(

        primarySwatch: Colors.blueGrey,

      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();


  @override
  void initState() {

    _emailController.text = "achreffaidi@gmail.com";
    _passwordController.text = "achreffaidi@gmail.com";
    _tryConnectLocally();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title , style: GoogleFonts.dancingScript(),),
      ),
      body: Center(

        child: Column(
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: "Email"
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                  hintText: "Password"
              ),
            ),
            RaisedButton(child: Text("Login"),onPressed: _goToEvent ,) ,



          ],

        ),
      ),
    );
  }



  void _tryConnectLocally() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey('id')){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DashboardEventsUI()),
      );
    }

  }

  void _goToEvent() async {

    print("trying to login") ;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var body = {
      "email" :_emailController.text.toString(),
      "password":_passwordController.text.toString()
    };

   await http.post(baseUrl+"api/login/admin" , body: json.encode(body) ,
   headers:{
     "Content-Type":"application/json"
   }

   ).then((http.Response response) async{

     if(response.statusCode==444){

       var res = json.decode(response.body);
       print(res["message"]);

     }
      if(response.statusCode==200){
        print(response.body);
        var res = json.decode(response.body);
        print(res);
        await prefs.setString('id', res["id"]);
        await prefs.setString('name', res["name"]);
        await prefs.setString('token', res["token"]);

        print("i am here ");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashboardEventsUI()),
        );
      }

    });


  }

}
