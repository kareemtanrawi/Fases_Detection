// import 'dart:html';

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';

class FaceDtetctionScreen extends StatefulWidget {
  const FaceDtetctionScreen({super.key});
  @override
  State<FaceDtetctionScreen> createState() => _FaceDtetctionScreenState();
}

class _FaceDtetctionScreenState extends State<FaceDtetctionScreen> {
  File? _image;
  List<Face> faces = [];
  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      setState(() {
        _image = File(image.path);
      });
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future _detecteFaces(File img) async {
    final options = FaceDetectorOptions();
    final Facedetector = FaceDetector(options: options);
    final inputIamge = InputImage.fromFilePath(img.path);
    faces = await Facedetector.processImage(inputIamge);
    setState(() {});
    print(faces.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Face Detection',
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 250,
                color: Colors.grey,
                child: Center(
                  child: _image == null
                      ? const Icon(
                          Icons.add_a_photo,
                          size: 60,
                        )
                      : Image.file(_image!),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                height: 50,
                color: Colors.blue,
                child: MaterialButton(
                  onPressed: () {
                    _pickImage(ImageSource.camera).then((value) {
                      if (_image != null) {
                        _detecteFaces(_image!);
                      }
                    });
                  },
                  child: const Text(
                    'التقط صوره من الكاميرا',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                height: 50,
                color: Colors.blue,
                child: MaterialButton(
                  onPressed: () {
                    _pickImage(ImageSource.gallery).then((value) {
                      if (_image != null) {
                        _detecteFaces(_image!);
                      }
                    });
                    ;
                  },
                  child: const Text(
                    'اختر صوره من المعرض',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'عدد الاشخاص - ${faces.length}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
