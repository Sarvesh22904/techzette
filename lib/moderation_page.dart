import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ModerationPage extends StatelessWidget {
  const ModerationPage({super.key});

  void updateApprovalStatus(String docId, bool isApproved) async {
    await FirebaseFirestore.instance
        .collection('uploaded_pdfs')
        .doc(docId)
        .update({
      'isApproved': isApproved,
    });
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
              return ListTile(
                title: Text(doc['name']),
                subtitle: Text("Uploaded by: ${doc['uid']}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      onPressed: () => updateApprovalStatus(doc.id, true),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () => updateApprovalStatus(doc.id, false),
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
