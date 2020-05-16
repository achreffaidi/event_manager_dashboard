import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:testing_app/Api/Request/request.dart';
import 'package:testing_app/Api/staff/staff.dart';
import 'package:testing_app/Consts/Strings.dart';
import 'package:testing_app/Widgets/RequestPopUp.dart';
import 'package:testing_app/Widgets/staffPopUp.dart';

class EventRequestsUI extends StatefulWidget {
  String event ;
  EventRequestsUI({Key key,this.event}) : super(key: key);

  @override
  _EventRequestsUIState createState() => _EventRequestsUIState(event);
}

class _EventRequestsUIState extends State<EventRequestsUI> {

  _EventRequestsUIState(this.event) ;
  List<RequestElement> _requests = new List();
  List<String> _permissions = new List();
  String event  ;
  List<String> requestState = ["Pending","Unpaid","Accepted","Refused"];
  _loadRequests(){
    http.get(baseUrl+"api/event/request",headers: {
      "event":event
    }).then((http.Response response){
      print(response.body);
      _requests = requestsFromJson(response.body).requests;
      setState(() {

      });
    });
  }


  @override
  void initState() {
    _loadRequests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Requests"),leading: Container(),actions: <Widget>[
        FlatButton.icon(onPressed: (){
          _loadRequests();
        }, icon: Icon(Icons.refresh), label: Text("Refresh") , color: Colors.green,)
      ],),
      body: _getBody(),
    );
  }

  _getBody() {
    return Container(
      child: ListView.builder(
          itemCount: _requests.length,
          itemBuilder: _requestItemBuilder)
    );
  }



  Widget _requestItemBuilder(BuildContext context, int index) {

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
                  Text(_requests[index].plan.name , style: TextStyle(fontSize: 23 ,fontWeight: FontWeight.bold),),
                  Text(_requests[index].user.name , style: TextStyle(fontSize: 18 ,fontWeight: FontWeight.bold),),
                  Text(_requests[index].plan.cost.toString()+" TND" , style: TextStyle(color: Colors.green ,fontSize: 18 ,fontWeight: FontWeight.bold),),
                  Text("Request State :"+requestState[_requests[index].request.state]),
                ],
              ),
              Column(
                children: <Widget>[
                  RaisedButton.icon(onPressed: (){
                    _updateRequest(_requests[index]);
                  }, icon: Icon(Icons.update), label: Text("Update")),
                  RaisedButton.icon(onPressed: (){
                    _deleteRequest(_requests[index]) ;
                  }, icon: Icon(Icons.delete), label: Text("Delete")),
                ],
              )
            ],
          ),
        ),
      )
    );
  }


  _updateRequest(RequestElement requestElement){

    showDialog(
      context: context,
      builder: (BuildContext context) => CustomRequestDialog(
          requestElement.request.id
      ),
    ).then((result){
      _loadRequests();
    });
  }



  _deleteRequest(RequestElement request){

    http.delete(baseUrl+"api/event/request",

    headers: {
      "id":request.request.id
    }
    ).then((http.Response response){
      print(response.body) ;
_loadRequests();
    });
  }


}
