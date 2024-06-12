import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePackerHelper {
  static Future<File?> pickImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      print('Image Path: ${pickedFile.path}');

      return File(pickedFile.path);
    }
    return null;
  }
}