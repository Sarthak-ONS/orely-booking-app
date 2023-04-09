import 'package:bookingapp/Services/firesbase_firestore_api.dart';
import 'package:bookingapp/Widgets/custom_text_field.dart';
import 'package:bookingapp/appp_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../helper_functions.dart';

class ActiveBookingScreen extends StatefulWidget {
  const ActiveBookingScreen({Key? key}) : super(key: key);

  @override
  State<ActiveBookingScreen> createState() => _ActiveBookingScreenState();
}

class _ActiveBookingScreenState extends State<ActiveBookingScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future updateMeetingObjective(
      {required String newMeetingObjective,
      required List finalList,
      required int index}) async {
    try {
      finalList[index]['meeting_objective'] = newMeetingObjective;
      FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "bookings": finalList,
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Bookings'),
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
                          DateTime.now().month, DateTime.now().day)) >=
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
                    initiallyExpanded: true,
                    collapsedBackgroundColor: Colors.white60,
                    iconColor: Colors.green,
                    title: Text("${allBookings[index]['meeting_objective']}"),
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
                      Text(
                        'Venue : ${allBookings[index]['meeting_room_name']}',
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextButton.icon(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.green,
                          ),
                        ),
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) => Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text(
                                    'Options',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 50.0),
                                    child: Divider(
                                      thickness: 1,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.edit),
                                    style: ElevatedButton.styleFrom(
                                      primary: AppColors.primayColor,
                                      shadowColor: Colors.black54,
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        side: const BorderSide(
                                          color: AppColors.primayColor,
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                    ),
                                    onPressed: () {
                                      // Call for change Meeting objetive
                                      final TextEditingController controller =
                                          TextEditingController();
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (_) => Padding(
                                          padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 20),
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15.0))),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                const Text(
                                                  'New Meeting Objective',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 18),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                CustomTextFormField(
                                                  emailController: controller,
                                                  hintText: 'Meeting Objective',
                                                ),
                                                const SizedBox(height: 20),
                                                TextButton(
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(
                                                      AppColors.primayColor,
                                                    ),
                                                    padding:
                                                        MaterialStateProperty
                                                            .all(
                                                      const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 30.0,
                                                        vertical: 8,
                                                      ),
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    await updateMeetingObjective(
                                                        newMeetingObjective:
                                                            controller.text,
                                                        finalList: allBookings,
                                                        index: index);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    setState(() {});
                                                  },
                                                  child: const Text(
                                                    'Update',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    label: const Text(
                                      'Change Meeting Objective',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.lock),
                                    style: ElevatedButton.styleFrom(
                                      primary: AppColors.primayColor,
                                      shadowColor: Colors.black54,
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        side: const BorderSide(
                                          color: AppColors.primayColor,
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                    ),
                                    onPressed: () {},
                                    label: const Text(
                                      'Lock/Unlock Door',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        label: const Text(
                          'Options',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      TextButton.icon(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.red,
                          ),
                        ),
                        icon: const Icon(
                          Icons.cancel,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          // showDialog(
                          //   context: context,
                          //   builder: (_) => AlertDialog(
                          //     title: const Text('Are you sure?'),
                          //     content: ,
                          //   ),
                          // );
                          showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) => Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Are you sure?',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      try {
                                        await FirebaseFirestoreApi()
                                            .deleteBookingFromBookings(
                                          startTime: startTime,
                                          endTime: endTime,
                                          meetingRoomId: allBookings[index]
                                              ['meeting_room_id'],
                                          formattedDate: allBookings[index]
                                              ['formatted_date'],
                                        );
                                        allBookings.removeAt(index);
                                        await FirebaseFirestore.instance
                                            .collection('Users')
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .update({
                                          "bookings": allBookings,
                                        });

                                        Navigator.pop(context);
                                        setState(() {});
                                      } catch (e) {
                                        print(e);
                                      }
                                    },
                                    child: const Text(
                                      'Yes',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('No'),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        label: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
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
