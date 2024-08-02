import 'package:flutter/material.dart';
import 'authform.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLoginPage = true; // Assuming login page is the initial page

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        title: Center(
          child: Text(
            isLoginPage ? 'SignUp' : 'Login',
            style: const TextStyle(color: Colors.white, fontSize: 24,fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AuthForm(),
      ),
    );
  }
}
