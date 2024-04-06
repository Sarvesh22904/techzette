import 'package:flutter/material.dart';
import 'package:techzette/moderator_login_page.dart';
import 'package:techzette/student_login_page.dart';

class TechZettePage2 extends StatelessWidget {
  const TechZettePage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "VCET Techzette",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black, // Make the text black
          ),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Select your Role:",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 50.0), // Add padding around the dropdown
              child: DropdownButton<String>(
                items: const [
                  DropdownMenuItem<String>(
                    value: "Moderator",
                    child: Text(
                      "Moderator",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  DropdownMenuItem<String>(
                    value: "Student",
                    child: Text(
                      "Student",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
                onChanged: (String? value) {
                  // Handle dropdown value change
                  if (value == "Moderator") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ModeratorPage()),
                    );
                  } else if (value == "Student") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StudentPage()),
                    );
                  }
                },
                hint: const Text(
                  "Select your Role",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                isExpanded: true,
                underline: Container(
                  height: 2,
                  color: Colors.orange,
                ),
                icon: const Icon(Icons.arrow_drop_down),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
