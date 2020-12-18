import 'package:flutter/material.dart';

class BottomLoader extends StatelessWidget {

  final bool loadedAll;
  final bool sliver;


  const BottomLoader({Key key, this.loadedAll, this.sliver = false}): super(key: key);

  @override
  Widget build(BuildContext context) {

    Widget child;
    if(loadedAll == null){
      child = _BottomLoader(); 
    }
    else{
      child = loadedAll ? Container() : _BottomLoader();
    }
    if (sliver) { return SliverToBoxAdapter(child: child); }
    else { return child; }
  }
}

class _BottomLoader extends StatelessWidget {
  const _BottomLoader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // il circular progress fa si che nelle liste sta sempre a rebuildare
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
            ),
          )
        ),
      ),
    );
  }
}
