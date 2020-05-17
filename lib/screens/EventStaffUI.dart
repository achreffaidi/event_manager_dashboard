import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:testing_app/Api/staff/staff.dart';
import 'package:testing_app/Consts/Strings.dart';
import 'package:testing_app/Widgets/staffPopUp.dart';

class EventStaffUI extends StatefulWidget {
  EventStaffUI({Key key,this.event}) : super(key: key);

  String event ;

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
      appBar: AppBar(title: Text("Staff"),
        leading: Container(),
        actions: <Widget>[
        FlatButton.icon(onPressed: (){
          _newStaff(null);
        }, icon: Icon(Icons.add), label: Text("add Stuff") , color: Colors.green,)
      ],),
      body: _getBody(),
    );
  }

  _getBody() {
    double width = MediaQuery.of(context).size.width*0.8 ;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Card(child: Container(  child: generateTable())),
          Card(child: Container(width: 300.0, child: getPermissionTable(),),)
        ],
      )
    );
  }

  List<Widget> _getPermissionList(List<int> per){
    List<Widget> list = new List();
    for(int i in per) list.add(Text(_permissions[i]));
    return list ;
  }


  Widget generateTable(){

    List<DataColumn> temp = new List();
    _permissions.forEach((s){
      temp.add(
        DataColumn(
            label: Text(
              s,
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w900),
            )),
      );
    });

    return PaginatedDataTable(

      source: StaffDataSource(_staffs,_permissions,_deleteStaff,_updateStaff),
      header: Text("Table of Staffs"),
      rowsPerPage: 5,
      columns: [

        DataColumn(
            label: Text(
              "name",
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w900),
            )),
        DataColumn(
            label: Text(
              "email",
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w900),
            )),
        DataColumn(
            label: Text(
              "phone",
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w900),
            )),
      ] +
      temp +
      [
        DataColumn(
            label: Text(
              "Update",
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w900),
            )),
        DataColumn(
            label: Text(
              "Delete",
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w900),
            )),

      ],
    );

  }

  Widget getPermissionTable(){

    List<DataRow> temp = new List();
    List<int> permissions = [];
    for(int i = 0 ; i<_permissions.length ; i++) permissions.add(0);
    _staffs.forEach((staff){
      staff.permissions.forEach((x){
        permissions[x]++;
      });
    });
    for(int i = 0 ; i<_permissions.length ; i++) {
      temp.add(
        DataRow(
          cells: [
        DataCell(
        Text(_permissions[i]),
    ),
            DataCell(
              Text(permissions[i].toString()),
            ),
          ]
        ));
    };


    return DataTable(

      columns: [
        DataColumn(
          label: Text("Permission"),
          numeric: false,
        ),
        DataColumn(
          label: Text("Staffs"),
          numeric: true,
        ),
      ],
      rows: temp ,
    );

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


class StaffDataSource extends DataTableSource {



  final List<Staff> _results;
  List<String> _permissions ;
  final Function _deleteStaff ,_updateStaff  ;
  StaffDataSource(this._results,this._permissions,this._deleteStaff,this._updateStaff);

  void _sort<T>(Comparable<T> getField(Staff d), bool ascending) {
    notifyListeners();
  }

  int _selectedCount = 0;



  @override
  DataRow getRow(int index) {

    List<DataCell> temp = new List();


    assert(index >= 0);
    if (index >= _results.length) return null;
    final Staff result = _results[index];
    for(int i =0 ; i<_permissions.length ; i++){
      if(result.permissions.contains(i)) temp.add(DataCell(Icon(Icons.check,color: Colors.green,)));
      else temp.add(DataCell(Icon(Icons.not_interested,color: Colors.red,)));
    }
    return DataRow.byIndex(
        index: index,
        cells: <DataCell>[
          DataCell(Text('${result.user.name}',style: TextStyle(fontWeight: FontWeight.bold),)),
          DataCell(Text('${result.user.email}')),
          DataCell(Text('${result.user.number}')),

        ]
        + temp + [
          DataCell(Text('update' , style: TextStyle(color:Colors.blue),),onTap:(){
            _updateStaff(result);
          }),
          DataCell(Text('delete' , style: TextStyle(color:Colors.red),),onTap:(){
            _deleteStaff(result);
          }),
        ]


    );
  }

  @override
  int get rowCount => _results.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;


}
