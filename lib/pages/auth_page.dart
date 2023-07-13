import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ten_2023/pages/router_page.dart';
import 'login_screen.dart';

class AuthPage extends StatelessWidget {
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: firebaseAuth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //return HomePage();
            return RouterPage();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
