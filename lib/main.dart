import 'package:flutter/material.dart';
import 'package:to_do/screens/login_screen.dart';
import 'package:to_do/screens/todo_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': ((context) => const Login()),
        '/home': (context) => const ToDoHomeScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
