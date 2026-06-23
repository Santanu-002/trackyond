// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_preview_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MediaPreviewItem {

 String get path; JobChatMessageContentType get type; ChatMessageMetadataModel get metadata;
/// Create a copy of MediaPreviewItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaPreviewItemCopyWith<MediaPreviewItem> get copyWith => _$MediaPreviewItemCopyWithImpl<MediaPreviewItem>(this as MediaPreviewItem, _$identity);

  /// Serializes this MediaPreviewItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaPreviewItem&&(identical(other.path, path) || other.path == path)&&(identical(other.type, type) || other.type == type)&&(identical(other.metadata, metadata) || other.metadata == metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,type,metadata);

@override
String toString() {
  return 'MediaPreviewItem(path: $path, type: $type, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $MediaPreviewItemCopyWith<$Res>  {
  factory $MediaPreviewItemCopyWith(MediaPreviewItem value, $Res Function(MediaPreviewItem) _then) = _$MediaPreviewItemCopyWithImpl;
@useResult
$Res call({
 String path, JobChatMessageContentType type, ChatMessageMetadataModel metadata
});


$ChatMessageMetadataModelCopyWith<$Res> get metadata;

}
/// @nodoc
class _$MediaPreviewItemCopyWithImpl<$Res>
    implements $MediaPreviewItemCopyWith<$Res> {
  _$MediaPreviewItemCopyWithImpl(this._self, this._then);

  final MediaPreviewItem _self;
  final $Res Function(MediaPreviewItem) _then;

/// Create a copy of MediaPreviewItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = null,Object? type = null,Object? metadata = null,}) {
  return _then(_self.copyWith(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as JobChatMessageContentType,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as ChatMessageMetadataModel,
  ));
}
/// Create a copy of MediaPreviewItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatMessageMetadataModelCopyWith<$Res> get metadata {
  
  return $ChatMessageMetadataModelCopyWith<$Res>(_self.metadata, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}


/// Adds pattern-matching-related methods to [MediaPreviewItem].
extension MediaPreviewItemPatterns on MediaPreviewItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MediaPreviewItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MediaPreviewItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MediaPreviewItem value)  $default,){
final _that = this;
switch (_that) {
case _MediaPreviewItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MediaPreviewItem value)?  $default,){
final _that = this;
switch (_that) {
case _MediaPreviewItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String path,  JobChatMessageContentType type,  ChatMessageMetadataModel metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MediaPreviewItem() when $default != null:
return $default(_that.path,_that.type,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String path,  JobChatMessageContentType type,  ChatMessageMetadataModel metadata)  $default,) {final _that = this;
switch (_that) {
case _MediaPreviewItem():
return $default(_that.path,_that.type,_that.metadata);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String path,  JobChatMessageContentType type,  ChatMessageMetadataModel metadata)?  $default,) {final _that = this;
switch (_that) {
case _MediaPreviewItem() when $default != null:
return $default(_that.path,_that.type,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MediaPreviewItem extends MediaPreviewItem {
  const _MediaPreviewItem({required this.path, required this.type, required this.metadata}): super._();
  factory _MediaPreviewItem.fromJson(Map<String, dynamic> json) => _$MediaPreviewItemFromJson(json);

@override final  String path;
@override final  JobChatMessageContentType type;
@override final  ChatMessageMetadataModel metadata;

/// Create a copy of MediaPreviewItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaPreviewItemCopyWith<_MediaPreviewItem> get copyWith => __$MediaPreviewItemCopyWithImpl<_MediaPreviewItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MediaPreviewItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaPreviewItem&&(identical(other.path, path) || other.path == path)&&(identical(other.type, type) || other.type == type)&&(identical(other.metadata, metadata) || other.metadata == metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,type,metadata);

@override
String toString() {
  return 'MediaPreviewItem(path: $path, type: $type, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$MediaPreviewItemCopyWith<$Res> implements $MediaPreviewItemCopyWith<$Res> {
  factory _$MediaPreviewItemCopyWith(_MediaPreviewItem value, $Res Function(_MediaPreviewItem) _then) = __$MediaPreviewItemCopyWithImpl;
@override @useResult
$Res call({
 String path, JobChatMessageContentType type, ChatMessageMetadataModel metadata
});


@override $ChatMessageMetadataModelCopyWith<$Res> get metadata;

}
/// @nodoc
class __$MediaPreviewItemCopyWithImpl<$Res>
    implements _$MediaPreviewItemCopyWith<$Res> {
  __$MediaPreviewItemCopyWithImpl(this._self, this._then);

  final _MediaPreviewItem _self;
  final $Res Function(_MediaPreviewItem) _then;

/// Create a copy of MediaPreviewItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? type = null,Object? metadata = null,}) {
  return _then(_MediaPreviewItem(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as JobChatMessageContentType,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as ChatMessageMetadataModel,
  ));
}

/// Create a copy of MediaPreviewItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatMessageMetadataModelCopyWith<$Res> get metadata {
  
  return $ChatMessageMetadataModelCopyWith<$Res>(_self.metadata, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}

// dart format on
