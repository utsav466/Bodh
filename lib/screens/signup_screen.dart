import 'package:bodh_flutter/screens/login_screen.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
const SignUpScreen({super.key});

@override
Widget build(BuildContext context) {
final TextEditingController nameController = TextEditingController();
final TextEditingController phoneController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController passController = TextEditingController();
final TextEditingController confirmPassController = TextEditingController();


return Scaffold(
  backgroundColor: Colors.white,
  body: Stack(
    children: [
      Container(
        height: 270,
        decoration: const BoxDecoration(
          color: Color(0xFF5C8CF6),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
          ),
        ),
      ),
      SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                "Create an account",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 25),
                      _inputField("Full Name", nameController),
                      const SizedBox(height: 15),
                      _inputField("Phone", phoneController),
                      const SizedBox(height: 15),
                      _inputField("Email", emailController),
                      const SizedBox(height: 15),
                      _inputField("Password", passController, obscure: true),
                      const SizedBox(height: 15),
                      _inputField("Confirm Password", confirmPassController, obscure: true),
                      const SizedBox(height: 30),
                      Container(
                        width: double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                          color: const Color(0xFF5C8CF6),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Center(
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account?",
                            style: TextStyle(fontSize: 15),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()), // replace with your login page
                              );
                            },
                            child: const Text(
                              " Login",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ],
  ),
);


}

Widget _inputField(String hint, TextEditingController controller, {bool obscure = false}) {
return TextField(
controller: controller,
obscureText: obscure,
decoration: InputDecoration(
hintText: hint,
filled: true,
fillColor: Colors.white,
contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
enabledBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(35),
borderSide: const BorderSide(color: Colors.lightBlueAccent),
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(35),
borderSide: const BorderSide(color: Colors.blue),
),
),
);
}
}
