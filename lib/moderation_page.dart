import 'package:flutter/material.dart';

class ModerationPage extends StatelessWidget {
  const ModerationPage({super.key});

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
      body: Padding(
        padding: const EdgeInsets.all(20.0), // Adds padding around the column
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Expanded(
              child: Center(
                child: Text("Welcome to the Moderation Page!"),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceEvenly, // Centers the buttons horizontally
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Add your approval logic here
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // Set the background color to green
                  ),
                  child: const Text('Approve'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Add your rejection logic here
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // Set the background color to red
                  ),
                  child: const Text('Reject'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
