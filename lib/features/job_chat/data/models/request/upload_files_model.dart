import 'package:trackyond/core/common/enums/media_preview_type.dart';

class UploadFiles {
  final MediaPreviewType type;
  final List<UploadFile> files;

  const UploadFiles({
    required this.type,
    required this.files,
  });
}

class UploadFile {
  final String path;
  final String extension;
  final String mimeType;
  final Map<String, dynamic>? metadata;

  const UploadFile({
    required this.path,
    required this.extension,
    required this.mimeType,
    this.metadata,
  });
}
