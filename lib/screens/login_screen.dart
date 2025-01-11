//ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:securenotes/constants/utils.dart';
import 'package:securenotes/controller/login_controller.dart';
import 'package:securenotes/screens/dashboard_screen.dart';
import 'package:securenotes/screens/recover_account_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginController loginController = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    loginController.emailController.clear();
    loginController.passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: kToolbarHeight,
            ),
            Center(
              child: Text(
                "SecureNotes",
                style: GoogleFonts.titanOne(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  // color: Color(0xff403B36),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
            ),
            Center(
              child: Text(
                "Secrets Inside.....",
                style: GoogleFonts.nunito(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  // color: Color(0xff403B36),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.015,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 13, right: 13),
                child: Text(
                  "Your notes are safe, sound, and waiting for you.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Color(0xff595550),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Image.asset(
              "images/lock.png",
              height: MediaQuery.of(context).size.height * 0.26,
            ),
            // Spacer(),
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffFFFDFA),
              ),
              child: TextField(
                controller: loginController.emailController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Email",
                  hintStyle: GoogleFonts.nunito(
                    color: Color(0xff595550),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffFFFDFA),
              ),
              child: TextField(
                controller: loginController.passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Password",
                  hintStyle: GoogleFonts.nunito(
                    color: Color(0xff595550),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Obx(
              () => GestureDetector(
                onTap: loginController.isLoading.value
                    ? null // Disable onTap when loading
                    : () async {
                        final ans = await loginController.login();
                        if (ans) {
                          Get.snackbar(
                            'Login Successful',
                            'You have successfully logged in',
                            backgroundColor: Colors.black,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                          Get.offAll(DashBoardScreen());
                        }
                      },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: loginController.isLoading.value
                        ? MyColor.kOrange
                            .withOpacity(0.7) // Dim the color when loading
                        : MyColor.kOrange,
                  ),
                  child: Center(
                    child: loginController.isLoading.value
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Login",
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ),
            // GestureDetector(
            //   onTap: () async {},
            //   child: Container(
            //     height: MediaQuery.of(context).size.height * 0.1,
            //     width: MediaQuery.of(context).size.width * 0.8,
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(10),
            //       color: MyColor.kOrange,
            //     ),
            //     child: Center(
            //       child: Text(
            //         "Login",
            //         style: GoogleFonts.nunito(
            //           fontWeight: FontWeight.bold,
            //           fontSize: 20,
            //           color: Colors.white,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Get.to(RecoverAccountScreen());
              },
              child: Center(
                child: Text(
                  "Lost your Device?",
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: MyColor.kOrange,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: kBottomNavigationBarHeight,
            ),
          ],
        ),
      ),
    );
  }
}
