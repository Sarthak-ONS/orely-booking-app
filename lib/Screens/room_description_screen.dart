import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../appp_colors.dart';

class RoomDescriptionScreen extends StatefulWidget {
  const RoomDescriptionScreen({Key? key, this.roomId}) : super(key: key);

  final String? roomId;

  @override
  State<RoomDescriptionScreen> createState() => _RoomDescriptionScreenState();
}

class _RoomDescriptionScreenState extends State<RoomDescriptionScreen> {
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
              snapshot.data!.get("name"),
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
                    const Text(
                      'Select a Date for a meeting',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');
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
