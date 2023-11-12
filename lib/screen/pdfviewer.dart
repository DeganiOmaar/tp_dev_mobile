import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path/path.dart';
import 'package:tp_dev_mobile/constant.dart';

class PDFViewerPage extends StatefulWidget {
  final File file;
  const PDFViewerPage({super.key, required this.file});

  @override
  State<PDFViewerPage> createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  @override
  Widget build(BuildContext context) {
    final name = basename(widget.file.path);
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: blackColor,
      ),
      body: PDFView(
        filePath: widget.file.path,
      ),
    );
  }
}