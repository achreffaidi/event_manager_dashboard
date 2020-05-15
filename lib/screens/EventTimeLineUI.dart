import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:testing_app/Api/Request/request.dart';
import 'package:testing_app/Api/TimeSlots/timeslots.dart';
import 'package:testing_app/Api/staff/staff.dart';
import 'package:testing_app/Consts/Strings.dart';
import 'package:testing_app/Widgets/RequestPopUp.dart';
import 'package:testing_app/Widgets/TimeSlotPopUp.dart';
import 'package:testing_app/Widgets/staffPopUp.dart';

class EventTimeLineUI extends StatefulWidget {
  String event ;
  EventTimeLineUI(this.event) ;

  @override
  _EventTimeLineUIState createState() => _EventTimeLineUIState(event);
}

class _EventTimeLineUIState extends State<EventTimeLineUI> {

  _EventTimeLineUIState(this.event) ;

  String event  ;
  List<Timeslot> timeslots;

  _loadTimeSlots(){
    http.get(baseUrl+"api/event/timeslot",headers: {
      "event":event
    }).then((http.Response response){
      print(response.body);
      timeslots =  timeSlotsFromJson(response.body).timeslots;
      setState(() {

      });
    });
  }


  @override
  void initState() {
    timeslots = new List() ;
    _loadTimeSlots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Time Line"),actions: <Widget>[
        FlatButton.icon(onPressed: (){
          _addTimeSlot();
        }, icon: Icon(Icons.add), label: Text("Add TimeSlot") , color: Colors.green,)
      ],),
      body: _getBody(),
    );
  }

  _getBody() {
    return Container(
      child: ListView.builder(
          itemCount: timeslots.length,
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
                  Text(timeslots[index].title , style: TextStyle(fontSize: 23 ,fontWeight: FontWeight.bold),),
                  Text(timeslots[index].location , style: TextStyle(fontSize: 18 ,fontWeight: FontWeight.bold),),
                  Text(timeslots[index].startDate.toIso8601String() , style: TextStyle(fontSize: 18 ,fontWeight: FontWeight.bold),),
                  Text(timeslots[index].endDate.toIso8601String() , style: TextStyle(fontSize: 18 ,fontWeight: FontWeight.bold),),
                ],
              ),
              Column(
                children: <Widget>[
                  RaisedButton.icon(onPressed: (){
                    _deleteTimeSlot(timeslots[index]) ;
                  }, icon: Icon(Icons.delete), label: Text("Delete")),
                ],
              )
            ],
          ),
        ),
      )
    );
  }



  _deleteTimeSlot(Timeslot timeslot){

    http.delete(baseUrl+"api/event/timeslot",

    headers: {
      "id":timeslot.id
    }
    ).then((http.Response response){
      print(response.body) ;
_loadTimeSlots();
    });
  }

  void _addTimeSlot() {

    showDialog(
      context: context,
      builder: (BuildContext context) => TimeSlotPopUp(event),
    ).then((result){
      _loadTimeSlots();
    });

  }


}
