import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:techzette/articles_page.dart';
import 'abouttheinstitute.dart';
import 'aboutthedep.dart';
import 'aboutmagzine.dart';
import 'upload_page.dart';
import 'student_login_page.dart';

void main() {
  runApp(const StudentHomePage());
}

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.orange,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.orange,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Welcome!',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'VCET TECHZETTE',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text('Upload'),
              onTap: () => _handleUpload(context),
            ),
            ExpansionTile(
              leading: Icon(Icons.info),
              title: Text("About Us"),
              children: [
                ListTile(
                  title: Text("About the Institute"),
                  onTap: () => _handleAbouttheinstitute(context),
                ),
                ListTile(
                  title: Text("About the Department"),
                  onTap: () => _handleAbouttheDep(context),
                ),
                ListTile(
                  title: Text("About the Magazine"),
                  onTap: () => _handleAbouttheMag(context),
                ),
              ],
            ),
            ListTile(
              leading: Icon(Icons.folder),
              title: Text("Articles"),
              onTap: () => _handleArticles(context),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () => _handleLogout(context),
            ),
          ],
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
                } else {
                  return ListTile(
                    title: Text(
                      item['content']!,
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }

  Future<String> fetchWebPage() async {
    final response = await http.get(Uri.parse('https://techz.vcet.edu.in'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load web page');
    }
  }

  List<Map<String, String>> parseContent(String responseBody) {
    final List<Map<String, String>> content = [];
    final dom.Document document = parser.parse(responseBody);

    final List<dom.Element> container = document.querySelectorAll('.page-area');

    for (final element in container) {
      final List<dom.Element> images = element.querySelectorAll('img');
      for (final img in images) {
        final imageUrl = img.attributes['src'] ?? '';
        if (imageUrl.isNotEmpty && imageUrl.startsWith('http')) {
          content.add({'type': 'image', 'content': imageUrl});
        }
      }

      final List<dom.Element> headers = element.querySelectorAll('h1, h2');
      for (final header in headers) {
        final headerText = header.text.trim();
        if (headerText.isNotEmpty) {
          content.add({'type': 'header', 'content': headerText});
        }
      }

      final List<dom.Element> paragraphs = element.querySelectorAll('p');
      for (final paragraph in paragraphs) {
        final paragraphText = paragraph.text.trim();
        if (paragraphText.isNotEmpty) {
          content.add({'type': 'paragraph', 'content': paragraphText});
        }
      }
    }

    return content;
  }

  void _handleUpload(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UploadPage()),
    );
  }

  void _handleLogout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => StudentPage()),
    );
  }

  void _handleAbouttheinstitute(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Abouttheinstitute()),
    );
  }

  void _handleAbouttheDep(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AbouttheDep()),
    );
  }

  void _handleAbouttheMag(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AbouttheMag()),
    );
  }

  void _handleArticles(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const ArticlesPage(
                pdfUrls: [],
              )),
    );
  }
}
