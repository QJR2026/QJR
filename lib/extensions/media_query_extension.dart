import 'package:flutter/material.dart';
import 'package:motivational/app/my_app_view.dart';

extension DynamicHeight on num {
  double pxV() {
    const double figmaHeight = 932;
    double figmaRatio = (this * 100) / figmaHeight;

    double currentScreenRatio = figmaRatio.percentHeight();

    return currentScreenRatio;
  }

  double pxH() {
    const double figmaWidth = 430;
    double figmaRatio = (this * 100) / figmaWidth;

    double currentScreenRatio = figmaRatio.percentWidth();

    return currentScreenRatio;
  }

  double percentHeight() {
    return (MediaQuery.of(MyApp.gCtx).size.height) * (this / 100);
  }

  double percentWidth() {
    return MediaQuery.of(MyApp.gCtx).size.width * (this / 100);
  }
}
