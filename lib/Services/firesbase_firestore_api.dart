import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreApi {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future checkAValidBooking({
    required String meetingRoomId,
    required String formattedDate,
    required String startTime,
    required String endTime,
  }) async {
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
      Map<dynamic, dynamic>? selectedDateScheduleMap = data.data();
      print(selectedDateScheduleMap!);

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
          return;
        }
      }

      print("slot is available, sent email");
    } catch (e) {
      print(e);
    }
  }
}
