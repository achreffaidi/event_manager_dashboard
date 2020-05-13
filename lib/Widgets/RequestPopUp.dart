import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testing_app/Consts/Strings.dart';
import 'package:http/http.dart' as http;


class CustomRequestDialog extends StatefulWidget {

  String id ;

  CustomRequestDialog(this.id);

  @override
  _CustomRequestDialogState createState() => _CustomRequestDialogState(id);
}

class _CustomRequestDialogState extends State<CustomRequestDialog> {


  _CustomRequestDialogState(this.id);

  String id ;




  List<String> options = new List() ;



  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Container(

      padding: EdgeInsets.only(
        top:  Consts.padding,
        bottom: Consts.padding,
        left: Consts.padding,
        right: Consts.padding,
      ),
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(Consts.padding),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // To make the card compact
        children: <Widget>[
          Text(
            "Change Request State To"
          ),
          SizedBox(height: 16.0),
          getButton(0,Colors.deepOrange,"pending"),
          SizedBox(height: 16.0),
          getButton(1,Colors.purple,"unpaid"),
          SizedBox(height: 16.0),
          getButton(2,Colors.green,"accepted"),
          SizedBox(height: 16.0),
          getButton(3,Colors.red,"refused"),
          SizedBox(height: 16.0),




        ],
      ),
    );
  }





  _updateStateTo(int state) async {

    var body = {
      "id":id,
      "state":state,
    };

    print(body);
   await http.put(baseUrl+"api/event/request",
        headers: {
      "Content-Type":"application/json"
    },body: json.encode(body)
    ).then((http.Response response){
      print(response);
    });


  }

  getButton(int i, MaterialColor color , String text) {
    return RaisedButton(
      child: Container( width: 300, child: Text(text,style: TextStyle(color: color),)),
      color: Colors.white,
      splashColor: color,
      onPressed: () async {
        await _updateStateTo(i);
        Navigator.of(context).pop();
      },
    );
  }


}
class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}
