import 'package:flutter/material.dart';
import 'package:tempero_do_amor/colors.dart';
import 'package:tempero_do_amor/route_generator.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    title: "Tempero do Amor",
    debugShowCheckedModeBanner: false,
    initialRoute: "/",
    onGenerateRoute: RouteGenerator.generateRoute,
    theme: ThemeData(
      primarySwatch: primary,
      ),
    ),
  );
}