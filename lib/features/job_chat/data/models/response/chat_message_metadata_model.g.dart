// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_metadata_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatMessageMetadataModel _$ChatMessageMetadataModelFromJson(
  Map<String, dynamic> json,
) => _ChatMessageMetadataModel(
  fileName: json['fileName'] as String?,
  size: json['size'] as String?,
  mimeType: json['mimeType'] as String?,
  videoMetadata: json['videoMetadata'] == null
      ? null
      : VideoMetadataModel.fromJson(
          json['videoMetadata'] as Map<String, dynamic>,
        ),
  imageMetadata: json['imageMetadata'] == null
      ? null
      : ImageMetadataModel.fromJson(
          json['imageMetadata'] as Map<String, dynamic>,
        ),
  pdfMetadata: json['pdfMetadata'] == null
      ? null
      : PdfMetadataModel.fromJson(json['pdfMetadata'] as Map<String, dynamic>),
  documentMetadata: json['documentMetadata'] == null
      ? null
      : DocumentMetadataModel.fromJson(
          json['documentMetadata'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$ChatMessageMetadataModelToJson(
  _ChatMessageMetadataModel instance,
) => <String, dynamic>{
  'fileName': instance.fileName,
  'size': instance.size,
  'mimeType': instance.mimeType,
  'videoMetadata': instance.videoMetadata?.toJson(),
  'imageMetadata': instance.imageMetadata?.toJson(),
  'pdfMetadata': instance.pdfMetadata?.toJson(),
  'documentMetadata': instance.documentMetadata?.toJson(),
};

_VideoMetadataModel _$VideoMetadataModelFromJson(Map<String, dynamic> json) =>
    _VideoMetadataModel(
      aspectRatio: (json['aspectRatio'] as num).toDouble(),
      duration: (json['duration'] as num).toInt(),
      thumbnailBlurHash: json['thumbnailBlurHash'] as String,
    );

Map<String, dynamic> _$VideoMetadataModelToJson(_VideoMetadataModel instance) =>
    <String, dynamic>{
      'aspectRatio': instance.aspectRatio,
      'duration': instance.duration,
      'thumbnailBlurHash': instance.thumbnailBlurHash,
    };

_ImageMetadataModel _$ImageMetadataModelFromJson(Map<String, dynamic> json) =>
    _ImageMetadataModel(
      width: (json['width'] as num).toInt(),
      height: (json['height'] as num).toInt(),
      blurHash: json['blurHash'] as String,
    );

Map<String, dynamic> _$ImageMetadataModelToJson(_ImageMetadataModel instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'blurHash': instance.blurHash,
    };

_PdfMetadataModel _$PdfMetadataModelFromJson(Map<String, dynamic> json) =>
    _PdfMetadataModel(
      extension: json['extension'] as String,
      pageCount: (json['pageCount'] as num).toInt(),
    );

Map<String, dynamic> _$PdfMetadataModelToJson(_PdfMetadataModel instance) =>
    <String, dynamic>{
      'extension': instance.extension,
      'pageCount': instance.pageCount,
    };

_DocumentMetadataModel _$DocumentMetadataModelFromJson(
  Map<String, dynamic> json,
) => _DocumentMetadataModel(
  extension: json['extension'] as String,
  pageCount: (json['pageCount'] as num?)?.toInt(),
);

Map<String, dynamic> _$DocumentMetadataModelToJson(
  _DocumentMetadataModel instance,
) => <String, dynamic>{
  'extension': instance.extension,
  'pageCount': instance.pageCount,
};
