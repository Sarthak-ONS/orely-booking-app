import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../appp_colors.dart';

class RoomDescriptionScreen extends StatefulWidget {
  const RoomDescriptionScreen({Key? key, this.roomId}) : super(key: key);

  final String? roomId;

  @override
  State<RoomDescriptionScreen> createState() => _RoomDescriptionScreenState();
}

class _RoomDescriptionScreenState extends State<RoomDescriptionScreen> {
  DateTime? selectedDateTime;

  TimeOfDay? startingTime;

  TimeOfDay? endingTime;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('MeetingRooms')
          .doc(widget.roomId!)
          .get(),
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
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back, color: Colors.black),
            ),
            title: Text(
              snapshot.data!.get("name") ?? "Defaultter",
              style: const TextStyle(color: Colors.black),
            ),
            centerTitle: true,
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: SizedBox(
                        height: 250,
                        width: double.infinity,
                        child: PageView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.get("photos").length,
                          itemBuilder: ((context, index1) {
                            return Image.network(
                              snapshot.data!.get("photos")[index1],
                              fit: BoxFit.cover,
                            );
                          }),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.person),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          "No of Persons Accomodated: ${snapshot.data!.get("capcity").toString()}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.black,
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          snapshot.data!.get("address").toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    GestureDetector(
                      onTap: () async {
                        selectedDateTime = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 10),
                          ),
                        );
                        print(selectedDateTime);
                        setState(() {});
                      },
                      child: const Text(
                        'Tap to Book a Date',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Text(
                      selectedDateTime != null
                          ? DateFormat('EEE, d/M/y').format(selectedDateTime!)
                          : "" "No Date Selected",
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),

                    //// Time Slots booking Starting time
                    GestureDetector(
                      onTap: () async {
                        startingTime = await showTimePicker(
                          context: context,
                          initialTime: const TimeOfDay(hour: 8, minute: 30),
                        );
                        print(startingTime);
                        setState(() {});
                      },
                      child: Row(
                        children: const [
                          Text(
                            'Starting Time',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.edit),
                        ],
                      ),
                    ),
                    Text(
                      startingTime != null
                          ? startingTime!.format(context)
                          : "" "No Starting Time Selected",
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),

                    /// Ending Time For seletced Date
                    GestureDetector(
                      onTap: () async {
                        endingTime = await showTimePicker(
                          context: context,
                          initialTime: const TimeOfDay(hour: 8, minute: 30),
                        );
                        print(selectedDateTime);
                        setState(() {});
                      },
                      child: Row(
                        children: const [
                          Text(
                            'Endings Time',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.edit),
                        ],
                      ),
                    ),
                    Text(
                      endingTime != null
                          ? endingTime!.format(context)
                          : "" "No Ending Time Selected",
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        //
                        Navigator.pushNamed(context, '/selectedBookings',
                            arguments: {
                              "roomId": widget.roomId,
                              "startingTime": selectedDateTime.toString()
                            });
                      },
                      child: const Text(
                        'Find Bookings of this meeting room on Selected Date',
                        style: TextStyle(
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                    const Text(
                      'You can find meetings of this room on selected date, so that you can book this meeting room on available slots. Please note that you can also contact the booking person of a specific slot, and change the bookings.',
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    icon: Container(),
                    style: ElevatedButton.styleFrom(
                      primary: AppColors.primayColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('bookings')
                          .add({
                        "user": "loggedInuser",
                        "meetingRoomId": widget.roomId,
                        "startTimeStamp": Timestamp.fromDate(
                          selectedDateTime!.add(
                            Duration(
                              minutes: startingTime!.minute,
                              hours: startingTime!.hour,
                            ),
                          ),
                        ),
                        "endTimeStamp": Timestamp.fromDate(
                          selectedDateTime!.add(Duration(
                            minutes: endingTime!.minute,
                            hours: endingTime!.hour,
                          )),
                        )
                      });
                    },
                    label: const Text(
                      'Book',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
