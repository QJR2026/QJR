import 'package:flutter/material.dart';
import 'package:motivational/views/auth/widget/auth_button.dart';
import 'package:motivational/views/onboarding/widget/circle_text.dart';
import 'package:motivational/views/widgets/my_textfield.dart';

class AdminBottomSheet extends StatefulWidget {
  final VoidCallback fucntion;
  final TextEditingController? controller,descController;
  final String firstTitle, secondTitle, hintText, buttonText;
  final bool loader, isTheme;
  const AdminBottomSheet({
    super.key,
    required this.fucntion,
    required this.firstTitle,
    required this.secondTitle,
    required this.controller,
    required this.hintText,
    required this.buttonText,
    required this.loader,
    this.isTheme = false,
    this.descController ,
  });

  @override
  State<AdminBottomSheet> createState() => _AdminBottomSheetState();
}

class _AdminBottomSheetState extends State<AdminBottomSheet> {
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircleText(
                text: widget.firstTitle,
                textStyling: const TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                widget.secondTitle,
                style:
                    const TextStyle(fontSize: 38, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          MyTextFormField(
            hintText: widget.hintText,
            controller: widget.controller,
            onChanged: (value) {
              setState(() {});
            },
            bottomSpace: 8,
          ),
          
          if(!widget.isTheme)const SizedBox(height: 16),
          if (widget.isTheme) ...[
          const SizedBox(height: 8),
            MyTextFormField(
              hintText: "description",
              controller: widget.descController,
              onChanged: (value) {
                setState(() {});
              },
              bottomSpace: 20,
            ),
            const SizedBox(height: 16),
          ],
          AuthButton(
            text: widget.buttonText,
            loading: widget.loader,
            onPressed: ( widget.isTheme ? (widget.controller!.text.isEmpty || widget.descController!.text.isEmpty) :widget.controller!.text.isEmpty)
                ? null
                : () {
                    // if (_formKey.currentState!.validate()) {
                    widget.fucntion();
                    // }
                  },
          ),
          const SizedBox(height: kBottomNavigationBarHeight),
        ],
      ),
    );
  }
}
