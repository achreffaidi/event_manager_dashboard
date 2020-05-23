import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:testing_app/Api/SocialNetwork/socialmedialinks.dart';
import 'package:testing_app/Api/SocialNetwork/websites.dart';
import 'package:testing_app/Consts/Strings.dart';
import 'package:http/http.dart' as http;


class CustomSocialLinkDialog extends StatefulWidget {

  String event ;
  SocialMediaLink social ;


  CustomSocialLinkDialog(this.event,this.social);

  @override
  _CustomSocialLinkDialogState createState() => _CustomSocialLinkDialogState(this.event,this.social);
}

class _CustomSocialLinkDialogState extends State<CustomSocialLinkDialog> {


  _CustomSocialLinkDialogState(this.event,this.social);

  String event ;
  SocialMediaLink social ;

  TextEditingController _controllerTitle = new TextEditingController();
  TextEditingController _controllerLink = new TextEditingController();

  List<String> options = new List() ;
  List<DropdownMenuItem<String>>  items = new List() ;
  String _value ;

  @override
  void initState() {
    if(social!=null){
      print(social.website);
      _controllerLink.text = social.link ;
      _controllerTitle.text = social.title ;
    }
    super.initState();
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

          getDropDown(),
          SizedBox(height: 16.0),

          TextField(
            controller: _controllerTitle,
            decoration: InputDecoration(hintText: "Title"),
          ),
          SizedBox(height: 16.0),
          TextField(
            minLines: 3,
            maxLines: 3,
            controller: _controllerLink,
            decoration: InputDecoration(hintText: "Link" , ),
          ),


          SizedBox(height: 24.0),
          _getButtons(),

        ],
      ),
    );
  }

  _getButtons(){
    if(social!=null ) return Row(
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
            await _deleteLink();
            Navigator.of(context).pop(); // To close the dialog
          },
          child: Text("Delete" , style: TextStyle(color: Colors.red , fontWeight: FontWeight.bold),),
        ),FlatButton(
          onPressed: ()async {
            await _updateLink();
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
            await _saveLink() ;
            Navigator.of(context).pop(); // To close the dialog
          },
          child: Text("Save" , style: TextStyle(color: Colors.blue , fontWeight: FontWeight.bold),),
        )
      ],
    ) ;

  }


  _saveLink() async {

    var body = {
      "title":_controllerTitle.text.toString(),
      "event":event ,
      "url":_controllerLink.text.toLowerCase(),
      "website": _value
    };
    
   await http.post(baseUrl+"api/event/sociallinks",
        headers: {
      "Content-Type":"application/json"
    },body: json.encode(body)
    ).then((http.Response response){
      print(response);
    });
    

  }
  _updateLink() async {

    var body = {
      "id":social.id,
      "title":_controllerTitle.text.toString(),
      "url":_controllerLink.text.toLowerCase(),
      "website": _value
    };

   await http.put(baseUrl+"api/event/sociallinks",
        headers: {
      "Content-Type":"application/json"
    },body: json.encode(body)
    ).then((http.Response response){
      print(response);
    });


  }
  _deleteLink() async {

    var headers = {
        "id":social.id
    };

    await http.delete(baseUrl+"api/event/sociallinks",
        headers: headers
    ).then((http.Response response){
      print(response.body);
    });


  }



  Widget getDropDown() {
    return FutureBuilder(
      future: http.get(baseUrl+"api/sociallinks"),
      builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
        if(snapshot.data==null){
          return Container();
        }else{
          if(_value==null){
            if(social==null)  _value = websitesFromJson(snapshot.data.body).data[0];
            else _value = social.website;
          }
        }
        return new DropdownButton<String>(
          value: _value.toLowerCase(),
          items: websitesFromJson(snapshot.data.body).data.map((String value) {
            return new DropdownMenuItem<String>(
              value: value.toLowerCase(),
              child: Row(
                children: <Widget>[
                  Icon(MdiIcons.fromString(value.toLowerCase()),size: 30,),
                   Text(value),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            if(social==null)
           setState(()=> _value = value) ;

          },
        );
        },
    );
  }



}
class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}
