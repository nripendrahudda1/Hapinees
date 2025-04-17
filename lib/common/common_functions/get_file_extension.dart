String getFileExtension({required String path}) {
  int dotIndex = path.lastIndexOf('.');

  if (dotIndex != -1 && dotIndex < path.length - 1) {
    return path.substring(dotIndex + 1);
  } else {
    return '';
  }
}
