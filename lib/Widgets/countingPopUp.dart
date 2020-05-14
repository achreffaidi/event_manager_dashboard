import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testing_app/Api/EventCounting/event_counting.dart';
import 'package:testing_app/Api/staff/staff.dart';
import 'package:testing_app/Consts/Strings.dart';
import 'package:http/http.dart' as http;


class CustomCountingDialog extends StatefulWidget {



String event  ;
  Counting counting;



  CustomCountingDialog(this.counting , this.event);

  @override
  _CustomCountingDialogState createState() => _CustomCountingDialogState(counting,event);
}

class _CustomCountingDialogState extends State<CustomCountingDialog> {


  _CustomCountingDialogState(
      this.counting , this.event);

  String event ;
  Counting counting;

  TextEditingController _controllerName = new TextEditingController();


  List<bool> list_bool = new List();

  @override
  void initState() {
    if (counting != null) {
      _controllerName.text = counting.name;
      super.initState();
    }
  }

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
       width: 400,
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
          TextField(
            controller: _controllerName,
            decoration: InputDecoration(hintText: "Counting Name"),
          ),
          SizedBox(height: 16.0),


          SizedBox(height: 24.0),
          _getButtons(),
        ],
      ),
    );
  }

  _getButtons(){
    if(counting!=null) return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop(); // To close the dialog
          },
          child: Text("Cancel" , style: TextStyle(color: Colors.orange , fontWeight: FontWeight.bold),),
        ),
        FlatButton(
          onPressed: ()async {
            await _updateCounting();
            Navigator.of(context).pop(); // To close the dialog
          },
          child: Text("Update" , style: TextStyle(color: Colors.blue , fontWeight: FontWeight.bold),),
        )
      ],
    ) ;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop(); // To close the dialog
          },
          child: Text("Cancel" , style: TextStyle(color: Colors.orange , fontWeight: FontWeight.bold),),
        ),FlatButton(
          onPressed: () async {
            await _saveCounting() ;
            Navigator.of(context).pop(); // To close the dialog
          },
          child: Text("Save" , style: TextStyle(color: Colors.blue , fontWeight: FontWeight.bold),),
        )
      ],
    ) ;

  }


  _saveCounting() async {

    List<int> per = new List();
    for(int i = 0 ;i < list_bool.length;i++) if(list_bool[i]) per.add(i);

    var body = {
      "name": _controllerName.text.toString(),
      "event":event
    };

    await http.post(baseUrl+"api/event/presence"
    ,body: json.encode(body) ,headers: {
      "Content-Type":"application/json"
      },
    ).then((http.Response response){
      print(response.body);
    });

  }
  _updateCounting() async {


    var body = {
      "id": counting.id,
      "name":_controllerName.text.toString()
    };

    await http.put(baseUrl+"api/event/presence", headers: {
      "Content-Type":"application/json"
    }
        ,body: json.encode(body)
    ).then((http.Response response){
      print(response.body);
    });

  }



}
class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}
