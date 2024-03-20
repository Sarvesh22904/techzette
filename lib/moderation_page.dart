import 'package:flutter/material.dart';

class ModerationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Moderation",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
      ),
      body: const Center(
        child: Text("Welcome to the Moderation Page!"),
      ),
    );
  }
}
