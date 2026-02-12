import 'package:flutter/material.dart';
import 'package:motivational/extensions/size_box_extension.dart';
import 'package:motivational/providers/auth_provider.dart';
import 'package:motivational/utils/form_validators.dart';
import 'package:motivational/views/auth/widget/auth_button.dart';
import 'package:motivational/views/widgets/my_textfield.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_back_button.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
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
                    'Report an Issue',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500),
                  ),
                ),
                const Text(
                  'Seen something inappropriate or not working as expected? Let us know so we can take action.',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                ),
                35.vSpace(),
                MyTextFormField(
                  hintText: "Describe the issue...",
                  controller: controller,
                  maxLines: 3,
                  maxLength: 400,
                  validator: (v) => FormValidators.requiredFieldValidator(v,
                      fieldName: 'Report'),
                  bottomSpace: 8,
                ),
                35.vSpace(),
                Consumer<AuthProvider>(builder: (context, value, child) {
                  return AuthButton(
                      text: "Submit Report",
                      loading: value.reportLoading,
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) return;
        
                        if (controller.text.isNotEmpty) {
                          await value.report(report: controller.text.trim());
                          controller.clear();
                        }
                      });
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
