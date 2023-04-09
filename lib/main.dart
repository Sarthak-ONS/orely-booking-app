import 'package:bookingapp/Screens/error_screen.dart';
import 'package:bookingapp/route_generator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    runApp(const MyApp());
  } catch (e) {
    print(e);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return const ErrorScreen();
        }

        if (snapshot.data == null) {
          getMaterialAppWithRoute(path: '/');
        }

        if (snapshot.connectionState == ConnectionState.none) {
          return getMaterialAppWithRoute(path: '/');
        }
        return getMaterialAppWithRoute(path: '/home');
      },
    );
  }

  Widget getMaterialAppWithRoute({required String path}) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
      initialRoute: path,
      onGenerateRoute: RouteGenerator().generateRoute,
    );
  }
}
