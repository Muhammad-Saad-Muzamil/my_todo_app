import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_todo_app/firebase_options.dart';
import 'package:my_todo_app/screens/main_app_page.dart';
import 'package:my_todo_app/screens/login_page.dart';
import 'package:my_todo_app/screens/signUp_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your Todo App',
      initialRoute: '/signup', // You can set the initial route here
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/mainApp': (context) => MainAppScreen(),
      },
      home: StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasData) {
            print("User authenticated: ${snapshot.data?.email}");
            return MainAppScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
