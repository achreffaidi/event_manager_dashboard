import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testing_app/Api/staff/staff.dart';
import 'package:testing_app/Consts/Strings.dart';
import 'package:http/http.dart' as http;


class CustomStaffDialog extends StatefulWidget {

  Staff staff ;

  String event ;
  List<String> _permissions ;


  CustomStaffDialog(this.staff, this.event, this._permissions);

  @override
  _CustomStaffDialogState createState() => _CustomStaffDialogState(staff,event,_permissions);
}

class _CustomStaffDialogState extends State<CustomStaffDialog> {


  _CustomStaffDialogState(
      this.staff, this.event, this._permissions);

  Staff staff ;
  String event ;
  List<String> _permissions ;

  TextEditingController _controllerEmail = new TextEditingController();


  List<bool> list_bool = new List();

  @override
  void initState() {
    print("I am here ");
    for(int i =0 ; i<_permissions.length;i++) list_bool.add(false) ;
    print("I am here ");
    if(staff!=null){
      _controllerEmail.text = staff.user.email;
      for(int x in staff.permissions) list_bool[x]= true;

    }else{

    }
    print("I am here ");



    super.initState();
  }



  _getPermissionWidget(){
    List<Widget> list = new List();
    for(int i =0 ; i<_permissions.length;i++){
      list.add(Card(child: Container(child:
        Row(children: <Widget>[
          Text(_permissions[i]),
          Switch(
            value: list_bool[i],
            onChanged: (val){
              setState(() => list_bool[i]= val );
            },
          )
        ],)
        ,),));
    }
    return list ;
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
          (staff!=null)?Container(): TextField(
            controller: _controllerEmail,
            decoration: InputDecoration(hintText: "Email"),
          ),
          SizedBox(height: 16.0),



        ]+_getPermissionWidget()+[
          SizedBox(height: 24.0),
          _getButtons(),
        ],
      ),
    );
  }

  _getButtons(){
    if(staff!=null) return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop(); // To close the dialog
          },
          child: Text("Cancel" , style: TextStyle(color: Colors.orange , fontWeight: FontWeight.bold),),
        ),
        FlatButton(
          onPressed: () async {
            await _deletePlan();
            Navigator.of(context).pop(); // To close the dialog
          },
          child: Text("Delete" , style: TextStyle(color: Colors.red , fontWeight: FontWeight.bold),),
        ),FlatButton(
          onPressed: ()async {
            await _updatePlan();
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
            await _savePlan() ;
            Navigator.of(context).pop(); // To close the dialog
          },
          child: Text("Save" , style: TextStyle(color: Colors.blue , fontWeight: FontWeight.bold),),
        )
      ],
    ) ;

  }


  _savePlan() async {

    List<int> per = new List();
    for(int i = 0 ;i < list_bool.length;i++) if(list_bool[i]) per.add(i);

    var body = {
      "email": _controllerEmail.text.toString(),
      "event":event,
      "permissions":per
    };

    await http.post(baseUrl+"api/event/staff"
    ,body: json.encode(body) ,headers: {
      "Content-Type":"application/json"
      },
    ).then((http.Response response){
      print(response.body);
    });

  }
  _updatePlan() async {
    List<int> per = new List();
    for(int i = 0 ;i < list_bool.length;i++) if(list_bool[i]) per.add(i);

    var body = {
      "id": staff.id,
      "permissions":per
    };

    await http.put(baseUrl+"api/event/staff", headers: {
      "Content-Type":"application/json"
    }
        ,body: json.encode(body)
    ).then((http.Response response){
      print(response.body);
    });

  }
  _deletePlan() async {

  }


}
class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}
