import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'pdfviewer_page.dart';
import 'package:techzette/uploaded_file.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  bool _isUploading = false;
  final user = FirebaseAuth.instance.currentUser; // Get the current user

  @override
  void initState() {
    super.initState();
    // If you want to fetch files at the start
    fetchUploadedFiles();
  }

  Future<void> onUploadButtonPressed() async {
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to upload files')),
      );
      return;
    }

    setState(() {
      _isUploading = true; // Start the upload process
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        File pdfFile = File(file.path!);
        String fileName = file.name;

        String filePath =
            'articles/${user!.uid}/$fileName'; // Include the user's UID in the path
        Reference ref = FirebaseStorage.instance.ref().child(filePath);

        UploadTask uploadTask = ref.putFile(pdfFile);
        final TaskSnapshot downloadUrl = (await uploadTask);
        final String url = await downloadUrl.ref.getDownloadURL();

        // Save PDF metadata to Firestore with user's UID
        await FirebaseFirestore.instance.collection('uploaded_pdfs').add({
          'url': url,
          'name': fileName,
          'uid': user!.uid, // Include the user's UID
          'timestamp': FieldValue.serverTimestamp(),
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
    } finally {
      setState(() {
        _isUploading = false; // End the upload process
      });
      fetchUploadedFiles(); // Refresh the list after upload
    }
  }

  Future<void> fetchUploadedFiles() async {
    // This method needs modification to filter files based on the current user.
    // However, as it's not being actively used in the UI, we'll focus on the StreamBuilder query adjustment.
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Upload'),
          backgroundColor: Colors.orange,
        ),
        body: const Center(
          child: Text('Please log in to view and upload files.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.orange,
      ),
<<<<<<< HEAD
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
=======
      body: _isUploading
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('uploaded_pdfs')
                  .where('uid',
                      isEqualTo: user!.uid) // Filter by the current user's UID
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  var documents = snapshot.data!.docs;
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0,
                    ),
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      var doc = documents[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                PdfViewerPage(url: doc['url']),
                          ));
                        },
                        child: Card(
                          child: Column(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                      'assets/pdfLogo1.png'), // PDF logo
                                ),
                              ),
                              Text(
                                doc['name'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 14.0),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
>>>>>>> 8ed705c3b074d8a55003cc42c0dbb93ba2a7e906
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: onUploadButtonPressed,
<<<<<<< HEAD
=======
        child: const Icon(Icons.upload_file),
>>>>>>> 8ed705c3b074d8a55003cc42c0dbb93ba2a7e906
        backgroundColor: Colors.orange,
        child: const Icon(Icons.upload_file),
      ),
    );
  }
}
