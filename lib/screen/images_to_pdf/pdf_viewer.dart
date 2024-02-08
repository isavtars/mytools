import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:mytools/app/extension.dart';

class PdfViewerPage extends StatefulWidget {
  final File file;

  const PdfViewerPage(this.file, {Key? key}) : super(key: key);

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  PDFViewController? pdfViewController;
  int currentPage = 0;
  int totalPagess = 0;
  bool isReady = false;
  String errorMessage = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: Stack(
        children: [
          PDFView(
            filePath: widget.file.path,
            fitEachPage: true,
            fitPolicy: FitPolicy.BOTH,
            onPageChanged: (page, totalPage) {
              setState(() {
                currentPage = page!;
                totalPagess = totalPage!;
              });
            },
          ),
          Positioned(
              top: 0.4.h(context),
              left: 0.00053.w(context),
              child: Container(
                height: 0.043.h(context),
                width: 0.13.w(context),
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.all(Radius.circular(0.007.h(context))),
                    color: context.theme.primaryColor,
                    shape: BoxShape.rectangle),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    '${currentPage + 1} /',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 0.015.toResponsive(context)),
                  ),
                  Text(
                    '$totalPagess',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 0.015.toResponsive(context)),
                  )
                ]),
              ))
        ],
      ),
    );
  }
}
