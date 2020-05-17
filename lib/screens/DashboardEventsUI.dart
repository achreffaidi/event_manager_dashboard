import 'dart:convert';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing_app/Api/Events/ListEvents.dart';
import 'package:testing_app/Consts/Strings.dart';
import 'package:intl/intl.dart';
import 'package:testing_app/Widgets/sidebare_menu.dart';
import 'package:testing_app/screens/AddEventsUI.dart';
import 'package:testing_app/tools/Images.dart';
import 'package:testing_app/extensions/hover_extension.dart';

import 'EventAdminView.dart';
import 'EventCountingUI.dart';
import 'EventRequestsUI.dart';
import 'EventStaffUI.dart';
import 'EventTimeLineUI.dart';

class DashboardEventsUI extends StatefulWidget {
  @override
  _DashboardEventsUIState createState() => _DashboardEventsUIState();
}

class _DashboardEventsUIState extends State<DashboardEventsUI> {

  List<Event> events = new List<Event>();
  Map<String , ImageProvider> images  = new Map();
  List<DropdownMenuItem<Event>> _dropdownMenuItems;
  Event _selectedEvent;
  int _selectedEventIndex;
  int _selectedPage = 0 ;
  Widget _currentPage ;
  List<List<Widget>> pages = new List();


  @override
  void initState() {
    _loadEvents();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedEvent==null?"event":_selectedEvent.name),
        leading: Container(),
        actions: <Widget>[
          Container(

            child: DropdownButton(
              underline: SizedBox(),

              value: _selectedEvent,
              items: _dropdownMenuItems,
              onChanged: onChangeDropdownItem,

            ),
          ),
          RaisedButton.icon(onPressed: _addEvent, icon: Icon(Icons.add), label: Text("Add Event",style: TextStyle(color: Colors.white),),color: Colors.green,),
        ],
      ),
      body:

      Row(
        children: <Widget>[
          SideBarMenu((index){
            setState(() {
              _selectedPage = index;
            });
          }),
          new Expanded(
            child: Container(
              width: 1200,
              child:_selectedEvent==null? Container(): Padding(
                padding: const EdgeInsets.all(20.0),
                child: getSelectedPage(),
              ),
            ),
          ),
        ],
      ));

  }
  void _updateMenu(Event selectedEvent) {
    print("On Update Menu") ;
    _selectedEventIndex = events.indexOf(selectedEvent);
    setState(() {

    });
  }



  _loadEvents() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = await prefs.get("id");
    http.get(baseUrl+"api/events/admin",
    headers: {
      "user":id
    }
    ).then((http.Response response){

      print(response.body);
      if(response.statusCode==200){
        EventList eventList = eventListFromJson(response.body) ;

        events = eventList.data ;
        _dropdownMenuItems = buildDropdownMenuItems(events);
        _selectedEvent = events[0];
        pages = new List();

        _updateMenu(_selectedEvent);
        setState(() {

        });
      }
      
      
    });
    
    
  }




  void _addEvent() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEvent()),
    );
  }

  Widget addCard() {
    return Card(
      child: Column(
        children: [
          Container(
            
              child: Image.asset("assets/empty_list.png")),
          Hero(
            tag: "Button",
            child: FlatButton.icon(
                color: Colors.greenAccent,
                onPressed: _addEvent, icon: Icon(Icons.add_circle,color: Colors.white,), label: Text("Add Event" , style: TextStyle(color: Colors.white),)),
          )

        ],
      ),
    );
  }


  List<DropdownMenuItem<Event>> buildDropdownMenuItems(List events) {
    List<DropdownMenuItem<Event>> items = List();
    for (Event event in events) {
      items.add(
        DropdownMenuItem(

          value: event,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(width:200,child: Text(event.name)),
            ),
          ),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(Event selectedEvent) {
          _selectedEvent = selectedEvent;
      _updateMenu(selectedEvent);

  }

  getSelectedPage() {

    switch(_selectedPage){
      case 0 : return new  EventAdminView(key: Key(DateTime.now().millisecondsSinceEpoch.toString()),event:_selectedEvent);
      case 1 : return new EventStaffUI(key: Key(DateTime.now().millisecondsSinceEpoch.toString()),event:_selectedEvent.id);
      case 2 : return new EventRequestsUI(key: Key(DateTime.now().millisecondsSinceEpoch.toString()),event:_selectedEvent.id);
      case 3 : return new EventCountingUI(key: Key(DateTime.now().millisecondsSinceEpoch.toString()),event:_selectedEvent.id);
      case 4 : return new EventTimeLineUI(key: Key(DateTime.now().millisecondsSinceEpoch.toString()),event:_selectedEvent.id);
    }

    setState(() {

    });


  }



}
