import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_info/Controller/Provider/connectivity_provider.dart';
import 'package:weather_info/Controller/Provider/search_provider.dart';
import 'package:weather_info/View/splash_screen.dart';

import 'Controller/Provider/theme_provider.dart';
import 'View/home_page.dart';

late SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider()..getTheme(),
        ),
        ChangeNotifierProvider(
          create: (context) => SearchProvider(),
        ),
        ChangeNotifierProvider(create: (context) => ConnectivityProvider())
      ],
      child: Consumer<ThemeProvider>(
        builder: (BuildContext context, ThemeProvider value, Widget? child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: value.thememode,
            home: const Splash_screen(),
          );
        },
      ),
    );
  }
}
