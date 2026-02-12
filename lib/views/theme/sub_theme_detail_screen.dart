import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:motivational/providers/favorite_provider.dart';
import 'package:motivational/utils/images.dart';
import 'package:share_plus/share_plus.dart';
import '../../providers/theme_provider.dart';
import '/extensions/media_query_extension.dart';
import '/extensions/size_box_extension.dart';
import '/utils/icons.dart';
import '/utils/my_colors.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;
import '../widgets/custom_back_button.dart';

class SubThemeDetailScreen extends StatefulWidget {
  const SubThemeDetailScreen({super.key});

  @override
  State<SubThemeDetailScreen> createState() => _SubThemeDetailScreenState();
}

class _SubThemeDetailScreenState extends State<SubThemeDetailScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // final Map<String, dynamic> newArgs =
      //     (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>);
      // context
      //     .read<ThemeProvider>()
      //     .setNotificationSubThemeDetail(newArgs['item'] as SubTheme);
    });
    super.initState();
  }

  Color? color;

  markAsFavoriteOrUnFavoriteSubTheme(int subThemeId) async {
    final provider = context.read<FavoriteProvider>();

    await provider.markAsFavoriteOrUnFavoriteSubTheme(subThemeId);
  }

  GlobalKey globalKey = GlobalKey();
  Future<void> captureAndShare() async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);

    // Create a recorder to manually draw on a canvas
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas canvas = Canvas(recorder);

    // Draw a solid background before painting the widget
    Paint paint = Paint()..color = Colors.white;
    canvas.drawRect(
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
        paint);

    // Draw the captured widget image
    canvas.drawImage(image, Offset.zero, Paint());

    // Convert to final image
    ui.Image finalImage =
        await recorder.endRecording().toImage(image.width, image.height);
    ByteData? byteData =
        await finalImage.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    // Share the image directly without saving
    await Share.shareXFiles([XFile.fromData(pngBytes, mimeType: 'image/png')],
        text: "Check this out!");
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>);
    color = args["color"] as Color;

    final provider = context.watch<ThemeProvider>();
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  90.vSpace(),
                  const CustomBackButton(),
                  30.vSpace(),
                  const FittedBox(
                    child: Text(
                      'Your QJR\'s',
                      style:
                          TextStyle(fontSize: 36, fontWeight: FontWeight.w500),
                    ),
                  ),
                  // const Text(
                  //   'Please select a group from given list in which you can receive notifications of motivational quotes.',
                  //   style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  // ),
                  30.vSpace(),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      RepaintBoundary(
                        key: globalKey,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Hero(
                              tag: args["index"],
                              child: Material(
                                child: Container(
                                  // width: double.infinity,
                                  height: 480.pxV(), // your fixed height
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ).copyWith(top: 30, bottom: 24),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: color ??
                                        const Color(0XFFB5E48C).withOpacity(.5),
                                  ),
                                  child: FittedBox(
                                    // fit: BoxFit
                                    //     .scaleDown, // this makes it shrink
                                    alignment: Alignment.center,
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                          maxWidth:
                                              500.pxH()), // optional max width
                                      child: Text(
                                        (provider.notificationSubThemeDetail
                                                ?.description
                                                .trim() ??
                                            ''),
                                        style: const TextStyle(
                                          fontSize:
                                              26, // FittedBox will scale this down as needed
                                          fontWeight: FontWeight.w600,
                                          color: MyColors.colorE1E1,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              left: 20,
                              child: Image.asset(
                                Images.icon,
                                // color: Colors.blue,
                                color: const Color(0XFF041020),
                                width: 40,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: const EdgeInsets.only(top: 20),
                            width: 110,
                            height: 7,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.5),
                                borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 10,
                        bottom: -20,
                        child: Row(
                          children: [
                            iconCustomButton(
                              asset: (provider.notificationSubThemeDetail
                                          ?.isLiked ??
                                      false)
                                  ? IconAssets.bNFavoriteFillIcon
                                  : IconAssets.favoriteBorder,
                              onTap: () => {
                                if (provider.isLoggedIn())
                                  {
                                    markAsFavoriteOrUnFavoriteSubTheme(provider
                                            .notificationSubThemeDetail?.id ??
                                        0)
                                  }
                              },
                            ),
                            4.hSpace(),
                            iconCustomButton(
                                asset: IconAssets.share,
                                iconWidth: 24,
                                iconHeight: 26,
                                onTap: () {
                                  if (provider.isLoggedIn()) {
                                    captureAndShare();
                                  }
                                }),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          // Consumer<FavoriteProvider>(
          //   builder: (context, value, child) {
          //     return value.markAsFavoriteLoading
          //         ? const Align(child: CircularProgressIndicator())
          //         : const SizedBox();
          //   },
          // )
        ],
      ),
    );
  }

  Widget iconCustomButton(
      {required String asset,
      double iconWidth = 20,
      double iconHeight = 18,
      void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 45.pxH(),
        height: 45.pxV(),
        decoration:
            const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        padding: const EdgeInsets.all(5),
        child: Container(
          alignment: Alignment.centerRight,
          decoration: const BoxDecoration(
            color: MyColors.yellowColor,
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            asset,
            width: iconWidth.pxH(),
            height: iconHeight.pxV(),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
