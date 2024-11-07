import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gappy/features/feed/views/home_screen.dart';
import 'package:gappy/features/profile/views/profile_screen.dart';
import 'package:gappy/features/shared/colors/colors.dart';

class Entry extends StatefulWidget {
  final int index;
  const Entry({Key? key, this.index = 0}) : super(key: key);

  @override
  State<Entry> createState() => _EntryState();
}

class _EntryState extends State<Entry> {
  late int _selectedIndex;
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index;
  }

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [HomePage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Disables the back button
      child: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          selectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
          unselectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
          elevation: 0,
          onTap: navigateBottomBar,
          unselectedItemColor: lightGreyColor,
          selectedItemColor: primaryColor,
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: whiteColor,
          items: [
            BottomNavigationBarItem(
                icon: Padding(
                    padding: EdgeInsets.only(bottom: 6, top: 10),
                    child: Icon(
                      Icons.feed_outlined,
                      color:
                          _selectedIndex == 0 ? primaryColor : lightGreyColor,
                    )),
                label: 'Feed'),
            BottomNavigationBarItem(
                icon: Padding(
                    padding: const EdgeInsets.only(bottom: 6, top: 10),
                    child: Icon(
                      Icons.feed_outlined,
                      color:
                          _selectedIndex == 1 ? primaryColor : lightGreyColor,
                    )),
                label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
