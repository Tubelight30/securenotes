// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:securenotes/constants/utils.dart';
import 'package:securenotes/controller/signup_controller.dart';
import 'package:securenotes/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  SignUpController signUpController = Get.put(SignUpController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    signUpController.emailController.clear();
    signUpController.usernameController.clear();
    signUpController.passwordController.clear();
    signUpController.passphraseController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
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
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Center(
              child: Text(
                "Create a free account",
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
                  "Start protecting your thoughts with complete privacy, backed by advanced encryption.",
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
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffFFFDFA),
              ),
              child: TextField(
                controller: signUpController.emailController,
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
                controller: signUpController.usernameController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Username",
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
                controller: signUpController.passwordController,
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
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xffFFFDFA),
              ),
              child: TextField(
                controller: signUpController.passphraseController,
                obscureText: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Passphrase",
                  hintStyle: GoogleFonts.nunito(
                    color: Color(0xff595550),
                  ),
                ),
              ),
            ),
            // Spacer(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Obx(
              () => GestureDetector(
                onTap: signUpController.isLoading.value
                    ? null // Disable onTap when loading
                    : () async {
                        final ans = await signUpController.signup();
                        if (ans) {
                          Get.snackbar(
                            'Registration Successful',
                            'You have successfully registered',
                            backgroundColor: Colors.black,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                          Get.to(LoginScreen());
                        }
                      },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: signUpController.isLoading.value
                        ? MyColor.kOrange
                            .withOpacity(0.7) // Dim the color when loading
                        : MyColor.kOrange,
                  ),
                  child: Center(
                    child: signUpController.isLoading.value
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Create Account",
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
            )
          ],
        ),
      ),
    );
  }
}
