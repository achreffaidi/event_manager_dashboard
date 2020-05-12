import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testing_app/Consts/Strings.dart';
import 'package:http/http.dart' as http;


class CustomPlanDialog extends StatefulWidget {

  String id ;
  String name ;
  String event ;
  String description ;
  List<String> list ;
  int color =0;
  double cost ;
  bool update ;


  CustomPlanDialog(this.id , this.name, this.event, this.description, this.list,
      this.color, this.cost , this.update);

  @override
  _CustomPlanDialogState createState() => _CustomPlanDialogState(id,name,event,description,list,color,cost,update);
}

class _CustomPlanDialogState extends State<CustomPlanDialog> {


  _CustomPlanDialogState(this.id,this.name, this.event, this.description, this.list,
      this.color, this.cost , this.update);

  String id ;
  String name ;
  String event ;
  String description ;
  List<String> list ;
  int color =0;
  double cost ;
  bool update ;

  TextEditingController _controllerName = new TextEditingController();
  TextEditingController _controllerDescription = new TextEditingController();
  TextEditingController _controllerCost = new TextEditingController();
  TextEditingController _controllerOptions = new TextEditingController();

  List<String> options = new List() ;


  @override
  void initState() {

    if(update){
      _controllerName.text = name ;
      _controllerDescription.text = description ;
      _controllerCost.text = cost.toString() ;
      options = list ;

    }else{
      color = 0 ;
    }


    super.initState();
  }


  Widget _colorItem(context,index){
    double x ,y ;
    x = index==color? 40 :30 ;
    y = index==color? 4 :2 ;
    return GestureDetector(
      onTap: (){
        setState(()=> color=index);
      },
      child: Card(
        elevation: y,
        child: Container(height: x,width: x,),
        color: colors[index],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  List<Widget> _listColorBuilder(){
    List<Widget> list = new List();
    for (int i =  0  ; i < colors.length ; i++) list.add(_colorItem(context, i));
    return list ;
  }

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
            controller: _controllerName,
            decoration: InputDecoration(hintText: "Plan Name"),
          ),
          SizedBox(height: 16.0),
          TextField(
            minLines: 3,
            maxLines: 3,
            controller: _controllerDescription,
            decoration: InputDecoration(hintText: "Plan Description" , ),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: _controllerCost,
            keyboardType: TextInputType.number ,
            decoration: InputDecoration(hintText: "Cost" , ),
          ),
          SizedBox(height: 16.0),
          Text("Color",style: TextStyle(fontSize: 18 , fontWeight: FontWeight.bold),),
          Container(
           child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _listColorBuilder(),
            ),
          ),
          Row(
            children: <Widget>[
              Container(
                width : 200,
                child: TextField(
                  controller: _controllerOptions,
                  decoration: InputDecoration(hintText: "Option"),
                ),
              ),
              RaisedButton(
                child: Text("Add") ,onPressed: (){
                if(_controllerOptions.text.toString().trim().isNotEmpty)
                options.add(_controllerOptions.text.toString());
                setState(() {
                  _controllerOptions.text="";
                });
              },)
            ],
          ),
          SizedBox(height: 5.0),
          Container(
            decoration: BoxDecoration(
              color : Color.lerp(Colors.grey, Colors.white, 0.8),
              borderRadius: BorderRadius.circular(8.0),
            ),
            height: 300,
            child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context,index){
                  return Card(child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                      Text(options[index]),
                      IconButton(icon: Icon(Icons.delete),onPressed: (){
                        options.removeAt(index);
                        setState(() {});
                      },)
                    ],),
                  ),);
                }),
          ),

          SizedBox(height: 24.0),
          _getButtons(),

        ],
      ),
    );
  }

  _getButtons(){
    if(update) return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop(); // To close the dialog
          },
          child: Text("Cancel" , style: TextStyle(color: Colors.orange , fontWeight: FontWeight.bold),),
        ),
        FlatButton(
          onPressed: () async {
            await _deletePlan();
            Navigator.of(context).pop(); // To close the dialog
          },
          child: Text("Delete" , style: TextStyle(color: Colors.red , fontWeight: FontWeight.bold),),
        ),FlatButton(
          onPressed: ()async {
            await _updatePlan();
            Navigator.of(context).pop(); // To close the dialog
          },
          child: Text("Update" , style: TextStyle(color: Colors.blue , fontWeight: FontWeight.bold),),
        )
      ],
    ) ;

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
            await _savePlan() ;
            Navigator.of(context).pop(); // To close the dialog
          },
          child: Text("Save" , style: TextStyle(color: Colors.blue , fontWeight: FontWeight.bold),),
        )
      ],
    ) ;

  }


  _savePlan() async {

    var body = {
      "name":_controllerName.text.toString(),
      "event":event ,
      "description":_controllerDescription.text.toString(),
      "options": options,
      "cost": _controllerCost.text.toString() ,
      "color":color
    };
    
   await http.post(baseUrl+"api/plan",
        headers: {
      "Content-Type":"application/json"
    },body: json.encode(body)
    ).then((http.Response response){
      print(response);
    });
    

  }
  _updatePlan() async {

    var body = {
      "id":id,
      "name":_controllerName.text.toString(),
      "event":event ,
      "description":_controllerDescription.text.toString(),
      "options": options,
      "cost": _controllerCost.text.toString() ,
      "color":color
    };

   await http.put(baseUrl+"api/plan",
        headers: {
      "Content-Type":"application/json"
    },body: json.encode(body)
    ).then((http.Response response){
      print(response);
    });


  }
  _deletePlan() async {

    var headers = {
      "id":id,
    };

    await http.delete(baseUrl+"api/plan",
        headers: headers
    ).then((http.Response response){
      print(response.body);
    });


  }

}
class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}
