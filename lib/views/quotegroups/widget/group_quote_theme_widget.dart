import 'package:flutter/material.dart';


import '../../../utils/my_colors.dart';

// class GroupQuoteThemeWidget extends StatelessWidget {
//   final String asset;
//   final String name;
//   final String description;
//   const GroupQuoteThemeWidget({
//     super.key,
//     required this.asset,
//     required this.name,
//     required this.description,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 40),
//       // height: 270.pxV(),
//       constraints: BoxConstraints(minHeight: 270.pxV()),
//       // alignment: Alignment.center,
//       width: double.infinity,
//       decoration: BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage(
//             asset,
//           ),
//           fit: BoxFit.fill,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.end,
//         mainAxisSize: MainAxisSize.max,
//         children: [
//           FittedBox(
//             child: Text(
//               name,
//               style: const TextStyle(
//                 fontSize: 30,
//                 color: MyColors.blackTypeColor,
//                 fontWeight: FontWeight.bold,
//               ),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//           Text(
//             description,
//             style: const TextStyle(
//               fontSize: 14,
//               color: MyColors.colorE1E1,
//               fontWeight: FontWeight.w400,
//             ),
//             maxLines: 3,
//             overflow: TextOverflow.ellipsis,
//           ),
//           40.vSpace(),
//         ],
//       ),
//     );
//   }
// }

class GroupQuoteThemeWidgetNew extends StatelessWidget {
  final String asset;
  final String name;
  final String description;
  const GroupQuoteThemeWidgetNew({
    super.key,
    required this.asset,
    required this.name,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20)
          .copyWith(top: 15),
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            asset,
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        // mainAxisSize: MainAxisSize.max,
        children: [
          FittedBox(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 30,
                color: MyColors.blackTypeColor,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: MyColors.colorE1E1,
              fontWeight: FontWeight.w400,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          // 40.vSpace(),
        ],
      ),
    );
  }
}
