import 'package:flutter/material.dart';
import '/extensions/media_query_extension.dart';

extension Space on num {
  // Accept BuildContext to calculate the dynamic space
  SizedBox vSpace() {
    return SizedBox(
      height: pxV(),
    );
  }

  // Accept BuildContext to calculate the dynamic space
  SizedBox hSpace() {
    return SizedBox(
      width: pxH(),
    );
  }
}