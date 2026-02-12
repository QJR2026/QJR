import 'package:flutter/material.dart';
import 'package:motivational/app/my_app_view.dart';
import '../../../model/notification_sub_theme.dart';
import '../../../providers/theme_provider.dart';
import '../../widgets/custom_loader_center.dart';
import '../../widgets/icon_wrapper_body.dart';
import '../../widgets/no_data_widget.dart';
import '/extensions/media_query_extension.dart';
import '/extensions/size_box_extension.dart';
import '/providers/favorite_provider.dart';
import '/utils/icons.dart';
import 'package:provider/provider.dart';

import '../../../utils/my_colors.dart';
import '../../../utils/routes.dart';

class FavoriteSubThemeNotificationListingScreen extends StatefulWidget {
  const FavoriteSubThemeNotificationListingScreen({super.key});

  @override
  State<FavoriteSubThemeNotificationListingScreen> createState() =>
      _FavoriteSubThemeNotificationListingScreenState();
}

class _FavoriteSubThemeNotificationListingScreenState
    extends State<FavoriteSubThemeNotificationListingScreen> {
  final List<Color> colors = [
    const Color(0XFFB5E48C).withOpacity(.5),
    // const Color(0XFF1A759F).withOpacity(.5),
    const Color(0XFFFFD60A).withOpacity(.5),
    const Color(0XFFFF6B35).withOpacity(.5),
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoriteProvider>().getFavoriteSubThemeNotifications();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FavoriteProvider>();
    return Scaffold(
      body: IconWrapperBody(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              90.vSpace(),
              // const CustomBackButton(),
              // 30.vSpace(),
              const FittedBox(
                child: Text(
                  'Favorite QJR’s',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500),
                ),
              ),
              // const Text(
              //   'Get notified with your favorite motivational quotes',
              //   style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
              // ),
              if (provider.getFavoriteSubThemesLoading)
                const Expanded(child: CustomLoaderCenter())
              else if (provider.notificationSubThemeFavoriteList.isEmpty)
                const Expanded(
                    child: NoDataWidget(
                  text: 'Favorite quote data not found.',
                ))
              else
                Expanded(
                  child: ListView.builder(
                    padding: const  EdgeInsets.symmetric(vertical: 20),
                    itemCount: provider.notificationSubThemeFavoriteList.length,
                    itemBuilder: (context, index) {
                      return FavoriteListingItem(
                        color: colors[index % colors.length],
                        index: index,
                        notificationSubTheme:
                            provider.notificationSubThemeFavoriteList[index],
                      );
                    },
                  ),
                ),
              //  10.vSpace(),
            ],
          ),
        ),
      ),
    );
  }
}

class FavoriteListingItem extends StatelessWidget {
  const FavoriteListingItem({
    super.key,
    required this.index,
    required this.color,
    required this.notificationSubTheme,
  });

  final Color color;
  final NotificationSubTheme notificationSubTheme;
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
              'index': index.toString(),
            },
            // arguments: notificationSubTheme.subtheme.id,
          );
        },
        child: Stack(
          children: [
            Positioned(
              right: index.isEven ? 16.pxH() : null,
              left: index.isEven ? null : 16.pxH(),
              top: 20.pxV(),
              child: Image.asset(
                IconAssets.bNFavoriteFillIcon,
                width: 20,
                height: 18,
              ),
            ),
            Hero(
              tag: index.toString(),
              child: Card(
                elevation: 8, // Controls the shadow depth
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                shadowColor: Colors.black.withOpacity(0.3),
                color: color,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  alignment: Alignment.center,
                  height: 150.pxV(),
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
          ],
        ),
      ),
    );
  }
}
