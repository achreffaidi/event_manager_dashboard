import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:testing_app/Api/staff/staff.dart';
import 'package:testing_app/Consts/Strings.dart';
import 'package:testing_app/Widgets/staffPopUp.dart';

class EventStaffUI extends StatefulWidget {
  String event ;
  EventStaffUI(this.event) ;

  @override
  _EventStaffUIState createState() => _EventStaffUIState(event);
}

class _EventStaffUIState extends State<EventStaffUI> {

  _EventStaffUIState(this.event) ;
  List<Staff> _staffs = new List();
  List<String> _permissions = new List();
  String event  ;

  _loadStaff(){
    http.get(baseUrl+"api/event/staff",headers: {
      "event":event
    }).then((http.Response response){
      print(response.body);
      _staffs = staffsFromJson(response.body).staffs;
      setState(() {

      });
    });
  }
  _loadPermissions() async {
    await http.get(baseUrl+"api/event/staff/permissions").then((http.Response response){


       _permissions =  List<String>.from(json.decode(response.body)["permissions"].map((x) => x)) ;
       print(_permissions);
       _loadStaff();
    });
  }

  @override
  void initState() {
    _loadPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Staff"),actions: <Widget>[
        FlatButton.icon(onPressed: (){
          _newStaff(null);
        }, icon: Icon(Icons.add), label: Text("add Stuff") , color: Colors.green,)
      ],),
      body: _getBody(),
    );
  }

  _getBody() {
    return Container(
      child: ListView.builder(
          itemCount: _staffs.length,
          itemBuilder: _staffItemBuilder)
    );
  }

  List<Widget> _getPermissionList(List<int> per){
    List<Widget> list = new List();
    for(int i in per) list.add(Text(_permissions[i]));
    return list ;
  }

  Widget _staffItemBuilder(BuildContext context, int index) {
    return Card(
      child :
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_staffs[index].user.name , style: TextStyle(fontSize: 23 ,fontWeight: FontWeight.bold),),
                  Text(_staffs[index].user.email),
                  Text("permissions :"),
                ]+_getPermissionList(_staffs[index].permissions),
              ),
              Column(
                children: <Widget>[
                  RaisedButton.icon(onPressed: (){
                    _updateStaff(_staffs[index]);
                  }, icon: Icon(Icons.update), label: Text("Update")),
                  RaisedButton.icon(onPressed: (){
                    _deleteStaff(_staffs[index]) ;
                  }, icon: Icon(Icons.delete), label: Text("Delete")),
                ],
              )
            ],
          ),
        ),
      )
    );
  }


  _updateStaff(Staff staff){
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomStaffDialog(
       staff,event,_permissions
      ),
    ).then((result){
      _loadStaff();
    });
  }

  _newStaff(Staff staff){
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomStaffDialog(
          staff,event,_permissions
      ),
    ).then((result){
      _loadStaff();
    });
  }

  _deleteStaff(Staff staff){
    http.delete(baseUrl+"api/event/staff",
    headers: {
      "id":staff.id
    }
    ).then((http.Response response){
      print(response.body) ;
      _loadStaff();
    });
  }


}
