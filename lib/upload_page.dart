import 'package:flutter/material.dart';

class UploadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Function to be called when the button is pressed
    void onUploadButtonPressed() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload button pressed')),
      );
      // Here you can add your file upload functionality
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Upload',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed:
              onUploadButtonPressed, // Call the function when the button is pressed
          child: Text('Upload'),
          style: ElevatedButton.styleFrom(
            primary: Colors.orange, // Button background color
            onPrimary: Colors.white, // Button text color
          ),
        ),
      ),
    );
  }
}
