import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:securenotes/constants/utils.dart';
import 'package:securenotes/screens/login_screen.dart';
import 'package:securenotes/screens/register_screen.dart';

class OnBoardScreen extends StatelessWidget {
  const OnBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.kScaffoldBackground,
      body: Column(
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
              ),
            ),
          ),
          Spacer(),
          Image.asset(
            "images/intor.png",
            height: MediaQuery.of(context).size.height * 0.26,
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 13, right: 13),
              child: Text(
                "Welcome to SecureNotes, your secure and private note-taking app",
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              Get.to(RegisterScreen());
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
                  "GET STARTED",
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              Get.to(LoginScreen());
            },
            child: Center(
              child: Text(
                "Already have an account?",
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
    );
  }
}
