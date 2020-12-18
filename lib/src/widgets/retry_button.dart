
import 'package:flutter/material.dart';

class RetryButton extends StatelessWidget {
  final Future<void> Function() onPressed;
  const RetryButton({@required this.onPressed, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 80,
        height: 32,
        child: OutlineButton(
          child: Text('Try again', style: TextStyle( fontWeight: FontWeight.w200)),
          onPressed: onPressed
        )
      ) 
    );
  }
}