import 'package:flutter/material.dart';
import 'moderation_page.dart';
import 'moderator_login_page.dart';

class ModeratorHomePage extends StatefulWidget {
  @override
  _ModeratorHomePageState createState() => _ModeratorHomePageState();
}

class _ModeratorHomePageState extends State<ModeratorHomePage> {
  // Function to handle menu option selection
  void _handleMenuSelection(String value) {
    switch (value) {
      case 'Moderation':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ModerationPage()),
        );
        break;
      case 'Logout':
        // Navigate to the ModeratorLoginPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ModeratorPage()),
        );
        break;
      default:
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
          PopupMenuButton<String>(
            onSelected: _handleMenuSelection,
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'Moderation',
                  child: Text('Moderation'),
                ),
                const PopupMenuItem<String>(
                  value: 'Logout',
                  child: Text('Logout'),
                ),
              ];
            },
            icon: const Icon(Icons.more_vert, color: Colors.black),
          ),
        ],
      ),
      body: const Center(
        child: Text("Welcome to the Moderator Home Page!!!!"),
      ),
    );
  }
}
