import 'package:flutter/material.dart';
import 'package:motivational/extensions/media_query_extension.dart';
import 'package:motivational/extensions/size_box_extension.dart';
import 'package:motivational/utils/form_validators.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/icons.dart';
import '../auth/widget/auth_button.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/my_textfield.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final currentPasswordController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.pxV()),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (kToolbarHeight * 2).vSpace(),
                const CustomBackButton(),
                25.vSpace(),
                const Text(
                  "Change Password",
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 50),
                MyTextFormField(
                  hintText: 'Current Password',
                  controller: currentPasswordController,
                  bottomSpace: 20,
                  isPasswordField: true,
                  prefixIconAsset: IconAssets.password,
                  validator: FormValidators.passwordOnlyRequiredValidator,
                ),
                MyTextFormField(
                    hintText: 'New Password',
                    controller: passwordController,
                    bottomSpace: 20,
                    isPasswordField: true,
                    prefixIconAsset: IconAssets.password,
                    validator: FormValidators.passwordValidator),
                MyTextFormField(
                  hintText: 'Retype Password',
                  controller: confirmPasswordController,
                  isPasswordField: true,
                  prefixIconAsset: IconAssets.password,
                  validator: (val) => FormValidators.confirmPasswordValidator(
                    val,
                    passwordController.text,
                  ),

                  // bottomSpace: 5,
                ),
                const SizedBox(height: 50),
                Consumer<AuthProvider>(
                  builder: (context, value, child) {
                    return Align(
                      alignment: Alignment.center,
                      child: AuthButton(
                        text: 'Submit',
                        loading: value.loading,
                        onPressed: () => changePasswordFormSubmit(),
                      ),
                    );
                  },
                ),
                // const Spacer(),

                // 25.percentHeight().vSpace(),
              ],
            ),
          ),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: TextButton(
      //   onPressed: () {
      //     showConfirmationDialog(
      //       context,
      //       'Confirm Deletion',
      //       'Are you sure you want to delete this item?',
      //       'Delete',
      //       () => _deleteAccount(),
      //     );
      //   },
      //   child: const Text(
      //     'Delete Account',
      //     style: TextStyle(fontSize: 17, color: Colors.red),
      //   ),
      // ),

      resizeToAvoidBottomInset: false,
    );
  }

  // void _deleteAccount() {
  //   context.read<AuthProvider>().deleteAccount();
  // }

  // void showConfirmationDialog(
  //   BuildContext context,
  //   String title,
  //   String content,
  //   String confirmText,
  //   VoidCallback onConfirm,
  // ) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return CustomConfirmationDialog(
  //         title: title,
  //         content: content,
  //         confirmText: confirmText,
  //         onConfirm: onConfirm,
  //       );
  //     },
  //   );
  // }

  changePasswordFormSubmit() {
    if (!formKey.currentState!.validate()) return;
    context.read<AuthProvider>().changePassword(
          password: currentPasswordController.text.trim(),
          newPassword: confirmPasswordController.text.trim(),
        );
  }
}
