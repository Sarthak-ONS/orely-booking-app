import 'dart:async';

import 'package:bookingapp/appp_colors.dart';
import 'package:flutter/material.dart';

class BookingConfirmationScreen extends StatefulWidget {
  const BookingConfirmationScreen({Key? key}) : super(key: key);

  @override
  State<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.primayColor,
              child: Icon(
                Icons.check,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            const Text(
              'Booking Confirmed!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            const Text(
              'We have sent you all the details of the booking on your registered email!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
            ),
            TextButton(
              onPressed: () {
                // Unn=lock Door For Gate
                print("Unlocking Door");
                // await FirebaseFirestoreApi().unlockDoor();
              },
              child: const Text('UNLOCK DOOR!'),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
