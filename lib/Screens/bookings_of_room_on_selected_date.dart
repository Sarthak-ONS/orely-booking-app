import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookingsOnSelectedDate extends StatefulWidget {
  const BookingsOnSelectedDate({
    Key? key,
    required this.roomId,
    required this.startingDate,
  }) : super(key: key);

  final String? roomId;

  final String? startingDate;

  @override
  State<BookingsOnSelectedDate> createState() => _BookingsOnSelectedDateState();
}

class _BookingsOnSelectedDateState extends State<BookingsOnSelectedDate> {
  @override
  Widget build(BuildContext context) {
    print(widget.roomId);
    print(widget.startingDate);
    print(Timestamp.fromDate(DateTime.parse(widget.startingDate!)));
    print(DateTime.parse(widget.startingDate!).millisecondsSinceEpoch);
    DateTime temp = DateTime.parse(widget.startingDate!);
    print(temp.microsecondsSinceEpoch);
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
          'Bookings on Selected Date',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('bookings')
            .where("meetingRoomId", isEqualTo: widget.roomId!)
            .where("dayDate",
                isEqualTo: Timestamp.fromMillisecondsSinceEpoch(
                    DateTime.parse(widget.startingDate!)
                        .millisecondsSinceEpoch))
            .get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
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
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) => Text(
              snapshot.data.docs[index]['meetingRoomId'],
              style: const TextStyle(fontSize: 20),
            ),
          );
        },
      ),
    );
  }
}
