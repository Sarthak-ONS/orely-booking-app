import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FirebaseFirestoreApi {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future sendEmailBookingConfirmtaion({
    required String addressName,
    required String date,
    required String timeStringm,
    required String name,
  }) async {
    try {
      print("////////////");

      final bodyMap = jsonEncode({
        "addressList": [
          "gsamarth14@gmail.com",
          "sarthak1931006@akgec.ac.in",
          "samarth1931005@akgec.ac.in",
          "bookexpo1810@gmail.com",
          FirebaseAuth.instance.currentUser!.email!,
        ],
        "messageString":
            "Your booking for $date at $timeStringm is confirmed at $name. We wish you a happy meeting",
      });
      print(bodyMap);

      http.Response res = await http.post(
        Uri.parse(
          "http://localhost:4000/user/sendEmail",
        ),
        body: bodyMap,
        headers: {
          "Content-Type": "application/json",
        },
      );
      print(res.body);
    } catch (e) {
      print("////////////\\\\\\\\\\\\\\\\\\\\\\\\\"");
      print(e);
    }
  }

  Future checkAValidBooking(
    context, {
    required String meetingRoomName,
    required String meetingRoomId,
    required String formattedDate,
    required String startTime,
    required String endTime,
    required String messageStringDate,
    required String startEndTimeMessageString,
    required String roomName,
    required String meetingObjective,
  }) async {
    print("checkvalid booking Called");

    try {
      print(meetingRoomId);
      print(formattedDate);
      print(startTime);
      print(endTime);
      final data = await _firebaseFirestore
          .collection('bookings')
          .doc(meetingRoomId)
          .collection('date-time')
          .doc(formattedDate)
          .get();
      Map<dynamic, dynamic> selectedDateScheduleMap = data.data()!;
      print(selectedDateScheduleMap);

      for (var i = int.parse(startTime); i < int.parse(endTime); i += 15) {
        if (i % 100 >= 60) {
          i = (i ~/ 100 + 1) * 100;
        }

        var s = i.toString();

        if (s.length == 3) {
          s = '0' + s;
        }
        if (s.endsWith("00") == false ||
            s.endsWith("15") == false ||
            s.endsWith("30") == false ||
            s.endsWith("45") == false) {
          print(int.parse(s.substring(2)));
          if (int.parse(s.substring(2)) < 15) {
            s = s.replaceRange(2, null, "00");
          } else if (int.parse(s.substring(2)) < 30) {
            s = s.replaceRange(2, null, "15");
          } else if (int.parse(s.substring(2)) < 45) {
            s = s.replaceRange(2, null, "30");
          } else {
            s = s.replaceRange(2, null, "45");
          }
          print(s);
          print("/////");
        }

        Map d = selectedDateScheduleMap[s];
        if (d['user_id'].toString().isNotEmpty) {
          print("Someone has choosen this slot, Please try some other slot");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(
                'Someone has choosen this slot, Please try some other slot',
              ),
            ),
          );
          return;
        }
      }

      for (var i = int.parse(startTime); i < int.parse(endTime); i += 15) {
        if (i % 100 >= 60) {
          i = (i ~/ 100 + 1) * 100;
        }

        var s = i.toString();

        if (s.length == 3) {
          s = '0' + s;
        }
        await _firebaseFirestore
            .collection('bookings')
            .doc(meetingRoomId)
            .collection('date-time')
            .doc(formattedDate)
            .update(
          {
            s: {
              "user_id": FirebaseAuth.instance.currentUser!.uid,
            },
          },
        );
      }

      print("slot is available, sent email");
      Navigator.pushNamed(context, '/bookingConfirmation');

      await _firebaseFirestore
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "bookings": FieldValue.arrayUnion([
          {
            "meeting_objective": meetingObjective,
            "meeting_room_name": meetingRoomName,
            "user_id": FirebaseAuth.instance.currentUser!.uid,
            "formatted_date": formattedDate,
            "meeting_room_id": meetingRoomId,
            "start_time": startTime,
            "end_time": endTime,
            "booking_date": Timestamp.fromDate(DateTime.now())
          }
        ]),
      });

      // await sendEmailBookingConfirmtaion(
      //   addressName: FirebaseAuth.instance.currentUser!.email!.toString(),
      //   date: messageStringDate,
      //   timeStringm: startEndTimeMessageString,
      //   name: roomName,
      // );
    } catch (e) {
      print(e);
    }
  }

  Future saveUserToDatabase({
    required String name,
    required String email,
    required String photoUrl,
    required String userId,
    String? phoneNo,
  }) async {
    try {
      final DocumentSnapshot snapshot =
          await _firebaseFirestore.collection('Users').doc(userId).get();
      if (snapshot.exists) {
      } else {
        _firebaseFirestore.collection('Users').doc(userId).set({
          "name": name,
          "email": email,
          "photoUrl": photoUrl,
          "user_id": userId,
          "phoneNo": phoneNo ?? "",
          "bookings": []
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
