import 'package:flutter/material.dart';
import 'package:motivational/extensions/media_query_extension.dart';

import '../../../utils/my_colors.dart';

// class AuthButton extends StatelessWidget {
//   final String text;
//   final Function onPressed;
//   final EdgeInsets padding;
//   final bool loading;
//   final bool disable;
//   final Size? size;
//   const AuthButton({
//     super.key,
//     required this.text,
//     required this.onPressed,
//     this.loading = false,
//     this.size ,
//     this.disable = false,
//     this.padding = const EdgeInsets.symmetric(horizontal: 34, vertical: 14),
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: disable ? null : () => loading ? null : onPressed(),

//       style: ElevatedButton.styleFrom(
//         // maximumSize: size,
//         minimumSize: size,
//         backgroundColor: MyColors.blackTypeColor, // Button color
//         foregroundColor: MyColors.primaryColor, // Text color
//         padding: padding,
// shape: RoundedRectangleBorder(
//   borderRadius: BorderRadius.circular(20),
// ),

//       ),
//       child: loading
//           ? const CircularProgressIndicator(
//               color: MyColors.primaryColor,
//             )
//           : Text(
//               text,
// style: const TextStyle(
//   fontSize: 15,
//   fontWeight: FontWeight.bold,
// ),
//             ),
//     );
//   }
// }

class AuthButton extends StatelessWidget {
  final bool loading;
  final bool disable;
  final VoidCallback? onPressed;
  final String text;
  final EdgeInsets padding;
  final Color? buttonLoaderBGColor,
      borderColor,
      buttonBackgroundColor,
      disabledTextColor,
      textColor,
      loaderColor;
  final double height, loaderWidth, buttonWidth;
  final EdgeInsets? margin;

  AuthButton({
    super.key,
    this.loading = false,
    this.disable = false,
    this.onPressed,
    required this.text,
    this.buttonLoaderBGColor = MyColors.blackTypeColor,
    this.margin,
    this.height = 45,
    this.buttonWidth = 200,
    this.loaderWidth = 60,
    this.buttonBackgroundColor = MyColors.blackTypeColor,
    this.disabledTextColor = MyColors.blackTypeColor,
    this.loaderColor = MyColors.primaryColor,
    this.borderColor,
    this.textColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 34, vertical: 14),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.center,
          child: AnimatedContainer(
            decoration: BoxDecoration(
              color:
                  onPressed != null ? buttonLoaderBGColor! : Colors.transparent,
              borderRadius: BorderRadius.circular(loading ? 30 : 20),
            ),
            duration: const Duration(milliseconds: 500),
            width: loading ? loaderWidth : buttonWidth.pxH(),
            child: loading
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          loaderColor ?? Colors.white,
                        ),
                      ),
                    ),
                  )
                : ElevatedButton(
                    onPressed: disable ? null : onPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: disable
                          ? Colors
                              .grey // Set the background color when disabled
                          : (onPressed != null ? buttonBackgroundColor : null),
                      foregroundColor: disable
                          ? Colors.grey // Set the text color when disabled
                          : buttonBackgroundColor,
                      side: BorderSide(
                        width: 1,
                        color: borderColor ?? Colors.transparent,
                      ),
                      padding: padding,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(loading ? 30.0 : 20.0),
                      ),
                    ),
                    child: FittedBox(
                      child: Text(
                        loading ? "" : text,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: disable
                              ? Colors.grey // Text color when disabled
                              : MyColors
                                  .primaryColor, // Text color when enabled
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
