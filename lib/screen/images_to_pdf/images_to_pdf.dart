import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:mytools/app/extension.dart';
import 'package:mytools/screen/images_to_pdf/pdf_viewer.dart';
import 'package:path_provider/path_provider.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:get/get.dart';

class ImagesToPdf extends StatefulWidget {
  const ImagesToPdf({Key? key}) : super(key: key);

  @override
  State<ImagesToPdf> createState() => _ImagesToPdfState();
}

class _ImagesToPdfState extends State<ImagesToPdf> {
  List<File> _pickedImages = [];
  int currentPages = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.keyboard_return,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "Images to pdf",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.image,
                allowMultiple: true,
              );

              if (result != null) {
                setState(() {
                  _pickedImages =
                      result.paths!.map((path) => File(path!)).toList();
                });
              }
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 0.13.h(context),
              width: 1.0.w(context),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _pickedImages.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          height: 0.3.h(context),
                          width: 0.35.w(context),
                          margin: EdgeInsets.only(
                              left: index == 0
                                  ? 0
                                  : 0.00002.toResponsive(context)),
                          child: Image.file(_pickedImages[index]),
                        ),
                        Positioned(
                            top: 8,
                            right: 0,
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _pickedImages.removeAt(index);
                                  });
                                },
                                icon: Icon(Icons.deblur)))
                      ],
                    );
                  }),
            ),
            ElevatedButton(
              onPressed: () async {
                final pdf = pw.Document();

                for (var image in _pickedImages) {
                  final imageBytes = await image.readAsBytes();
                  final pdfImage = pw.MemoryImage(imageBytes);

                  pdf.addPage(
                    pw.Page(
                      build: (pw.Context context) {
                        return pw.Center(
                          child: pw.Image(pdfImage),
                        );
                      },
                    ),
                  );
                }

                final output = await getTemporaryDirectory();
                final file = File('${output.path}/images.pdf');
                await file.writeAsBytes(await pdf.save());

                log('PDF file saved at: ${file.path}');

                setState(() {
                  _pickedImages.clear();
                });
                // Show PDF after generating
                openPdf(file);
              },
              child: const Text("Convert"),
            ),
          ],
        ),
      ),
    );
  }

  void openPdf(File file) {
    Get.to(() => PdfViewerPage(file));
  }
}
