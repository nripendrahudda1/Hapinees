import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PDFViewer extends StatefulWidget {
  final String pdfUrl;

  const PDFViewer({super.key, required this.pdfUrl});

  @override
  _PDFViewerState createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  bool _isLoading = true;
  String? _localFilePath;

  @override
  void initState() {
    super.initState();
    _initPdf();
  }

  Future<void> _initPdf() async {
    final url = widget.pdfUrl;
    final filename = url.split('/').last;
    final request = await http.get(Uri.parse(url));
    final bytes = request.bodyBytes;
    final dir = await getApplicationCacheDirectory();
    final path = '${dir.path}/$filename';
    final file = File(path);
    await file.writeAsBytes(bytes);

    if (mounted) {
      setState(() {
        _isLoading = false;
        _localFilePath = path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : PDFView(
        filePath: _localFilePath!,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: false,
        onError: (error) {
          print(error);
        },
      ),
    );
  }
}
