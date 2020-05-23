import 'package:flutter/material.dart';

class ChangeColorOnHover extends StatefulWidget {
  final Widget child;
  final  color ;
  // You can also pass the translation in here if you want to
  ChangeColorOnHover({Key key, this.child , this.color}) : super(key: key);

  @override
  _ChangeColorOnHoverState createState() => _ChangeColorOnHoverState();
}

class _ChangeColorOnHoverState extends State<ChangeColorOnHover> {
  final nonHoverTransform = Matrix4.identity()..translate(0, 0, 0);
  final hoverTransform = Matrix4.identity()..translate(0, -10, 0);

  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (e) => _mouseEnter(true),
      onExit: (e) => _mouseEnter(false),
      child: Container(

        child: Container(
            color: _hovering? widget.color : Colors.white,
            child : widget.child),
      ),
    );
  }

  void _mouseEnter(bool hover) {
    setState(() {
      _hovering = hover;
    });
  }
}