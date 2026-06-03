// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'send_message_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SendMessageModel {

 String? get localId; String get jobId; String? get senderUid;@JsonKey(unknownEnumValue: JobChatMessageType.message) JobChatMessageType get type; Map<String, dynamic>? get metadata; String? get actionPerformed;@DateTimeConverter() DateTime get createdByAuthorAt; List<JobChatMessageContentModel> get content;
/// Create a copy of SendMessageModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SendMessageModelCopyWith<SendMessageModel> get copyWith => _$SendMessageModelCopyWithImpl<SendMessageModel>(this as SendMessageModel, _$identity);

  /// Serializes this SendMessageModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SendMessageModel&&(identical(other.localId, localId) || other.localId == localId)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.senderUid, senderUid) || other.senderUid == senderUid)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.metadata, metadata)&&(identical(other.actionPerformed, actionPerformed) || other.actionPerformed == actionPerformed)&&(identical(other.createdByAuthorAt, createdByAuthorAt) || other.createdByAuthorAt == createdByAuthorAt)&&const DeepCollectionEquality().equals(other.content, content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,localId,jobId,senderUid,type,const DeepCollectionEquality().hash(metadata),actionPerformed,createdByAuthorAt,const DeepCollectionEquality().hash(content));

@override
String toString() {
  return 'SendMessageModel(localId: $localId, jobId: $jobId, senderUid: $senderUid, type: $type, metadata: $metadata, actionPerformed: $actionPerformed, createdByAuthorAt: $createdByAuthorAt, content: $content)';
}


}

/// @nodoc
abstract mixin class $SendMessageModelCopyWith<$Res>  {
  factory $SendMessageModelCopyWith(SendMessageModel value, $Res Function(SendMessageModel) _then) = _$SendMessageModelCopyWithImpl;
@useResult
$Res call({
 String? localId, String jobId, String? senderUid,@JsonKey(unknownEnumValue: JobChatMessageType.message) JobChatMessageType type, Map<String, dynamic>? metadata, String? actionPerformed,@DateTimeConverter() DateTime createdByAuthorAt, List<JobChatMessageContentModel> content
});




}
/// @nodoc
class _$SendMessageModelCopyWithImpl<$Res>
    implements $SendMessageModelCopyWith<$Res> {
  _$SendMessageModelCopyWithImpl(this._self, this._then);

  final SendMessageModel _self;
  final $Res Function(SendMessageModel) _then;

/// Create a copy of SendMessageModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? localId = freezed,Object? jobId = null,Object? senderUid = freezed,Object? type = null,Object? metadata = freezed,Object? actionPerformed = freezed,Object? createdByAuthorAt = null,Object? content = null,}) {
  return _then(_self.copyWith(
localId: freezed == localId ? _self.localId : localId // ignore: cast_nullable_to_non_nullable
as String?,jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,senderUid: freezed == senderUid ? _self.senderUid : senderUid // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as JobChatMessageType,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,actionPerformed: freezed == actionPerformed ? _self.actionPerformed : actionPerformed // ignore: cast_nullable_to_non_nullable
as String?,createdByAuthorAt: null == createdByAuthorAt ? _self.createdByAuthorAt : createdByAuthorAt // ignore: cast_nullable_to_non_nullable
as DateTime,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as List<JobChatMessageContentModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [SendMessageModel].
extension SendMessageModelPatterns on SendMessageModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SendMessageModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SendMessageModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SendMessageModel value)  $default,){
final _that = this;
switch (_that) {
case _SendMessageModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SendMessageModel value)?  $default,){
final _that = this;
switch (_that) {
case _SendMessageModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? localId,  String jobId,  String? senderUid, @JsonKey(unknownEnumValue: JobChatMessageType.message)  JobChatMessageType type,  Map<String, dynamic>? metadata,  String? actionPerformed, @DateTimeConverter()  DateTime createdByAuthorAt,  List<JobChatMessageContentModel> content)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SendMessageModel() when $default != null:
return $default(_that.localId,_that.jobId,_that.senderUid,_that.type,_that.metadata,_that.actionPerformed,_that.createdByAuthorAt,_that.content);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? localId,  String jobId,  String? senderUid, @JsonKey(unknownEnumValue: JobChatMessageType.message)  JobChatMessageType type,  Map<String, dynamic>? metadata,  String? actionPerformed, @DateTimeConverter()  DateTime createdByAuthorAt,  List<JobChatMessageContentModel> content)  $default,) {final _that = this;
switch (_that) {
case _SendMessageModel():
return $default(_that.localId,_that.jobId,_that.senderUid,_that.type,_that.metadata,_that.actionPerformed,_that.createdByAuthorAt,_that.content);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? localId,  String jobId,  String? senderUid, @JsonKey(unknownEnumValue: JobChatMessageType.message)  JobChatMessageType type,  Map<String, dynamic>? metadata,  String? actionPerformed, @DateTimeConverter()  DateTime createdByAuthorAt,  List<JobChatMessageContentModel> content)?  $default,) {final _that = this;
switch (_that) {
case _SendMessageModel() when $default != null:
return $default(_that.localId,_that.jobId,_that.senderUid,_that.type,_that.metadata,_that.actionPerformed,_that.createdByAuthorAt,_that.content);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SendMessageModel extends SendMessageModel {
  const _SendMessageModel({this.localId, required this.jobId, this.senderUid, @JsonKey(unknownEnumValue: JobChatMessageType.message) this.type = JobChatMessageType.message, final  Map<String, dynamic>? metadata, this.actionPerformed, @DateTimeConverter() required this.createdByAuthorAt, required final  List<JobChatMessageContentModel> content}): _metadata = metadata,_content = content,super._();
  factory _SendMessageModel.fromJson(Map<String, dynamic> json) => _$SendMessageModelFromJson(json);

@override final  String? localId;
@override final  String jobId;
@override final  String? senderUid;
@override@JsonKey(unknownEnumValue: JobChatMessageType.message) final  JobChatMessageType type;
 final  Map<String, dynamic>? _metadata;
@override Map<String, dynamic>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  String? actionPerformed;
@override@DateTimeConverter() final  DateTime createdByAuthorAt;
 final  List<JobChatMessageContentModel> _content;
@override List<JobChatMessageContentModel> get content {
  if (_content is EqualUnmodifiableListView) return _content;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_content);
}


/// Create a copy of SendMessageModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SendMessageModelCopyWith<_SendMessageModel> get copyWith => __$SendMessageModelCopyWithImpl<_SendMessageModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SendMessageModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SendMessageModel&&(identical(other.localId, localId) || other.localId == localId)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.senderUid, senderUid) || other.senderUid == senderUid)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._metadata, _metadata)&&(identical(other.actionPerformed, actionPerformed) || other.actionPerformed == actionPerformed)&&(identical(other.createdByAuthorAt, createdByAuthorAt) || other.createdByAuthorAt == createdByAuthorAt)&&const DeepCollectionEquality().equals(other._content, _content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,localId,jobId,senderUid,type,const DeepCollectionEquality().hash(_metadata),actionPerformed,createdByAuthorAt,const DeepCollectionEquality().hash(_content));

@override
String toString() {
  return 'SendMessageModel(localId: $localId, jobId: $jobId, senderUid: $senderUid, type: $type, metadata: $metadata, actionPerformed: $actionPerformed, createdByAuthorAt: $createdByAuthorAt, content: $content)';
}


}

/// @nodoc
abstract mixin class _$SendMessageModelCopyWith<$Res> implements $SendMessageModelCopyWith<$Res> {
  factory _$SendMessageModelCopyWith(_SendMessageModel value, $Res Function(_SendMessageModel) _then) = __$SendMessageModelCopyWithImpl;
@override @useResult
$Res call({
 String? localId, String jobId, String? senderUid,@JsonKey(unknownEnumValue: JobChatMessageType.message) JobChatMessageType type, Map<String, dynamic>? metadata, String? actionPerformed,@DateTimeConverter() DateTime createdByAuthorAt, List<JobChatMessageContentModel> content
});




}
/// @nodoc
class __$SendMessageModelCopyWithImpl<$Res>
    implements _$SendMessageModelCopyWith<$Res> {
  __$SendMessageModelCopyWithImpl(this._self, this._then);

  final _SendMessageModel _self;
  final $Res Function(_SendMessageModel) _then;

/// Create a copy of SendMessageModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? localId = freezed,Object? jobId = null,Object? senderUid = freezed,Object? type = null,Object? metadata = freezed,Object? actionPerformed = freezed,Object? createdByAuthorAt = null,Object? content = null,}) {
  return _then(_SendMessageModel(
localId: freezed == localId ? _self.localId : localId // ignore: cast_nullable_to_non_nullable
as String?,jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,senderUid: freezed == senderUid ? _self.senderUid : senderUid // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as JobChatMessageType,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,actionPerformed: freezed == actionPerformed ? _self.actionPerformed : actionPerformed // ignore: cast_nullable_to_non_nullable
as String?,createdByAuthorAt: null == createdByAuthorAt ? _self.createdByAuthorAt : createdByAuthorAt // ignore: cast_nullable_to_non_nullable
as DateTime,content: null == content ? _self._content : content // ignore: cast_nullable_to_non_nullable
as List<JobChatMessageContentModel>,
  ));
}


}

// dart format on
