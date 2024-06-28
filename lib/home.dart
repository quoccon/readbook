import 'package:flutter/material.dart';
import 'package:readbook/page/collection.page.dart';
import 'package:readbook/page/explore.page.dart';
import 'package:readbook/page/home/home.page.dart';

import 'model/user.dart';

class HomeScreen extends StatefulWidget {
  final Auth auth;
  const HomeScreen({super.key, required this.auth});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int myIndex = 0;


  @override
  Widget build(BuildContext context) {
    List<Widget> page = [
      Home(auth: widget.auth),
      Search(auth: widget.auth),
      CollectiobPage()
    ];
    return Scaffold(
      body: IndexedStack(
        children: page,
        index: myIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
        },
        currentIndex: myIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled),
          label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search),
              label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark),
              label: 'My Collection'),
        ],
      ),
    );
  }
}