import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:techzette/moderator_home_page.dart';

class ModeratorPage extends StatefulWidget {
  @override
  _ModeratorPageState createState() => _ModeratorPageState();
}

class _ModeratorPageState extends State<ModeratorPage> {
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _tryLogin() async {
    final String enteredRole = _roleController.text.trim();
    final String enteredEmail = _emailController.text.trim();
    final String enteredPassword = _passwordController.text.trim();

    if (enteredRole.isEmpty ||
        enteredEmail.isEmpty ||
        enteredPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter all details")),
      );
      return;
    }

    try {
      // Query Firestore for a moderator with the entered email
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Moderators')
          .where('Email', isEqualTo: enteredEmail)
          .get();

      if (querySnapshot.docs.isEmpty) {
        // No matching email found
        throw Exception("No matching user found.");
      }

      final doc = querySnapshot.docs.first;

      if (doc['Password'].toString() == enteredPassword &&
          doc['Role'].toString().toLowerCase() == enteredRole.toLowerCase()) {
        // Password matches and role is correct, navigate to the next page
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ModeratorHomePage()));
      } else {
        // Password does not match or role is incorrect
        throw Exception("Incorrect password or role.");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Moderator Login",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Text(
                  "Login",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextFormField(
                  controller: _roleController, // Connect the controller
                  decoration: const InputDecoration(
                    labelText: 'Enter Your Role',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextFormField(
                  controller: _emailController, // Connect the controller
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextFormField(
                  controller: _passwordController, // Connect the controller
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
              ),
              ElevatedButton(
                onPressed: _tryLogin, // Use _tryLogin here
                child: const Text('Enter'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  onPrimary: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
