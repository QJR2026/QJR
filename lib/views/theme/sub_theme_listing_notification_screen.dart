import 'package:flutter/material.dart';
import 'package:motivational/extensions/media_query_extension.dart';
import 'package:motivational/extensions/size_box_extension.dart';
import 'package:motivational/app/my_app_view.dart';
import 'package:motivational/model/notification_sub_theme.dart';

import 'package:motivational/utils/my_colors.dart';
import 'package:motivational/utils/routes.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';
import '../widgets/custom_loader_center.dart';
import '../widgets/icon_wrapper_body.dart';
import '../widgets/no_data_widget.dart';

class SubThemeNotificationListingScreen extends StatefulWidget {
  const SubThemeNotificationListingScreen({super.key});

  @override
  State<SubThemeNotificationListingScreen> createState() =>
      _SubThemeNotificationListingScreenState();
}

class _SubThemeNotificationListingScreenState
    extends State<SubThemeNotificationListingScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ThemeProvider>().getAllSubThemeNotifications();
    });
    super.initState();
  }

  final List<Color> colors = [
    const Color(0XFFB5E48C).withOpacity(.5),
    const Color(0XFF1A759F).withOpacity(.5),
    const Color(0XFFFF6B35).withOpacity(.5),
    const Color(0XFFFFD60A).withOpacity(.5),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ThemeProvider>();
    // final QuoteTheme? selectedTheme = ApiService.userData?.quotetheme;
    return Scaffold(
      body: IconWrapperBody(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              90.vSpace(),
              // Container(
              //   // height: 120.pxV(),
              //   width: 100.percentWidth(),
              //   decoration: const BoxDecoration(
              //       image: DecorationImage(
              //           image: AssetImage(
              //             Images.quoteGroupSilver,
              //           ),
              //           fit: BoxFit.fill)),
              //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text(
              //             selectedTheme?.name ?? 'Motivation',
              //             style: const TextStyle(
              //               fontSize: 26,
              //               color: MyColors.blackTypeColor,
              //               fontWeight: FontWeight.bold,
              //             ),
              //             maxLines: 1,
              //             overflow: TextOverflow.ellipsis,
              //           ),
              //           Align(
              //               alignment: Alignment.bottomCenter,
              //               child: Image.asset(
              //                 IconAssets.bell,
              //                 width: 23,
              //                 height: 26,
              //                 fit: BoxFit.fill,
              //               ))
              //         ],
              //       ),
              //       Text(
              //         selectedTheme?.description ??
              //             'Daily motivational quotes to inspire and uplift',
              //         style: const TextStyle(
              //           fontSize: 13,
              //           color: MyColors.colorE1E1,
              //           fontWeight: FontWeight.w400,
              //         ),
              //         maxLines: 2,
              //         overflow: TextOverflow.ellipsis,
              //       ),
              //     ],
              //   ),
              // ),

              const FittedBox(
                child: Text(
                  'Your QJR’s',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500),
                ),
              ),

              if (provider.getSubThemesLoading)
                const Expanded(child: CustomLoaderCenter())
              else if (provider.notificationSubThemeList.isEmpty)
                const Expanded(
                  child: NoDataWidget(
                    text: 'Theme quotes data not found.',
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    itemCount: provider.notificationSubThemeList.length,
                    itemBuilder: (context, index) {
                      return SubThemeNotificationListingItem(
                        color: colors[index % colors.length],
                        index: index,
                        notificationSubTheme:
                            provider.notificationSubThemeList[index],
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class SubThemeNotificationListingItem extends StatelessWidget {
  const SubThemeNotificationListingItem({
    super.key,
    required this.index,
    required this.color,
    required this.notificationSubTheme,
  });

  final NotificationSubTheme notificationSubTheme;
  final Color color;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: index.isEven ? 6.34 : 18.8,
      child: GestureDetector(
        onTap: () {
          context
              .read<ThemeProvider>()
              .setNotificationSubThemeDetail(notificationSubTheme.subtheme);
          MyApp.gState.pushNamed(
            Routes.subThemeDetail,
            arguments: {
              "item": notificationSubTheme.subtheme,
              "color": color,
              'index': index.toString()
            },
          );
        },
        child: Hero(
          tag: index.toString(),
          child: Card(
            elevation: 8, // Adds a subtle shadow
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            shadowColor: Colors.black.withOpacity(0.3),
            color: color,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              alignment: Alignment.center,
              height: 140.pxV(),
              width: double.infinity,
              child: Text(
                notificationSubTheme.subtheme.subDesctiption(length: 50),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: MyColors.colorE1E1,
                  fontSize: 17.pxH(),
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
