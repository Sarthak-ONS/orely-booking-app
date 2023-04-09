import 'package:bookingapp/Services/firebase_auth_api.dart';
import 'package:flutter/material.dart';

import '../Widgets/custom_text_field.dart';
import '../appp_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController? _emailController;
  TextEditingController? _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController!.dispose();
    _passwordController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Orely',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 50,
                  fontFamily: 'Logo',
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              CustomTextFormField(emailController: _emailController),
              const SizedBox(
                height: 10.0,
              ),
              CustomTextFormField(
                emailController: _passwordController,
                isPasswordField: true,
                hintText: 'Password',
              ),
              const SizedBox(
                height: 10.0,
              ),
              GestureDetector(
                onTap: () async {
                  print("Start custom Password Forgot Function");
                  Navigator.pushNamed(context, '/forgotPassword');
                },
                child: const Text(
                  'Forgot Password?',
                  textAlign: TextAlign.end,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              ElevatedButton.icon(
                icon: Container(),
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.black54,
                  elevation: 10,
                  primary: AppColors.primayColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                onPressed: () async {
                  print('Start Login with email and password');
                  await FirebaseAuthApi().loginWithEmailandPassword(
                    context,
                    email: _emailController!.text,
                    password: _passwordController!.text,
                  );
                  print("Completed Signing in with Email and Password");
                },
                label: const Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              ElevatedButton.icon(
                icon: Image.asset(
                  'Assets/Images/google.png',
                  height: 30,
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shadowColor: Colors.black54,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: const BorderSide(
                      color: AppColors.primayColor,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                onPressed: () {
                  print('Start Logging in with Google');
                  FirebaseAuthApi().signUpWithGoogle(context);
                },
                label: const Text(
                  'Login with Google',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              TextButton(
                child: const Material(
                  elevation: 10,
                  shadowColor: Colors.black54,
                  child: Text(
                    'Dont have a account? Sign up!',
                    style: TextStyle(
                      color: Colors.black,
                      backgroundColor: Colors.transparent,
                      foreground: null,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
