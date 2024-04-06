import 'package:flutter/material.dart';
import 'package:techzette/techzette_page2.dart'; // Import your next page file

class TechzettePage1 extends StatelessWidget {
  const TechzettePage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "VCET Techzette",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          _navigateToNextPage(context);
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/techzette.png',
                height: 200,
                width: 400,
              ),
              const SizedBox(
                height: 20,
              ),
              Image.asset(
                'assets/vcet-logo.jpeg',
                height: 200,
                width: 200,
              ),
              const SizedBox(
                height: 50,
              ),
              const SizedBox(height: 10),
              const Text(
                "Welcome to Techzette",
                style: TextStyle(
                  color: Color.fromARGB(255, 3, 1, 14),
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 50),
              const Text(
                "Tap to Continue",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToNextPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TechZettePage2()),
    );
  }
}
