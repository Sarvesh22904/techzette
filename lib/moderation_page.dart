import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'articles_page.dart';

class ModerationPage extends StatefulWidget {
  const ModerationPage({Key? key}) : super(key: key);

  @override
  State<ModerationPage> createState() => _ModerationPageState();
}

class _ModerationPageState extends State<ModerationPage> {
  void updateApprovalStatus(
      String docId, bool isApproved, String? pdfUrl) async {
    if (isApproved) {
      await FirebaseFirestore.instance
          .collection('uploaded_pdfs')
          .doc(docId)
          .update({
        'isApproved': isApproved,
        'pdfUrl': pdfUrl, // Add the PDF URL to the document
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PDF Approved'),
        ),
      );
    } else {
      await FirebaseFirestore.instance
          .collection('uploaded_pdfs')
          .doc(docId)
          .delete(); // Delete the document from Firestore

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PDF Rejected'),
        ),
      );
    }
  }

  Future<String> downloadPDF(String pdfUrl) async {
    final response = await http.get(Uri.parse(pdfUrl));
    final bytes = response.bodyBytes;
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/document.pdf');
    await file.writeAsBytes(bytes);
    return file.path;
  }

  void viewPdf(String? pdfUrl, String docId) {
    if (pdfUrl != null) {
      downloadPDF(pdfUrl).then((filePath) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PdfViewerPage(filePath: filePath),
          ),
        ).then((value) {
          // If approved, add the PDF URL to the list and navigate to ArticlesPage
          if (value == true) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArticlesPage(pdfUrls: [pdfUrl]),
              ),
            );
          }
        });
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to download PDF'),
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PDF URL is missing'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Moderation",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('uploaded_pdfs')
            .where('isApproved', isEqualTo: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var documents = snapshot.data!.docs;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              var doc = documents[index];
              String? pdfUrl = doc['url']?.toString();
              return ListTile(
                title: Text(doc['name']),
                subtitle: Text("Uploaded by: ${doc['uid']}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      onPressed: () => updateApprovalStatus(doc.id, true,
                          pdfUrl), // Pass PDF URL to updateApprovalStatus
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () => updateApprovalStatus(doc.id, false,
                          null), // Set PDF URL to null when rejected
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_red_eye),
                      onPressed: () =>
                          viewPdf(pdfUrl, doc.id), // Pass PDF URL and docId
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class PdfViewerPage extends StatelessWidget {
  final String filePath;

  const PdfViewerPage({Key? key, required this.filePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: PDFView(
        filePath: filePath,
      ),
    );
  }
}
