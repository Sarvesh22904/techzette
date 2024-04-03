import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class PdfViewerPage extends StatefulWidget {
  final String url;

  const PdfViewerPage({Key? key, required this.url}) : super(key: key);

  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  String? localPath;

  @override
  void initState() {
    super.initState();
    downloadFile();
  }

  Future<void> downloadFile() async {
    Dio dio = Dio();
    try {
      var dir = await getTemporaryDirectory();
      String pdfPath = '${dir.path}/pdfTemp.pdf';
      await dio.download(widget.url, pdfPath);
      setState(() {
        localPath = pdfPath;
      });
    } catch (e) {
      print(e);
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View PDF'),
      ),
      body: localPath != null
          ? PDFView(
              filePath: localPath,
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: false,
              pageFling: false,
              onError: (error) {
                print(error.toString());
              },
              onPageError: (page, error) {
                print('$page: ${error.toString()}');
              },
            )
          : Center(
              child:
                  CircularProgressIndicator()), // Show loading indicator while downloading
    );
  }
}
