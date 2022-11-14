import 'package:bookingapp/Services/firebase_auth_api.dart';
import 'package:flutter/material.dart';

import '../Widgets/custom_text_field.dart';
import '../appp_colors.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  TextEditingController? _nameController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _nameController = TextEditingController();

    _emailController!.text = "agarwalsarthak456@gmail.com";
    _passwordController!.text = "Sarthak@123";
    _nameController!.text = "Sarthak Agarwal";
  }

  @override
  void dispose() {
    _emailController!.dispose();
    _passwordController!.dispose();
    _nameController!.dispose();
    super.dispose();
  }

  bool showPassword = false;

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
                height: 25.0,
              ),
              const Text(
                'We are very excited to have you on board!',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              CustomTextFormField(
                emailController: _nameController,
                hintText: 'Name',
              ),
              const SizedBox(
                height: 10.0,
              ),
              CustomTextFormField(emailController: _emailController),
              const SizedBox(
                height: 10.0,
              ),
              CustomTextFormField(
                emailController: _passwordController,
                isPasswordField: showPassword,
                hintText: 'Password',
              ),
              const SizedBox(
                height: 10.0,
              ),
              CustomTextFormField(
                emailController: _passwordController,
                isPasswordField: showPassword,
                hintText: 'Confirm Password',
              ),
              const SizedBox(
                height: 10.0,
              ),
              ElevatedButton.icon(
                icon: Container(),
                style: ElevatedButton.styleFrom(
                  primary: AppColors.primayColor,
                  elevation: 10,
                  shadowColor: Colors.black54,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  print("Start Sign Up Proces");
                  FirebaseAuthApi().signUpWithEmailAndPassword(
                    context,
                    name: _nameController!.text,
                    email: _emailController!.text,
                    password: _passwordController!.text,
                  );
                },
                label: const Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
