import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

void main() {
  runApp(const Abouttheinstitute());
}

class Abouttheinstitute extends StatelessWidget {
  const Abouttheinstitute({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About the Institute'),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FutureBuilder(
        future: fetchWebPage(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Map<String, String>> content = parseContent(snapshot.data!);

            return ListView.builder(
              itemCount: content.length,
              itemBuilder: (context, index) {
                final item = content[index];

                if (item['type'] == 'image') {
                  return Image.network(
                    item['content']!,
                    fit: BoxFit.cover,
                  );
                }

                return ListTile(
                  title: Text(
                    item['content']!,
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<String> fetchWebPage() async {
    final response =
        await http.get(Uri.parse('https://techz.vcet.edu.in/vcet/#'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load web page');
    }
  }

  List<Map<String, String>> parseContent(String responseBody) {
    final List<Map<String, String>> content = [];
    final dom.Document document = parser.parse(responseBody);

    final List<dom.Element> newsThumbImages =
        document.querySelectorAll('.news-thumb img');
    for (final element in newsThumbImages) {
      final imageUrl = element.attributes['src'] ?? '';
      if (imageUrl.isNotEmpty && imageUrl.startsWith('http')) {
        content.add({'type': 'image', 'content': imageUrl});
      }
    }

    final List<dom.Element> header1Elements = document.querySelectorAll('h1');
    for (final element in header1Elements) {
      final headerText = element.text.trim();
      if (headerText.isNotEmpty) {
        content.add({'type': 'header', 'content': headerText});
      }
    }
    final List<dom.Element> paragraphElements = document.querySelectorAll('p');
    for (final element in paragraphElements) {
      final paragraphText = element.text.trim();
      if (paragraphText.isNotEmpty) {
        content.add({'type': 'paragraph', 'content': paragraphText});
      }
    }

    final List<dom.Element> wpBlockImages =
        document.querySelectorAll('.wp-block-image img');
    for (final element in wpBlockImages) {
      final imageUrl = element.attributes['src'] ?? '';
      if (imageUrl.isNotEmpty && imageUrl.startsWith('http')) {
        content.add({'type': 'image', 'content': imageUrl});
      }
    }

    final List<dom.Element> headerElements = document.querySelectorAll('h2');
    for (final element in headerElements) {
      final headerText = element.text.trim();
      if (headerText.isNotEmpty) {
        content.add({'type': 'header', 'content': headerText});
      }
    }

    return content;
  }
}
