import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motivational/extensions/media_query_extension.dart';
import 'package:motivational/extensions/size_box_extension.dart';
import 'package:motivational/views/widgets/custom_back_button.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/form_validators.dart';
import '../../utils/icons.dart';
import '../widgets/my_textfield.dart';
import 'widget/auth_button.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  forgetPasswordFormSubmit() {
    if (!formKey.currentState!.validate()) return;
    context.read<AuthProvider>().verifyEmail(
          email: emailController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.black),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.pxH()),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // 148.vSpace(),
                  (kToolbarHeight * 2).vSpace(),
                  const CustomBackButton(),
                  kTextTabBarHeight.vSpace(),
                  const Text(
                    overflow: TextOverflow.ellipsis,
                    "Forget Password",
                    style: TextStyle(fontSize: 38, fontWeight: FontWeight.w500),
                  ),
                  const Text(
                    "Please Login To Your Account!",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  60.vSpace(),

                  MyTextFormField(
                    hintText: "Email Address",
                    controller: emailController,
                    prefixIconAsset: IconAssets.email,
                    validator: FormValidators.emailValidator,
                    // bottomSpace: 5,
                  ),
                  40.vSpace(),
                  Consumer<AuthProvider>(builder: (_, val, neverUpdate) {
                    return Align(
                      alignment: Alignment.center,
                      child: AuthButton(
                        loading: val.loading,
                        text: 'Submit',
                        onPressed: () => forgetPasswordFormSubmit(),
                      ),
                    );
                  }),
                  50.vSpace(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
