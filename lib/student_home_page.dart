import 'package:flutter/material.dart';
import 'upload_page.dart';
import 'student_login_page.dart';

class StudentHomePage extends StatefulWidget {
  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  // Function to handle menu option selection
  void _handleMenuSelection(String value) {
    switch (value) {
      case 'Upload':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UploadPage()),
        );
        break;
      case 'Logout':
        // Navigate to the StudentLoginPage
        Navigator.pushReplacement(
          // Using pushReplacement to prevent returning to the previous screen after logout
          context,
          MaterialPageRoute(builder: (context) => StudentPage()),
        );
        break;
      default:
        // Handle other cases if necessary
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.orange,
        actions: <Widget>[
          // Using PopupMenuButton for the three dots menu
          PopupMenuButton<String>(
            onSelected: _handleMenuSelection,
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'Upload',
                  child: Text('Upload'),
                ),
                const PopupMenuItem<String>(
                  value: 'Logout',
                  child: Text('Logout'),
                ),
              ];
            },
            icon: const Icon(Icons.more_vert,
                color: Colors.black), // Three dots icon in black color
          ),
        ],
      ),
      body: const Center(
        child: Text("Welcome to the Student Home Page!"),
      ),
    );
  }
}
