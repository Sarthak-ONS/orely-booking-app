import 'package:bookingapp/Services/request_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../helper_functions.dart';

class FirebaseFirestoreApi {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future sendEmailBookingConfirmtaion(
      String name,
      String formattedDate,
      String formattedTime,
      String meetingObjective,
      String userEmail,
      bool isDelete) async {
    try {
      await RequestHelper().request(endPoint: '/user/sendEmail', bodyMap: {
        "name": name,
        "formattedDate": formattedDate,
        "formattedTime": formattedTime,
        "meetingObjective": meetingObjective,
        "userEmail": userEmail,
        "isDelete": isDelete
      });
    } catch (e) {
      print(e);
    }
  }

  Future checkAValidBooking(context,
      {required String meetingRoomName,
      required String meetingRoomId,
      required String formattedDate,
      required String startTime,
      required String endTime,
      required String messageStringDate,
      required String startEndTimeMessageString,
      required String roomName,
      required String meetingObjective,
      required bool isRefreshmentNeeded,
      required String refreshmentNeeded}) async {
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

      var stTime = startTime;
      if (stTime.length == 3) {
        stTime = '0' + stTime;
      }
      if (stTime.endsWith("00") == false ||
          stTime.endsWith("15") == false ||
          stTime.endsWith("30") == false ||
          stTime.endsWith("45") == false) {
        print(int.parse(stTime.substring(2)));
        if (int.parse(stTime.substring(2)) < 15) {
          stTime = stTime.replaceRange(2, null, "00");
        } else if (int.parse(stTime.substring(2)) < 30) {
          stTime = stTime.replaceRange(2, null, "15");
        } else if (int.parse(stTime.substring(2)) < 45) {
          stTime = stTime.replaceRange(2, null, "30");
        } else {
          stTime = stTime.replaceRange(2, null, "45");
        }
        print(stTime);
        print("/////");
      }
      for (var i = int.parse(stTime); i < int.parse(endTime); i += 15) {
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
            "meeting_id": '',
            "isRefreshmentNeeded": isRefreshmentNeeded,
            "meeting_requirements": refreshmentNeeded
          }
        ]),
      });

      await _firebaseFirestore
          .collection('MeetingRooms')
          .doc(meetingRoomId)
          .update({
        "bookings": FieldValue.arrayUnion([
          {
            "meeting_objective": meetingObjective,
            "user_id": FirebaseAuth.instance.currentUser!.uid,
            "formatted_date": formattedDate,
            "start_time": startTime,
            "end_time": endTime,
            "meeting_id": '',
            "isRefreshmentNeeded": isRefreshmentNeeded,
            "meeting_requirements": refreshmentNeeded,
          }
        ]),
      });

      await sendEmailBookingConfirmtaion(
          FirebaseAuth.instance.currentUser!.displayName!,
          DateFormat('yyyy-MM-dd')
              .format(convertToFornattedDateTime(formattedDate, 0, 0))
              .toString(),
          startTime.substring(0, 2) +
              ":" +
              startTime.substring(2, 4) +
              " - " +
              endTime.substring(0, 2) +
              ":" +
              endTime.substring(2, 4),
          meetingObjective,
          FirebaseAuth.instance.currentUser!.email!,
          false);
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
        print("Document Exists");
      } else {
        _firebaseFirestore.collection('Users').doc(userId).set({
          "name": name,
          "email": email,
          "photoUrl": photoUrl,
          "user_id": userId,
          "phoneNo": phoneNo ?? "",
          "isAdmin": false,
          "bookings": []
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future deleteBookingFromBookings({
    required String startTime,
    required String endTime,
    required String meetingRoomId,
    required String formattedDate,
  }) async {
    try {
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
              "user_id": "",
            },
          },
        );
      }
    } catch (e) {
      print(e);
    }
  }
}
