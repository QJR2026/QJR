import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:motivational/app/my_app_view.dart';
import 'package:motivational/model/user_data.dart';
import 'package:motivational/utils/routes.dart';
import 'package:provider/provider.dart';

import '../providers/subscription_provider.dart';
import '../providers/user_provider.dart';
import '../services/api_service.dart';
import '../services/shared_prefrence_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _sharedPreferences = SharedPreferencesService();

  final _noInternet = ValueNotifier<bool>(false);
  final _retrying = ValueNotifier<bool>(false);
  StreamSubscription? _connectivitySubscription;

  UserProvider? _userProvider;
  SubscriptionProvider? _subscriptionProvider;

  @override
  void initState() {
    super.initState();
    _initializeSubscriptionProvider();
    _navigateToHome();
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    _noInternet.dispose();
    _retrying.dispose();
    super.dispose();
  }

  void _initializeSubscriptionProvider() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubscriptionProvider>().initialize();
    });
  }

  void _restoreSession() {
    final token = _sharedPreferences.getString('token');
    final data = _sharedPreferences.getString('data');
    if (token != null) ApiService.authToken = token;
    if (data != null) {
      ApiService.userData = UserData.fromJson(jsonDecode(data));
    }
  }

  void _navigateToHome() {
    _restoreSession();

    final isOnBoarded = _sharedPreferences.getString('onboarding') != null;
    final isLoggedIn = _sharedPreferences.getString('token') != null;

    if (isLoggedIn) {
      _userProvider = MyApp.gCtx.read<UserProvider>();
      _subscriptionProvider = MyApp.gCtx.read<SubscriptionProvider>();
    }

    Future.delayed(const Duration(milliseconds: 2000), () async {
      if (!mounted) return;
      if (!isOnBoarded) {
        MyApp.gState.pushNamedAndRemoveUntil(Routes.onBoarding, (_) => false);
      } else if (isLoggedIn) {
        await _performLoggedInNavigation();
      } else {
        MyApp.gState.pushNamedAndRemoveUntil(Routes.login, (_) => false);
      }
    });
  }

  Future<void> _performLoggedInNavigation() async {
    try {
      await _userProvider!.getUserDetail();
      if (!mounted) return;
      await _subscriptionProvider!.checkSubscriptionOnServerAndNavigate();
    } catch (_) {
      if (!mounted) return;
      _noInternet.value = true;
      _listenForConnectivity();
    }
  }

  void _listenForConnectivity() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((results) {
      final isConnected = results.any((r) => r != ConnectivityResult.none);
      if (isConnected && _noInternet.value && mounted) {
        _retry();
      }
    });
  }

  Future<void> _retry() async {
    if (_retrying.value) return;
    _connectivitySubscription?.cancel();
    _noInternet.value = false;
    _retrying.value = true;
    await _performLoggedInNavigation();
    if (mounted) _retrying.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<bool>(
        valueListenable: _noInternet,
        builder: (context, noInternet, _) => ValueListenableBuilder<bool>(
          valueListenable: _retrying,
          builder: (context, retrying, _) => Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/splash_screen.png',
                fit: BoxFit.cover,
              ),
              if (noInternet) _NoInternetOverlay(onRetry: _retry),
              if (retrying)
                const ColoredBox(
                  color: Colors.black38,
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoInternetOverlay extends StatelessWidget {
  final VoidCallback onRetry;
  const _NoInternetOverlay({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black54,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_rounded, color: Colors.white, size: 52),
              const SizedBox(height: 16),
              const Text(
                'No Internet Connection',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "We'll retry automatically when connection is restored.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Retry Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
