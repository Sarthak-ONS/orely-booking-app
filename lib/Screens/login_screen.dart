import 'package:bookingapp/appp_colors.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    precacheImage(const AssetImage('Assets/Images/Wallpaper.jpg'), context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'Assets/Images/Wallpaper.jpg',
          ),
          fit: BoxFit.cover,
          filterQuality: FilterQuality.medium,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Let\'s make your booking easy',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  //fontFamily: 'Logo',
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Divider(
                color: Colors.white.withOpacity(0.95),
                thickness: 3,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                icon: Container(),
                style: ElevatedButton.styleFrom(
                  primary: AppColors.primayColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () {},
                label: const Text(
                  'Get Started',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 15.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
