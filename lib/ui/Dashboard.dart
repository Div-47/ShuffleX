import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'Home.dart';
import 'Library.dart';
import 'Search.dart';
import 'Settings.dart';

class Dashboard extends StatefulWidget {
  Dashboard();

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
   //   appBar: _appbar(),
      bottomNavigationBar: _bottomNavigationBar(),
      body: IndexedStack(
        index: selectedTab,
        children: [
          
          Home(),
          Search(),
          Library(),
          Settings()
        ],
      ),
    );
  }

  Widget _appbar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
   
    );
  }

  Widget _bottomNavigationBar() {
    List icons = [
      AntDesign.home,
      AntDesign.search1,
      MaterialIcons.library_music,
      Zocial.xing
    ];
    return Container(
      
      height: 55,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 11, right: 11),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(4, (index) {
              return IconButton(
                  icon: Icon(icons[index]),
                  splashColor: Colors.teal,
                  splashRadius: 25,
                  color: selectedTab == index ? Colors.teal : Colors.white,
                  onPressed: () {
                    setState(() {
                      selectedTab = index;
                    });
                  });
            })),
      ),
    );
  }
}
