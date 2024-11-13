import 'package:flutter/material.dart';
import 'package:my_todo_app/screens/main_app_page.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      title: 'Your Todo App',
      initialRoute: '/mainApp', // You can set the initial route here
      routes: {
  
        '/mainApp': (context) => MainAppScreen(),
      },
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Placeholder for determining initial screen logic if needed
    return MainAppScreen();
  }
}
