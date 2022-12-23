
import 'package:flutter_model_listview/src/widgets/bottom_loader.dart';
import 'package:flutter_model_listview/src/widgets/center_loading.dart';
import 'package:flutter_model_listview/src/widgets/retry_button.dart';
import 'package:flutter_model_listview/src/widgets/scroll_listener.dart';
import 'package:flutter_model_listview/src/widgets/searching_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_throttling/flutter_throttling.dart';
import 'package:tuple/tuple.dart';

typedef ModelListViewBuilder<T> = Widget Function(BuildContext context, int index, T element);
typedef ModelListViewStaggerdBuilder<T> = Tuple2<int, double>? Function(BuildContext context, int index, T element);
typedef ModelListViewDatatableBuilder<T> = DataTable Function(BuildContext context, List<T> elements);

class InfiniteList<T> extends StatefulWidget {

  /// The list of element to be rendered
  final List<T> list;
  
  /// Function to be called for load new elements
  /// Needed
  final Future<void> Function() load;

  /// bool parameters to tell [ModelListView] when stop to load more elements
  /// if not specified [ModelListView] will try to call [load] method undefinitely
  final bool loadedAll;

  /// The default behaviour of [ModelListView] is to call [load] method in the [initState]
  /// If this is not wanted set [loadOnInit] to [false]
  final bool loadOnInit;


  /// Function to be called when refresh happens. 
  /// Useless if sliver
  final Future<void> Function()? refresh; 

  /// Threshold of when [load] method will be called
  final double treshold;

  /// When [error] is not null it will be rendered [errorBuilder] on the end of the list
  
  final String? error;

  // ListView properties

  /// Padding of the list
  final EdgeInsets? padding;

  /// [ScrollPhysics]
  final ScrollPhysics? physics;

  final ScrollController? scrollController;

  /// Widget that will be rendered when [load] method returns an error
  /// Useful to create a "try again" widget
  final Widget Function(BuildContext context, String error, bool firstPage)? errorWidgetBuilder;

  /// Widget that will be rendered on the first [load] and at the end of the list on subsequent [load]
  /// Default will be [CenterLoading]
  final Widget? loadingWidget;

  /// Widget that will be rendered when [list] is empty and [load] method does not return any elements
  final Widget? noResultsWidget;

  /// Builder method for the single element of the [list]
  final ModelListViewBuilder<T>? builder;

  /// Separator builder
  /// Only used in separated factory constructor
  final Widget Function(BuildContext, int)? separatorBuilder;


  final bool reverse;

  const InfiniteList({
    Key? key, 
    required this.list, required this.load, required this.loadedAll, required this.builder, 
    this.loadOnInit = true,
    this.refresh, this.error, 
    this.treshold = 200,
    this.errorWidgetBuilder, this.loadingWidget, this.noResultsWidget,
    this.padding,
    this.physics,
    this.scrollController,
    this.reverse = false
  }) : 
    separatorBuilder = null,
    super(key: key);

  const InfiniteList.separated({
    Key? key, 
    required this.list, required this.load, required this.loadedAll, required this.builder, 
    required this.separatorBuilder,
    this.loadOnInit = true,
    this.refresh, this.error, 
    this.treshold = 200,
    this.errorWidgetBuilder, this.loadingWidget, this.noResultsWidget,
    this.padding,
    this.physics,
    this.scrollController,
    this.reverse = false
  }) : 
    super(key: key);


  @override
  _ModelListViewState<T> createState() => _ModelListViewState<T>();
}

class _ModelListViewState<T> extends State<ModelListView<T>> {

  Throttling? throttling;

  @override 
  void initState(){
    if (widget.loadOnInit){
      widget.load(); 
    }
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

        if(widget.list.isNotEmpty){

          var list;

       
          if (widget.separatorBuilder != null) {
            list = ListView.separated(

              cacheExtent: MediaQuery.of(context).size.height * 10,
              physics: widget.physics ?? AlwaysScrollableScrollPhysics(),
              controller: widget.scrollController,
              itemCount: widget.list.length + 1,
              reverse: widget.reverse,
              padding: widget.padding,
              itemBuilder: (BuildContext context, int index) => _builder(index),
              separatorBuilder: widget.separatorBuilder!,
            );
          }
          else {
            list = ListView.builder(
              cacheExtent: MediaQuery.of(context).size.height * 10,
              physics: widget.physics ?? AlwaysScrollableScrollPhysics(),
              controller: widget.scrollController,
              itemCount: widget.list.length + 1,
              reverse: widget.reverse,
              padding: widget.padding,
              itemBuilder: (BuildContext context, int index) => _builder(index)
              
            );
          }
              
            
          
          if(widget.refresh != null) {
            list = RefreshIndicator(
              child: list,
              onRefresh: widget.refresh!,
            );
          }
          
          list = ScrollListener(
            child: list,
            treshold: widget.treshold,
            onEndReach: widget.load,
            reverse: widget.reverse,
          );
          
          
          return list;

        }
        else {
          Widget child;
          if(widget.error != null) { 
            child = widget.errorWidgetBuilder != null 
              ? widget.errorWidgetBuilder!(context, widget.error ?? '', true) 
              : Padding(
                padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 16), 
                child: RetryButton(onPressed: widget.load)
              ); 
          }
          else if(widget.list.isEmpty) { 
            child = SearchingWidget(loadedAll: widget.loadedAll, loadingWidget: widget.loadingWidget, noResultsWidget: widget.noResultsWidget); 
            if (widget.padding != null) { child = Padding(padding: widget.padding!, child: child); }
          }
          else { 
            child = widget.loadingWidget ?? CenterLoading(); 
          }
          return child; 
        } 

  }

  Widget _builder(int index) {

    if(index >= widget.list.length) {
      var child;
      if (widget.error != null) {
        child = widget.errorWidgetBuilder != null ? widget.errorWidgetBuilder!(context, widget.error!, false) : Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: RetryButton(onPressed: widget.load));
      }
      else {
        child = widget.loadingWidget ?? Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: CenterLoading());
      }
      return child;
    } 
    else {
      return widget.builder!(context, index, widget.list[index]);
    }

  }

  void _onScroll() {
    if (!widget.loadedAll && widget.error == null) {
      final maxScroll = widget.scrollController!.position.maxScrollExtent;
      final currentScroll = widget.scrollController!.position.pixels;
      if (currentScroll >= maxScroll - widget.treshold) {
        if (mounted) { throttling?.throttle(widget.load); }
      }
    }
    
  }

  @override
  void dispose() { 
    if (widget.scrollController != null){
      widget.scrollController!.removeListener(_onScroll);
    }
    throttling?.dispose();
    
    
    super.dispose();
  }
}
