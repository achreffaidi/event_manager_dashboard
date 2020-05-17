import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:testing_app/Api/Request/request.dart';
import 'package:testing_app/Api/staff/staff.dart';
import 'package:testing_app/Consts/Strings.dart';
import 'package:testing_app/Widgets/RequestPopUp.dart';
import 'package:testing_app/Widgets/charts/requestsCircularChart.dart';
import 'package:testing_app/Widgets/staffPopUp.dart';
import 'dart:html' as html;


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

  bool _sort = false ;

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
        }, icon: Icon(Icons.refresh,color: Colors.green,), label: Text("Refresh" , style: TextStyle(color: Colors.green),) ,color: Colors.white),
        FlatButton.icon(onPressed: (){
          exportData();
        }, icon: Icon(Icons.file_download, color: Colors.deepOrange,), label: Text("Export as CSV" , style: TextStyle(color: Colors.deepOrange),) ,color: Colors.white,)


      ],),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _getBody()),
        ),
      ),
    );
  }


  void exportData(){
    List<List<dynamic>> temp = [];
    temp.add(["name","plan","cost","state"]) ;
    _requests.forEach((r){
      temp.add([r.user.name,r.plan.name,r.plan.cost,requestState[r.request.state]]) ;
    });
    String csv = const ListToCsvConverter().convert(temp);

// prepare
    final bytes = utf8.encode(csv);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = "requests_"+DateTime.now().toIso8601String()+ ".csv";
    html.document.body.children.add(anchor);

// download
    anchor.click();

// cleanup
    html.document.body.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }

  Widget _getBody() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Card(child: Container( width: 850, child: generateTable())),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Card(child: Container(
                width: 400.0,
                height: 400,
                child: DatumLegendRequestsState.withRealData(_requests),),),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 400.0
                ),
                child: Card(child: SingleChildScrollView(
                  child: Container(
                    child: getRequestsByPlanTable(),),
                ),),
              ),

            ],
          ),

        ],
      ));
  }



  Widget generateTable(){


    return PaginatedDataTable(
      source: RequestsDataSource(_requests,_updateRequest),
      header: Text("Table of Requests"),
      rowsPerPage: 10,
      columns: [

        DataColumn(
            onSort: onSort,
            label: Text(
              "",
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w900),
            )),
        DataColumn(
            onSort: onSort,
            label: Text(
              "Name",
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w900),
            )),
        DataColumn(
            onSort: onSort,
            label: Text(
              "Email",
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w900),
            )),
        DataColumn(
            onSort: onSort,
            label: Text(
              "Phone",
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w900),
            )),
        DataColumn(
            onSort: onSort,
            label: Text(
              "Plan",
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w900),
            )),
        DataColumn(
            onSort: onSort,
          numeric: true,

            label: Text(
              "Cost",
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w900),
            )),
        DataColumn(
            onSort: onSort,
            label: Text(
              "State",
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w900),
            )),
      ],
    );

  }


  Widget getRequestsByPlanTable(){


    List<PlanItem> plans = new List();
    List<String> plansID = new List();
    PlanItem total = PlanItem("Total",0);
    PlanItem totalCount = PlanItem("Total",0);

    _requests.forEach((req){
      if(!plansID.contains(req.plan.id)){
        plans.add(new PlanItem(req.plan.name,req.plan.cost));
        plansID.add(req.plan.id);
      }
    });

    _requests.forEach((req){
      int index = plansID.indexOf(req.plan.id);
      plans[index].requests++ ;
      totalCount.requests++ ;
      switch(req.request.state){
        case 0 : plans[index].unapproved ++ ;totalCount.unapproved++; total.unapproved+=plans[index].cost; break;
        case 1 : plans[index].unpaid ++ ;totalCount.unpaid++;total.unpaid+=plans[index].cost; break;
        case 2 : plans[index].paid ++;totalCount.paid++;total.paid+=plans[index].cost; break;
      }
    });


    List<DataRow> temp = new List();

    for(int i = 0 ; i<plans.length ; i++) {
      temp.add(
          DataRow(
              cells: [
                DataCell(
                  Text(plans[i].plan),
                ),
                DataCell(
                  Text(plans[i].requests.toString()),
                ),
                DataCell(
                  Text('${plans[i].unapproved} ( ${plans[i].unapproved*plans[i].cost} TND)'),
                ),
                DataCell(
                  Text('${plans[i].unpaid} ( ${plans[i].unpaid*plans[i].cost} TND)'),
                ),
                DataCell(
                  Text('${plans[i].paid} ( ${plans[i].paid*plans[i].cost} TND)'),
                ),
              ]
          ));
    }
    temp.add( DataRow(

        cells: [
          DataCell(
            Text(total.plan ,style: TextStyle(fontWeight: FontWeight.bold),),

          ),
          DataCell(
            Text(totalCount.requests.toString()),
          ),
          DataCell(
            Text('${totalCount.unapproved} ( ${total.unapproved} TND)'),
          ),
          DataCell(
            Text('${totalCount.unpaid} ( ${total.unpaid} TND)'),
          ),
          DataCell(
            Text('${totalCount.paid} ( ${total.paid} TND)'),
          ),
        ]
    ));


    return DataTable(

      columns: [
        DataColumn(
          label: Text("Plan"),
          numeric: false,
        ),
        DataColumn(
          label: Text("Requests"),
          numeric: true,
        ),DataColumn(
          label: Text("UnApproved"),
          numeric: true,
        ),
        DataColumn(
          label: Text("Unpaid"),
          numeric: true,
        ),
        DataColumn(
          label: Text("Paid"),
          numeric: true,
        ),
      ],
      rows: temp  ,
    );

  }

  onSort(int columnIndex, bool ascending) {

    ascending = _sort ;
    _sort= !_sort;


     if (columnIndex == 1) {
      if (ascending) {
        _requests.sort((a, b) => a.user.name.compareTo(b.user.name));
      } else {
        _requests.sort((a, b) => b.user.name.compareTo(a.user.name));
      }
    } else if (columnIndex ==4) {
      if (ascending) {
        _requests.sort((a, b) => a.plan.name.compareTo(b.plan.name));
      } else {
        _requests.sort((a, b) => b.plan.name.compareTo(a.plan.name));
      }
    }else if (columnIndex == 5) {
      if (ascending) {
        _requests.sort((a, b) => a.plan.cost.compareTo(b.plan.cost));
      } else {
        _requests.sort((a, b) => b.plan.cost.compareTo(a.plan.cost));
      }
    }
    else if (columnIndex == 6) {
      if (ascending) {
        _requests.sort((a, b) => a.request.state.compareTo(b.request.state));
      } else {
        _requests.sort((a, b) => b.request.state.compareTo(a.request.state));
      }
    }

    setState(() {

    });
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

class PlanItem{
  double cost ;
  String plan ;
  double paid = 0.0 ;
  double unpaid = 0.0 ;
  double unapproved =0.0 ;
  int requests = 0 ;
  PlanItem(this.plan,this.cost);
}

class RequestsDataSource extends DataTableSource {


  final List<RequestElement> _results;
  final Function _updateRequest ;
  RequestsDataSource(this._results,this._updateRequest);

  void _sort<T>(Comparable<T> getField(RequestElement d), bool ascending) {
    _results.sort((RequestElement a, RequestElement b) {
      if (!ascending) {
        final RequestElement c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
    notifyListeners();
  }

  int _selectedCount = 0;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= _results.length) return null;
    final RequestElement result = _results[index];
    return DataRow.byIndex(
        index: index,
        cells: <DataCell>[
          DataCell(Text(index.toString())),
          DataCell(Text('${result.user.name}')),
          DataCell(Text('${result.user.email}')),
          DataCell(Text('${result.user.number}')),
          DataCell(Text('${result.plan.name}')),
          DataCell(Text('${result.plan.cost} TND')),
          DataCell(Text(requestState[result.request.state]),showEditIcon: true,onTap: (){
            _updateRequest(result);
          })

        ]);
  }

  @override
  int get rowCount => _results.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;


}
