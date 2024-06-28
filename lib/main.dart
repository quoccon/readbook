import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:readbook/page/auth/login.page.dart';
import 'package:readbook/provider.dart';
import 'package:readbook/blocs/book/socket_service.dart';

import 'blocs/book/socket_service.dart';  // Import SocketService

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const OverlaySupport.global(child: MyApp()));

}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.savedThemeMode});

  final AdaptiveThemeMode? savedThemeMode;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UiProvider()..init()),
        ChangeNotifierProvider(create: (_) => SocketService()..initialize(),
        lazy: false,),  // Provide SocketService
      ],
      child: Consumer<UiProvider>(
        builder:(context, UiProvider notifier, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: notifier.isDark ? ThemeMode.dark : ThemeMode.light,
            darkTheme: notifier.isDark? notifier.themeDark : notifier.themeLight,
            theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true
            ),
            home: const Login(),
          );
        },
      ),
    );
  }
}
