import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testing_app/Consts/Strings.dart';
import 'package:http/http.dart' as http;


class TimeSlotPopUp extends StatefulWidget {

  String event ;



  TimeSlotPopUp(this.event);

  @override
  _TimeSlotPopUpState createState() => _TimeSlotPopUpState(this.event);
}

class _TimeSlotPopUpState extends State<TimeSlotPopUp> {


  _TimeSlotPopUpState(this.event);

  String event ;

  final format = DateFormat("yyyy-MM-dd HH:mm");
  DateTime _start ;
  DateTime _end ;
  TextEditingController _controllerTitle = new TextEditingController();
  TextEditingController _controllerLocation = new TextEditingController();




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
            controller: _controllerTitle,
            decoration: InputDecoration(hintText: "Title"),
          ),
          SizedBox(height: 16.0),
          TextField(
            minLines: 3,
            maxLines: 3,
            controller: _controllerLocation,
            decoration: InputDecoration(hintText: "Location (Optional)" , ),
          ),
          SizedBox(height: 16.0),
          _startDateInput(),
          SizedBox(height: 16.0),
          _endDateInput(),
          SizedBox(height: 24.0),
          _getButtons(),

        ],
      ),
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
      decoration: InputDecoration(hintText: "End Time (Optional)"),
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


  _getButtons(){


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
            await _saveTimeSlot() ;
            Navigator.of(context).pop(); // To close the dialog
          },
          child: Text("Save" , style: TextStyle(color: Colors.blue , fontWeight: FontWeight.bold),),
        )
      ],
    ) ;

  }


  _saveTimeSlot() async {

    if(_start==null) _start = DateTime.now() ;
    if(_end==null) _end = DateTime.now().add(Duration(days: 2)) ;
    var header = {
      "Content-Type": "application/json",
    };
    var body = {
      "title": _controllerTitle.text.toString(),
      "location": _controllerLocation.text.toString(),
      "event": event,
      "start_date": _start.toIso8601String(),
      "end_date": _end.toIso8601String(),
    };
    await http
        .post(baseUrl+"api/event/timeslot",
        headers: header, body: json.encode(body))
        .then((http.Response response) {
          print(response.body);
        });


  }

  }




class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}
