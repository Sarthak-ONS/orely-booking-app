import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminBookingsScreen extends StatefulWidget {
  const AdminBookingsScreen({Key? key}) : super(key: key);

  @override
  State<AdminBookingsScreen> createState() => _AdminBookingsScreenState();
}

class _AdminBookingsScreenState extends State<AdminBookingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        title: const Text(
          'Admin Panel',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('MeetingRooms')
            .doc('STJiWl8WFdDlYP91pvV8')
            .snapshots(),
        builder:
            ((BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
          return ListView.builder(
              itemCount: snapshot.data!.get("bookings").length,
              itemBuilder: (context, index) {
                var startTime =
                    snapshot.data!.get("bookings")[index]['start_time'];

                var endTime = snapshot.data!.get("bookings")[index]['end_time'];
                var formattedDate = snapshot.data!
                    .get("bookings")[index]['formatted_date']
                    .toString();

                var date = formattedDate.substring(0, 2) +
                    "/" +
                    formattedDate.substring(2, 3) +
                    "/" +
                    formattedDate.substring(3);

                var formattedStarttime = startTime.substring(0, 2) +
                    ":" +
                    startTime.substring(2, startTime.length);
                var formattedEndtime = endTime.substring(0, 2) +
                    ":" +
                    endTime.substring(2, endTime.length);

                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black54)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(snapshot.data!.get("bookings")[index]
                          ['meeting_objective']),
                      Text(date),
                      Text(formattedStarttime),
                      Text(formattedEndtime),
                      Text(snapshot.data!.get("bookings")[index]
                          ['meeting_requirements']),
                    ],
                  ),
                );
              });
        }),
      ),
    );
  }
}
