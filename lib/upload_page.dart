import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // For Firebase Storage

class UploadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Function to be called when the button is pressed
    Future<void> onUploadButtonPressed() async {
      try {
        FilePickerResult? result = await FilePicker.platform
            .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
        if (result != null) {
          PlatformFile file = result.files.first;

          // Create a File object
          File pdfFile = File(file.path!);

          // Upload file
          String fileName = file.name;
          try {
            // Define the file path in Firebase Storage
            String filePath = 'articles/$fileName';
            // Get a reference to the Firebase Storage instance
            Reference ref = FirebaseStorage.instance.ref().child(filePath);

            // Upload the file
            UploadTask uploadTask = ref.putFile(pdfFile);

            // Get the download URL
            final TaskSnapshot downloadUrl = await uploadTask;
            final String url = await downloadUrl.ref.getDownloadURL();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('File uploaded successfully: $url')),
            );
          } catch (e) {
            print(e); // Print any errors to the console.
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to upload file: $e')),
            );
          }
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
