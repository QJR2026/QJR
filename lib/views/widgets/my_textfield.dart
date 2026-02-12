import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/extensions/media_query_extension.dart';

class MyTextFormField extends StatefulWidget {
  final String title, hintText;
  final Color? titleColor,
      backgroundColor,
      enabledColor,
      hintColor,
      borderColor,
      filledColor;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final String? prefixIconAsset;
  final Widget? suffixIcon;
  final VoidCallback? titleBtnOnTap;
  final int? maxLength;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final FocusNode? focusNode;
  final TextCapitalization? textCapitalization;
  final List<TextInputFormatter>? textInputFormater;
  final bool? readOnly, isShowTitleBtn;
  bool enabled = true;
  final double focusedBorderWidth, textFieldHeight;
  final double enableBorderWidth, textenableFieldHeight;
  final double? bottomSpace;
  final int maxLines;
  final EdgeInsets margin;
  final Widget? prefix;
  final TextStyle? inputTextStyle, hintStyle;
  final double borderRadius;
  final BoxConstraints? prefixConstraints;

  final bool isPasswordField;

  MyTextFormField({
    super.key,
    this.title = '',
     this.prefixIconAsset,
    this.titleColor,
    this.backgroundColor,
    this.controller,
    this.hintText = '',
    this.prefixIcon,
    this.prefix,
    this.maxLength,
    this.keyboardType,
    this.filledColor,
    this.borderColor,
    this.onChanged,
    this.validator,
    this.focusNode,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
    this.textCapitalization,
    this.textInputFormater,
    this.suffixIcon,
    this.enabledColor,
    this.hintColor,
    this.focusedBorderWidth = 1.5,
    this.enableBorderWidth = 1.0,
    this.borderRadius = 10,
    this.titleBtnOnTap,
    this.isShowTitleBtn,
    this.margin = EdgeInsets.zero,
    this.textFieldHeight = 65,
    this.textenableFieldHeight = 52,
    this.bottomSpace,
    this.maxLines = 1,
    this.hintStyle,
    this.prefixConstraints,
    this.inputTextStyle,
    this.readOnly = false,
    this.isPasswordField = false,
    this.enabled = true,
  });

  @override
  _MyTextFormFieldState createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
  bool _isObscured = true; // Manage obscure text visibility

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.margin.copyWith(bottom: widget.bottomSpace?.pxV()),
      child: SizedBox(
        // height: widget.textFieldHeight.pxH(),
        child: TextFormField(
          onTapOutside: (event) {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          cursorColor: Colors.black,
          readOnly: widget.readOnly ?? false,
          obscureText: widget.isPasswordField ? _isObscured : false,
          onFieldSubmitted: widget.onFieldSubmitted,
          textAlignVertical: TextAlignVertical.center,
          textInputAction: widget.textInputAction,
          onChanged: widget.onChanged,
          keyboardType: widget.keyboardType,
          maxLength: widget.maxLength,
          controller: widget.controller,
          style: widget.inputTextStyle ??
              const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 15,
                color: Colors.black,
              ),
          focusNode: widget.focusNode,
          maxLines: widget.maxLines,
          decoration: InputDecoration(
            enabled: widget.enabled,
            counterText: '',
            
            // prefixIcon: widget.prefixIcon,
            prefixIconConstraints: BoxConstraints(
                maxWidth: 40, maxHeight: widget.isPasswordField ? 20 : 16),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: widget.enableBorderWidth,
              ),
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            suffixIcon: widget.suffixIcon ??
                // Add the visibility toggle button if _isObscured is true
                Visibility(
                  visible: widget.isPasswordField == true,
                  child: IconButton(
                    icon: Icon(
                      _isObscured
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: const Color(0XFF1E1007),
                      size: 22,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                  ),
                ),

            // enabledBorder: OutlineInputBorder(
            //   borderSide: BorderSide(
            //     color: Colors.grey,
            //     width: widget.enableBorderWidth,
            //   ),
            //   borderRadius: BorderRadius.circular(widget.borderRadius),
            // ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: widget.focusedBorderWidth,
              ),
              borderRadius: BorderRadius.circular(20),
            ),

            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: widget.focusedBorderWidth,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            errorStyle: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w300, color: Colors.red),
            filled: true,
            
            fillColor: Colors.white,
            hintText: widget.hintText,
            hintStyle: TextStyle(
                color: widget.hintColor ?? const Color(0XFF141B34),
                fontSize: 14,
                fontWeight: FontWeight.w500),
            // prefix: widget.prefix,
            prefixIcon: widget.prefixIconAsset!= null ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SizedBox(
                width: 20,
                height: 20,
                child: Image.asset(
                  widget.prefixIconAsset!,
                  fit: BoxFit.fill,
                ),
              ),
            ) :null,
            // contentPadding:
            //     const EdgeInsets.symmetric(vertical: 16, horizontal: 20),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Colors.black,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                color: Colors.black,
                width: 1.5,
              ),
            ),
          ),
          validator: widget.validator,
          textCapitalization:
              widget.textCapitalization ?? TextCapitalization.none,
          inputFormatters: widget.textInputFormater ??
              [FilteringTextInputFormatter.singleLineFormatter],
        ),
      ),
    );
  }
}
