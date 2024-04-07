import 'package:flutter/material.dart';
import 'package:techzette/moderator_login_page.dart';
import 'package:techzette/student_login_page.dart';

class TechZettePage2 extends StatelessWidget {
  const TechZettePage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "assets/background_image.avif"), // Add your background image
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Select your Role:",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white), // Change text color to white
              ),
              SizedBox(height: 10),
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
                        MaterialPageRoute(
                            builder: (context) => ModeratorPage()),
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
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
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
      ),
    );
  }
}
