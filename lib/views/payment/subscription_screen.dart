// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:motivational/providers/payment_provider.dart';
// import 'package:motivational/views/widgets/custom_loader_center.dart';
// import 'package:provider/provider.dart';
// import 'package:motivational/app/my_app_view.dart';

// import '../../utils/routes.dart';
// import '/utils/my_colors.dart';
// import '/extensions/size_box_extension.dart';
// import '../auth/widget/auth_button.dart';
// import '../auth/widget/terms_of_service_and_privacy_policy.dart';
// import '../widgets/payment_plan_widget.dart';

// class SubscriptionScreen extends StatefulWidget {
//   const SubscriptionScreen({super.key});

//   @override
//   State<SubscriptionScreen> createState() => _SubscriptionScreenState();
// }

// class _SubscriptionScreenState extends State<SubscriptionScreen> {
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<PaymentProvider>().getAllPackages();
//     });

//     super.initState();
//   }

//   // CardDetail? cardDetail;
//   final cardEditController = CardEditController();
//   CardFieldInputDetails? cardIFDetails;

//   // final ValueNotifier<bool> _isChecked = ValueNotifier<bool>(true);

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<PaymentProvider>();

//     //  context.read<PaymentProvider>().getAllPackages();
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             120.vSpace(),
//             const Text(
//               'Payment Method.',
//               style: TextStyle(
//                 fontSize: 38,
//                 fontWeight: FontWeight.w600,
//                 color: MyColors.blackTypeColor,
//               ),
//             ),
//             Expanded(
//                 child: SingleChildScrollView(
//                     child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 25.vSpace(),
//                 // const Text(
//                 //   'To continue enjoying our premium features, please select a payment plan that suits your needs and enter your card details below. Your payment information will be securely processed.',
//                 //   style: TextStyle(
//                 //     fontSize: 14,
//                 //     fontWeight: FontWeight.w400,
//                 //     color: MyColors.colorE1E1,
//                 //   ),
//                 // ),
//                 // 16.vSpace(),
//                 // const Text(
//                 //   'Choose from our available plans to unlock exclusive content and remove limitations. Once you\'ve selected a plan, provide your card details to complete the payment process.',
//                 //   style: TextStyle(
//                 //     fontSize: 14,
//                 //     fontWeight: FontWeight.w400,
//                 //     color: MyColors.colorE1E1,
//                 //   ),
//                 // ),
//                 // 16.vSpace(),
//                 const Text(
//                   'QJR doesn’t sell or store any information. Your QJR will show up randomly during your selected time frames. Your QJR is also random. No two are alike.  Always remember, Jesus is in Control.',
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w400,
//                     color: MyColors.colorE1E1,
//                   ),
//                 ),
//                 16.vSpace(),
//                 const Text(
//                   'Choose your plan.',
//                   style: TextStyle(
//                     fontSize: 30,
//                     fontWeight: FontWeight.w600,
//                     color: MyColors.blackTypeColor,
//                   ),
//                 ),
//                 12.vSpace(),
//                 if (provider.getPackagesLoading)
//                   const CustomLoaderCenter()
//                 else if (!provider.getPackagesLoading &&
//                     provider.paymentPlanList.isEmpty)
//                   const Text(
//                     'No payment plan found',
//                     style: TextStyle(
//                       fontSize: 30,
//                       fontWeight: FontWeight.w600,
//                       color: MyColors.blackTypeColor,
//                     ),
//                   )
//                 else
//                   ...provider.paymentPlanList.map((val) {
//                     return PaymentPlanWidget(
//                         paymentPlan: val,
//                         selected: val.id == provider.selectedId,
//                         onTap: () {
//                           provider.setSelectedId(val.id!);
//                         });
//                   }),

//                 // Row(
//                 //   mainAxisAlignment: MainAxisAlignment.end,
//                 //   children: [
//                 //     const Text('Auto Renew'),
//                 //     ValueListenableBuilder<bool>(
//                 //       valueListenable: _isChecked,
//                 //       builder: (context, isChecked, child) {
//                 //         return Checkbox.adaptive(
//                 //           activeColor: MyColors.blackTypeColor,
//                 //           checkColor: MyColors.primaryColor,
//                 //           value: isChecked,
//                 //           onChanged: (bool? newValue) {
//                 //             if (newValue != null) {
//                 //               _isChecked.value = newValue;
//                 //             }
//                 //           },
//                 //         );
//                 //       },
//                 //     ),
//                 //     10.hSpace()
//                 //   ],
//                 // ),

//                 if (provider.selectedId != null) ...[
//                   30.vSpace(),
//                   _buildGlassCard(cardEditController),
//                   20.vSpace(),
//                   Align(
//                     child: AuthButton(
//                       disable: !cardEditController.complete,
//                       loading: provider.addCardDetailLoading,
//                       text: 'Save Details',
//                       onPressed: () => provider.createPaymentMethod(),
//                       // padding: const EdgeInsets.symmetric(
//                       //     horizontal: 24, vertical: 14),
//                     ),
//                   )
//                 ],
//                 // cardWidget(selected: true),
//                 40.vSpace(),
//                 TermsOfServiceAndPrivacyPolicy(
//                   text:
//                       'By selecting payment plan you agree to Quick Jesus Reminder’s',
//                   termOfServiceOnPressed: () =>
//                       MyApp.gState.pushNamed(Routes.termsOfService),
//                   privacyPolicyOnPressed: () =>
//                       MyApp.gState.pushNamed(Routes.privacyPolicy),
//                 ),
//                 70.vSpace(),
//               ],
//             ))),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildGlassCard(CardEditController cardEditController) {
//     return Container(
//       // decoration: BoxDecoration(
//       //   borderRadius: BorderRadius.circular(20),
//       //   // color: Colors.white.withOpacity(0.1),
//       //   // boxShadow: [
//       //   //   BoxShadow(
//       //   //       color: Colors.black.withOpacity(0.2),
//       //   //       blurRadius: 10,
//       //   //       spreadRadius: 2),
//       //   // ],
//       // ),
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       child: Column(
//         children: [
//           const Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Card Details",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               Icon(
//                 Icons.credit_card,
//                 //  color: Colors.white
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           CardField(
//             controller: cardEditController,
//             onCardChanged: (cardDetails) {
//               setState(() => cardIFDetails = cardDetails);
//             },
//             style: const TextStyle(
//                 fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
//             decoration: InputDecoration(
//               border: InputBorder.none,
//               // hintText: "XXXX XXXX XXXX XXXX",

//               hintStyle: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w300,
//                   color: Colors.grey.withOpacity(.7)),
//             ),
//             numberHintText: '**** **** **** ****',
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:motivational/providers/subscription_provider.dart';
import 'package:provider/provider.dart';
import 'package:motivational/app/my_app_view.dart';

import '../../utils/routes.dart';
import '/utils/my_colors.dart';
import '/extensions/size_box_extension.dart';
import '../auth/widget/auth_button.dart';
import '../auth/widget/terms_of_service_and_privacy_policy.dart';
import '../widgets/payment_plan_widget.dart';

class SubscriptionScreen extends StatefulWidget {
  static bool isOnSubscriptionPage = false;
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  @override
  void initState() {
    SubscriptionScreen.isOnSubscriptionPage = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // context.read<PaymentProvider>().getAllPackages();
    });

    super.initState();
  }

  @override
  void dispose() {
    SubscriptionScreen.isOnSubscriptionPage = false;
    super.dispose();
  }

  final ValueNotifier<ProductDetails?> selectedId =
      ValueNotifier<ProductDetails?>(null);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SubscriptionProvider>();

    //  context.read<PaymentProvider>().getAllPackages();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            120.vSpace(),
            const Text(
              'Payment Method.',
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w600,
                color: MyColors.blackTypeColor,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    25.vSpace(),
                    // const Text(
                    //   'To continue enjoying our premium features, please select a payment plan that suits your needs and enter your card details below. Your payment information will be securely processed.',
                    //   style: TextStyle(
                    //     fontSize: 14,
                    //     fontWeight: FontWeight.w400,
                    //     color: MyColors.colorE1E1,
                    //   ),
                    // ),
                    // 16.vSpace(),
                    // const Text(
                    //   'Choose from our available plans to unlock exclusive content and remove limitations. Once you\'ve selected a plan, provide your card details to complete the payment process.',
                    //   style: TextStyle(
                    //     fontSize: 14,
                    //     fontWeight: FontWeight.w400,
                    //     color: MyColors.colorE1E1,
                    //   ),
                    // ),
                    // 16.vSpace(),
                    const Text(
                      'QJR doesn’t sell or store any information. Your QJR will show up randomly during your selected time frames. Your QJR is also random. No two are alike.  Always remember, Jesus is in Control.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: MyColors.colorE1E1,
                      ),
                    ),
                    16.vSpace(),
                    const Text(
                      'Choose your plan.',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        color: MyColors.blackTypeColor,
                      ),
                    ),
                    12.vSpace(),
                    // if (provider.isLoading)
                    //   const CustomLoaderCenter()
                    // else
                     if (provider.products.isEmpty)
                      const Text(
                        'No payment plan found',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: MyColors.blackTypeColor,
                        ),
                      )
                    else
                      ...provider.products.map((val) {
                        return ValueListenableBuilder(
                          valueListenable: selectedId,
                          builder: (context, value, child) {
                            return PaymentPlanWidget(
                                paymentPlan: val,
                                selected: val == value,
                                onTap: () {
                                  selectedId.value = val;
                                });
                          },
                        );
                      }),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     const Text('Auto Renew'),
                    //     ValueListenableBuilder<bool>(
                    //       valueListenable: _isChecked,
                    //       builder: (context, isChecked, child) {
                    //         return Checkbox.adaptive(
                    //           activeColor: MyColors.blackTypeColor,
                    //           checkColor: MyColors.primaryColor,
                    //           value: isChecked,
                    //           onChanged: (bool? newValue) {
                    //             if (newValue != null) {
                    //               _isChecked.value = newValue;
                    //             }
                    //           },
                    //         );
                    //       },
                    //     ),
                    //     10.hSpace()
                    //   ],
                    // ),

                    30.vSpace(),
                    ValueListenableBuilder(
                      valueListenable: selectedId,
                      builder: (context, value, child) {
                        return Align(
                          child: AuthButton(
                            disable: value == null,
                            loading: provider.isLoading,
                            text: 'Pay now',
                            onPressed: () => provider.buy(value!),
                            // padding: const EdgeInsets.symmetric(
                            //     horizontal: 24, vertical: 14),
                          ),
                        );
                      },
                    ),

                    // cardWidget(selected: true),
                    40.vSpace(),
                    TermsOfServiceAndPrivacyPolicy(
                      text:
                          'By selecting payment plan you agree to Quick Jesus Reminder’s',
                      termOfServiceOnPressed: () =>
                          MyApp.gState.pushNamed(Routes.termsOfService),
                      privacyPolicyOnPressed: () =>
                          MyApp.gState.pushNamed(Routes.privacyPolicy),
                    ),
                    70.vSpace(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
