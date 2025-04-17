import 'package:file_picker/file_picker.dart';


Future<String?> pickAudio() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['mp3'],
  );

  if (result != null) {
    PlatformFile file = result.files.first;
    return file.path; // Local path to the selected audio file
  } else {
    return null; // File picking was canceled
  }
}
