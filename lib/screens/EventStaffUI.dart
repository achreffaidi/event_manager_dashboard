import 'package:flutter/material.dart';

class EventStaffUI extends StatefulWidget {
  String event ;
  EventStaffUI(this.event) ;

  @override
  _EventStaffUIState createState() => _EventStaffUIState(event);
}

class _EventStaffUIState extends State<EventStaffUI> {

  _EventStaffUIState(this.event) ;

  String event  ;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
