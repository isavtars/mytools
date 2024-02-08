import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytools/app/extension.dart';
import 'package:mytools/screen/images_to_pdf/images_to_pdf.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MyTools"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 0.033.w(context)),
        child: Column(children: [
          SizedBox(
            height: 0.021.h(context),
          ),
          ElevatedButton(
              onPressed: () {
                Get.to(() => const ImagesToPdf());
              },
              child: const Text("Images to pdf"))
        ]),
      ),
    );
  }
}
