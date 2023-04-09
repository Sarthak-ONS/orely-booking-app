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
  String changetoFormattedDate() {
    final x = DateTime.parse(widget.startingDate!);
    final formattedDate =
        x.day.toString() + x.month.toString() + x.year.toString();
    return formattedDate;
  }

  makeSlots(Map bookedSlotsMapDateWise) {
    bookedSlotsMapDateWise.forEach((key, value) {
      var userId;
      if (value['user_id'] != null) {
        userId = value['user_id'];
      }
    });
  }

  @override
  void initState() {
    super.initState();
    changetoFormattedDate();
  }

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
          'Bookings on Selected Date',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('bookings')
            .doc('${widget.roomId}')
            .collection('date-time')
            .doc(changetoFormattedDate())
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
          Map bookedSlotsMapDateWise = Map.fromEntries(
              (snapshot.data!.data() as Map).entries.toList()
                ..sort((e1, e2) => e1.key.compareTo(e2.key)));

          print(bookedSlotsMapDateWise);

          bookedSlotsMapDateWise.forEach((key, value) {
            if (value['user_id'] != null) {}
          });
          return ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) => Text(
              index.toString(),
              style: const TextStyle(fontSize: 20),
            ),
          );
        },
      ),
    );
  }
}
