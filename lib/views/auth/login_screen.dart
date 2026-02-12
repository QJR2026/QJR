import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motivational/utils/images.dart';
import 'package:motivational/views/widgets/icon_wrapper_body.dart';
import 'package:provider/provider.dart';
import 'package:motivational/app/my_app_view.dart';

import '../../providers/auth_provider.dart';
import '../../utils/form_validators.dart';
import '../../utils/icons.dart';
import '../../utils/routes.dart';
import '/utils/my_colors.dart';
import '/views/auth/widget/auth_wrapper.dart';
import '/views/onboarding/widget/circle_text.dart';
import '/views/widgets/my_textfield.dart';

import 'widget/auth_button.dart';
import 'widget/auth_rich_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  signInFormSubmit() {
    if (!formKey.currentState!.validate()) return;
    context.read<AuthProvider>().signin(
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
        resizeToAvoidBottomInset: true,
        backgroundColor: MyColors.primaryColor,
        body: IconWrapperBody(
          body: AuthWrapper(
            useLogo: true,
            titleWidget: const Row(
              children: [
                CircleText(
                  text: ' Hello ',
                  textStyling: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'there!',
                  style: TextStyle(fontSize: 38, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            subTitleText: 'Your QJR\'s awaiting you, Please sign in.',
            body: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 50),
                  MyTextFormField(
                    hintText: 'Email',
                    controller: emailController,
                    validator: FormValidators.emailValidator,
                    prefixIconAsset: IconAssets.email,
                    bottomSpace: 20,
                  ),
                  MyTextFormField(
                    hintText: 'Password',
                    controller: passwordController,
                    prefixIconAsset: IconAssets.password,
                    isPasswordField: true,
                    validator: FormValidators.passwordOnlyRequiredValidator,
                    // bottomSpace: 5,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () =>
                          MyApp.gState.pushNamed(Routes.forgetPassword),
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                            color: MyColors.blackTypeColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Consumer<AuthProvider>(builder: (_, val, neverUpdate) {
                    return AuthButton(
                      loading: val.loading,
                      text: 'Sign In',
                      onPressed: () => signInFormSubmit(),
                    );
                  }),
                  const SizedBox(height: 26),
                  AuthRichText(
                    text: "Don’t have an account? ",
                    actiontext: "Sign up",
                    onPressed: () => MyApp.gState.pushNamed(Routes.signup),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "You can explore the app without signing in. Some features may be limited.",
                    style: TextStyle(
                      color: MyColors.blackTypeColor,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  TextButton(
                    onPressed: () {
                      MyApp.gState.pushNamedAndRemoveUntil(
                        Routes.home,
                        (route) => false,
                      );
                    },
                    child: const Text(
                      "Continue without account",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: MyColors.blackTypeColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
