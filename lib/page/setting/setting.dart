import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readbook/provider.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  String? selectedLanguage;
  final List<String> language = ['English','Vietnam','Thailand'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Cài đặt"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Consumer<UiProvider>(
          builder: (context, UiProvider notifier, child) {
            return  Column(
              children: [
                Consumer<UiProvider>(
                  builder: (context, UiProvider notifier, child) {
                    return  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.dark_mode),
                          title: const Text("Dark Mode"),
                          trailing: Switch(
                            value: notifier.isDark,
                            onChanged: (value) => notifier.changeTheme(),
                          ),
                        ),
                        const Divider(color: Color(0xffededed)),
                        ListTile(
                          leading: Icon(Icons.language),
                          title: Text("Ngôn ngữ"),
                          trailing: DropdownButton<String>(
                            value:selectedLanguage,
                            icon: const Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            underline: Container(
                              height: 2,
                              color: Colors.grey[300],
                            ),
                            onChanged: (String? newValue){
                              setState(() {
                                selectedLanguage = newValue!;
                              });
                            },
                            items: language.map<DropdownMenuItem<String>>((String value){
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
