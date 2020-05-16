import 'dart:html' as html;
import 'dart:io';
import 'dart:typed_data';
import 'package:testing_app/Consts/Strings.dart';
import 'package:testing_app/Widgets/PlanPopUp.dart';
import 'package:testing_app/extensions/hover_extension.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http_parser/http_parser.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:testing_app/Api/Events/ListEvents.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:testing_app/Api/Plans/plans.dart';
import 'package:testing_app/screens/EventStaffUI.dart';
import 'package:testing_app/tools/Images.dart';
import 'package:http/http.dart' as http;

import 'EventCountingUI.dart';
import 'EventRequestsUI.dart';
import 'EventTimeLineUI.dart';


class EventAdminView extends StatefulWidget {
  EventAdminView({Key key,this.event}) : super(key: key);
  Event event ;


  @override
  _EventAdminViewState createState() => _EventAdminViewState(event);
}



class _EventAdminViewState extends State<EventAdminView> {
  Event event ;
  List<Plan> plans = new List();
  ImageProvider imageProvider ;


  _EventAdminViewState(this.event);


  _loadPlans(){
    http.get(baseUrl+"api/plan", headers: {
      "event":event.id
    }).then((http.Response response){
      plans = plansFromJson(response.body).plans;
      setState(() {

      });
    });
  }

  @override
  void initState() {
    imageProvider = AdvancedNetworkImage(

      baseUrl+"api/event/image?event="+event.id+"&rand="+DateTime.now().millisecondsSinceEpoch.toString(),

      useDiskCache: false,
      cacheRule: CacheRule(maxAge: const Duration(days: 7)),
    ) ;
    _loadPlans();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return _getBody(1);
  }



  _getBody(int mode) {

    double padding  ;
    mode = 1 ;
    switch(mode){
      case 0 : padding = MediaQuery.of(context).size.width*0.25 ; break ;
      case 1 : padding = MediaQuery.of(context).size.width*0.15 ;break ;
      case 2 : padding = MediaQuery.of(context).size.width*0 ;
    }
    double screenSize = MediaQuery.of(context).size.width -2*padding  ;
    return SingleChildScrollView(
      child : Container(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal:padding ),
          child: Column(
            children: <Widget>[
              Container(
              ) ,
              _getHeaderImage(),
              _getBloc("Details", mode,  _getDetails(screenSize)) ,
              _getBloc("Plans", mode,  _getPlans(screenSize)) ,
              //_getBloc("Tools", mode,  _getTools(screenSize)) ,
            ],
          ),
        ),
      ),
    );
  }

  String text = " fdsf dsfdsf dsjkb  hdfh sdhfsdf sd fhqidsuhf ❤ sdh sdhf sdfhosh dsqifhdih oqfgsdifhisdhfihfi dqhfsd  fdoihdsif  fihdfoqidushf  hoqfi\n difug isudgfosifhfhdfqdf dfhdifhqf hdfiqhfo hd iqfhdqsifhqofu hsdfhq";

  _getDetails(double screen){
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[Icon(Icons.description),SizedBox(width: 10,),Container(
                width: screen*0.7,
                child: Text(text))],),
          Row(children: <Widget>[Icon(Icons.location_on),SizedBox(width: 10,),Text(event.location)],),
          Row(children: <Widget>[Icon(Icons.timer),SizedBox(width: 10,),Text(event.startDate.toIso8601String())],),
          Row(children: <Widget>[Icon(Icons.timer_off),SizedBox(width: 10,),Text(event.endDate.toIso8601String())],),

        ],
      ),
    );

  }

  _getHeaderImage(){
  return  Padding(
    padding: const EdgeInsets.all(8.0),
    child: Stack(
      children: <Widget>[
        Container(
          child: Hero(
            tag: "image:"+event.id,
            child: AspectRatio(
              aspectRatio: 1.5,
              child: Container(
                color: Colors.red,
                child: Image(
                  image: imageProvider,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
        ),
        Positioned(
            bottom: 10,
            right: 10,
            child: RaisedButton.icon(onPressed: _updatePicture, icon: Icon(Icons.file_upload), label: Text("Update Cover")))
      ],
    ),
  );
  }

  _getBloc(String title , int mode , Widget widget){

    var style = TextStyle(fontSize: 30) ;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              child :
              Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  Text(title , style: style,) ,
                ],),
                Container(child: widget)
              ],),
            ),
            Positioned(
                top: 0,
                right: 0,
                child: Card(color:Colors.grey,child: Icon(Icons.settings),))
          ],
        ),
      ),
    );


  }


  _getPlans(double screen){
    return Container(
      height: 300,
      margin: EdgeInsets.all(20),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: plans.length+1,
          itemBuilder: _planItemBuilder),
    );

  }








  Widget _planItemBuilder(context, index){
    List<List<Color>> colorList = new List();
    for(int i = 0 ; i<colors.length;i++)
    colorList.add([colors[i] , Colors.white]) ;


    List<double> _stops = [0.1, 0.6];
    return GestureDetector(
      onTap: index==plans.length?_addPlan:(){
        _updatePlan(plans[index]) ;
      },
      child: Card(child: Container(
          decoration: index==plans.length?null: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-1.0, -2.0),
                end: Alignment(1.0, 2.0),
                colors: colorList[plans[index].color],
                stops: _stops,
              )
          ),
          height: 150,
        width: 200,
          child: index==plans.length?

          Container(child: Center(child: Icon(Icons.add),),):
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(plans[index].name, style: TextStyle(fontSize: 25 , color: Colors.blueGrey , fontWeight: FontWeight.bold),),

            Text(plans[index].cost.toString()+" TND" , style: GoogleFonts.economica(
              textStyle: TextStyle(color: Colors.green, letterSpacing: .5 , fontSize:20),
            ),),

          ],
        ))).showCursorOnHover.moveUpOnHover,
    );
  }

  Future<bool> _updatePicture()  async {


    Uint8List bytesFromPicker =
    await ImagePickerWeb.getImage(outputType: ImageType.bytes);

    if (bytesFromPicker != null) {
      debugPrint(bytesFromPicker.length.toString());


     await uploadImage(bytesFromPicker,baseUrl+"api/event/image", {
        "event":event.id,
      }).then((result) async {
        if(result){
          print("successfully Uploaded") ;

          setState(() {
            print("updating image") ;
            imageProvider = AdvancedNetworkImage(

              baseUrl+"api/event/image?event="+event.id+"&rand="+DateTime.now().millisecondsSinceEpoch.toString(),

              useDiskCache: false,
              cacheRule: CacheRule(maxAge: const Duration(days: 7)),
            ) ;
          });

        }else{

        }
     }) ;

    }


  }


  Future<bool> uploadImage(Uint8List file,  url , headers) async {

    var headers = {
      "event":event.id,
    };

    Uri uri = Uri.parse(baseUrl+"api/event/image");
    print(uri);
    var request = http.MultipartRequest("POST", uri);

    request.files.add(http.MultipartFile.fromBytes(
      "image",
      file,
      filename: "image.jpg",
    ));
    request.headers.addAll(headers);

    http.StreamedResponse res = await request.send().catchError((onError){
      print(onError);
    });
    print("here") ;
    print("event : "+event.id);
    print(res.statusCode);
    return res.statusCode >= 200 && res.statusCode < 300;

  }


  void _addPlan(){
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomPlanDialog(
        "",
       null,event.id,null,null,null,null,false
      ),
    ).then((result){
      _loadPlans();
    });
  }

  void _updatePlan(Plan plan){
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomPlanDialog(
        plan.id,  plan.name,plan.event,plan.description,plan.options,plan.color,plan.cost,true
      ),
    ).then((result){
      _loadPlans();
    });
  }

}
