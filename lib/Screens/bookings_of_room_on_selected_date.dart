import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
          List<Users> users = [];
          bookedSlotsMapDateWise.forEach((key, value) {
            users.add(Users(time: key, uid: value['user_id']));
          });
          List<BookedSlot> finalList = [];

          for (int i = 0; i < users.length; i++) {
            if (users[i].uid.isNotEmpty) {
              var singleTimeSlot = BookedSlot(id: "", stime: "", etime: "");
              singleTimeSlot.id = users[i].uid;
              singleTimeSlot.stime = users[i].time;
              for (int j = i; j < users.length; j++) {
                if (users[j].uid != singleTimeSlot.id) {
                  singleTimeSlot.etime = users[j].time;
                  i = j;
                  j = users.length;
                  finalList.add(singleTimeSlot);
                }
              }
            }
          }

          if (finalList.isEmpty) {
            return const Center(
              child: Text('No bookings on selected Date!'),
            );
          }

          return ListView.builder(
            itemCount: finalList.length,
            itemBuilder: (context, index) {
              return FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(finalList[index].id)
                    .get(),
                builder: ((context, AsyncSnapshot<DocumentSnapshot> snapshot2) {
                  if (snapshot2.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  String startTime = finalList[index].stime;
                  String endTime = finalList[index].etime;
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
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Meeting Timings : ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text("$formattedStarttime-$formattedEndtime"),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Meeting Host : ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Name : ${snapshot2.data!.get("name")}",
                          style: const TextStyle(),
                        ),
                        Text(
                          "Email : ${snapshot2.data!.get("email")}",
                          style: const TextStyle(),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextButton.icon(
                          onPressed: () async {
                            await launchUrl(Uri.parse(
                                "mailto:${snapshot2.data!.get("email")}"));
                          },
                          icon: const Icon(
                            Icons.contact_phone_rounded,
                            color: Colors.white,
                          ),
                          label: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Contact',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(horizontal: 16)),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.orange[800]),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }),
              );
            },
          );
        },
      ),
    );
  }

  Future getDetails({required String userId}) async {
    try {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();
      print(snapshot.data());
    } catch (e) {
      print(e);
      return "";
    }
  }
}

class Users {
  String uid;
  String time;
  Users({required this.time, required this.uid});
}

class BookedSlot {
  String id;
  String stime;
  String etime;
  BookedSlot({required this.id, required this.stime, required this.etime});
}
