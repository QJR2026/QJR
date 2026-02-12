import 'package:flutter/material.dart';

import '../../utils/my_colors.dart';

class NoDataWidget extends StatelessWidget {
  final String text;
  const NoDataWidget({super.key, this.text = 'No Data Found'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color: MyColors.blackTypeColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
