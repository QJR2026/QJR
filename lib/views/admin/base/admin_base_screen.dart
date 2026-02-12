import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motivational/utils/icons.dart';
import 'package:motivational/views/admin/home/admin_home_screen.dart';
import 'package:motivational/views/admin/setting/admin_setting_screeen.dart';

class AdminBaseScreen extends StatefulWidget {
  const AdminBaseScreen({super.key});

  @override
  State<AdminBaseScreen> createState() => _AdminBaseScreenState();
}

class _AdminBaseScreenState extends State<AdminBaseScreen> {
  int _selectedIndex = 0;

  final List<Map<String, String>> _navIcons = [
    {
      "selected": IconAssets.bNHomeFillIcon,
      "unselected": IconAssets.bNHomeBorderIcon
    },
    {
      "selected": IconAssets.bNSettingFillIcon,
      "unselected": IconAssets.bNSettingBorderIcon
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      child: Scaffold(
        body: <Widget>[
          const AdminHomeScreen(),
          const AdminSettingScreen(),
        ][_selectedIndex],
        bottomNavigationBar: SafeArea(
          child: Container(
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
                showSelectedLabels: false,
                showUnselectedLabels: false,
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
