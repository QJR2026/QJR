import 'package:flutter/material.dart';
import 'package:motivational/extensions/media_query_extension.dart';
import 'package:motivational/views/widgets/custom_loader_center.dart';
import 'package:motivational/views/widgets/no_data_widget.dart';

class AppLoaderWidget extends StatelessWidget {
  final Widget child;
  final bool isLoading, hasData;
  final Widget? loadingChild;
  const AppLoaderWidget({
    super.key,
    required this.child,
    required this.isLoading,
    required this.hasData,
    this.loadingChild,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: 100.percentHeight(),
        width: 100.percentWidth(),
        child: const CustomLoaderCenter(),
      );
    } else if (!isLoading && !hasData) {
      return const  NoDataWidget();
    } else {
      return child;
    }
  }
}
