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
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: Image.asset(
                      'Assets/Images/google.png',
                      height: 40,
                    ),
                    style: ButtonStyle(
                      // padding: MaterialStateProperty.all(
                      //   const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                      // ),
                      backgroundColor: MaterialStateProperty.all(
                        Colors.white,
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                    label: const Text(
                      'Login with Google',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Align(
              //     alignment: Alignment.bottomCenter,
              //     child: ElevatedButton.icon(
              //       icon: Image.asset(
              //         'Assets/Images/google.png',
              //         height: 40,
              //       ),
              //       onPressed: () {},
              //       label: const Text(
              //         'Login with Google',
              //         style: TextStyle(
              //           color: Colors.black,
              //           fontWeight: FontWeight.w400,
              //           fontSize: 15,
              //         ),
              //       ),
              //       style: ButtonStyle(
              //         padding: MaterialStateProperty.all(
              //           const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
              //         ),
              //         backgroundColor: MaterialStateProperty.all(
              //           Colors.white,
              //         ),
              //         shape: MaterialStateProperty.all(
              //           RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(15.0),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
