import 'package:bookingapp/route_generator.dart';
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
    return getMaterialAppWithRoute(path: '/');
  }

  Widget getMaterialAppWithRoute({required String path}) {
    return MaterialApp(
      title: 'Orely',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
      initialRoute: path,
      onGenerateRoute: RouteGenerator().generateRoute,
    );
  }
}
