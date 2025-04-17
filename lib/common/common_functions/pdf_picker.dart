import 'package:file_picker/file_picker.dart';

Future<String?> getPdf() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );

  if (result != null) {
    PlatformFile file = result.files.first;
    return file.path;
  } else {
    return null;
  }
}
