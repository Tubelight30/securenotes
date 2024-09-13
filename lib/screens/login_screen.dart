//ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:securenotes/controller/login_controller.dart';
import 'package:securenotes/screens/dashboard_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginController loginController = Get.put(LoginController());
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: loginController.emailController,
            decoration: InputDecoration(
              hintText: "Email",
            ),
          ),
          TextField(
            controller: loginController.passwordController,
            decoration: InputDecoration(
              hintText: "Password",
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final ans = await loginController.login();
              if (ans) {
                Get.snackbar(
                  'Login Successful',
                  'You have successfully logged in',
                  backgroundColor: Colors.black,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                );
                Get.to(DashBoardScreen());
              }
            },
            child: Text("Login"),
          ),
        ],
      ),
    );
  }
}
