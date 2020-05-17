import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing_app/Consts/theme.dart';

import 'menu_item_tile.dart';


class SideBarMenu extends StatefulWidget {

  Function _onChange ;

  SideBarMenu(this._onChange);



  @override
  _SideBarMenuState createState() => _SideBarMenuState(_onChange);
}

class _SideBarMenuState extends State<SideBarMenu>
    with SingleTickerProviderStateMixin {
  double maxWidth = 250;
  double minWidgth = 70;
  bool collapsed = false;
  int selectedIndex = 0;
  Function _onChange ;


  String username ="";
  String email ="" ;
  String id ="";



  _SideBarMenuState(this._onChange);

  AnimationController _animationController;
  Animation<double> _animation;

  void initVariables()async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = await prefs.getString("name");
    id = await prefs.getString("id");
    email = await prefs.getString("email");

    setState(() {

    });

  }

  @override
  void initState() {
    super.initState();



    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));

    _animation = Tween<double>(begin: maxWidth, end: minWidgth)
        .animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget child) {
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(blurRadius: 10, color: Colors.black26, spreadRadius: 2)
            ],
            color: drawerBgColor,
          ),
          width: _animation.value,
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 200,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://backgrounddownload.com/wp-content/uploads/2018/09/google-material-design-background-6.jpg'),
                      fit: BoxFit.cover,
                    )),
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                                ''),
                            backgroundColor: Colors.white,
                            radius: _animation.value >= 250 ? 30 : 20,
                          ),
                          SizedBox(
                            width: _animation.value >= 250 ? 20 : 0,
                          ),
                          (_animation.value >= 250)
                              ? Text(username,
                              style: menuListTileDefaultText)
                              : Container(),
                        ],
                      ),
                      SizedBox(
                        height: _animation.value >= 250 ? 20 : 0,
                      ),
                      Spacer(),
                      (_animation.value >= 250)
                          ? Text(
                        email,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                          : Container(),
                      (_animation.value >= 250)
                          ? Text(
                        id,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                          : Container(),
                      RaisedButton.icon(onPressed: _logout, icon: Icon(Icons.exit_to_app), label: Text("logout"))
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 80,
              ),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, counter) {
                    return Divider(
                      height: 2,
                    );
                  },
                  itemCount: menuItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    return MenuItemTile(
                      title: menuItems[index].title,
                      icon: menuItems[index].icon,
                      animationController: _animationController,
                      isSelected: selectedIndex == index,
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                          _onChange(selectedIndex);
                        });
                      },
                    );
                  },
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    collapsed = !collapsed;
                    collapsed
                        ? _animationController.reverse()
                        : _animationController.forward();
                  });
                },
                child: AnimatedIcon(
                  icon: AnimatedIcons.close_menu,
                  progress: _animationController,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        );
      },
    );
  }

  void _logout() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
     await prefs.remove("id");
     await prefs.remove("name");
     await prefs.remove("email");
     Navigator.of(context).pop();


  }
}



class Menu {
  String title;
  IconData icon;

  Menu({this.title, this.icon});
}

List<Menu> menuItems = [
  Menu(title: 'Main', icon: Icons.dashboard),
  Menu(title: 'Staff', icon: Icons.people),
  Menu(title: 'Request', icon: Icons.tab),
  Menu(title: 'Counting', icon: Icons.format_list_numbered),
  Menu(title: 'TimeLine', icon: Icons.schedule),
];