import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message_metadata_model.freezed.dart';
part 'chat_message_metadata_model.g.dart';

@freezed
sealed class ChatMessageMetadataModel with _$ChatMessageMetadataModel {
  const factory ChatMessageMetadataModel({
    String? fileName,
    String? size,
    String? mimeType,
    VideoMetadataModel? videoMetadata,
    ImageMetadataModel? imageMetadata,
    PdfMetadataModel? pdfMetadata,
    DocumentMetadataModel? documentMetadata,
  }) = _ChatMessageMetadataModel;

  const ChatMessageMetadataModel._();

  dynamic operator [](String key) {
    switch (key) {
      case 'fileName':
        return fileName;
      case 'size':
        return size;
      case 'mimeType':
        return mimeType;
      case 'videoMetadata':
        return videoMetadata?.toJson();
      case 'imageMetadata':
        return imageMetadata?.toJson();
      case 'pdfMetadata':
        return pdfMetadata?.toJson();
      case 'documentMetadata':
        return documentMetadata?.toJson();
      default:
        return null;
    }
  }

  factory ChatMessageMetadataModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageMetadataModelFromJson(json);
}

@freezed
sealed class VideoMetadataModel with _$VideoMetadataModel {
  const factory VideoMetadataModel({
    required double aspectRatio,
    required int duration,
    required String thumbnailBlurHash,
  }) = _VideoMetadataModel;

  const VideoMetadataModel._();

  factory VideoMetadataModel.fromJson(Map<String, dynamic> json) =>
      _$VideoMetadataModelFromJson(json);
}

@freezed
sealed class ImageMetadataModel with _$ImageMetadataModel {
  const factory ImageMetadataModel({
    required int width,
    required int height,
    required String blurHash,
  }) = _ImageMetadataModel;

  const ImageMetadataModel._();

  factory ImageMetadataModel.fromJson(Map<String, dynamic> json) =>
      _$ImageMetadataModelFromJson(json);
}

@freezed
sealed class PdfMetadataModel with _$PdfMetadataModel {
  const factory PdfMetadataModel({
    required String extension,
    required int pageCount,
  }) = _PdfMetadataModel;

  const PdfMetadataModel._();

  factory PdfMetadataModel.fromJson(Map<String, dynamic> json) =>
      _$PdfMetadataModelFromJson(json);
}

@freezed
sealed class DocumentMetadataModel with _$DocumentMetadataModel {
  const factory DocumentMetadataModel({
    required String extension,
    int? pageCount,
  }) = _DocumentMetadataModel;

  const DocumentMetadataModel._();

  factory DocumentMetadataModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentMetadataModelFromJson(json);
}
