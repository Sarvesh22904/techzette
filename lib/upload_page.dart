import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'pdfviewer_page.dart';
import 'package:techzette/uploaded_file.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  List<UploadedFile> uploadedFiles = []; // Use the UploadedFile class

  Future<void> onUploadButtonPressed() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null) {
        PlatformFile file = result.files.first;
        File pdfFile = File(file.path!);
        String fileName = file.name;

        String filePath = 'articles/$fileName';
        Reference ref = FirebaseStorage.instance.ref().child(filePath);

        UploadTask uploadTask = ref.putFile(pdfFile);
        final TaskSnapshot downloadUrl = await uploadTask;
        final String url = await downloadUrl.ref.getDownloadURL();

        // Update the state to include the new file with its URL and name
        setState(() {
          uploadedFiles.add(UploadedFile(url: url, name: fileName));
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File uploaded successfully: $url')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No file selected')),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick file: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.orange,
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: uploadedFiles.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    PdfViewerPage(url: uploadedFiles[index].url),
              ));
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange),
              ),
              child: Center(
                // Display the original file name
                child: Text(uploadedFiles[index].name),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onUploadButtonPressed,
        backgroundColor: Colors.orange,
        child: const Icon(Icons.upload_file),
      ),
    );
  }
}
