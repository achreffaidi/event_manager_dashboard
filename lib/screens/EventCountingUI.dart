import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:testing_app/Api/EventCounting/event_counting.dart';
import 'package:testing_app/Api/EventCounting/event_counting_details.dart';
import 'package:testing_app/Api/Request/request.dart';
import 'package:testing_app/Api/staff/staff.dart';
import 'package:testing_app/Consts/Strings.dart';
import 'package:testing_app/Widgets/RequestPopUp.dart';
import 'package:testing_app/Widgets/countingPopUp.dart';
import 'package:testing_app/Widgets/staffPopUp.dart';

class EventCountingUI extends StatefulWidget {
  String event ;
  EventCountingUI({Key key,this.event}) : super(key: key);

  @override
  _EventCountingUIState createState() => _EventCountingUIState(event);
}

class _EventCountingUIState extends State<EventCountingUI> {


  _EventCountingUIState(this.event) ;
  List<Item> _counting;

  Item currentItem ;

  String event  ;


  _loadCounting(){
    http.get(baseUrl+"api/event/presence",headers: {
      "event":event
    }).then((http.Response response){
      print(response.body);
      _counting = new List();
      List<Counting> temp = eventCountingFromJson(response.body).data ;
      for(Counting x in temp) _counting.add(Item(counting: x));
      setState(() {

      });
    });
  }


  @override
  void initState() {
    _loadCounting();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Counting"),leading: Container(),actions: <Widget>[
        FlatButton.icon(onPressed: (){
          _addCounting();
        }, icon: Icon(Icons.add), label: Text("Add") , color: Colors.green,)
      ],),
      body: _getBody(),
    );
  }

  _getBody() {
    return Container(
      child: Row(
        children: <Widget>[
          _getCard("List Counting", SingleChildScrollView(child: getCountingListTable())),
          _getCard("Details", Container(
              height: 700,
              width: 500,
              child: SingleChildScrollView(child: getCountingDetailsTable()))),

        ],
      )
    );
  }

  _getCard(String title , Widget body){

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(

            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(title,style: TextStyle(fontSize: 22 , color: Colors.blueGrey),),
              ),
              body
            ],
          ),
        ),
      ),
    );

  }



  void loadItemDetails(Item item){
    
    http.get(baseUrl+"api/presence",headers: {
      "id":item.counting.id
    }).then((http.Response res){
      item.eventCountingDetails = eventCountingDetailsFromJson(res.body);

      item.counting.countIn = item.eventCountingDetails.listIn.length ;
      item.counting.countOut = item.eventCountingDetails.listOut.length ;
      setState(() {

      });
    });
    
    
    
  }


  void updateCountingState(Item item ,bool state) async {

    item.counting.state = ! item.counting.state ;
    setState(() {

    });

    var body = {
      "id": item.counting.id,
      "name":item.counting.name,
      "state":state
    };


    await http.put(baseUrl+"api/event/presence", headers: {
      "Content-Type":"application/json"
    }
        ,body: json.encode(body)
    ).then((http.Response response){

      if(response.statusCode!=200){

        item.counting.state = ! item.counting.state ;
        setState(() {

        });
      }
      print(response.body);
    });

  }



  Widget getCountingDetailsTable(){

    Item item = currentItem;
    if(item==null) return Container();
    if(item.eventCountingDetails==null)return Center(child: CircularProgressIndicator());

    List<DataRow> temp = new List();

    for(int i = 0 ; i<item.eventCountingDetails.listIn.length ; i++) {
      temp.add(
          DataRow(
              cells: [
                DataCell(
                    Text(item.eventCountingDetails.listIn[i].name),
                ),
                DataCell(
                  Text(item.eventCountingDetails.listIn[i].email),
                ),
                DataCell(
                  Text('${item.eventCountingDetails.listIn[i].number}'),
                ),
                DataCell(
                  Text("IN", style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
                ),

              ]
          ));
    }
    for(int i = 0 ; i<item.eventCountingDetails.listOut.length ; i++) {
      temp.add(
          DataRow(
              cells: [
                DataCell(
                  Text(item.eventCountingDetails.listOut[i].name),
                ),
                DataCell(
                  Text(item.eventCountingDetails.listOut[i].email),
                ),
                DataCell(
                  Text('${item.eventCountingDetails.listOut[i].number}'),
                ),
                DataCell(
                  Text("OUT", style: TextStyle(color: Colors.deepOrange,fontWeight: FontWeight.bold),),
                ),

              ]
          ));
    }



    return DataTable(

      columns: [
        DataColumn(
          label: Text("Name"),
        ),
        DataColumn(
          label: Text("Email"),
        ),DataColumn(
          label: Text("Phone"),
        ),
        DataColumn(
          label: Text("State"),
        ),

      ],
      rows: temp ,
    );

  }

  Widget _getItemBody(Item item){

    if(item==null) return Container();
    List<User> list ;
    if(item.hasDetails()) list = item.eventCountingDetails.listIn + item.eventCountingDetails.listOut;
    double itemHeight = 400.0 ;
    return Container(


      child: !item.hasDetails()? Center(child: CircularProgressIndicator(),):
      Container(
        child: Column(
          children: <Widget>[
            Container(
              height:  itemHeight,
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index){
                  bool isFirst = index<item.eventCountingDetails.listIn.length;
                  return Container(child:
                    Card(child: Row(
                      children: <Widget>[
                        Container(height: 50.0,width: 4,color: isFirst? Colors.green:Colors.deepOrange,),
                        SizedBox(width: 20,),
                        Text(list[index].name),
                      ],
                    ),),);

                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
              FlatButton.icon(onPressed: (){
                _updateCounting(item.counting);
              }, icon: Icon(Icons.edit), label: Text("Edit"),color: Colors.orangeAccent,),
              FlatButton.icon(onPressed: (){

                _deleteCounting(item.counting);
              }, icon: Icon(Icons.delete), label: Text("Delete"),color: Colors.red,),
            ],)
          ],
        ),
      ),
    );
  }

  Widget getCountingListTable(){




    List<DataRow> temp = new List();

    for(int i = 0 ; i<_counting.length ; i++) {
      temp.add(
          DataRow(
              cells: [
                DataCell(
                  Text(_counting[i].counting.name),
                  onTap:(){
                    onRowTap(_counting[i]);
                  }
                ),
                DataCell(
                  Text(_counting[i].counting.countIn.toString()),
                    onTap:(){
                      onRowTap(_counting[i]);
                    }
                ),
                DataCell(
                  Text(_counting[i].counting.countOut.toString()),
                    onTap:(){
                      onRowTap(_counting[i]);
                    }
                ),
                DataCell(
                  Switch(value: _counting[i].counting.state,onChanged: (value){
                    updateCountingState(_counting[i], value);
                  },)
                ),
                DataCell(
                  IconButton(icon: Icon(Icons.delete,color: Colors.red,),onPressed: (){
                    _deleteCounting(_counting[i].counting);
                  },)
                ),
                DataCell(
                    IconButton(icon: Icon(Icons.edit,color: Colors.blue,),onPressed: (){
                      _updateCounting(_counting[i].counting);
                    },)
                ),
              ]
          ));
    }



    return DataTable(

      columns: [
        DataColumn(
          label: Text("Name"),
          numeric: false,
        ),
        DataColumn(
          label: Text("People IN"),
          numeric: true,
        ),DataColumn(
          label: Text("People Out"),
          numeric: true,
        ),
        DataColumn(
          label: Text("Allow Counting"),
        ),
        DataColumn(
          label: Text(""),
        ),
        DataColumn(
          label: Text(""),
        ),
      ],
      rows: temp  ,
    );

  }


  void onRowTap(Item item){
    currentItem = item;
    setState(() {

    });
    if(!item.hasDetails()){
      loadItemDetails(item);
    }
  }

  void _addCounting() {

    showDialog(
      context: context,
      builder: (BuildContext context) => CustomCountingDialog(
          null,event
      ),
    ).then((result){
      _loadCounting();
    });

  }

  void _updateCounting(Counting counting) {

    showDialog(
      context: context,
      builder: (BuildContext context) => CustomCountingDialog(
         counting ,event
      ),
    ).then((result){
      _loadCounting();
    });

  }

  void _deleteCounting(Counting counting)  async {

    var headers = {
      "id":counting.id,
    };

    await http.delete(baseUrl+"api/event/presence",
        headers: headers
    ).then((http.Response response){
      _loadCounting();
      print(response.body);
    });



  }




}


class Item {
  Item({
    this.counting,
    this.isExpanded = false,
  });

  bool hasDetails(){
    return eventCountingDetails!=null ;
  }
  
  
  Counting counting ;
  bool isExpanded;
  EventCountingDetails eventCountingDetails ; 
}
