import 'package:flutter/material.dart';
import 'package:motivational/providers/admin/admin_quote_provider.dart';
import 'package:motivational/providers/admin/admin_theme_provider.dart';
import 'package:motivational/providers/favorite_provider.dart';
import 'package:motivational/providers/notification_time_preference_provider.dart';
import 'package:motivational/providers/payment_provider.dart';
import 'package:motivational/providers/theme_provider.dart';
import 'package:motivational/providers/user_provider.dart';
import 'package:motivational/views/admin/base/admin_base_screen.dart';
import 'package:motivational/views/admin/home/admin_home_screen.dart';
import 'package:motivational/views/admin/home/admin_theme_detail_screen.dart';
import 'package:motivational/views/auth/forget_password_screen.dart';
import 'package:motivational/views/auth/otp_screen.dart';
import 'package:motivational/views/auth/privacy_and_policy_screen.dart';
import 'package:motivational/views/auth/reset_password_screen.dart';
import 'package:motivational/views/auth/signup_screen.dart';
import 'package:motivational/views/auth/terms_of_service.dart';
import 'package:motivational/views/home/favorite/favorite_sub_theme_notification_listing_screen.dart';
import 'package:motivational/views/home/setting/setting_screen.dart';
import 'package:motivational/views/onboarding/onboarding_screen.dart';
import 'package:motivational/views/payment/subscription_screen.dart';
import 'package:motivational/views/preference/select_notification_time_preference_screen.dart';
import 'package:motivational/views/preference/update_notification_time_preference_screen.dart';
import 'package:motivational/views/quotegroups/select_quote_groups_theme_screen.dart';
import 'package:motivational/views/settings/change_password_screen.dart';
import 'package:motivational/views/settings/feed_back_screen.dart';
import 'package:motivational/views/settings/report_screen.dart';
import 'package:motivational/views/theme/sub_theme_detail_screen.dart';
import 'package:motivational/views/theme/sub_theme_listing_notification_screen.dart';
import '../providers/subscription_provider.dart';
import '../views/payment/edit_payment_plan_screen.dart';
import '../views/splash_screen.dart';
import '/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '/views/home/home_screen.dart';
import '/views/auth/login_screen.dart';
import '/utils/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final navigatorKey = GlobalKey<NavigatorState>();
  static final gState = navigatorKey.currentState!;
  static final gCtx = navigatorKey.currentContext!;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => PaymentProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => NotificationTimePreferenceProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => AdminQuoteProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => FavoriteProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => AdminThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SubscriptionProvider(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Quick Jesus Reminder',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: 'Urbanist',
        ),
        home: const SplashScreen(),
        // home: const SubscriptionScreen(),
        routes: {
          Routes.onBoarding: (ctx) => const OnboardingScreen(),
          Routes.login: (ctx) => const LoginScreen(),
          Routes.signup: (ctx) => const SignupScreen(),
          Routes.forgetPassword: (ctx) => const ForgetPasswordScreen(),
          Routes.otp: (ctx) => const OtpScreen(),
          Routes.resetPassword: (ctx) => const ResetPasswordScreen(),
          Routes.privacyPolicy: (ctx) => const PrivacyAndPolicyScreen(),
          Routes.termsOfService: (ctx) => const TermsOfService(),
          Routes.home: (ctx) => const HomeScreen(),
          // Routes.paymentMethod: (ctx) => const PaymentMethodScreen(),
          // Routes.subscriptionIAP: (ctx) => const SubscriptionScreen(),
          Routes.subscription: (ctx) => const SubscriptionScreen(),
          Routes.selectQuoteGroupsTheme: (ctx) =>
              const SelectQuoteGroupsThemeScreen(),
          Routes.selectNotificationTimePref: (ctx) =>
              const SelectNotificationTimePreferenceScreen(),
          Routes.updateNotificationTimePref: (ctx) =>
              const UpdateNotificationTimePreferenceScreen(),
          Routes.subThemeListing: (ctx) =>
              const SubThemeNotificationListingScreen(),
          Routes.subThemeDetail: (ctx) => const SubThemeDetailScreen(),
          Routes.subThemefavorite: (ctx) =>
              const FavoriteSubThemeNotificationListingScreen(),
          Routes.settings: (ctx) => const SettingScreen(),
          Routes.editPaymentMehtod: (ctx) => const EditPaymentPlanScreen(),
          Routes.changePassword: (ctx) => const ChangePasswordScreen(),
          Routes.adminBaseScreen: (ctx) => const AdminBaseScreen(),
          Routes.adminThemeDetailScreen: (ctx) =>
              const AdminThemeDetailScreen(),
          Routes.adminHomeScreen: (ctx) => const AdminHomeScreen(),
          Routes.feedBackScreen: (ctx) => const FeedBackScreen(),
          Routes.reportScreen: (ctx) => const ReportScreen(),
        },
      ),
    );
  }
}
