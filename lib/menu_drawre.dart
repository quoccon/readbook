import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readbook/page/setting/setting.dart';
import 'package:readbook/provider.dart';

import 'model/user.dart';

class MenuDrawre extends StatefulWidget {
  final Auth auth;
  const MenuDrawre({super.key, required this.auth});

  @override
  State<MenuDrawre> createState() => _MenuDrawreState();
}

class _MenuDrawreState extends State<MenuDrawre> {
  bool isDark = false;

  void getTheme() async {
    final savedThemeMode = await AdaptiveTheme.getThemeMode();
    if (savedThemeMode == AdaptiveThemeMode.dark) {
      setState(() {
        isDark = true;
      });
    } else {
      setState(() {
        isDark = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
        children: [
          const SizedBox(height: 50),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.network(
                    "https://media.istockphoto.com/id/1332100919/vector/man-icon-black-icon-person-symbol.jpg?s=612x612&w=0&k=20&c=AVVJkvxQQCuBhawHrUhDRTCeNQ3Jgt0K1tXjJsFy1eg=",
                    width: 80,
                    height: 80,
                  )),
              const SizedBox(
                height: 8.0,
              ),
              Text(
                widget.auth.user?.username??"",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const Divider(color: Colors.grey),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                title: const Text('Thông tin tài khoản'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const Divider(color: Colors.grey),
              ListTile(
                 title: Text("Cài đặt"),
                onTap: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context) => const Setting()));
                },
               ),
              Divider(color: Colors.grey[500]),
              ListTile(
                title: const Text('Ngôn ngữ'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const Divider(color: Colors.grey),
            ],
          )
        ],
      ),
    );
  }
}
