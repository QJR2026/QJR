// // import 'package:flutter/material.dart';
// // import 'package:flutter/material.dart' as material;
// // import 'package:flutter_stripe/flutter_stripe.dart';
// // import 'package:motivational/providers/payment_provider.dart';
// // import 'package:motivational/services/api_service.dart';
// // import 'package:provider/provider.dart';
// // import '../../model/card_detail.dart';
// // import '../../providers/user_provider.dart';
// // import '../widgets/custom_back_button.dart';
// // import '../widgets/custom_loader_center.dart';
// // import '/utils/my_colors.dart';
// // import '/extensions/size_box_extension.dart';
// // import '../auth/widget/auth_button.dart';
// // import '../widgets/payment_plan_widget.dart';

// // class EditPaymentPlanScreen extends StatefulWidget {
// //   const EditPaymentPlanScreen({super.key});

// //   @override
// //   State<EditPaymentPlanScreen> createState() => _EditPaymentPlanScreenState();
// // }

// // class _EditPaymentPlanScreenState extends State<EditPaymentPlanScreen> {
// //   @override
// //   void initState() {
// //     WidgetsBinding.instance.addPostFrameCallback((_) async {
// //       final userProvider = context.read<UserProvider>();
// //       final paymentProvider = context.read<PaymentProvider>();

// //       // Run both API calls simultaneously
// //       await Future.wait([
// //         userProvider.getUserDetail(),
// //         paymentProvider.getAllPackages(),
// //       ]);

// //       // Proceed after both are done
// //       String? packageId = ApiService.userData?.packageId;
// //       if (packageId != null) {
// //         paymentProvider.setSelectedId(int.parse(packageId));
// //       }
// //     });

// //     super.initState();
// //   }

// //   // CardDetail? cardDetail;
// //   final cardEditController = CardEditController();
// //   CardFieldInputDetails? cardIFDetails;

// //   @override
// //   Widget build(BuildContext context) {
// //     final provider = context.watch<PaymentProvider>();

// //     final userProvider = context.watch<UserProvider>();
// //     return Scaffold(
// //       body: GestureDetector(
// //         onTap: () {
// //           primaryFocus?.unfocus();
// //         },
// //         child: Padding(
// //           padding: const EdgeInsets.symmetric(horizontal: 16),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               70.vSpace(),
// //               const CustomBackButton(),
// //               40.vSpace(),
// //               const Text(
// //                 'Payment Plan.',
// //                 style: TextStyle(
// //                   fontSize: 38,
// //                   fontWeight: FontWeight.w600,
// //                   color: MyColors.blackTypeColor,
// //                 ),
// //               ),
// //               16.vSpace(),
// //               const Text(
// //                 'QJR doesn’t sell or store any information. Your QJR will show up randomly during your selected time frames. Your QJR is also random. No two are alike.  Always remember, Jesus is in Control.',
// //                 style: TextStyle(
// //                   fontSize: 14,
// //                   fontWeight: FontWeight.w400,
// //                   color: MyColors.colorE1E1,
// //                 ),
// //               ),
// //               16.vSpace(),

// //               if (provider.getPackagesLoading)
// //                 const CustomLoaderCenter()
// //               else if (!provider.getPackagesLoading &&
// //                   provider.paymentPlanList.isEmpty)
// //                 const Text(
// //                   'No payment plan found',
// //                   style: TextStyle(
// //                     fontSize: 30,
// //                     fontWeight: FontWeight.w600,
// //                     color: MyColors.blackTypeColor,
// //                   ),
// //                 )
// //               else ...[
// //                 if (ApiService.userData?.packageId != "0")
// //                   Text(
// //                     'You are a paid subscriber. Your current plan is ${provider.paymentPlanList.firstWhere((val) => val.id == int.parse(ApiService.userData?.packageId ?? '0')).name}',
// //                     style: const TextStyle(
// //                       fontSize: 14,
// //                       fontWeight: FontWeight.w400,
// //                       color: MyColors.colorE1E1,
// //                     ),
// //                   ),
// //                 5.vSpace(),
// //                 Align(
// //                   alignment: Alignment.centerRight,
// //                   child: TextButton.icon(
// //                     iconAlignment: IconAlignment.end,
// //                     icon: const Icon(Icons.settings),
// //                     onPressed: () {
// //                       if (userProvider.userData != null) {
// //                         showAutoRenewModalBottomSheet(
// //                           context,
// //                           initialCancelSubscription:
// //                               !userProvider.userData!.autoRenew,
// //                         );
// //                       }
// //                     },
// //                     label: const Text(
// //                       "Payment Settings",
// //                       style: TextStyle(
// //                         fontSize: 17,
// //                         fontWeight: FontWeight.w400,
// //                         color: MyColors.blackTypeColor,
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //                 Expanded(
// //                   child: SingleChildScrollView(
// //                     child: Column(
// //                       children: [
// //                         const Text(
// //                           'Choose your plan.',
// //                           style: TextStyle(
// //                             fontSize: 30,
// //                             fontWeight: FontWeight.w600,
// //                             color: MyColors.blackTypeColor,
// //                           ),
// //                         ),
// //                         12.vSpace(),
// //                         ...provider.paymentPlanList.map((val) {
// //                           return PaymentPlanWidget(
// //                               paymentPlan: val,
// //                               selected: val.id == provider.selectedId,
// //                               onTap: () {
// //                                 provider.setSelectedId(val.id!);
// //                               });
// //                         }),
// //                         if (userProvider.userData != null ||
// //                             !userProvider.userData!.isGlobal) ...[
// //                           if (userProvider.userData?.cardDetail != null)
// //                             cardWidget(userProvider.userData!.cardDetail!),
// //                           20.vSpace(),
// //                           _buildGlassCard(
// //                               userProvider.userData?.cardDetail != null,
// //                               cardEditController),
// //                           30.vSpace(),
// //                           Align(
// //                             child: AuthButton(
// //                               // disable: int.parse(ApiService.userData!.packageId) ==
// //                               //     provider.selectedId || !cardEditController.complete,
// //                               disable: (!cardEditController.complete) &&
// //                                   int.parse(ApiService.userData!.packageId) ==
// //                                       provider.selectedId,
// //                               loading: provider.addCardDetailLoading,
// //                               text: 'Save Details',
// //                               onPressed: () async {
// //                                 String paymentMethodId = "";
// //                                 if (cardEditController.complete) {
// //                                   final paymentMethod =
// //                                       await Stripe.instance.createPaymentMethod(
// //                                     params: PaymentMethodParams.card(
// //                                       paymentMethodData: PaymentMethodData(
// //                                         billingDetails: BillingDetails(
// //                                           email: ApiService.userData?.email ??
// //                                               'example@gmail.com',
// //                                           name: ApiService.userData?.email
// //                                                   .split('@')
// //                                                   .first ??
// //                                               'test',
// //                                         ),
// //                                       ),
// //                                     ),
// //                                   );
// //                                   paymentMethodId = paymentMethod.id;
// //                                 }
// //                                 provider.updatePaymentPlan(paymentMethodId);
// //                               },
// //                             ),
// //                           ),
// //                         ],
// //                         // if (provider.selectedId != null) ...[

// //                         100.vSpace(),
// //                       ],
// //                     ),
// //                   ),
// //                 )
// //               ],

// //               // ],
// //               // cardWidget(selected: true),
// //               // 40.vSpace(),
// //               // TermsOfServiceAndPrivacyPolicy(
// //               //   text:
// //               //       'By selecting payment plan you agree to Quick Jesus Reminder’s',
// //               //   termOfServiceOnPressed: () {},
// //               //   privacyPolicyOnPressed: () {},
// //               // ),
// //               // 70.vSpace(),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildGlassCard(
// //       bool cardAddedAlready, CardEditController cardEditController) {
// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 12),
// //       child: Column(
// //         children: [
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               Text(
// //                 "${cardAddedAlready ? 'Change ' : ''}Card Details",
// //                 style:
// //                     const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //               ),
// //               const Icon(
// //                 Icons.credit_card,
// //                 //  color: Colors.white
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 10),
// //           CardField(
// //             controller: cardEditController,
// //             onCardChanged: (cardDetails) {
// //               setState(() => cardIFDetails = cardDetails);
// //             },
// //             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
// //             decoration:  InputDecoration(
// //               border: InputBorder.none,
// //               // hintText: "XXXX XXXX XXXX XXXX",

// //               hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.grey.withOpacity(.7)),

// //             ),
// //             numberHintText: '**** **** **** ****',

// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget cardWidget(CardDetail cardDetail) {
// //     return material.Card(
// //       elevation: 4,
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //       child: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: SizedBox(
// //           width: double.infinity,
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text(
// //                 cardDetail.brand?.toUpperCase() ?? '',
// //                 style: const TextStyle(
// //                     fontSize: 15,
// //                     color: MyColors.blackTypeColor,
// //                     fontWeight: FontWeight.bold),
// //               ),
// //               const SizedBox(height: 8),
// //               Text(
// //                 "**** **** **** ${cardDetail.last4}",
// //                 style: const TextStyle(
// //                     fontSize: 14,
// //                     color: MyColors.blackTypeColor,
// //                     fontWeight: FontWeight.w500),
// //               ),
// //               const SizedBox(height: 8),
// //               Text(
// //                 "Expires: ${cardDetail.expMonth}/${cardDetail.expiryYear}",
// //                 style: const TextStyle(
// //                     fontSize: 14,
// //                     color: MyColors.blackTypeColor,
// //                     fontWeight: FontWeight.w500),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   void showAutoRenewModalBottomSheet(
// //     BuildContext context, {
// //     required bool initialCancelSubscription,
// //   }) {
// //     String cancelSubscription =
// //         initialCancelSubscription ? '0' : '1'; // '0' for cancel, '1' for enable

// //     showModalBottomSheet(
// //       context: context,
// //       shape: const RoundedRectangleBorder(
// //         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
// //       ),
// //       builder: (context) {
// //         return StatefulBuilder(
// //           builder: (context, setState) {
// //             final provider = context.watch<PaymentProvider>();
// //             return Padding(
// //               padding: const EdgeInsets.all(16.0),
// //               child: Column(
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   // Subscription Title
// //                   const SizedBox(height: 16),
// //                   const Text(
// //                     'Subscription',
// //                     style: TextStyle(
// //                       fontSize: 18,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                   const SizedBox(height: 16),

// //                   // Auto Renew Checkbox

// //                   // Subscription Action Dropdown (Enable or Cancel)
// //                   DropdownButtonFormField<String>(
// //                     value: cancelSubscription,
// //                     decoration: const InputDecoration(
// //                       labelText: 'Choose Action',
// //                       border: OutlineInputBorder(),
// //                     ),
// //                     items: const [
// //                       DropdownMenuItem(
// //                         value: '1', // Enable Subscription
// //                         child: Text('Enable Subscription'),
// //                       ),
// //                       DropdownMenuItem(
// //                         value: '0', // Cancel Subscription
// //                         child: Text('Cancel Subscription'),
// //                       ),
// //                     ],
// //                     onChanged: (value) {
// //                       setState(() {
// //                         cancelSubscription = value!;
// //                       });
// //                     },
// //                   ),

// //                   const SizedBox(height: 16),

// //                   // Save Changes Button
// //                   Align(
// //                     child: AuthButton(
// //                       loading: provider.addCardDetailLoading,
// //                       disable: (initialCancelSubscription ? '0' : '1') ==
// //                           cancelSubscription,
// //                       text: 'Save Changes',
// //                       onPressed: () async {
// //                         // Handle saving the changes here
// //                         provider.updateAutoRenewStatus(
// //                           int.parse(cancelSubscription),
// //                         );
// //                       },
// //                     ),
// //                   ),
// //                   const SizedBox(height: 30),
// //                 ],
// //               ),
// //             );
// //           },
// //         );
// //       },
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart' as material;
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:motivational/providers/payment_provider.dart';
// import 'package:motivational/services/api_service.dart';
// import 'package:provider/provider.dart';
// import '../../model/card_detail.dart';
// import '../../providers/subscription_provider.dart';
// import '../../providers/user_provider.dart';
// import '../widgets/custom_back_button.dart';
// import '../widgets/custom_loader_center.dart';
// import '/utils/my_colors.dart';
// import '/extensions/size_box_extension.dart';
// import '../auth/widget/auth_button.dart';
// import '../widgets/payment_plan_widget.dart';

// class EditPaymentPlanScreen extends StatefulWidget {
//   static bool isOnSubscriptionChangePage = false;
//   const EditPaymentPlanScreen({super.key});

//   @override
//   State<EditPaymentPlanScreen> createState() => _EditPaymentPlanScreenState();
// }

// class _EditPaymentPlanScreenState extends State<EditPaymentPlanScreen> {
//   @override
//   void initState() {
//     EditPaymentPlanScreen.isOnSubscriptionChangePage = true;
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       Provider.of<SubscriptionProvider>(context, listen: false).initStoreInfo();
//       // final userProvider = context.read<UserProvider>();
//       // final paymentProvider = context.read<PaymentProvider>();

//       // Run both API calls simultaneously
//       // await Future.wait([
//       //   userProvider.getUserDetail(),
//       //   paymentProvider.getAllPackages(),
//       // ]);

//       // Proceed after both are done
//       // String? packageId = ApiService.userData?.packageId;
//       // if (packageId != null) {
//       //   paymentProvider.setSelectedId(int.parse(packageId));
//       // }
//     });

//     super.initState();
//   }

//   @override
//   void dispose() {
//     EditPaymentPlanScreen.isOnSubscriptionChangePage = false;
//     super.dispose();
//   }

//   // CardDetail? cardDetail;
//   final cardEditController = CardEditController();
//   CardFieldInputDetails? cardIFDetails;

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<PaymentProvider>();

//     final userProvider = context.watch<UserProvider>();
//     return Scaffold(
//       body: GestureDetector(
//         onTap: () {
//           primaryFocus?.unfocus();
//         },
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               70.vSpace(),
//               const CustomBackButton(),
//               40.vSpace(),
//               const Text(
//                 'Payment Plan.',
//                 style: TextStyle(
//                   fontSize: 38,
//                   fontWeight: FontWeight.w600,
//                   color: MyColors.blackTypeColor,
//                 ),
//               ),
//               16.vSpace(),
//               const Text(
//                 'QJR doesn’t sell or store any information. Your QJR will show up randomly during your selected time frames. Your QJR is also random. No two are alike.  Always remember, Jesus is in Control.',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w400,
//                   color: MyColors.colorE1E1,
//                 ),
//               ),
//               16.vSpace(),

//               if (provider.getPackagesLoading)
//                 const CustomLoaderCenter()
//               else if (!provider.getPackagesLoading &&
//                   provider.paymentPlanList.isEmpty)
//                 const Text(
//                   'No payment plan found',
//                   style: TextStyle(
//                     fontSize: 30,
//                     fontWeight: FontWeight.w600,
//                     color: MyColors.blackTypeColor,
//                   ),
//                 )
//               else ...[
//                 if (ApiService.userData?.packageId != "0")
//                   Text(
//                     'You are a paid subscriber. Your current plan is ${provider.paymentPlanList.firstWhere((val) => val.id == int.parse(ApiService.userData?.packageId ?? '0')).name}',
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w400,
//                       color: MyColors.colorE1E1,
//                     ),
//                   ),
//                 5.vSpace(),
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: TextButton.icon(
//                     iconAlignment: IconAlignment.end,
//                     icon: const Icon(Icons.settings),
//                     onPressed: () {
//                       if (userProvider.userData != null) {
//                         showAutoRenewModalBottomSheet(
//                           context,
//                           initialCancelSubscription:
//                               !userProvider.userData!.autoRenew,
//                         );
//                       }
//                     },
//                     label: const Text(
//                       "Payment Settings",
//                       style: TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.w400,
//                         color: MyColors.blackTypeColor,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         const Text(
//                           'Choose your plan.',
//                           style: TextStyle(
//                             fontSize: 30,
//                             fontWeight: FontWeight.w600,
//                             color: MyColors.blackTypeColor,
//                           ),
//                         ),
//                         12.vSpace(),
//                         // ...provider.paymentPlanList.map((val) {
//                         //   return PaymentPlanWidget(
//                         //       paymentPlan: val,
//                         //       selected: val.id == provider.selectedId,
//                         //       onTap: () {
//                         //         provider.setSelectedId(val.id!);
//                         //       });
//                         // }),
//                         if (userProvider.userData != null ||
//                             !userProvider.userData!.isGlobal) ...[
//                           if (userProvider.userData?.cardDetail != null)
//                             cardWidget(userProvider.userData!.cardDetail!),
//                           20.vSpace(),
//                           _buildGlassCard(
//                               userProvider.userData?.cardDetail != null,
//                               cardEditController),
//                           30.vSpace(),
//                           Align(
//                             child: AuthButton(
//                               // disable: int.parse(ApiService.userData!.packageId) ==
//                               //     provider.selectedId || !cardEditController.complete,
//                               disable: (!cardEditController.complete) &&
//                                   int.parse(ApiService.userData!.packageId) ==
//                                       provider.selectedId,
//                               loading: provider.addCardDetailLoading,
//                               text: 'Save Details',
//                               onPressed: () async {
//                                 String paymentMethodId = "";
//                                 if (cardEditController.complete) {
//                                   final paymentMethod =
//                                       await Stripe.instance.createPaymentMethod(
//                                     params: PaymentMethodParams.card(
//                                       paymentMethodData: PaymentMethodData(
//                                         billingDetails: BillingDetails(
//                                           email: ApiService.userData?.email ??
//                                               'example@gmail.com',
//                                           name: ApiService.userData?.email
//                                                   .split('@')
//                                                   .first ??
//                                               'test',
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                   paymentMethodId = paymentMethod.id;
//                                 }
//                                 provider.updatePaymentPlan(paymentMethodId);
//                               },
//                             ),
//                           ),
//                         ],
//                         // if (provider.selectedId != null) ...[

//                         100.vSpace(),
//                       ],
//                     ),
//                   ),
//                 )
//               ],

//               // ],
//               // cardWidget(selected: true),
//               // 40.vSpace(),
//               // TermsOfServiceAndPrivacyPolicy(
//               //   text:
//               //       'By selecting payment plan you agree to Quick Jesus Reminder’s',
//               //   termOfServiceOnPressed: () {},
//               //   privacyPolicyOnPressed: () {},
//               // ),
//               // 70.vSpace(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildGlassCard(
//       bool cardAddedAlready, CardEditController cardEditController) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "${cardAddedAlready ? 'Change ' : ''}Card Details",
//                 style:
//                     const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const Icon(
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

//   Widget cardWidget(CardDetail cardDetail) {
//     return material.Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SizedBox(
//           width: double.infinity,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 cardDetail.brand?.toUpperCase() ?? '',
//                 style: const TextStyle(
//                     fontSize: 15,
//                     color: MyColors.blackTypeColor,
//                     fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 "**** **** **** ${cardDetail.last4}",
//                 style: const TextStyle(
//                     fontSize: 14,
//                     color: MyColors.blackTypeColor,
//                     fontWeight: FontWeight.w500),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 "Expires: ${cardDetail.expMonth}/${cardDetail.expiryYear}",
//                 style: const TextStyle(
//                     fontSize: 14,
//                     color: MyColors.blackTypeColor,
//                     fontWeight: FontWeight.w500),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void showAutoRenewModalBottomSheet(
//     BuildContext context, {
//     required bool initialCancelSubscription,
//   }) {
//     String cancelSubscription =
//         initialCancelSubscription ? '0' : '1'; // '0' for cancel, '1' for enable

//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             final provider = context.watch<PaymentProvider>();
//             return Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Subscription Title
//                   const SizedBox(height: 16),
//                   const Text(
//                     'Subscription',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   // Auto Renew Checkbox

//                   // Subscription Action Dropdown (Enable or Cancel)
//                   DropdownButtonFormField<String>(
//                     value: cancelSubscription,
//                     decoration: const InputDecoration(
//                       labelText: 'Choose Action',
//                       border: OutlineInputBorder(),
//                     ),
//                     items: const [
//                       DropdownMenuItem(
//                         value: '1', // Enable Subscription
//                         child: Text('Enable Subscription'),
//                       ),
//                       DropdownMenuItem(
//                         value: '0', // Cancel Subscription
//                         child: Text('Cancel Subscription'),
//                       ),
//                     ],
//                     onChanged: (value) {
//                       setState(() {
//                         cancelSubscription = value!;
//                       });
//                     },
//                   ),

//                   const SizedBox(height: 16),

//                   // Save Changes Button
//                   Align(
//                     child: AuthButton(
//                       loading: provider.addCardDetailLoading,
//                       disable: (initialCancelSubscription ? '0' : '1') ==
//                           cancelSubscription,
//                       text: 'Save Changes',
//                       onPressed: () async {
//                         // Handle saving the changes here
//                         provider.updateAutoRenewStatus(
//                           int.parse(cancelSubscription),
//                         );
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart' as material;
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:motivational/providers/payment_provider.dart';
// import 'package:motivational/services/api_service.dart';
// import 'package:provider/provider.dart';
// import '../../model/card_detail.dart';
// import '../../providers/user_provider.dart';
// import '../widgets/custom_back_button.dart';
// import '../widgets/custom_loader_center.dart';
// import '/utils/my_colors.dart';
// import '/extensions/size_box_extension.dart';
// import '../auth/widget/auth_button.dart';
// import '../widgets/payment_plan_widget.dart';

// class EditPaymentPlanScreen extends StatefulWidget {
//   const EditPaymentPlanScreen({super.key});

//   @override
//   State<EditPaymentPlanScreen> createState() => _EditPaymentPlanScreenState();
// }

// class _EditPaymentPlanScreenState extends State<EditPaymentPlanScreen> {
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       final userProvider = context.read<UserProvider>();
//       final paymentProvider = context.read<PaymentProvider>();

//       // Run both API calls simultaneously
//       await Future.wait([
//         userProvider.getUserDetail(),
//         paymentProvider.getAllPackages(),
//       ]);

//       // Proceed after both are done
//       String? packageId = ApiService.userData?.packageId;
//       if (packageId != null) {
//         paymentProvider.setSelectedId(int.parse(packageId));
//       }
//     });

//     super.initState();
//   }

//   // CardDetail? cardDetail;
//   final cardEditController = CardEditController();
//   CardFieldInputDetails? cardIFDetails;

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<PaymentProvider>();

//     final userProvider = context.watch<UserProvider>();
//     return Scaffold(
//       body: GestureDetector(
//         onTap: () {
//           primaryFocus?.unfocus();
//         },
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               70.vSpace(),
//               const CustomBackButton(),
//               40.vSpace(),
//               const Text(
//                 'Payment Plan.',
//                 style: TextStyle(
//                   fontSize: 38,
//                   fontWeight: FontWeight.w600,
//                   color: MyColors.blackTypeColor,
//                 ),
//               ),
//               16.vSpace(),
//               const Text(
//                 'QJR doesn’t sell or store any information. Your QJR will show up randomly during your selected time frames. Your QJR is also random. No two are alike.  Always remember, Jesus is in Control.',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w400,
//                   color: MyColors.colorE1E1,
//                 ),
//               ),
//               16.vSpace(),

//               if (provider.getPackagesLoading)
//                 const CustomLoaderCenter()
//               else if (!provider.getPackagesLoading &&
//                   provider.paymentPlanList.isEmpty)
//                 const Text(
//                   'No payment plan found',
//                   style: TextStyle(
//                     fontSize: 30,
//                     fontWeight: FontWeight.w600,
//                     color: MyColors.blackTypeColor,
//                   ),
//                 )
//               else ...[
//                 if (ApiService.userData?.packageId != "0")
//                   Text(
//                     'You are a paid subscriber. Your current plan is ${provider.paymentPlanList.firstWhere((val) => val.id == int.parse(ApiService.userData?.packageId ?? '0')).name}',
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w400,
//                       color: MyColors.colorE1E1,
//                     ),
//                   ),
//                 5.vSpace(),
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: TextButton.icon(
//                     iconAlignment: IconAlignment.end,
//                     icon: const Icon(Icons.settings),
//                     onPressed: () {
//                       if (userProvider.userData != null) {
//                         showAutoRenewModalBottomSheet(
//                           context,
//                           initialCancelSubscription:
//                               !userProvider.userData!.autoRenew,
//                         );
//                       }
//                     },
//                     label: const Text(
//                       "Payment Settings",
//                       style: TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.w400,
//                         color: MyColors.blackTypeColor,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         const Text(
//                           'Choose your plan.',
//                           style: TextStyle(
//                             fontSize: 30,
//                             fontWeight: FontWeight.w600,
//                             color: MyColors.blackTypeColor,
//                           ),
//                         ),
//                         12.vSpace(),
//                         ...provider.paymentPlanList.map((val) {
//                           return PaymentPlanWidget(
//                               paymentPlan: val,
//                               selected: val.id == provider.selectedId,
//                               onTap: () {
//                                 provider.setSelectedId(val.id!);
//                               });
//                         }),
//                         if (userProvider.userData != null ||
//                             !userProvider.userData!.isGlobal) ...[
//                           if (userProvider.userData?.cardDetail != null)
//                             cardWidget(userProvider.userData!.cardDetail!),
//                           20.vSpace(),
//                           _buildGlassCard(
//                               userProvider.userData?.cardDetail != null,
//                               cardEditController),
//                           30.vSpace(),
//                           Align(
//                             child: AuthButton(
//                               // disable: int.parse(ApiService.userData!.packageId) ==
//                               //     provider.selectedId || !cardEditController.complete,
//                               disable: (!cardEditController.complete) &&
//                                   int.parse(ApiService.userData!.packageId) ==
//                                       provider.selectedId,
//                               loading: provider.addCardDetailLoading,
//                               text: 'Save Details',
//                               onPressed: () async {
//                                 String paymentMethodId = "";
//                                 if (cardEditController.complete) {
//                                   final paymentMethod =
//                                       await Stripe.instance.createPaymentMethod(
//                                     params: PaymentMethodParams.card(
//                                       paymentMethodData: PaymentMethodData(
//                                         billingDetails: BillingDetails(
//                                           email: ApiService.userData?.email ??
//                                               'example@gmail.com',
//                                           name: ApiService.userData?.email
//                                                   .split('@')
//                                                   .first ??
//                                               'test',
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                   paymentMethodId = paymentMethod.id;
//                                 }
//                                 provider.updatePaymentPlan(paymentMethodId);
//                               },
//                             ),
//                           ),
//                         ],
//                         // if (provider.selectedId != null) ...[

//                         100.vSpace(),
//                       ],
//                     ),
//                   ),
//                 )
//               ],

//               // ],
//               // cardWidget(selected: true),
//               // 40.vSpace(),
//               // TermsOfServiceAndPrivacyPolicy(
//               //   text:
//               //       'By selecting payment plan you agree to Quick Jesus Reminder’s',
//               //   termOfServiceOnPressed: () {},
//               //   privacyPolicyOnPressed: () {},
//               // ),
//               // 70.vSpace(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildGlassCard(
//       bool cardAddedAlready, CardEditController cardEditController) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "${cardAddedAlready ? 'Change ' : ''}Card Details",
//                 style:
//                     const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               const Icon(
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
//             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
//             decoration:  InputDecoration(
//               border: InputBorder.none,
//               // hintText: "XXXX XXXX XXXX XXXX",

//               hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.grey.withOpacity(.7)),

//             ),
//             numberHintText: '**** **** **** ****',

//           ),
//         ],
//       ),
//     );
//   }

//   Widget cardWidget(CardDetail cardDetail) {
//     return material.Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SizedBox(
//           width: double.infinity,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 cardDetail.brand?.toUpperCase() ?? '',
//                 style: const TextStyle(
//                     fontSize: 15,
//                     color: MyColors.blackTypeColor,
//                     fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 "**** **** **** ${cardDetail.last4}",
//                 style: const TextStyle(
//                     fontSize: 14,
//                     color: MyColors.blackTypeColor,
//                     fontWeight: FontWeight.w500),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 "Expires: ${cardDetail.expMonth}/${cardDetail.expiryYear}",
//                 style: const TextStyle(
//                     fontSize: 14,
//                     color: MyColors.blackTypeColor,
//                     fontWeight: FontWeight.w500),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void showAutoRenewModalBottomSheet(
//     BuildContext context, {
//     required bool initialCancelSubscription,
//   }) {
//     String cancelSubscription =
//         initialCancelSubscription ? '0' : '1'; // '0' for cancel, '1' for enable

//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             final provider = context.watch<PaymentProvider>();
//             return Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Subscription Title
//                   const SizedBox(height: 16),
//                   const Text(
//                     'Subscription',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   // Auto Renew Checkbox

//                   // Subscription Action Dropdown (Enable or Cancel)
//                   DropdownButtonFormField<String>(
//                     value: cancelSubscription,
//                     decoration: const InputDecoration(
//                       labelText: 'Choose Action',
//                       border: OutlineInputBorder(),
//                     ),
//                     items: const [
//                       DropdownMenuItem(
//                         value: '1', // Enable Subscription
//                         child: Text('Enable Subscription'),
//                       ),
//                       DropdownMenuItem(
//                         value: '0', // Cancel Subscription
//                         child: Text('Cancel Subscription'),
//                       ),
//                     ],
//                     onChanged: (value) {
//                       setState(() {
//                         cancelSubscription = value!;
//                       });
//                     },
//                   ),

//                   const SizedBox(height: 16),

//                   // Save Changes Button
//                   Align(
//                     child: AuthButton(
//                       loading: provider.addCardDetailLoading,
//                       disable: (initialCancelSubscription ? '0' : '1') ==
//                           cancelSubscription,
//                       text: 'Save Changes',
//                       onPressed: () async {
//                         // Handle saving the changes here
//                         provider.updateAutoRenewStatus(
//                           int.parse(cancelSubscription),
//                         );
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:motivational/utils/custom_snackbar.dart';
import 'package:provider/provider.dart';
import '../../providers/subscription_provider.dart';
import '../widgets/custom_back_button.dart';
import '/utils/my_colors.dart';
import '/extensions/size_box_extension.dart';
import '../auth/widget/auth_button.dart';
import '../widgets/payment_plan_widget.dart';

class EditPaymentPlanScreen extends StatefulWidget {
  static bool isOnSubscriptionChangePage = false;
  const EditPaymentPlanScreen({super.key});

  @override
  State<EditPaymentPlanScreen> createState() => _EditPaymentPlanScreenState();
}

class _EditPaymentPlanScreenState extends State<EditPaymentPlanScreen> {
  @override
  void initState() {
    EditPaymentPlanScreen.isOnSubscriptionChangePage = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider =
          Provider.of<SubscriptionProvider>(context, listen: false);
      provider.initStoreInfo();
      selectedId.value = provider.activePlan;

      // final userProvider = context.read<UserProvider>();
      // final paymentProvider = context.read<PaymentProvider>();

      // // Run both API calls simultaneously
      // await Future.wait([
      //   userProvider.getUserDetail(),
      //   paymentProvider.getAllPackages(),
      // ]);

      // // Proceed after both are done
      // String? packageId = ApiService.userData?.packageId;
      // if (packageId != null) {
      //   paymentProvider.setSelectedId(int.parse(packageId));
      // }
    });

    super.initState();
  }

  final ValueNotifier<ProductDetails?> selectedId =
      ValueNotifier<ProductDetails?>(null);

  @override
  void dispose() {
    EditPaymentPlanScreen.isOnSubscriptionChangePage = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SubscriptionProvider>();

    // final userProvider = context.watch<UserProvider>();
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          primaryFocus?.unfocus();
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  70.vSpace(),
                  const CustomBackButton(),
                  40.vSpace(),
                  const Text(
                    'Payment Plan.',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w600,
                      color: MyColors.blackTypeColor,
                    ),
                  ),
                  16.vSpace(),
                  const Text(
                    'QJR doesn’t sell or store any information. Your QJR will show up randomly during your selected time frames. Your QJR is also random. No two are alike.  Always remember, Jesus is in Control.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: MyColors.colorE1E1,
                    ),
                  ),
                  16.vSpace(),

                  // if (provider.getPackagesLoading)
                  //   const CustomLoaderCenter()
                  if (provider.products.isEmpty)
                    const Text(
                      'No payment plan found',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        color: MyColors.blackTypeColor,
                      ),
                    )
                  else ...[
                    // Text(
                    //   'You are a paid subscriber. Your current plan is ${provider.activePlan?.title ?? 'N/A'}',
                    //   style: const TextStyle(
                    //     fontSize: 14,
                    //     fontWeight: FontWeight.w400,
                    //     color: MyColors.colorE1E1,
                    //   ),
                    // ),
                    5.vSpace(),

                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const Text(
                              'Choose your plan.',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                                color: MyColors.blackTypeColor,
                              ),
                            ),
                            12.vSpace(),
                            ValueListenableBuilder(
                              valueListenable: selectedId,
                              builder: (context, value, child) {
                                bool isCurrent = (selectedId.value != null &&
                                    provider.activePlan == selectedId.value);
                                return Column(children: [
                                  ...provider.products.map((val) {
                                    return PaymentPlanWidget(
                                        paymentPlan: val,
                                        selected: val == value,
                                        isAlreadyPurchased: val.id ==
                                            (provider.activePlan?.id ?? ""),
                                        showYourPlan: true,
                                        onTap: () {
                                          selectedId.value = val;
                                          // provider.setSelectedId(val.id!);
                                        });
                                  }),
                                  30.vSpace(),
                                  Align(
                                    child: AuthButton(
                                      disable: (selectedId.value != null &&
                                              provider.activePlan ==
                                                  selectedId.value) ||
                                          provider.isLoading,
                                      // loading: provider.isLoading,
                                      text: isCurrent
                                          ? 'Your Plan'
                                          : 'Change Plan',
                                      onPressed: () async {
                                        if (selectedId.value != null &&
                                            provider.activePlan ==
                                                selectedId.value) {
                                          CustomSnackBar.showError(
                                              message:
                                                  "You have already subscribed this to ${selectedId.value?.title}");
                                          return;
                                        }
                                        if (selectedId.value != null) {
                                          provider.changeSubscription(
                                              selectedId.value!);
                                        }
                                      },
                                    ),
                                  ),
                                ]);
                              },
                            ),

                            // if (provider.selectedId != null) ...[

                            100.vSpace(),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                          onPressed: () {
                            AppSettings.openAppSettings(
                                type: AppSettingsType.subscriptions);
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: MyColors.colorE1E1),
                          )),
                    ),
                    40.vSpace()
                  ],

                  // ],
                  // cardWidget(selected: true),
                  // 40.vSpace(),
                  // TermsOfServiceAndPrivacyPolicy(
                  //   text:
                  //       'By selecting payment plan you agree to Quick Jesus Reminder’s',
                  //   termOfServiceOnPressed: () {},
                  //   privacyPolicyOnPressed: () {},
                  // ),
                  // 70.vSpace(),
                ],
              ),
            ),
            if (provider.isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
