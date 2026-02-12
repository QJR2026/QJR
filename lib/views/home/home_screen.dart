import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motivational/utils/icons.dart';
import 'package:motivational/views/home/favorite/favorite_sub_theme_notification_listing_screen.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';
import '../theme/sub_theme_listing_notification_screen.dart';
import 'setting/setting_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // List of icons for selected and unselected states
  final List<Map<String, String>> _navIcons = [
    {
      "selected": IconAssets.bNHomeFillIcon,
      "unselected": IconAssets.bNHomeBorderIcon
    },
    {
      "selected": IconAssets.bNFavoriteFillIcon,
      "unselected": IconAssets.bNFavoriteBorderIcon
    },
    {
      "selected": IconAssets.bNSettingFillIcon,
      "unselected": IconAssets.bNSettingBorderIcon
    },
  ];

  void _onItemTapped(int index) {
    if (context.read<ThemeProvider>().isLoggedIn()) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      child: Scaffold(
        body: const <Widget>[
          SubThemeNotificationListingScreen(),
          FavoriteSubThemeNotificationListingScreen(),
          SettingScreen(),
        ][_selectedIndex],
        bottomNavigationBar: SafeArea(
          child: Container(
            // height: kBottomNavigationBarHeight + 10,
            margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BottomNavigationBar(
                // enableFeedback: false,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                // iconSize: 25,
                items: List.generate(
                  _navIcons.length,
                  (index) => BottomNavigationBarItem(
                    icon: Image.asset(
                      _selectedIndex == index
                          ? _navIcons[index]["selected"]!
                          : _navIcons[index]["unselected"]!,
                      width: 25,
                      height: 25,
                    ),
                    label: '',
                  ),
                ),
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.blue,
                onTap: _onItemTapped,
              ),
            ),
          ),
        ),
      
      ),
    );
  }
}
