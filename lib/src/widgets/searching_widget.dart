import 'package:flutter/material.dart';
import 'package:flutter_model_listview/src/widgets/center_loading.dart';
import 'package:flutter_model_listview/src/widgets/no_content.dart';

class SearchingWidget extends StatelessWidget {

  /// Creates a searching widget.
  ///
  /// if [loadedAll] is true returns [noResultsWidget] or else [NoContentWidget]
  /// returns [loadinWidget] or [CenterLoading] otherwise

  final bool loadedAll;
  final Widget? noResultsWidget;
  final String? noResultText;
  final Widget? loadingWidget;
  final String? platform;

  const SearchingWidget({Key? key, required this.loadedAll, this.noResultsWidget, this.noResultText, this.loadingWidget, this.platform}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (loadedAll) 
    ? noResultsWidget ?? NoContentWidget(text: noResultText ?? 'Nessun risultato trovato.')
    : loadingWidget ?? CenterLoading(platform: platform);
  }
}