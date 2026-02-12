import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motivational/app/my_app_view.dart';
import 'package:motivational/extensions/size_box_extension.dart';
import 'package:motivational/providers/auth_provider.dart';
import 'package:motivational/utils/routes.dart';
import 'package:provider/provider.dart';
import '../../utils/form_validators.dart';
import '../../utils/icons.dart';

import '/utils/my_colors.dart';
import '/views/auth/widget/auth_wrapper.dart';
import '/views/onboarding/widget/circle_text.dart';
import '/views/widgets/my_textfield.dart';

import 'widget/auth_button.dart';
import 'widget/auth_rich_text.dart';
import 'widget/terms_of_service_and_privacy_policy.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  signUpFormSubmit() {
    if (!formKey.currentState!.validate()) return;
    context.read<AuthProvider>().signUp(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
    //
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: MyColors.primaryColor,
        body: AuthWrapper(
          titleWidget: const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                Text(
                  'Let’s ',
                  style: TextStyle(fontSize: 38, fontWeight: FontWeight.w500),
                ),
                CircleText(
                  text: 'Motivate.',
                  textStyling: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          subTitleText: 'New quotes awaiting you, Please Sign up.',
          body: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(height: 50),
                MyTextFormField(
                  hintText: 'Email Id',
                  controller: emailController,
                  bottomSpace: 20,
                  prefixIconAsset: IconAssets.email,
                  validator: FormValidators.emailValidator,
                ),
                MyTextFormField(
                  hintText: 'Password',
                  controller: passwordController,
                  bottomSpace: 20,
                  isPasswordField: true,
                  prefixIconAsset: IconAssets.password,
                  validator: FormValidators.passwordValidator,
                ),
                MyTextFormField(
                  hintText: 'Confirm Password',
                  controller: confirmPasswordController,
                  isPasswordField: true,
                  prefixIconAsset: IconAssets.password,
                  validator: (val) => FormValidators.confirmPasswordValidator(
                      val, passwordController.text),
                  // bottomSpace: 5,
                ),
                50.vSpace(),
                Consumer<AuthProvider>(builder: (_, val, neverUpdate) {
                  return AuthButton(
                    loading: val.loading,
                    text: 'Create Account',
                    onPressed: () => signUpFormSubmit(),
                    // padding: const EdgeInsets.symmetric(
                    //     horizontal: 24, vertical: 14),
                  );
                }),
                30.vSpace(),
                AuthRichText(
                  text: "Already have an account? ",
                  actiontext: "Sign in",
                  onPressed: () => MyApp.gState.pop(),
                ),
                20.vSpace(),

                TermsOfServiceAndPrivacyPolicy(
                  text:
                      'By creating an account you agree to Quick Jesus Reminder’s',
                  termOfServiceOnPressed: () =>
                      MyApp.gState.pushNamed(Routes.termsOfService),
                  privacyPolicyOnPressed: () =>
                      MyApp.gState.pushNamed(Routes.privacyPolicy),
                ),
                30.vSpace(),
                // RichText(
                //   text: TextSpan(
                //     text: 'Terms of Services',
                //     recognizer: TapGestureRecognizer()..onTap = () {},
                //     style: const TextStyle(
                //       color: MyColors.blackTypeColor,
                //       fontSize: 14,
                //       fontWeight: FontWeight.bold,
                //     ),
                //     children: [
                //       const TextSpan(
                //         text: ' and ',
                //         style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                //       ),
                //       TextSpan(
                //         text: 'Privacy Policy',
                //         style: const TextStyle(
                //           fontSize: 14,
                //           fontWeight: FontWeight.bold,
                //           color: MyColors.blackTypeColor,
                //         ),
                //         recognizer: TapGestureRecognizer()..onTap = () {},
                //       ),
                //     ],
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
