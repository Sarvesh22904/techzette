import 'package:flutter/material.dart';
import 'package:techzette/techzette_page1.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Techzette());
}

class Techzette extends StatelessWidget {
  const Techzette({super.key});
  @override
  Widget build(BuildContext context) {
    return (const MaterialApp(
        title: "VCET ",
        debugShowCheckedModeBanner: false,
        home: TechzettePage1()));
  }
}
