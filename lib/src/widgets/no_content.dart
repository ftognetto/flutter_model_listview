
import 'package:flutter/material.dart';

class NoContentWidget extends StatelessWidget {

  final String text;
  final Widget child;
  final bool center;

  const NoContentWidget({Key key, this.text, this.child, this.center = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget widget = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child:Text(
            text ?? 'Nessun risultato', 
            textAlign: TextAlign.center, 
            style: TextStyle(color: Colors.grey[350], fontWeight: FontWeight.w300, fontSize: 18),
          ),
        ),
        child ?? Container()
      ],
    ) ;
    if (center) {
      widget = Center(
        child: widget
      );
    }
    return widget;
  }
}