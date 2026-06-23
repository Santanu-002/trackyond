// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message_metadata_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatMessageMetadataModel {

 String? get fileName; String? get size; String? get mimeType; VideoMetadataModel? get videoMetadata; ImageMetadataModel? get imageMetadata; PdfMetadataModel? get pdfMetadata; DocumentMetadataModel? get documentMetadata;
/// Create a copy of ChatMessageMetadataModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMessageMetadataModelCopyWith<ChatMessageMetadataModel> get copyWith => _$ChatMessageMetadataModelCopyWithImpl<ChatMessageMetadataModel>(this as ChatMessageMetadataModel, _$identity);

  /// Serializes this ChatMessageMetadataModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMessageMetadataModel&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.size, size) || other.size == size)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.videoMetadata, videoMetadata) || other.videoMetadata == videoMetadata)&&(identical(other.imageMetadata, imageMetadata) || other.imageMetadata == imageMetadata)&&(identical(other.pdfMetadata, pdfMetadata) || other.pdfMetadata == pdfMetadata)&&(identical(other.documentMetadata, documentMetadata) || other.documentMetadata == documentMetadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileName,size,mimeType,videoMetadata,imageMetadata,pdfMetadata,documentMetadata);

@override
String toString() {
  return 'ChatMessageMetadataModel(fileName: $fileName, size: $size, mimeType: $mimeType, videoMetadata: $videoMetadata, imageMetadata: $imageMetadata, pdfMetadata: $pdfMetadata, documentMetadata: $documentMetadata)';
}


}

/// @nodoc
abstract mixin class $ChatMessageMetadataModelCopyWith<$Res>  {
  factory $ChatMessageMetadataModelCopyWith(ChatMessageMetadataModel value, $Res Function(ChatMessageMetadataModel) _then) = _$ChatMessageMetadataModelCopyWithImpl;
@useResult
$Res call({
 String? fileName, String? size, String? mimeType, VideoMetadataModel? videoMetadata, ImageMetadataModel? imageMetadata, PdfMetadataModel? pdfMetadata, DocumentMetadataModel? documentMetadata
});


$VideoMetadataModelCopyWith<$Res>? get videoMetadata;$ImageMetadataModelCopyWith<$Res>? get imageMetadata;$PdfMetadataModelCopyWith<$Res>? get pdfMetadata;$DocumentMetadataModelCopyWith<$Res>? get documentMetadata;

}
/// @nodoc
class _$ChatMessageMetadataModelCopyWithImpl<$Res>
    implements $ChatMessageMetadataModelCopyWith<$Res> {
  _$ChatMessageMetadataModelCopyWithImpl(this._self, this._then);

  final ChatMessageMetadataModel _self;
  final $Res Function(ChatMessageMetadataModel) _then;

/// Create a copy of ChatMessageMetadataModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileName = freezed,Object? size = freezed,Object? mimeType = freezed,Object? videoMetadata = freezed,Object? imageMetadata = freezed,Object? pdfMetadata = freezed,Object? documentMetadata = freezed,}) {
  return _then(_self.copyWith(
fileName: freezed == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as String?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,videoMetadata: freezed == videoMetadata ? _self.videoMetadata : videoMetadata // ignore: cast_nullable_to_non_nullable
as VideoMetadataModel?,imageMetadata: freezed == imageMetadata ? _self.imageMetadata : imageMetadata // ignore: cast_nullable_to_non_nullable
as ImageMetadataModel?,pdfMetadata: freezed == pdfMetadata ? _self.pdfMetadata : pdfMetadata // ignore: cast_nullable_to_non_nullable
as PdfMetadataModel?,documentMetadata: freezed == documentMetadata ? _self.documentMetadata : documentMetadata // ignore: cast_nullable_to_non_nullable
as DocumentMetadataModel?,
  ));
}
/// Create a copy of ChatMessageMetadataModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VideoMetadataModelCopyWith<$Res>? get videoMetadata {
    if (_self.videoMetadata == null) {
    return null;
  }

  return $VideoMetadataModelCopyWith<$Res>(_self.videoMetadata!, (value) {
    return _then(_self.copyWith(videoMetadata: value));
  });
}/// Create a copy of ChatMessageMetadataModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ImageMetadataModelCopyWith<$Res>? get imageMetadata {
    if (_self.imageMetadata == null) {
    return null;
  }

  return $ImageMetadataModelCopyWith<$Res>(_self.imageMetadata!, (value) {
    return _then(_self.copyWith(imageMetadata: value));
  });
}/// Create a copy of ChatMessageMetadataModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PdfMetadataModelCopyWith<$Res>? get pdfMetadata {
    if (_self.pdfMetadata == null) {
    return null;
  }

  return $PdfMetadataModelCopyWith<$Res>(_self.pdfMetadata!, (value) {
    return _then(_self.copyWith(pdfMetadata: value));
  });
}/// Create a copy of ChatMessageMetadataModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DocumentMetadataModelCopyWith<$Res>? get documentMetadata {
    if (_self.documentMetadata == null) {
    return null;
  }

  return $DocumentMetadataModelCopyWith<$Res>(_self.documentMetadata!, (value) {
    return _then(_self.copyWith(documentMetadata: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChatMessageMetadataModel].
extension ChatMessageMetadataModelPatterns on ChatMessageMetadataModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMessageMetadataModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMessageMetadataModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMessageMetadataModel value)  $default,){
final _that = this;
switch (_that) {
case _ChatMessageMetadataModel():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMessageMetadataModel value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMessageMetadataModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? fileName,  String? size,  String? mimeType,  VideoMetadataModel? videoMetadata,  ImageMetadataModel? imageMetadata,  PdfMetadataModel? pdfMetadata,  DocumentMetadataModel? documentMetadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatMessageMetadataModel() when $default != null:
return $default(_that.fileName,_that.size,_that.mimeType,_that.videoMetadata,_that.imageMetadata,_that.pdfMetadata,_that.documentMetadata);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? fileName,  String? size,  String? mimeType,  VideoMetadataModel? videoMetadata,  ImageMetadataModel? imageMetadata,  PdfMetadataModel? pdfMetadata,  DocumentMetadataModel? documentMetadata)  $default,) {final _that = this;
switch (_that) {
case _ChatMessageMetadataModel():
return $default(_that.fileName,_that.size,_that.mimeType,_that.videoMetadata,_that.imageMetadata,_that.pdfMetadata,_that.documentMetadata);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? fileName,  String? size,  String? mimeType,  VideoMetadataModel? videoMetadata,  ImageMetadataModel? imageMetadata,  PdfMetadataModel? pdfMetadata,  DocumentMetadataModel? documentMetadata)?  $default,) {final _that = this;
switch (_that) {
case _ChatMessageMetadataModel() when $default != null:
return $default(_that.fileName,_that.size,_that.mimeType,_that.videoMetadata,_that.imageMetadata,_that.pdfMetadata,_that.documentMetadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatMessageMetadataModel extends ChatMessageMetadataModel {
  const _ChatMessageMetadataModel({this.fileName, this.size, this.mimeType, this.videoMetadata, this.imageMetadata, this.pdfMetadata, this.documentMetadata}): super._();
  factory _ChatMessageMetadataModel.fromJson(Map<String, dynamic> json) => _$ChatMessageMetadataModelFromJson(json);

@override final  String? fileName;
@override final  String? size;
@override final  String? mimeType;
@override final  VideoMetadataModel? videoMetadata;
@override final  ImageMetadataModel? imageMetadata;
@override final  PdfMetadataModel? pdfMetadata;
@override final  DocumentMetadataModel? documentMetadata;

/// Create a copy of ChatMessageMetadataModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMessageMetadataModelCopyWith<_ChatMessageMetadataModel> get copyWith => __$ChatMessageMetadataModelCopyWithImpl<_ChatMessageMetadataModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatMessageMetadataModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMessageMetadataModel&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.size, size) || other.size == size)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.videoMetadata, videoMetadata) || other.videoMetadata == videoMetadata)&&(identical(other.imageMetadata, imageMetadata) || other.imageMetadata == imageMetadata)&&(identical(other.pdfMetadata, pdfMetadata) || other.pdfMetadata == pdfMetadata)&&(identical(other.documentMetadata, documentMetadata) || other.documentMetadata == documentMetadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileName,size,mimeType,videoMetadata,imageMetadata,pdfMetadata,documentMetadata);

@override
String toString() {
  return 'ChatMessageMetadataModel(fileName: $fileName, size: $size, mimeType: $mimeType, videoMetadata: $videoMetadata, imageMetadata: $imageMetadata, pdfMetadata: $pdfMetadata, documentMetadata: $documentMetadata)';
}


}

/// @nodoc
abstract mixin class _$ChatMessageMetadataModelCopyWith<$Res> implements $ChatMessageMetadataModelCopyWith<$Res> {
  factory _$ChatMessageMetadataModelCopyWith(_ChatMessageMetadataModel value, $Res Function(_ChatMessageMetadataModel) _then) = __$ChatMessageMetadataModelCopyWithImpl;
@override @useResult
$Res call({
 String? fileName, String? size, String? mimeType, VideoMetadataModel? videoMetadata, ImageMetadataModel? imageMetadata, PdfMetadataModel? pdfMetadata, DocumentMetadataModel? documentMetadata
});


@override $VideoMetadataModelCopyWith<$Res>? get videoMetadata;@override $ImageMetadataModelCopyWith<$Res>? get imageMetadata;@override $PdfMetadataModelCopyWith<$Res>? get pdfMetadata;@override $DocumentMetadataModelCopyWith<$Res>? get documentMetadata;

}
/// @nodoc
class __$ChatMessageMetadataModelCopyWithImpl<$Res>
    implements _$ChatMessageMetadataModelCopyWith<$Res> {
  __$ChatMessageMetadataModelCopyWithImpl(this._self, this._then);

  final _ChatMessageMetadataModel _self;
  final $Res Function(_ChatMessageMetadataModel) _then;

/// Create a copy of ChatMessageMetadataModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileName = freezed,Object? size = freezed,Object? mimeType = freezed,Object? videoMetadata = freezed,Object? imageMetadata = freezed,Object? pdfMetadata = freezed,Object? documentMetadata = freezed,}) {
  return _then(_ChatMessageMetadataModel(
fileName: freezed == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as String?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,videoMetadata: freezed == videoMetadata ? _self.videoMetadata : videoMetadata // ignore: cast_nullable_to_non_nullable
as VideoMetadataModel?,imageMetadata: freezed == imageMetadata ? _self.imageMetadata : imageMetadata // ignore: cast_nullable_to_non_nullable
as ImageMetadataModel?,pdfMetadata: freezed == pdfMetadata ? _self.pdfMetadata : pdfMetadata // ignore: cast_nullable_to_non_nullable
as PdfMetadataModel?,documentMetadata: freezed == documentMetadata ? _self.documentMetadata : documentMetadata // ignore: cast_nullable_to_non_nullable
as DocumentMetadataModel?,
  ));
}

/// Create a copy of ChatMessageMetadataModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VideoMetadataModelCopyWith<$Res>? get videoMetadata {
    if (_self.videoMetadata == null) {
    return null;
  }

  return $VideoMetadataModelCopyWith<$Res>(_self.videoMetadata!, (value) {
    return _then(_self.copyWith(videoMetadata: value));
  });
}/// Create a copy of ChatMessageMetadataModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ImageMetadataModelCopyWith<$Res>? get imageMetadata {
    if (_self.imageMetadata == null) {
    return null;
  }

  return $ImageMetadataModelCopyWith<$Res>(_self.imageMetadata!, (value) {
    return _then(_self.copyWith(imageMetadata: value));
  });
}/// Create a copy of ChatMessageMetadataModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PdfMetadataModelCopyWith<$Res>? get pdfMetadata {
    if (_self.pdfMetadata == null) {
    return null;
  }

  return $PdfMetadataModelCopyWith<$Res>(_self.pdfMetadata!, (value) {
    return _then(_self.copyWith(pdfMetadata: value));
  });
}/// Create a copy of ChatMessageMetadataModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DocumentMetadataModelCopyWith<$Res>? get documentMetadata {
    if (_self.documentMetadata == null) {
    return null;
  }

  return $DocumentMetadataModelCopyWith<$Res>(_self.documentMetadata!, (value) {
    return _then(_self.copyWith(documentMetadata: value));
  });
}
}


/// @nodoc
mixin _$VideoMetadataModel {

 double get aspectRatio; int get duration; String get thumbnailBlurHash;
/// Create a copy of VideoMetadataModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VideoMetadataModelCopyWith<VideoMetadataModel> get copyWith => _$VideoMetadataModelCopyWithImpl<VideoMetadataModel>(this as VideoMetadataModel, _$identity);

  /// Serializes this VideoMetadataModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideoMetadataModel&&(identical(other.aspectRatio, aspectRatio) || other.aspectRatio == aspectRatio)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.thumbnailBlurHash, thumbnailBlurHash) || other.thumbnailBlurHash == thumbnailBlurHash));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,aspectRatio,duration,thumbnailBlurHash);

@override
String toString() {
  return 'VideoMetadataModel(aspectRatio: $aspectRatio, duration: $duration, thumbnailBlurHash: $thumbnailBlurHash)';
}


}

/// @nodoc
abstract mixin class $VideoMetadataModelCopyWith<$Res>  {
  factory $VideoMetadataModelCopyWith(VideoMetadataModel value, $Res Function(VideoMetadataModel) _then) = _$VideoMetadataModelCopyWithImpl;
@useResult
$Res call({
 double aspectRatio, int duration, String thumbnailBlurHash
});




}
/// @nodoc
class _$VideoMetadataModelCopyWithImpl<$Res>
    implements $VideoMetadataModelCopyWith<$Res> {
  _$VideoMetadataModelCopyWithImpl(this._self, this._then);

  final VideoMetadataModel _self;
  final $Res Function(VideoMetadataModel) _then;

/// Create a copy of VideoMetadataModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? aspectRatio = null,Object? duration = null,Object? thumbnailBlurHash = null,}) {
  return _then(_self.copyWith(
aspectRatio: null == aspectRatio ? _self.aspectRatio : aspectRatio // ignore: cast_nullable_to_non_nullable
as double,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,thumbnailBlurHash: null == thumbnailBlurHash ? _self.thumbnailBlurHash : thumbnailBlurHash // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [VideoMetadataModel].
extension VideoMetadataModelPatterns on VideoMetadataModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VideoMetadataModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VideoMetadataModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VideoMetadataModel value)  $default,){
final _that = this;
switch (_that) {
case _VideoMetadataModel():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VideoMetadataModel value)?  $default,){
final _that = this;
switch (_that) {
case _VideoMetadataModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double aspectRatio,  int duration,  String thumbnailBlurHash)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VideoMetadataModel() when $default != null:
return $default(_that.aspectRatio,_that.duration,_that.thumbnailBlurHash);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double aspectRatio,  int duration,  String thumbnailBlurHash)  $default,) {final _that = this;
switch (_that) {
case _VideoMetadataModel():
return $default(_that.aspectRatio,_that.duration,_that.thumbnailBlurHash);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double aspectRatio,  int duration,  String thumbnailBlurHash)?  $default,) {final _that = this;
switch (_that) {
case _VideoMetadataModel() when $default != null:
return $default(_that.aspectRatio,_that.duration,_that.thumbnailBlurHash);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VideoMetadataModel extends VideoMetadataModel {
  const _VideoMetadataModel({required this.aspectRatio, required this.duration, required this.thumbnailBlurHash}): super._();
  factory _VideoMetadataModel.fromJson(Map<String, dynamic> json) => _$VideoMetadataModelFromJson(json);

@override final  double aspectRatio;
@override final  int duration;
@override final  String thumbnailBlurHash;

/// Create a copy of VideoMetadataModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VideoMetadataModelCopyWith<_VideoMetadataModel> get copyWith => __$VideoMetadataModelCopyWithImpl<_VideoMetadataModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VideoMetadataModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VideoMetadataModel&&(identical(other.aspectRatio, aspectRatio) || other.aspectRatio == aspectRatio)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.thumbnailBlurHash, thumbnailBlurHash) || other.thumbnailBlurHash == thumbnailBlurHash));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,aspectRatio,duration,thumbnailBlurHash);

@override
String toString() {
  return 'VideoMetadataModel(aspectRatio: $aspectRatio, duration: $duration, thumbnailBlurHash: $thumbnailBlurHash)';
}


}

/// @nodoc
abstract mixin class _$VideoMetadataModelCopyWith<$Res> implements $VideoMetadataModelCopyWith<$Res> {
  factory _$VideoMetadataModelCopyWith(_VideoMetadataModel value, $Res Function(_VideoMetadataModel) _then) = __$VideoMetadataModelCopyWithImpl;
@override @useResult
$Res call({
 double aspectRatio, int duration, String thumbnailBlurHash
});




}
/// @nodoc
class __$VideoMetadataModelCopyWithImpl<$Res>
    implements _$VideoMetadataModelCopyWith<$Res> {
  __$VideoMetadataModelCopyWithImpl(this._self, this._then);

  final _VideoMetadataModel _self;
  final $Res Function(_VideoMetadataModel) _then;

/// Create a copy of VideoMetadataModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? aspectRatio = null,Object? duration = null,Object? thumbnailBlurHash = null,}) {
  return _then(_VideoMetadataModel(
aspectRatio: null == aspectRatio ? _self.aspectRatio : aspectRatio // ignore: cast_nullable_to_non_nullable
as double,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,thumbnailBlurHash: null == thumbnailBlurHash ? _self.thumbnailBlurHash : thumbnailBlurHash // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ImageMetadataModel {

 int get width; int get height; String get blurHash;
/// Create a copy of ImageMetadataModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImageMetadataModelCopyWith<ImageMetadataModel> get copyWith => _$ImageMetadataModelCopyWithImpl<ImageMetadataModel>(this as ImageMetadataModel, _$identity);

  /// Serializes this ImageMetadataModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImageMetadataModel&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.blurHash, blurHash) || other.blurHash == blurHash));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,width,height,blurHash);

@override
String toString() {
  return 'ImageMetadataModel(width: $width, height: $height, blurHash: $blurHash)';
}


}

/// @nodoc
abstract mixin class $ImageMetadataModelCopyWith<$Res>  {
  factory $ImageMetadataModelCopyWith(ImageMetadataModel value, $Res Function(ImageMetadataModel) _then) = _$ImageMetadataModelCopyWithImpl;
@useResult
$Res call({
 int width, int height, String blurHash
});




}
/// @nodoc
class _$ImageMetadataModelCopyWithImpl<$Res>
    implements $ImageMetadataModelCopyWith<$Res> {
  _$ImageMetadataModelCopyWithImpl(this._self, this._then);

  final ImageMetadataModel _self;
  final $Res Function(ImageMetadataModel) _then;

/// Create a copy of ImageMetadataModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? width = null,Object? height = null,Object? blurHash = null,}) {
  return _then(_self.copyWith(
width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,blurHash: null == blurHash ? _self.blurHash : blurHash // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ImageMetadataModel].
extension ImageMetadataModelPatterns on ImageMetadataModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImageMetadataModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImageMetadataModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImageMetadataModel value)  $default,){
final _that = this;
switch (_that) {
case _ImageMetadataModel():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImageMetadataModel value)?  $default,){
final _that = this;
switch (_that) {
case _ImageMetadataModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int width,  int height,  String blurHash)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImageMetadataModel() when $default != null:
return $default(_that.width,_that.height,_that.blurHash);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int width,  int height,  String blurHash)  $default,) {final _that = this;
switch (_that) {
case _ImageMetadataModel():
return $default(_that.width,_that.height,_that.blurHash);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int width,  int height,  String blurHash)?  $default,) {final _that = this;
switch (_that) {
case _ImageMetadataModel() when $default != null:
return $default(_that.width,_that.height,_that.blurHash);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ImageMetadataModel extends ImageMetadataModel {
  const _ImageMetadataModel({required this.width, required this.height, required this.blurHash}): super._();
  factory _ImageMetadataModel.fromJson(Map<String, dynamic> json) => _$ImageMetadataModelFromJson(json);

@override final  int width;
@override final  int height;
@override final  String blurHash;

/// Create a copy of ImageMetadataModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImageMetadataModelCopyWith<_ImageMetadataModel> get copyWith => __$ImageMetadataModelCopyWithImpl<_ImageMetadataModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ImageMetadataModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImageMetadataModel&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.blurHash, blurHash) || other.blurHash == blurHash));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,width,height,blurHash);

@override
String toString() {
  return 'ImageMetadataModel(width: $width, height: $height, blurHash: $blurHash)';
}


}

/// @nodoc
abstract mixin class _$ImageMetadataModelCopyWith<$Res> implements $ImageMetadataModelCopyWith<$Res> {
  factory _$ImageMetadataModelCopyWith(_ImageMetadataModel value, $Res Function(_ImageMetadataModel) _then) = __$ImageMetadataModelCopyWithImpl;
@override @useResult
$Res call({
 int width, int height, String blurHash
});




}
/// @nodoc
class __$ImageMetadataModelCopyWithImpl<$Res>
    implements _$ImageMetadataModelCopyWith<$Res> {
  __$ImageMetadataModelCopyWithImpl(this._self, this._then);

  final _ImageMetadataModel _self;
  final $Res Function(_ImageMetadataModel) _then;

/// Create a copy of ImageMetadataModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? width = null,Object? height = null,Object? blurHash = null,}) {
  return _then(_ImageMetadataModel(
width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,blurHash: null == blurHash ? _self.blurHash : blurHash // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$PdfMetadataModel {

 String get extension; int get pageCount;
/// Create a copy of PdfMetadataModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PdfMetadataModelCopyWith<PdfMetadataModel> get copyWith => _$PdfMetadataModelCopyWithImpl<PdfMetadataModel>(this as PdfMetadataModel, _$identity);

  /// Serializes this PdfMetadataModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PdfMetadataModel&&(identical(other.extension, extension) || other.extension == extension)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,extension,pageCount);

@override
String toString() {
  return 'PdfMetadataModel(extension: $extension, pageCount: $pageCount)';
}


}

/// @nodoc
abstract mixin class $PdfMetadataModelCopyWith<$Res>  {
  factory $PdfMetadataModelCopyWith(PdfMetadataModel value, $Res Function(PdfMetadataModel) _then) = _$PdfMetadataModelCopyWithImpl;
@useResult
$Res call({
 String extension, int pageCount
});




}
/// @nodoc
class _$PdfMetadataModelCopyWithImpl<$Res>
    implements $PdfMetadataModelCopyWith<$Res> {
  _$PdfMetadataModelCopyWithImpl(this._self, this._then);

  final PdfMetadataModel _self;
  final $Res Function(PdfMetadataModel) _then;

/// Create a copy of PdfMetadataModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? extension = null,Object? pageCount = null,}) {
  return _then(_self.copyWith(
extension: null == extension ? _self.extension : extension // ignore: cast_nullable_to_non_nullable
as String,pageCount: null == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PdfMetadataModel].
extension PdfMetadataModelPatterns on PdfMetadataModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PdfMetadataModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PdfMetadataModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PdfMetadataModel value)  $default,){
final _that = this;
switch (_that) {
case _PdfMetadataModel():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PdfMetadataModel value)?  $default,){
final _that = this;
switch (_that) {
case _PdfMetadataModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String extension,  int pageCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PdfMetadataModel() when $default != null:
return $default(_that.extension,_that.pageCount);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String extension,  int pageCount)  $default,) {final _that = this;
switch (_that) {
case _PdfMetadataModel():
return $default(_that.extension,_that.pageCount);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String extension,  int pageCount)?  $default,) {final _that = this;
switch (_that) {
case _PdfMetadataModel() when $default != null:
return $default(_that.extension,_that.pageCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PdfMetadataModel extends PdfMetadataModel {
  const _PdfMetadataModel({required this.extension, required this.pageCount}): super._();
  factory _PdfMetadataModel.fromJson(Map<String, dynamic> json) => _$PdfMetadataModelFromJson(json);

@override final  String extension;
@override final  int pageCount;

/// Create a copy of PdfMetadataModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PdfMetadataModelCopyWith<_PdfMetadataModel> get copyWith => __$PdfMetadataModelCopyWithImpl<_PdfMetadataModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PdfMetadataModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PdfMetadataModel&&(identical(other.extension, extension) || other.extension == extension)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,extension,pageCount);

@override
String toString() {
  return 'PdfMetadataModel(extension: $extension, pageCount: $pageCount)';
}


}

/// @nodoc
abstract mixin class _$PdfMetadataModelCopyWith<$Res> implements $PdfMetadataModelCopyWith<$Res> {
  factory _$PdfMetadataModelCopyWith(_PdfMetadataModel value, $Res Function(_PdfMetadataModel) _then) = __$PdfMetadataModelCopyWithImpl;
@override @useResult
$Res call({
 String extension, int pageCount
});




}
/// @nodoc
class __$PdfMetadataModelCopyWithImpl<$Res>
    implements _$PdfMetadataModelCopyWith<$Res> {
  __$PdfMetadataModelCopyWithImpl(this._self, this._then);

  final _PdfMetadataModel _self;
  final $Res Function(_PdfMetadataModel) _then;

/// Create a copy of PdfMetadataModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? extension = null,Object? pageCount = null,}) {
  return _then(_PdfMetadataModel(
extension: null == extension ? _self.extension : extension // ignore: cast_nullable_to_non_nullable
as String,pageCount: null == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$DocumentMetadataModel {

 String get extension; int? get pageCount;
/// Create a copy of DocumentMetadataModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentMetadataModelCopyWith<DocumentMetadataModel> get copyWith => _$DocumentMetadataModelCopyWithImpl<DocumentMetadataModel>(this as DocumentMetadataModel, _$identity);

  /// Serializes this DocumentMetadataModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentMetadataModel&&(identical(other.extension, extension) || other.extension == extension)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,extension,pageCount);

@override
String toString() {
  return 'DocumentMetadataModel(extension: $extension, pageCount: $pageCount)';
}


}

/// @nodoc
abstract mixin class $DocumentMetadataModelCopyWith<$Res>  {
  factory $DocumentMetadataModelCopyWith(DocumentMetadataModel value, $Res Function(DocumentMetadataModel) _then) = _$DocumentMetadataModelCopyWithImpl;
@useResult
$Res call({
 String extension, int? pageCount
});




}
/// @nodoc
class _$DocumentMetadataModelCopyWithImpl<$Res>
    implements $DocumentMetadataModelCopyWith<$Res> {
  _$DocumentMetadataModelCopyWithImpl(this._self, this._then);

  final DocumentMetadataModel _self;
  final $Res Function(DocumentMetadataModel) _then;

/// Create a copy of DocumentMetadataModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? extension = null,Object? pageCount = freezed,}) {
  return _then(_self.copyWith(
extension: null == extension ? _self.extension : extension // ignore: cast_nullable_to_non_nullable
as String,pageCount: freezed == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [DocumentMetadataModel].
extension DocumentMetadataModelPatterns on DocumentMetadataModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DocumentMetadataModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DocumentMetadataModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DocumentMetadataModel value)  $default,){
final _that = this;
switch (_that) {
case _DocumentMetadataModel():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DocumentMetadataModel value)?  $default,){
final _that = this;
switch (_that) {
case _DocumentMetadataModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String extension,  int? pageCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DocumentMetadataModel() when $default != null:
return $default(_that.extension,_that.pageCount);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String extension,  int? pageCount)  $default,) {final _that = this;
switch (_that) {
case _DocumentMetadataModel():
return $default(_that.extension,_that.pageCount);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String extension,  int? pageCount)?  $default,) {final _that = this;
switch (_that) {
case _DocumentMetadataModel() when $default != null:
return $default(_that.extension,_that.pageCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DocumentMetadataModel extends DocumentMetadataModel {
  const _DocumentMetadataModel({required this.extension, this.pageCount}): super._();
  factory _DocumentMetadataModel.fromJson(Map<String, dynamic> json) => _$DocumentMetadataModelFromJson(json);

@override final  String extension;
@override final  int? pageCount;

/// Create a copy of DocumentMetadataModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DocumentMetadataModelCopyWith<_DocumentMetadataModel> get copyWith => __$DocumentMetadataModelCopyWithImpl<_DocumentMetadataModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DocumentMetadataModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DocumentMetadataModel&&(identical(other.extension, extension) || other.extension == extension)&&(identical(other.pageCount, pageCount) || other.pageCount == pageCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,extension,pageCount);

@override
String toString() {
  return 'DocumentMetadataModel(extension: $extension, pageCount: $pageCount)';
}


}

/// @nodoc
abstract mixin class _$DocumentMetadataModelCopyWith<$Res> implements $DocumentMetadataModelCopyWith<$Res> {
  factory _$DocumentMetadataModelCopyWith(_DocumentMetadataModel value, $Res Function(_DocumentMetadataModel) _then) = __$DocumentMetadataModelCopyWithImpl;
@override @useResult
$Res call({
 String extension, int? pageCount
});




}
/// @nodoc
class __$DocumentMetadataModelCopyWithImpl<$Res>
    implements _$DocumentMetadataModelCopyWith<$Res> {
  __$DocumentMetadataModelCopyWithImpl(this._self, this._then);

  final _DocumentMetadataModel _self;
  final $Res Function(_DocumentMetadataModel) _then;

/// Create a copy of DocumentMetadataModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? extension = null,Object? pageCount = freezed,}) {
  return _then(_DocumentMetadataModel(
extension: null == extension ? _self.extension : extension // ignore: cast_nullable_to_non_nullable
as String,pageCount: freezed == pageCount ? _self.pageCount : pageCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
