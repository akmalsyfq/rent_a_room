import 'package:flutter/material.dart';
import 'package:rent_a_room/splashpage.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.yellow,
        ),
        title: 'Rent A Room',
        home: const Scaffold(
          body: SplashPage(),
        ));
  }
}
