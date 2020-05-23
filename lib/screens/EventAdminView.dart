import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:testing_app/Api/Events/allTags.dart';
import 'package:testing_app/Api/SocialNetwork/socialmedialinks.dart';
import 'package:testing_app/Consts/Strings.dart';
import 'package:testing_app/Widgets/PlanPopUp.dart';
import 'package:testing_app/Widgets/SocialMediaLinkPopUp.dart';
import 'package:testing_app/extensions/hover_extension.dart';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:testing_app/Api/Events/ListEvents.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:testing_app/Api/Plans/plans.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';



class EventAdminView extends StatefulWidget {
  EventAdminView({Key key,this.event}) : super(key: key);
  Event event ;


  @override
  _EventAdminViewState createState() => _EventAdminViewState(event);
}



class _EventAdminViewState extends State<EventAdminView> {
  Event event ;
  List<Plan> plans = new List();
  List<TagItem> tags = new List();
  List<SocialMediaLink> links = new List();
  List<String> tagNames = new List();
  ImageProvider imageProvider ;
  String _searchTagError = null ;


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
  _loadTags(){
    http.get(baseUrl+"api/tags").then((http.Response response){
      tags = tagsListFromJson(response.body).data ;
      tagNames = tags.map((t) => t.name).toList();
      setState(() {

      });
    });
  }
  _loadSocial(){
    http.get(baseUrl+"api/event/sociallinks",headers: {
      "event":event.id
    }).then((http.Response response){
      links = socialLinksFromJson(response.body).socialMediaLinks ;
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
    _loadTags();
    _loadSocial() ;
    _loadPlans();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return _getBody(1);
  }


  Widget _getDate(DateTime dateTime){
    final m = new DateFormat('MMM');
    return Container(
      child: Card(
          child :  Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(dateTime.day.toString() , style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue , fontSize: 25),),
                Text(m.format(dateTime), style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue),),
              ],
            ),),
          )
      ),
    );

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
              IntrinsicHeight(

               child: Row(
                 crossAxisAlignment: CrossAxisAlignment.stretch,
                 children: <Widget>[
                   Expanded(child: _getBloc("Details", mode,  _getDetails(screenSize*0.4))) ,
                   _getBloc("Tags", mode,  _getTags(screenSize*0.4)) ,],
               ),
             ),
              _getBloc("Social Links", mode,  _getSocialLinks(screenSize)) ,
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
    final double bottomPadding = 50 ;
  return  Padding(
    padding: const EdgeInsets.all(8.0),
    child: Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              child: Hero(
                tag: "image:"+event.id,
                child: AspectRatio(
                  aspectRatio: 3,
                  child: Card(
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(image: Image(
                          image: imageProvider,
                          fit: BoxFit.fitWidth,
                        ).image , fit: BoxFit.fitWidth)
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: bottomPadding,)
          ],
        ),
        Positioned(
            bottom: 10 + bottomPadding,
            right: 10,
            child: RaisedButton.icon(onPressed: _updatePicture, icon: Icon(Icons.file_upload), label: Text("Update Cover"))) ,
        Positioned(
          bottom: bottomPadding/2,
          left: 25,
          child: Container(
            height: 80,
            width: 80,
            child: _getDate(event.startDate),
          ),
        )
      ],
    ),
  );
  }

  Widget  _getBloc(String title , int mode , Widget widget){

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


  _getTags(double screen){
    return Container(
      width: screen*0.7,
      margin: EdgeInsets.all(10) ,
    child: Container(
      child: _getAllTags(),
    ));


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

  _getSocialLinks(double screen){
    return Container(
      height: 200,
      margin: EdgeInsets.all(20),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: links.length+1,
          itemBuilder: _socialItemBuilder),
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

  Widget _getAllTags() {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Tags(


        textField: TagsTextField(
          duplicates: false,

          textStyle: TextStyle(fontSize: 16),
          inputDecoration: InputDecoration(
            icon: Icon(Icons.alternate_email) ,
            errorText: _searchTagError

          ),

          onSubmitted: (String str) {

            str = str.trim();
            if(str.isEmpty){
              setState(() {
                _searchTagError = "Tag can't be Empty";

              });
            }else if(str.split(" ").length>1){
              setState(() {
                _searchTagError = "Tag should be one word";

              });
            }else{

              setState(() {
                _searchTagError = null ;
              });
              if(!tagNames.contains(str.trim())) _addTag(str.trim());
            }
            // Add item to the data source.

          },
        ),
        itemCount: tags.length, // required
        itemBuilder: (int index){
          final TagItem item = tags[index];

          return ItemTags(

            key: Key(index.toString()),
            index: index, // required
            pressEnabled: true,
            active: event.tags.contains(item.id),
            title: item.name,
            customData: item.id,
            icon: ItemTagsIcon(icon: Icons.alternate_email),
            textStyle: TextStyle( fontSize: 16, ),
            combine: ItemTagsCombine.withTextAfter, // OR null,
            onPressed: _onTagItemPress,
            activeColor: Colors.blue,
            colorShowDuplicate: Colors.white,

          );

        },
      ),
    );
  }

  void _addTag(String str) {
    http.post(baseUrl+"api/tags",headers: {
      "name":str
    }).then((http.Response response){
      print(response.body);
      if(response.statusCode==200){
        var data = json.decode(response.body);
        String id = data["data"]["_id"];
        tags.add(
            TagItem(count: 0,id: id , name: str));
        tagNames.add(str);
        setTagAsActive(id);

      }

    });
  }



  void _onTagItemPress(Item i) {
    var body = {
      "event":event.id,
      "tag":i.customData.toString()
    };

    if(i.active){
      setTagAsActive(i.customData.toString());
    }else{
      http.delete(baseUrl+"api/event/tags"  , headers : body).then((http.Response response){
        print(response.body);
        if(response.statusCode==200){
          setState(() {

          });
        }
      });


    }
  }


  void setTagAsActive(String id){

    print("setting "+id+" to active ");



    var body = {
      "event":event.id,
      "tag":id
    };
    http.post(baseUrl+"api/event/tags",body: json.encode(body) , headers: {
      "Content-Type":"application/json"
    }).then((http.Response response){
      print(response.body);
      if(response.statusCode==200){
        event.tags.add(id);

        setState(() {

        });
      }
    });
  }

  Widget _socialItemBuilder(BuildContext context, int index) {

    return GestureDetector(
      onTap: index==links.length?(){
        _addSocialLink() ;
      }:(){
        _updateSocialLink(links[index]);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(child: AspectRatio(
          aspectRatio: 1,
          child: Container(
              height: 50,

              child: index==links.length?

              Container(child: Center(child: Icon(Icons.add),),):
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(MdiIcons.fromString(links[index].website),size: 80,),
                  Text(links[index].title, style: TextStyle(fontSize: 20 , color: Colors.blueGrey , fontWeight: FontWeight.bold),),

                ],
              )).showCursorOnHover.changeColorOnHover(Color.lerp(Colors.blue, Colors.white, 0.8)),
        )).moveUpOnHover,
      ),
    );
  }

  void _addSocialLink(){
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomSocialLinkDialog(
      event.id,null
      ),
    ).then((result){
      _loadSocial();
    });
  }



  void _updateSocialLink(SocialMediaLink link) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomSocialLinkDialog(
          event.id,link
      ),
    ).then((result){
      _loadSocial();
    });

  }
}
