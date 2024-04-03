import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class UploadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Function to be called when the button is pressed
    Future<void> onUploadButtonPressed() async {
      try {
        FilePickerResult? result = await FilePicker.platform.pickFiles();
        if (result != null) {
          PlatformFile file = result.files.first;
          print(file.path);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Selected file: ${file.name}')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No file selected')),
          );
        }
      } catch (e) {
        print(e); // Print any errors to the console.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick file: $e')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Upload',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.orange,
      ),
      body: Stack(
        children: [
          Positioned(
            right: 16, // Right padding
            bottom: 16, // Bottom padding
            child: ElevatedButton(
              onPressed: onUploadButtonPressed,
              child: Icon(Icons.upload_file), // Upload icon
              style: ElevatedButton.styleFrom(
                primary: Colors.orange, // Button background color
                onPrimary: Colors.white, // Button text color
                shape: CircleBorder(), // Make the button circular
                padding: EdgeInsets.all(20), // Button padding to make it larger
              ),
            ),
          ),
        ],
      ),
    );
  }
}
