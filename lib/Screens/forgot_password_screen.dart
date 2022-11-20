import 'package:bookingapp/Widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

import '../Services/firebase_auth_api.dart';
import '../appp_colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController? _emailController;

  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          'Forgot Password',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Please let us know your Email',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 30,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'We will send you a email, you can click on the link sent to your email and change the password.',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            CustomTextFormField(emailController: _emailController),
            const SizedBox(
              height: 40,
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
                if (_emailController!.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text(
                        'Please enter a email',
                      ),
                    ),
                  );
                  return;
                }
                print('Start Login with email and password');
                await FirebaseAuthApi()
                    .forgotPassword(context, email: _emailController!.text);
                print("Completed Signing in with Email and Password");
              },
              label: const Text(
                'Confirm and send Email',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
