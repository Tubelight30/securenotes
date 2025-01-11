//ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:securenotes/constants/utils.dart';
import 'package:securenotes/controller/recover_account_controller.dart';
import 'package:securenotes/screens/dashboard_screen.dart';

class RecoverAccountScreen extends StatelessWidget {
  final RecoverAccountController controller =
      Get.put(RecoverAccountController());

  RecoverAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: kToolbarHeight),
            Center(
              child: Text(
                "Recover Account",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Image.asset(
              "images/phone_lock.png",
              height: MediaQuery.of(context).size.height * 0.26,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 13, right: 13),
                child: Text(
                  "Recover your account by entering your email, password, and passphrase",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            // Email TextField
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffFFFDFA),
              ),
              child: TextField(
                controller: controller.emailController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Email",
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
                controller: controller.passwordController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Password",
                ),
                obscureText: true,
              ),
            ),
            // Passphrase TextField
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffFFFDFA),
              ),
              child: TextField(
                controller: controller.passphraseController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Passphrase",
                ),
                obscureText: true,
              ),
            ),
            // Spacer(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.025,
            ),
            GestureDetector(
              onTap: () async {
                final success = await controller.recoverAccount();
                if (success) {
                  Get.offAll(DashBoardScreen());
                }
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: MyColor.kOrange,
                ),
                child: Center(
                  child: Text(
                    "Recover Account",
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: kBottomNavigationBarHeight),
          ],
        ),
      ),
    );
  }
}
