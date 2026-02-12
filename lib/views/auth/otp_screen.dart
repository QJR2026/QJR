import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '/extensions/media_query_extension.dart';
import '/extensions/size_box_extension.dart';
import '/utils/my_colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../widgets/custom_back_button.dart';
import 'widget/auth_button.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final formKeyOtp = GlobalKey<FormState>();
  String otp = '';

  otpFormSubmit(String email) {
    if (!formKeyOtp.currentState!.validate()) return;
    context.read<AuthProvider>().verifyOTP(
          email: email,
          otp: otp,
        );
  }

  @override
  Widget build(BuildContext context) {
    final email =
        (ModalRoute.of(context)?.settings.arguments as String?) ?? "Email";
    return GestureDetector(
      onTap: () => primaryFocus!.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Form(
            key: formKeyOtp,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.pxH()),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (kToolbarHeight).vSpace(),
                  const CustomBackButton(),
                  25.vSpace(),
                  const Text(
                    "Enter OTP code",
                    style: TextStyle(fontSize: 38, fontWeight: FontWeight.w500),
                  ),
                  RichText(
                    text: TextSpan(
                        text: 'We sent you your OTP to your email address ',
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: MyColors.blackTypeColor),
                        children: [
                          TextSpan(
                            text:
                                // "abc@yopmail.com",
                                email,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: MyColors.blackTypeColor),
                          )
                        ]),
                  ),
                  const Spacer(),
                  PinCodeTextField(
                    pinTheme: PinTheme(
                      activeColor: MyColors.blackTypeColor,
                      selectedColor: MyColors.blackTypeColor,
                      inactiveColor: MyColors.primaryColor,
                      disabledColor: MyColors.blackTypeColor,
                      activeFillColor: MyColors.blackTypeColor,
                      selectedFillColor: MyColors.blackTypeColor,
                      inactiveFillColor: MyColors.blackTypeColor,
                      fieldHeight: 60.pxV(),
                      fieldWidth: (100.percentWidth() - 40.pxH()) / 6 - 8.pxH(),
                      borderWidth: 1,
                      activeBorderWidth: 1,
                      inactiveBorderWidth: 1,
                      disabledBorderWidth: 0,
                      selectedBorderWidth: 1,
                    ),
                    enableActiveFill: false,
                    keyboardType: TextInputType.number,
                    animationType: AnimationType.fade,
                    animationCurve: Curves.fastEaseInToSlowEaseOut,
                    // cursorColor: textColor,
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w400),
                    appContext: context,
                    onChanged: (value) {
                      otp = value;
                    },
                    onCompleted: (value) async {
                      otp = value;
                    },
                    length: 5,
                    blinkDuration: const Duration(milliseconds: 100),
                    animationDuration: Duration.zero,
                    validator: (value) {
                      if (value!.length < 5) {
                        return "Please complete the otp";
                      }
                      return null;
                    },
                  ),
                  77.vSpace(),
                  Consumer<AuthProvider>(builder: (_, val, neverUpdate) {
                    return Align(
                      alignment: Alignment.center,
                      child: AuthButton(
                        loading: val.loading,
                        text: 'Submit',
                        onPressed: () => otpFormSubmit(email),
                      ),
                    );
                  }),
                  const Spacer(),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Didn’t received code yet?",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                        decorationColor: MyColors.blackTypeColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
