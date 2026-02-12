import 'package:flutter/material.dart';
import 'package:motivational/extensions/size_box_extension.dart';
import 'package:motivational/utils/form_validators.dart';
import 'package:motivational/views/auth/widget/auth_button.dart';
import 'package:motivational/views/widgets/custom_back_button.dart';
import 'package:motivational/views/widgets/my_textfield.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

class FeedBackScreen extends StatefulWidget {
  const FeedBackScreen({super.key});

  @override
  State<FeedBackScreen> createState() => _FeedBackScreenState();
}

class _FeedBackScreenState extends State<FeedBackScreen> {
  final TextEditingController controller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (kToolbarHeight * 2).vSpace(),
                const CustomBackButton(),
                25.vSpace(),
                const FittedBox(
                  child: Text(
                    'Feedback',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500),
                  ),
                ),
                const Text(
                  'We value your thoughts! Share your feedback to help us improve your experience.',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),
                35.vSpace(),
                MyTextFormField(
                  hintText: "Write your feedback here...",
                  controller: controller,
                  validator: (v) => FormValidators.requiredFieldValidator(v,
                      fieldName: 'Feedback'),
                  maxLines: 3,
                  maxLength: 400,
                  bottomSpace: 8,
                ),
                35.vSpace(),
                Consumer<AuthProvider>(
                  builder: (context, value, child) {
                    return AuthButton(
                        text: "Submit",
                        loading: value.feedBackLoading,
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) return;
                          if (controller.text.isNotEmpty) {
                            await value.feedBack(
                                feedback: controller.text.trim());
                            controller.clear();
                          }
                        });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
