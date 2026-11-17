import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:motivational/utils/custom_snackbar.dart';
import 'package:provider/provider.dart';
import '../../providers/subscription_provider.dart';
import '../../utils/platform_features.dart';
import '../widgets/custom_back_button.dart';
import '/utils/my_colors.dart';
import '/extensions/size_box_extension.dart';
import '../auth/widget/auth_button.dart';
import '../widgets/payment_plan_widget.dart';
import '../widgets/products_error_retry.dart';

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
      // Safety net: plan management is iOS-only. Never query billing on Android.
      if (!PlatformFeatures.isSubscriptionEnabled) {
        Navigator.of(context).maybePop();
        return;
      }
      final provider =
          Provider.of<SubscriptionProvider>(context, listen: false);
      await provider.initStoreInfo();
      // Seed selection once from the current plan — never overwrite a user tap.
      if (selectedId.value == null) {
        selectedId.value = provider.activePlan;
      }
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

    // Seed once when products/active plan become available — never clobber a tap.
    if (selectedId.value == null && provider.activePlan != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (selectedId.value == null) {
          selectedId.value = provider.activePlan;
        }
      });
    }

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
                  if (provider.products.isEmpty &&
                      !provider.isLoading &&
                      provider.productsError != null)
                    ProductsErrorRetry(
                      message: provider.productsError!,
                      onRetry: () => provider.retryLoadProducts(),
                    )
                  else if (provider.products.isEmpty && !provider.isLoading)
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
                                          provider.isLoading ||
                                          provider.isProcessing,
                                      loading: provider.isProcessing,
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
