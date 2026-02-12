import 'package:flutter/material.dart';
import 'package:motivational/extensions/size_box_extension.dart';
import 'package:motivational/utils/form_validators.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/icons.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/my_textfield.dart';
import 'widget/auth_button.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  resetPasswordFormSubmit(String email) {
    if (!formKey.currentState!.validate()) return;
    context.read<AuthProvider>().forgetPassword(
          email: email,
          password: passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final email =
        (ModalRoute.of(context)?.settings.arguments as String?) ?? "Email";
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (kToolbarHeight * 2).vSpace(),
                const CustomBackButton(),
                25.vSpace(),
                const Text(
                  "Reset Password",
                  style: TextStyle(fontSize: 38, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 50),
                MyTextFormField(
                  hintText: 'New Password',
                  controller: passwordController,
                  bottomSpace: 20,
                  isPasswordField: true,
                  prefixIconAsset: IconAssets.password,
                  validator: FormValidators.passwordValidator,
                ),
                MyTextFormField(
                  hintText: 'Retype Password',
                  controller: confirmPasswordController,
                  isPasswordField: true,
                  prefixIconAsset: IconAssets.password,
                  validator: (val) => FormValidators.confirmPasswordValidator(
                      val, passwordController.text),
                  // bottomSpace: 5,
                ),
                const SizedBox(height: 50),
                Consumer<AuthProvider>(builder: (_, val, neverUpdate) {
                  return Align(
                    alignment: Alignment.center,
                    child: AuthButton(
                      loading: val.loading,
                      text: 'Submit',
                      onPressed: () => resetPasswordFormSubmit(email),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
