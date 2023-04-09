import 'package:bookingapp/Services/firebase_auth_api.dart';
import 'package:bookingapp/appp_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                UserAccountsDrawerHeader(
                  accountName: Row(
                    children: [
                      Text(FirebaseAuth.instance.currentUser!.displayName!),
                      const SizedBox(
                        width: 5,
                      ),
                      FirebaseAuth.instance.currentUser!.emailVerified
                          ? const Icon(
                              Icons.verified_outlined,
                              color: Colors.white,
                              size: 15,
                            )
                          : Container()
                    ],
                  ),
                  accountEmail: Text(FirebaseAuth.instance.currentUser!.email!),
                  currentAccountPicture: ClipOval(
                    child: Image.network(FirebaseAuth
                                .instance.currentUser!.photoURL !=
                            null
                        ? FirebaseAuth.instance.currentUser!.photoURL!
                        : "https://images.pexels.com/photos/2224220/pexels-photo-2224220.jpeg?auto=compress&cs=tinysrgb&w=600"),
                  ),
                  decoration: const BoxDecoration(color: AppColors.primayColor),
                ),
                ListTile(
                  title: const Text('Active Bookings'),
                  onTap: () async {
                    Navigator.pushNamed(context, '/activeBookingScreen');
                  },
                  trailing: const Icon(Icons.book_online),
                ),
                ListTile(
                  title: const Text('Past  Bookings'),
                  trailing: const Icon(Icons.book_outlined),
                  onTap: () {
                    Navigator.pushNamed(context, '/pastBookingScreen');
                  },
                ),
                ListTile(
                  title: const Text('Settings'),
                  trailing: const Icon(Icons.settings),
                  onTap: () {},
                ),
                ListTile(
                  title: const Text('Signout'),
                  onTap: () {
                    FirebaseAuthApi().signoutOfDevice(context);
                  },
                  trailing: const Icon(Icons.exit_to_app_rounded),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Made by Sarthak Agarwal',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
            icon: const Icon(
              Icons.menu_sharp,
              color: Colors.black,
            )),
        title: const Text(
          'Book a room',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuthApi().signoutOfDevice(context);
              },
              icon: const Icon(
                Icons.exit_to_app,
                color: Colors.black,
              ))
        ],
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('MeetingRooms').get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data == null || snapshot.hasError) {
            return const Center(
              child: Text('Please try again later'),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: SizedBox(
                        height: 250,
                        width: double.infinity,
                        child: PageView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.docs[index]['photos'].length,
                          itemBuilder: ((context, index1) {
                            return Image.network(
                              snapshot.data.docs[index]['photos'][index1],
                              fit: BoxFit.cover,
                            );
                          }),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${snapshot.data.docs[index]['name']}, ",
                              ),
                              Text(
                                  "Capacity: ${snapshot.data.docs[index]['capcity'].toString()}"),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/roomDes',
                                arguments: {
                                  "roomId": snapshot.data.docs[index]['room_id']
                                },
                              );
                            },
                            child: const Text('Book'),
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 2)),
                              backgroundColor: MaterialStateProperty.all(
                                AppColors.primayColor,
                              ),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
