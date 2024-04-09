import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

void main() {
  runApp(const AbouttheMag());
}

class AbouttheMag extends StatelessWidget {
  const AbouttheMag({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About the Magazine'),
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
    // Fetch HTML content
    final response = await http
        .get(Uri.parse('https://techz.vcet.edu.in/about-the-magazine/'));

    // Return HTML content
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load data');
    }
  }

  List<Map<String, String>> parseContent(String htmlString) {
    final document = parser.parse(htmlString);

    // Extract container data
    final container = document.querySelector('.page-area');

    // Extract headings and paragraphs
    final headings = container?.querySelectorAll('h1, h2, h3, h4, h5, h6');
    final paragraphs = container?.querySelectorAll('p');

    // Store data in a list of maps
    List<Map<String, String>> data = [];

    // Add headings to data
    if (headings != null) {
      for (var heading in headings) {
        data.add({'type': 'heading', 'content': heading.text});
      }
    }

    // Add paragraphs to data
    if (paragraphs != null) {
      for (var paragraph in paragraphs) {
        data.add({'type': 'paragraph', 'content': paragraph.text});
      }
    }

    return data;
  }
}
