import 'dart:convert';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_builder/responsive_builder.dart';
import 'package:testing_app/Api/Events/ListEvents.dart';
import 'package:testing_app/Consts/Strings.dart';
import 'package:intl/intl.dart';
import 'package:testing_app/screens/AddEventsUI.dart';
import 'package:testing_app/tools/Images.dart';
import 'package:testing_app/extensions/hover_extension.dart';

import 'EventAdminView.dart';

class DashboardEventsUI extends StatefulWidget {
  @override
  _DashboardEventsUIState createState() => _DashboardEventsUIState();
}

class _DashboardEventsUIState extends State<DashboardEventsUI> {

  List<Event> events = new List<Event>();
  Map<String , ImageProvider> images  = new Map();

  @override
  void initState() {
    _loadEvents();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      body:  ResponsiveBuilder(
        builder: (context, sizingInformation) {
      // Check the sizing information here and return your UI
      if (sizingInformation.deviceScreenType ==
          DeviceScreenType.Desktop) {
        return _getBody(0);
      }

      if (sizingInformation.deviceScreenType == DeviceScreenType.Tablet) {
        return _getBody(1);
      }

      if (sizingInformation.deviceScreenType == DeviceScreenType.Mobile) {
        return _getBody(2);
      }


      return _getBody(0);
    },

    ));

  }

  _getBody(int mode) {
    int _rowCount ;
    switch(mode){
      case 0 : _rowCount = 5 ; break ;
      case 1 : _rowCount = 3 ; break ;
      case 2 : _rowCount = 1 ; break ;
    }
    return  events.isEmpty ? _emptyList():_eventList(_rowCount);
  }
  
  
  
  _loadEvents() async{
    
    http.get(baseUrl+"api/events").then((http.Response response){

      print(response.body);
      if(response.statusCode==200){
        EventList eventList = eventListFromJson(response.body) ;
        events = eventList.data ;
        setState(() {

        });
      }
      
      
    });
    
    
  }



  _emptyList() {
    return Container(
      child: Center(
        child: Column(
          children: [
            Container(
                height: 200,
                width: 200,
                child: Image.asset("assets/empty_list.png")),
            Hero(
              tag: "Button",
              child: FlatButton.icon(
                  color: Colors.greenAccent,
                  onPressed: _addEvent, icon: Icon(Icons.add_circle,color: Colors.white,), label: Text("Add Event" , style: TextStyle(color: Colors.white),)),
            )
          ],
        ),
      ),
    );

  }

  _eventList(int _rowCount){
    return
        Container(
          child :
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: new GridView.builder(
                itemCount: events.length+1,
                gridDelegate:
                new SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.8,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    crossAxisCount: _rowCount),
                itemBuilder: _getEventItem),
          )
        );
  }

  Widget _getEventItem(BuildContext context, int index){


    if(index==events.length) return addCard() ;
    String id = events[index].id ;
    if(!images.containsKey(id))
      images[id] =
          AdvancedNetworkImage(

            baseUrl+"api/event/image?event="+id,

            useDiskCache: false,
            cacheRule: CacheRule(maxAge: const Duration(days: 7)),
          );
    return
        GestureDetector(


          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EventAdminView(events[index],images[id])),
            ).then((result){
              images[id] = AdvancedNetworkImage(

                baseUrl+"api/event/image?event="+events[index].id+"&rand="+DateTime.now().millisecondsSinceEpoch.toString(),

                useDiskCache: true,
                cacheRule: CacheRule(maxAge: const Duration(days: 7)),
              ) ;
              setState(() {

              });
            });
          },
          child: AspectRatio(
            aspectRatio: 0.4,
            child: Card(child: Center(child: Column(
              children: [
                Hero(
                  tag : "image:"+events[index].id ,
                  child: AspectRatio(
                    aspectRatio: 1.5,
                    child: Image(
                      image: images[id],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AspectRatio(
                    aspectRatio: 1.8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                      children: <Widget>[
                        Text(events[index].name , style: TextStyle(fontSize: 25 , fontWeight: FontWeight.bold),),
                        Row(children: <Widget>[Icon(Icons.location_on),SizedBox(width: 10,),Text(events[index].location)],),
                        Row(children: <Widget>[Icon(Icons.timer),SizedBox(width: 10,),Text(events[index].startDate.toIso8601String())],),
                        Row(children: <Widget>[Icon(Icons.timer_off),SizedBox(width: 10,),Text(events[index].endDate.toIso8601String())],),
                      ],
                    ),
                  ),
                ),
              ],
            ),),),
          ),
        ).showCursorOnHover.moveUpOnHover;
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
}
