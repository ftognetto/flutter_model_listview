import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CenterLoading extends StatelessWidget {
  
  final bool bigger;
  final Color color;
  final Widget child;
  final bool overlay;
  final Color overlayColor;
  final String platform;

  const CenterLoading({Key key, this.bigger = false, this.color, this.overlay = false, this.overlayColor, this.platform, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _color = color ?? Theme.of(context).accentColor;
    Widget loading = SizedBox(
      width: bigger ? 50 : 33,
      height: bigger ? 50 : 33,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: platform != null && platform == 'ios' 
          ? CupertinoActivityIndicator(
            radius: bigger ? 20.0 : 10.0,
          )
          : CircularProgressIndicator(
            strokeWidth: bigger ? 3.0 : 1.5,
            valueColor: AlwaysStoppedAnimation<Color>(_color),
          )
      )
    );
    loading = Center(
      child: child != null ?
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            loading,
            SizedBox(height: 16,),
            child
          ],
        )
        : loading
    );
    if (overlay) {
      loading = Container(
        color: overlayColor ?? Colors.black.withOpacity(0.6),
        child: loading
      );
    }
    return loading;
  }
}