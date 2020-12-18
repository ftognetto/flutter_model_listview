import 'package:flutter/material.dart';
import 'package:throttling/throttling.dart';

class ScrollListener extends StatelessWidget {

  final Widget child; 
  final void Function() onEndReach;
  final double treshold;
  static const duration = Duration(milliseconds: 500);

  static final Throttling throttling = Throttling(duration: Duration(milliseconds: 500));

  const ScrollListener({ Key key, @required this.child, @required this.onEndReach, this.treshold = 200 }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      child: child,
      onNotification: (scrollInfo) {
        if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - treshold) { 
          throttling.throttle(onEndReach);
        }
      },
    );
  }
}