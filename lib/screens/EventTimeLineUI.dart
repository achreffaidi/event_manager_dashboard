import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'package:testing_app/Api/Request/request.dart';
import 'package:testing_app/Api/TimeSlots/timeslots.dart';
import 'package:testing_app/Api/staff/staff.dart';
import 'package:testing_app/Consts/Strings.dart';
import 'package:testing_app/Widgets/RequestPopUp.dart';
import 'package:testing_app/Widgets/TimeSlotPopUp.dart';
import 'package:testing_app/Widgets/staffPopUp.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';
import 'package:intl/intl.dart';


class EventTimeLineUI extends StatefulWidget {
  String event ;
  EventTimeLineUI({Key key,this.event}) : super(key: key);

  @override
  _EventTimeLineUIState createState() => _EventTimeLineUIState(event);
}

class _EventTimeLineUIState extends State<EventTimeLineUI> {

  _EventTimeLineUIState(this.event) ;

  final m = new DateFormat('MMMEd');
  final d = new DateFormat('jm');

  String event  ;
  List<Timeslot> timeslots;

  _loadTimeSlots(){
    http.get(baseUrl+"api/event/timeslot",headers: {
      "event":event
    }).then((http.Response response){
      print(response.body);
      timeslots =  timeSlotsFromJson(response.body).timeslots;
      timeslots.sort((Timeslot a, Timeslot b) => a.startDate.compareTo(b.startDate) );

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
      appBar: AppBar(title: Text("Time Line"),leading: Container(),actions: <Widget>[
        FlatButton.icon(onPressed: (){
          _addTimeSlot();
        }, icon: Icon(Icons.add_circle,color: Colors.green,), label: Text("Add TimeSlot" , style: TextStyle(color: Colors.green),) ,color: Colors.white),
        FlatButton.icon(onPressed: (){
          exportData();
        }, icon: Icon(Icons.file_download, color: Colors.deepOrange,), label: Text("Export as CSV" , style: TextStyle(color: Colors.deepOrange),) ,color: Colors.white,)

      ],),
      body: _getBody(),
    );
  }


  void exportData(){
    List<List<dynamic>> temp = [];
    temp.add(["title","location","start_time_Iso8601","end_time_Iso8601","start_day",'start_time','end_time']) ;
    timeslots.forEach((r){
      temp.add([r.title,r.location,r.startDate.toIso8601String(),r.endDate.toIso8601String(),m.format(r.startDate),d.format(r.startDate),d.format(r.startDate)],) ;
    });
    String csv = const ListToCsvConverter().convert(temp);

// prepare
    final bytes = utf8.encode(csv);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = "timelien_"+DateTime.now().toIso8601String()+ ".csv";
    html.document.body.children.add(anchor);

// download
    anchor.click();

// cleanup
    html.document.body.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }


  _getBody() {

    double width = MediaQuery.of(context).size.width*0.4 ;
    return Container(
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: width,
              child: generateTable(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: width,
                    child : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical :20.0,horizontal: 20),
                          child: Text("TimeLine Preview",style: TextStyle(fontSize: 26 , color: Colors.blueGrey),),
                        ),
                        Container(
                            height: 700,
                            child: _getTimeLine()),
                      ],
                    )),
              ),
            ),
          )
        ],
      )
    );
  }


  Widget _getTimeLine(){
    double width = 300 ;

    List<TimelineModel> temp = new List();


      int day = 0;
      int month =0 ;

    if(timeslots.isNotEmpty) timeslots.forEach((t){

      if(t.startDate.day!=day||t.startDate.month!=month){

        day = t.startDate.day ;
        month = t.startDate.month ;
        temp.add(
            (TimelineModel(Card(
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Colors.blue, Colors.blueGrey])),
                width: width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(m.format(t.startDate) , style: TextStyle(fontSize: 22 , fontWeight: FontWeight.bold ,color: Colors.white),),
                )

              ),
            ),
                position: TimelineItemPosition.left,
                iconBackground: Colors.blue,
                icon: Icon(Icons.stars))
        ));
      }
      temp.add(TimelineModel(Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: width,
            child: Column(
              children: <Widget>[
                Text(t.title , style: TextStyle(fontSize: 23 ,fontWeight: FontWeight.bold),),
                Text(t.location , style: TextStyle(fontSize: 18 ,fontWeight: FontWeight.bold),),
                Text(d.format(t.startDate) +" to " +d.format(t.endDate), style: TextStyle(fontSize: 18 ,fontWeight: FontWeight.bold),),
              ],
            ),
          ),
        ),
      ),
          position: TimelineItemPosition.right,
          iconBackground: Colors.purpleAccent,
          icon: Icon(Icons.blur_circular)));
    });

    return Timeline(children: temp, position: TimelinePosition.Center ,shrinkWrap: true,);


  }

  Widget generateTable(){


    return PaginatedDataTable(
      source: TimeSlotsDataSource(timeslots,_deleteTimeSlot),
      header: Text("Table of Requests"),
      rowsPerPage: 10,
      columns: [

        DataColumn(
            label: Text(
              "Title",
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w900),
            )),
        DataColumn(
            label: Text(
              "Location",
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w900),
            )),
        DataColumn(
            label: Text(
              "Start Day",
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w900),
            )),
        DataColumn(
            numeric: true,

            label: Text(
              "start",
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w900),
            )),
        DataColumn(
            label: Text(
              "end",
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
                  Text("start : " +m.format(timeslots[index].startDate)+" "+d.format(timeslots[index].startDate) , style: TextStyle(fontSize: 18 ,fontWeight: FontWeight.bold),),
                  Text("end : " +m.format(timeslots[index].endDate)+" "+d.format(timeslots[index].endDate) , style: TextStyle(fontSize: 18 ,fontWeight: FontWeight.bold),),
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


class TimeSlotsDataSource extends DataTableSource {
  final m = new DateFormat('MMMEd');
  final d = new DateFormat('jm');


  final List<Timeslot> _results;
  final Function _deleteTimeSlot ;
  TimeSlotsDataSource(this._results,this._deleteTimeSlot);

  void _sort<T>(Comparable<T> getField(RequestElement d), bool ascending) {
    notifyListeners();
  }

  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _results.length) return null;
    final Timeslot result = _results[index];
    return DataRow.byIndex(
        index: index,
        cells: <DataCell>[
          DataCell(Text('${result.title}',style: TextStyle(fontWeight: FontWeight.bold),)),
          DataCell(Text('${result.location}')),
          DataCell(Text('${m.format(result.startDate)}')),
          DataCell(Text('${d.format(result.startDate)}')),
          DataCell(Text('${d.format(result.endDate)}')),
          DataCell(Text('delete' , style: TextStyle(color:Colors.red),),onTap:(){
            _deleteTimeSlot(result);
          }),
        ]);
  }

  @override
  int get rowCount => _results.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;


}

