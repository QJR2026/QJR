import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motivational/app/my_app_view.dart';

import '../../services/shared_prefrence_service.dart';
import '../../utils/icons.dart';
import '../../utils/images.dart';
import '../../utils/my_colors.dart';
import '../../utils/routes.dart';
import 'widget/circle_text.dart';
import 'widget/onboarding_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();

  final ValueNotifier<int> _currentPageNotifier = ValueNotifier<int>(0);

  // final List<Map<String, dynamic>> onboardingData = [
  //   {
  //     "image": Images.onboarding1,
  //     "title": const [
  //       Text('Daily Basis ',
  //           style: TextStyle(
  //             fontSize: 30,
  //             fontWeight: FontWeight.w600,
  //           )),
  //       Row(
  //         children: [
  //           Text('Motivational',
  //               style: TextStyle(
  //                 fontSize: 30,
  //                 fontWeight: FontWeight.w600,
  //               )),
  //           CircleText(
  //               text: ' Quotes.',
  //               textStyling: TextStyle(
  //                 fontSize: 30,
  //                 fontWeight: FontWeight.w600,
  //               )),
  //         ],
  //       ),
  //     ],
  //     "subTitle":
  //         'Lorem ipsum dolor sit amet consectetur. Lectus aliquam nibh ornare massa elit ut fermentum. In neque gravida elit integer. Imperdiet sollicitudin.',
  //     "percent": 0.3,
  //   },
  //   {
  //     "image": Images.onboarding2,
  //     "title": const [
  //       Row(
  //         children: [
  //           Text(
  //             'Reminder',
  //             style: TextStyle(
  //               fontSize: 30,
  //               fontWeight: FontWeight.w600,
  //             ),
  //           ),
  //           CircleText(
  //               text: ' Popups',
  //               textStyling: TextStyle(
  //                 fontSize: 30,
  //                 fontWeight: FontWeight.w600,
  //               )),
  //         ],
  //       ),
  //       Text(
  //         'on Chosen Theme.',
  //         style: TextStyle(
  //           fontSize: 30,
  //           fontWeight: FontWeight.w600,
  //         ),
  //       ),
  //     ],
  //     "subTitle":
  //         'Lorem ipsum dolor sit amet consectetur. Lectus aliquam nibh ornare massa elit ut fermentum. In neque gravida elit integer. Imperdiet sollicitudin.',
  //     "percent": 0.6,
  //   },
  //   {
  //     "image": Images.onboarding3,
  //     "title": const [
  //       Row(
  //         children: [
  //           CircleText(
  //             text: ' Custom',
  //             textStyling: TextStyle(
  //               fontSize: 30,
  //               fontWeight: FontWeight.w600,
  //             ),
  //           ),
  //           Text(
  //             'izable',
  //             style: TextStyle(
  //               fontSize: 30,
  //               fontWeight: FontWeight.w600,
  //             ),
  //           ),
  //         ],
  //       ),
  //       Text(
  //         ' selection of time.',
  //         style: TextStyle(
  //           fontSize: 30,
  //           fontWeight: FontWeight.w600,
  //         ),
  //       ),
  //     ],
  //     "subTitle":
  //         'Lorem ipsum dolor sit amet consectetur. Lectus aliquam nibh ornare massa elit ut fermentum. In neque gravida elit integer. Imperdiet sollicitudin.',
  //     "percent": 1.0,
  //   },
  // ];

  final List<Map<String, dynamic>> onboardingData = [
    {
      "image": Images.onboarding1,
      "title": const [
        Text('Daily Basis ',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
            )),
        Row(
          children: [
            Text('Motivational',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                )),
            CircleText(
                text: ' Quotes.',
                textStyling: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                )),
          ],
        ),
      ],
      "subTitle":
          'Start your day inspired! Receive fresh, uplifting quotes every day to boost your motivation and positivity.', // Updated subTitle
      "percent": 0.3,
    },
    {
      "image": Images.onboarding2,
      "title": const [
        Row(
          children: [
            Text(
              'Reminder',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
            CircleText(
                text: ' Popups',
                textStyling: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                )),
          ],
        ),
        Text(
          'on Chosen Theme.',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
      "subTitle":
          'Never miss a beat! Get timely pop-up reminders tailored to your favorite motivational themes, keeping inspiration close.', // Updated subTitle
      "percent": 0.6,
    },
    {
      "image": Images.onboarding3,
      "title": const [
        Row(
          children: [
            CircleText(
              text: ' Custom',
              textStyling: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'izable',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Text(
          ' selection of time.',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
      "subTitle":
          'You\'re in control! Easily customize when you receive reminders, ensuring they fit perfectly into your daily schedule.', // Updated subTitle
      "percent": 1.0,
    },
  ];
  final SharedPreferencesService _sharedPreferences =
      SharedPreferencesService();
  late AnimationController animationController;
  late Animation<double> progressAnimation;

  @override
  void dispose() {
    _pageController.dispose();
    _currentPageNotifier.dispose();
    animationController.dispose();
    super.dispose();
  }

  void onPageChanged(int index) {
    _currentPageNotifier.value = index;
    animationController.animateTo((index + 1) / 3); // Smoothly update progress
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..value = 0.33;

    progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );

    debugPrint('Initial progress value: ${animationController.value}');
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                // physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                itemCount: onboardingData.length,
                onPageChanged: onPageChanged,
                itemBuilder: (context, index) {
                  return OnboardingWidget(
                    initialImage: onboardingData[index]['image'],
                    titleWidget: onboardingData[index]['title'],
                    subTitleText: onboardingData[index]['subTitle'],
                    percentValue: onboardingData[index]['percent'],
                  );
                },
              ),
            ),
            // const SizedBox(
            //   height: 20,
            // ),

            ValueListenableBuilder<int>(
                valueListenable: _currentPageNotifier,
                builder: (context, currentPage, child) {
                  return Row(
                    children: [
                      if (_currentPageNotifier.value != 2) ...[
                        const SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () async {
                            await SharedPreferencesService()
                                .setString("onboarding", "1");
                            MyApp.gState.pushNamedAndRemoveUntil(
                                Routes.login, (val) => false);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 6),
                            decoration: BoxDecoration(
                              color: MyColors.primaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Skip',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center, // Center text
                            ),
                          ),
                        ),
                      ],
                      Expanded(
                        flex: 5,
                        child: GestureDetector(
                          onTap: () async {
                            if (_currentPageNotifier.value ==
                                onboardingData.length - 1) {
                              await _sharedPreferences.setString(
                                  "onboarding", "1");
                              MyApp.gState.pushNamedAndRemoveUntil(
                                  Routes.login, (val) => false);
                            } else {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            }
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: const BoxDecoration(
                                  color: MyColors.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Image.asset(
                                    IconAssets.arrowForward,
                                    width: 32,
                                    height: 18,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 80,
                                height: 80,
                                child: AnimatedBuilder(
                                    animation: animationController,
                                    // tween: Tween<double>(
                                    //   begin: 0.0,
                                    //   end: (_currentPageNotifier.value + 1) / 3,
                                    // ),
                                    // duration:
                                    //     const Duration(milliseconds: 1000),
                                    builder: (context, child) {
                                      return CircularProgressIndicator(
                                        value: animationController.value,
                                        strokeWidth: 2,
                                        backgroundColor:
                                            const Color(0XFFE3F2FD),
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                          Color(0XFF034078),
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_currentPageNotifier.value != 2) const Spacer()
                    ],
                  );
                }),
            const SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
    );
  }
}
