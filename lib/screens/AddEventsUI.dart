import 'dart:convert';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:testing_app/Consts/Strings.dart';
import 'package:intl/intl.dart';

class AddEvent extends StatefulWidget {
  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Events"),
      ),
      body: _getBody(),
    );
  }

  _getBody() {
    return Center(
      child: Container(
        height: 500,
        width: 500,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              child: _getAddEventForum(),
            ),
          ),
        ),
      ),
    );
  }

  final format = DateFormat("yyyy-MM-dd HH:mm");
  DateTime _start ;
  DateTime _end ;
  TextEditingController eventNameController = new TextEditingController();
  TextEditingController eventDescController = new TextEditingController();
  TextEditingController eventlocController = new TextEditingController();
  _getAddEventForum() {
    return Column(
      children: [
        TextField(
          controller: eventNameController,
          decoration: InputDecoration(hintText: "Event Name"),
        ),
        TextField(
          controller: eventDescController,
          decoration: InputDecoration(hintText: "Description  "),
        ),
        TextField(
          controller: eventlocController,
          decoration: InputDecoration(hintText: "Location"),
        ),
        _startDateInput() ,
        _endDateInput() ,
        Hero(
          tag: "Button",
          child: FlatButton.icon(
            color: Colors.greenAccent,
            icon: Icon(Icons.save),
            label: Text("Submit"),
            onPressed: _submitNewEvent,
          ),
        )
      ],
    );
  }

  _startDateInput(){
    return DateTimeField(
      onChanged: (DateTime val){
      _start = val ;
      },
      decoration: InputDecoration(hintText: "Start Time"),
      format: format,
      onShowPicker: (context, currentValue) async {
        final date = await showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100));
        if (date != null) {
          final time = await showTimePicker(
            context: context,
            initialTime:
            TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
          );
          return DateTimeField.combine(date, time);
        } else {
          return currentValue;
        }
      },
    ) ;
  }
  _endDateInput(){
    return DateTimeField(
      onChanged: (DateTime val){
      _end = val ;
      },
      decoration: InputDecoration(hintText: "End Time"),
      format: format,
      onShowPicker: (context, currentValue) async {
        final date = await showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100));
        if (date != null) {
          final time = await showTimePicker(
            context: context,
            initialTime:
            TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
          );
          return DateTimeField.combine(date, time);
        } else {
          return currentValue;
        }
      },
    ) ;
  }
  void _submitNewEvent() {
    if(_start==null) _start = DateTime.now() ;
    if(_end==null) _end = DateTime.now().add(Duration(days: 2)) ;
    var header = {
      "Content-Type": "application/json",
    };
    var body = {
      "name": eventNameController.text.toString(),
      "description": eventDescController.text.toString(),
      "location": eventlocController.text.toString(),
      "admin": userId,
      "start_date": _start.toIso8601String(),
      "end_date": _end.toIso8601String(),
    };
    http
        .post(baseUrl+"api/events",
            headers: header, body: json.encode(body))
        .then((http.Response response) => {print(response.body)});
  }
}
