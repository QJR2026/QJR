import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:motivational/app/my_app_view.dart';
import 'package:motivational/model/user_data.dart';
import 'package:motivational/utils/routes.dart';
import 'package:provider/provider.dart';

import '../providers/subscription_provider.dart';
import '../services/api_service.dart';
import '../services/shared_prefrence_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // @override
  // void initState() {
  //   Future.delayed(const Duration(seconds: 3)).then((val) {
  //     MyApp.gState.pushNamed(Routes.onBoarding);
  //     // MyApp.gState.pushNamed(Routes.selectNotificationTimePref);
  //   });
  //   super.initState();
  // }

  final SharedPreferencesService _sharedPreferences =
      SharedPreferencesService();

  @override
  void initState() {
    super.initState();
    _navigateToHome();
    _initializeSubscriptionProvider();
  }

  _initializeSubscriptionProvider() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubscriptionProvider>().initialize();
    });
  }

  void _navigateToHome() {
    bool isOnBoarded = _sharedPreferences.getString('onboarding') != null;
    bool isLoggedIn = _sharedPreferences.getString('token') != null;
    bool hasUserData = _sharedPreferences.getString('data') != null;

    if (isLoggedIn) {
      ApiService.authToken = _sharedPreferences.getString('token');
    }

    if (hasUserData) {
      ApiService.userData = UserData.fromJson(
        jsonDecode(_sharedPreferences.getString('data') ?? ''),
      );
    }

    Future.delayed(const Duration(milliseconds: 2000), () {
      String routeName;

      if (!isOnBoarded) {
        routeName = Routes.onBoarding;
      } else if (isLoggedIn) {
        MyApp.gCtx
            .read<SubscriptionProvider>()
            .checkSubscriptionOnServerAndNavigate();
        return;
        // routeName = ApiService.userData!.userType == "1"
        //     ? Routes.adminBaseScreen
        //     : Routes.home;
      } else {
        routeName = Routes.login;
      }

      MyApp.gState.pushNamedAndRemoveUntil(routeName, (route) => false);
    });
  }

  // _navigateToHome() async {
  //   bool isOnBoarded = _sharedPreferences.containsKey('onboarding');
  //   bool isLoggedIn = _sharedPreferences.containsKey('token');
  //   bool data = _sharedPreferences.containsKey('data');
  //   if (isLoggedIn) {
  //     ApiService.authToken = _sharedPreferences.getString('token');
  //   }
  //   if (data) {
  //     ApiService.userData = UserData.fromJson(
  //         jsonDecode(_sharedPreferences.getString('data') ?? ''));
  //   }
  //   Future.delayed(const Duration(milliseconds: 2000), () {
  //     String routeName = '';
  //     if (isOnBoarded) {
  //       routeName = Routes.onBoarding;
  //     } else if (isLoggedIn) {
  //       routeName = Routes.home;
  //     } else if (!isLoggedIn) {
  //       routeName = Routes.login;
  //     }

  //     MyApp.gState.pushNamedAndRemoveUntil(
  //       routeName,
  //       (val) => false,
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset(
        'assets/images/splash_screen.png',
        width: double.infinity,
        height: MediaQuery.sizeOf(context).height,
        fit: BoxFit.cover,
      ),
    );
  }
}
