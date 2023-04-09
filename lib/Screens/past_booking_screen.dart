import 'package:bookingapp/appp_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PastBookingScreen extends StatefulWidget {
  const PastBookingScreen({Key? key}) : super(key: key);

  @override
  State<PastBookingScreen> createState() => _PastBookingScreenState();
}

class _PastBookingScreenState extends State<PastBookingScreen> {
  DateTime convertToFornattedDateTime(String formattedDateTime) {
    int year = int.parse(formattedDateTime.substring(
        formattedDateTime.length - 4, formattedDateTime.length));
    formattedDateTime = formattedDateTime.replaceRange(
        formattedDateTime.length - 4, formattedDateTime.length, "");
    int month =
        int.parse(formattedDateTime.substring(formattedDateTime.length - 1));
    formattedDateTime = formattedDateTime.replaceRange(
        formattedDateTime.length - 1, formattedDateTime.length, "");
    int day = int.parse(formattedDateTime);
    DateTime fd = DateTime(year, month, day);
    return fd;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Past Bookings'),
        elevation: 0,
        backgroundColor: AppColors.primayColor,
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data == null || snapshot.hasError) {
            return const Center(
              child: Text("Please try again later"),
            );
          }
          List allBookings = snapshot.data!.get('bookings');

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: allBookings.length,
            itemBuilder: (context, index) {
              if (convertToFornattedDateTime(
                          allBookings[index]['formatted_date'])
                      .compareTo(DateTime(DateTime.now().year,
                          DateTime.now().month, DateTime.now().day)) <
                  0) {
                print("Active bookings");
                String startTime = allBookings[index]['start_time'];
                String endTime = allBookings[index]['end_time'];
                var formattedStarttime = startTime.substring(0, 2) +
                    ":" +
                    startTime.substring(2, startTime.length);
                var formattedEndtime = endTime.substring(0, 2) +
                    ":" +
                    endTime.substring(2, endTime.length);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: ExpansionTile(
                    collapsedBackgroundColor: Colors.white60,
                    iconColor: Colors.green,
                    title: Text(allBookings[index]['meeting_objective']),
                    expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
                    expandedAlignment: Alignment.centerLeft,
                    childrenPadding: const EdgeInsets.symmetric(horizontal: 8),
                    children: [
                      Text(
                        'Date : ${DateFormat('yyyy-MM-dd').format(convertToFornattedDateTime(allBookings[index]['formatted_date']))}',
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Time : $formattedStarttime-$formattedEndtime',
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                );
              } else {
                print("Past booking");
                return Container();
              }
            },
          );
        },
      ),
    );
  }
}
