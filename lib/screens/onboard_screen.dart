import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:securenotes/screens/login_screen.dart';
import 'package:securenotes/screens/register_screen.dart';

class OnBoardScreen extends StatelessWidget {
  const OnBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Get.to(LoginScreen());
              },
              child: Text("Login"),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Get.to(RegisterScreen());
              },
              child: Text("Signup"),
            ),
          ),
        ],
      ),
    );
  }
}
