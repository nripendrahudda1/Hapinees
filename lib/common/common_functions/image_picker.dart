 import 'package:image_picker/image_picker.dart';

Future<String?> getGalleryImage()async {
  XFile? imgFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  return imgFile?.path;
}

Future<String?> getCameraImage()async {
  XFile? imgFile = await ImagePicker().pickImage(source: ImageSource.camera);
  return imgFile?.path;
}