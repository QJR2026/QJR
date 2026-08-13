import 'package:flutter/material.dart';
import 'package:motivational/extensions/size_box_extension.dart';
import 'package:motivational/utils/form_validators.dart';
import 'package:motivational/views/auth/widget/auth_button.dart';
import 'package:motivational/views/widgets/custom_back_button.dart';
import 'package:motivational/views/widgets/my_textfield.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../utils/my_colors.dart';

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

  Future<void> _submit() async {
    if (!formKey.currentState!.validate()) return;
    final provider = context.read<AuthProvider>();
    await provider.feedBack(feedback: controller.text.trim());
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting = context.watch<AuthProvider>().feedBackLoading;

    return PopScope(
      // Feedback submission pops this screen itself on success — don't let
      // the user back out (button, swipe, hardware back) mid-request and
      // risk popping while a response is still in flight.
      canPop: !isSubmitting,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  20.vSpace(),
                  Opacity(
                    opacity: isSubmitting ? 0.4 : 1,
                    child: IgnorePointer(
                      ignoring: isSubmitting,
                      child: const CustomBackButton(),
                    ),
                  ),
                  20.vSpace(),
                  const Text(
                    'Add Feedback',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w600,
                      color: MyColors.blackTypeColor,
                    ),
                  ),
                  12.vSpace(),
                  const Text(
                    "We'd love to hear your thoughts. Share your feedback, suggestions, or report any issues to help us improve the QJR experience.",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: MyColors.colorE1E1,
                    ),
                  ),
                  25.vSpace(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: MyTextFormField(
                        backgroundColor: Colors.transparent,
                        hintText: 'Feedback Message',
                        controller: controller,
                        validator: (v) => FormValidators.lengthValidator(
                          v,
                          fieldName: 'Feedback',
                          min: 10,
                          max: 500,
                        ),
                        maxLines: 8,
                        maxLength: 500,
                      ),
                    ),
                  ),
                  Consumer<AuthProvider>(
                    builder: (context, value, child) {
                      return Align(
                        child: AuthButton(
                          buttonWidth: 390,
                          text: 'Submit Feedback',
                          loading: value.feedBackLoading,
                          disable: value.feedBackLoading,
                          onPressed: _submit,
                        ),
                      );
                    },
                  ),
                  20.vSpace(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
