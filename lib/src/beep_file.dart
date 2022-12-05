class BeepFile {
  const BeepFile(
    this.assetFileName, {
    this.package,
  });

  final String assetFileName;
  final String? package;
}

extension BeepFileFullPath on BeepFile {
  String get toFullPath {
    final String path =
        package != null ? 'packages/$package/$assetFileName' : assetFileName;
    return path;
  }
}
