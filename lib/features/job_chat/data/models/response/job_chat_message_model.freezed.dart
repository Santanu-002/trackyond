// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_chat_message_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JobChatMessageModel {

@JsonKey(includeToJson: false, readValue: JobChatMessageModel._readUid) String get uid;@JsonKey(readValue: JobChatMessageModel._readServerUid) String? get serverUid; String get jobId; String? get senderUid; List<JobChatMessageContentModel> get content;@JsonKey(unknownEnumValue: JobChatMessageType.message) JobChatMessageType get type; Map<String, dynamic>? get metadata; String? get actionPerformed;@DateTimeConverter() DateTime get createdByAuthorAt;@JsonKey(includeToJson: false)@DateTimeNullableConverter() DateTime? get createdAt;@JsonKey(includeToJson: false)@DateTimeNullableConverter() DateTime? get updatedAt;@JsonKey(includeToJson: false)@DateTimeNullableConverter() DateTime? get seenAt;@JsonKey(includeToJson: false)@DateTimeNullableConverter() DateTime? get deliveredAt;@JsonKey(includeToJson: false, includeFromJson: false) bool get isMe;@JsonKey(includeToJson: false) bool get active;@JsonKey(includeToJson: false) bool get deleted; String? get deletedByUid; String? get deletedByUserType; List<String> get deletedFor;@DateTimeNullableConverter() DateTime? get deletedAt;@DateTimeNullableConverter() DateTime? get deletedByUserAt;
/// Create a copy of JobChatMessageModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobChatMessageModelCopyWith<JobChatMessageModel> get copyWith => _$JobChatMessageModelCopyWithImpl<JobChatMessageModel>(this as JobChatMessageModel, _$identity);

  /// Serializes this JobChatMessageModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobChatMessageModel&&super == other&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.serverUid, serverUid) || other.serverUid == serverUid)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.senderUid, senderUid) || other.senderUid == senderUid)&&const DeepCollectionEquality().equals(other.content, content)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.metadata, metadata)&&(identical(other.actionPerformed, actionPerformed) || other.actionPerformed == actionPerformed)&&(identical(other.createdByAuthorAt, createdByAuthorAt) || other.createdByAuthorAt == createdByAuthorAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.seenAt, seenAt) || other.seenAt == seenAt)&&(identical(other.deliveredAt, deliveredAt) || other.deliveredAt == deliveredAt)&&(identical(other.isMe, isMe) || other.isMe == isMe)&&(identical(other.active, active) || other.active == active)&&(identical(other.deleted, deleted) || other.deleted == deleted)&&(identical(other.deletedByUid, deletedByUid) || other.deletedByUid == deletedByUid)&&(identical(other.deletedByUserType, deletedByUserType) || other.deletedByUserType == deletedByUserType)&&const DeepCollectionEquality().equals(other.deletedFor, deletedFor)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.deletedByUserAt, deletedByUserAt) || other.deletedByUserAt == deletedByUserAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,super.hashCode,uid,serverUid,jobId,senderUid,const DeepCollectionEquality().hash(content),type,const DeepCollectionEquality().hash(metadata),actionPerformed,createdByAuthorAt,createdAt,updatedAt,seenAt,deliveredAt,isMe,active,deleted,deletedByUid,deletedByUserType,const DeepCollectionEquality().hash(deletedFor),deletedAt,deletedByUserAt]);



}

/// @nodoc
abstract mixin class $JobChatMessageModelCopyWith<$Res>  {
  factory $JobChatMessageModelCopyWith(JobChatMessageModel value, $Res Function(JobChatMessageModel) _then) = _$JobChatMessageModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeToJson: false, readValue: JobChatMessageModel._readUid) String uid,@JsonKey(readValue: JobChatMessageModel._readServerUid) String? serverUid, String jobId, String? senderUid, List<JobChatMessageContentModel> content,@JsonKey(unknownEnumValue: JobChatMessageType.message) JobChatMessageType type, Map<String, dynamic>? metadata, String? actionPerformed,@DateTimeConverter() DateTime createdByAuthorAt,@JsonKey(includeToJson: false)@DateTimeNullableConverter() DateTime? createdAt,@JsonKey(includeToJson: false)@DateTimeNullableConverter() DateTime? updatedAt,@JsonKey(includeToJson: false)@DateTimeNullableConverter() DateTime? seenAt,@JsonKey(includeToJson: false)@DateTimeNullableConverter() DateTime? deliveredAt,@JsonKey(includeToJson: false, includeFromJson: false) bool isMe,@JsonKey(includeToJson: false) bool active,@JsonKey(includeToJson: false) bool deleted, String? deletedByUid, String? deletedByUserType, List<String> deletedFor,@DateTimeNullableConverter() DateTime? deletedAt,@DateTimeNullableConverter() DateTime? deletedByUserAt
});




}
/// @nodoc
class _$JobChatMessageModelCopyWithImpl<$Res>
    implements $JobChatMessageModelCopyWith<$Res> {
  _$JobChatMessageModelCopyWithImpl(this._self, this._then);

  final JobChatMessageModel _self;
  final $Res Function(JobChatMessageModel) _then;

/// Create a copy of JobChatMessageModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? serverUid = freezed,Object? jobId = null,Object? senderUid = freezed,Object? content = null,Object? type = null,Object? metadata = freezed,Object? actionPerformed = freezed,Object? createdByAuthorAt = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? seenAt = freezed,Object? deliveredAt = freezed,Object? isMe = null,Object? active = null,Object? deleted = null,Object? deletedByUid = freezed,Object? deletedByUserType = freezed,Object? deletedFor = null,Object? deletedAt = freezed,Object? deletedByUserAt = freezed,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,serverUid: freezed == serverUid ? _self.serverUid : serverUid // ignore: cast_nullable_to_non_nullable
as String?,jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,senderUid: freezed == senderUid ? _self.senderUid : senderUid // ignore: cast_nullable_to_non_nullable
as String?,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as List<JobChatMessageContentModel>,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as JobChatMessageType,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,actionPerformed: freezed == actionPerformed ? _self.actionPerformed : actionPerformed // ignore: cast_nullable_to_non_nullable
as String?,createdByAuthorAt: null == createdByAuthorAt ? _self.createdByAuthorAt : createdByAuthorAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,seenAt: freezed == seenAt ? _self.seenAt : seenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deliveredAt: freezed == deliveredAt ? _self.deliveredAt : deliveredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isMe: null == isMe ? _self.isMe : isMe // ignore: cast_nullable_to_non_nullable
as bool,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,deleted: null == deleted ? _self.deleted : deleted // ignore: cast_nullable_to_non_nullable
as bool,deletedByUid: freezed == deletedByUid ? _self.deletedByUid : deletedByUid // ignore: cast_nullable_to_non_nullable
as String?,deletedByUserType: freezed == deletedByUserType ? _self.deletedByUserType : deletedByUserType // ignore: cast_nullable_to_non_nullable
as String?,deletedFor: null == deletedFor ? _self.deletedFor : deletedFor // ignore: cast_nullable_to_non_nullable
as List<String>,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedByUserAt: freezed == deletedByUserAt ? _self.deletedByUserAt : deletedByUserAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [JobChatMessageModel].
extension JobChatMessageModelPatterns on JobChatMessageModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobChatMessageModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobChatMessageModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobChatMessageModel value)  $default,){
final _that = this;
switch (_that) {
case _JobChatMessageModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobChatMessageModel value)?  $default,){
final _that = this;
switch (_that) {
case _JobChatMessageModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false, readValue: JobChatMessageModel._readUid)  String uid, @JsonKey(readValue: JobChatMessageModel._readServerUid)  String? serverUid,  String jobId,  String? senderUid,  List<JobChatMessageContentModel> content, @JsonKey(unknownEnumValue: JobChatMessageType.message)  JobChatMessageType type,  Map<String, dynamic>? metadata,  String? actionPerformed, @DateTimeConverter()  DateTime createdByAuthorAt, @JsonKey(includeToJson: false)@DateTimeNullableConverter()  DateTime? createdAt, @JsonKey(includeToJson: false)@DateTimeNullableConverter()  DateTime? updatedAt, @JsonKey(includeToJson: false)@DateTimeNullableConverter()  DateTime? seenAt, @JsonKey(includeToJson: false)@DateTimeNullableConverter()  DateTime? deliveredAt, @JsonKey(includeToJson: false, includeFromJson: false)  bool isMe, @JsonKey(includeToJson: false)  bool active, @JsonKey(includeToJson: false)  bool deleted,  String? deletedByUid,  String? deletedByUserType,  List<String> deletedFor, @DateTimeNullableConverter()  DateTime? deletedAt, @DateTimeNullableConverter()  DateTime? deletedByUserAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobChatMessageModel() when $default != null:
return $default(_that.uid,_that.serverUid,_that.jobId,_that.senderUid,_that.content,_that.type,_that.metadata,_that.actionPerformed,_that.createdByAuthorAt,_that.createdAt,_that.updatedAt,_that.seenAt,_that.deliveredAt,_that.isMe,_that.active,_that.deleted,_that.deletedByUid,_that.deletedByUserType,_that.deletedFor,_that.deletedAt,_that.deletedByUserAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeToJson: false, readValue: JobChatMessageModel._readUid)  String uid, @JsonKey(readValue: JobChatMessageModel._readServerUid)  String? serverUid,  String jobId,  String? senderUid,  List<JobChatMessageContentModel> content, @JsonKey(unknownEnumValue: JobChatMessageType.message)  JobChatMessageType type,  Map<String, dynamic>? metadata,  String? actionPerformed, @DateTimeConverter()  DateTime createdByAuthorAt, @JsonKey(includeToJson: false)@DateTimeNullableConverter()  DateTime? createdAt, @JsonKey(includeToJson: false)@DateTimeNullableConverter()  DateTime? updatedAt, @JsonKey(includeToJson: false)@DateTimeNullableConverter()  DateTime? seenAt, @JsonKey(includeToJson: false)@DateTimeNullableConverter()  DateTime? deliveredAt, @JsonKey(includeToJson: false, includeFromJson: false)  bool isMe, @JsonKey(includeToJson: false)  bool active, @JsonKey(includeToJson: false)  bool deleted,  String? deletedByUid,  String? deletedByUserType,  List<String> deletedFor, @DateTimeNullableConverter()  DateTime? deletedAt, @DateTimeNullableConverter()  DateTime? deletedByUserAt)  $default,) {final _that = this;
switch (_that) {
case _JobChatMessageModel():
return $default(_that.uid,_that.serverUid,_that.jobId,_that.senderUid,_that.content,_that.type,_that.metadata,_that.actionPerformed,_that.createdByAuthorAt,_that.createdAt,_that.updatedAt,_that.seenAt,_that.deliveredAt,_that.isMe,_that.active,_that.deleted,_that.deletedByUid,_that.deletedByUserType,_that.deletedFor,_that.deletedAt,_that.deletedByUserAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeToJson: false, readValue: JobChatMessageModel._readUid)  String uid, @JsonKey(readValue: JobChatMessageModel._readServerUid)  String? serverUid,  String jobId,  String? senderUid,  List<JobChatMessageContentModel> content, @JsonKey(unknownEnumValue: JobChatMessageType.message)  JobChatMessageType type,  Map<String, dynamic>? metadata,  String? actionPerformed, @DateTimeConverter()  DateTime createdByAuthorAt, @JsonKey(includeToJson: false)@DateTimeNullableConverter()  DateTime? createdAt, @JsonKey(includeToJson: false)@DateTimeNullableConverter()  DateTime? updatedAt, @JsonKey(includeToJson: false)@DateTimeNullableConverter()  DateTime? seenAt, @JsonKey(includeToJson: false)@DateTimeNullableConverter()  DateTime? deliveredAt, @JsonKey(includeToJson: false, includeFromJson: false)  bool isMe, @JsonKey(includeToJson: false)  bool active, @JsonKey(includeToJson: false)  bool deleted,  String? deletedByUid,  String? deletedByUserType,  List<String> deletedFor, @DateTimeNullableConverter()  DateTime? deletedAt, @DateTimeNullableConverter()  DateTime? deletedByUserAt)?  $default,) {final _that = this;
switch (_that) {
case _JobChatMessageModel() when $default != null:
return $default(_that.uid,_that.serverUid,_that.jobId,_that.senderUid,_that.content,_that.type,_that.metadata,_that.actionPerformed,_that.createdByAuthorAt,_that.createdAt,_that.updatedAt,_that.seenAt,_that.deliveredAt,_that.isMe,_that.active,_that.deleted,_that.deletedByUid,_that.deletedByUserType,_that.deletedFor,_that.deletedAt,_that.deletedByUserAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JobChatMessageModel extends JobChatMessageModel {
  const _JobChatMessageModel({@JsonKey(includeToJson: false, readValue: JobChatMessageModel._readUid) required this.uid, @JsonKey(readValue: JobChatMessageModel._readServerUid) this.serverUid, required this.jobId, this.senderUid, required final  List<JobChatMessageContentModel> content, @JsonKey(unknownEnumValue: JobChatMessageType.message) this.type = JobChatMessageType.message, final  Map<String, dynamic>? metadata, this.actionPerformed, @DateTimeConverter() required this.createdByAuthorAt, @JsonKey(includeToJson: false)@DateTimeNullableConverter() this.createdAt, @JsonKey(includeToJson: false)@DateTimeNullableConverter() this.updatedAt, @JsonKey(includeToJson: false)@DateTimeNullableConverter() this.seenAt, @JsonKey(includeToJson: false)@DateTimeNullableConverter() this.deliveredAt, @JsonKey(includeToJson: false, includeFromJson: false) this.isMe = false, @JsonKey(includeToJson: false) this.active = true, @JsonKey(includeToJson: false) this.deleted = false, this.deletedByUid, this.deletedByUserType, final  List<String> deletedFor = const [], @DateTimeNullableConverter() this.deletedAt, @DateTimeNullableConverter() this.deletedByUserAt}): _content = content,_metadata = metadata,_deletedFor = deletedFor,super._();
  factory _JobChatMessageModel.fromJson(Map<String, dynamic> json) => _$JobChatMessageModelFromJson(json);

@override@JsonKey(includeToJson: false, readValue: JobChatMessageModel._readUid) final  String uid;
@override@JsonKey(readValue: JobChatMessageModel._readServerUid) final  String? serverUid;
@override final  String jobId;
@override final  String? senderUid;
 final  List<JobChatMessageContentModel> _content;
@override List<JobChatMessageContentModel> get content {
  if (_content is EqualUnmodifiableListView) return _content;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_content);
}

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
@override@JsonKey(includeToJson: false)@DateTimeNullableConverter() final  DateTime? createdAt;
@override@JsonKey(includeToJson: false)@DateTimeNullableConverter() final  DateTime? updatedAt;
@override@JsonKey(includeToJson: false)@DateTimeNullableConverter() final  DateTime? seenAt;
@override@JsonKey(includeToJson: false)@DateTimeNullableConverter() final  DateTime? deliveredAt;
@override@JsonKey(includeToJson: false, includeFromJson: false) final  bool isMe;
@override@JsonKey(includeToJson: false) final  bool active;
@override@JsonKey(includeToJson: false) final  bool deleted;
@override final  String? deletedByUid;
@override final  String? deletedByUserType;
 final  List<String> _deletedFor;
@override@JsonKey() List<String> get deletedFor {
  if (_deletedFor is EqualUnmodifiableListView) return _deletedFor;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_deletedFor);
}

@override@DateTimeNullableConverter() final  DateTime? deletedAt;
@override@DateTimeNullableConverter() final  DateTime? deletedByUserAt;

/// Create a copy of JobChatMessageModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobChatMessageModelCopyWith<_JobChatMessageModel> get copyWith => __$JobChatMessageModelCopyWithImpl<_JobChatMessageModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JobChatMessageModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobChatMessageModel&&super == other&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.serverUid, serverUid) || other.serverUid == serverUid)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.senderUid, senderUid) || other.senderUid == senderUid)&&const DeepCollectionEquality().equals(other._content, _content)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._metadata, _metadata)&&(identical(other.actionPerformed, actionPerformed) || other.actionPerformed == actionPerformed)&&(identical(other.createdByAuthorAt, createdByAuthorAt) || other.createdByAuthorAt == createdByAuthorAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.seenAt, seenAt) || other.seenAt == seenAt)&&(identical(other.deliveredAt, deliveredAt) || other.deliveredAt == deliveredAt)&&(identical(other.isMe, isMe) || other.isMe == isMe)&&(identical(other.active, active) || other.active == active)&&(identical(other.deleted, deleted) || other.deleted == deleted)&&(identical(other.deletedByUid, deletedByUid) || other.deletedByUid == deletedByUid)&&(identical(other.deletedByUserType, deletedByUserType) || other.deletedByUserType == deletedByUserType)&&const DeepCollectionEquality().equals(other._deletedFor, _deletedFor)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.deletedByUserAt, deletedByUserAt) || other.deletedByUserAt == deletedByUserAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,super.hashCode,uid,serverUid,jobId,senderUid,const DeepCollectionEquality().hash(_content),type,const DeepCollectionEquality().hash(_metadata),actionPerformed,createdByAuthorAt,createdAt,updatedAt,seenAt,deliveredAt,isMe,active,deleted,deletedByUid,deletedByUserType,const DeepCollectionEquality().hash(_deletedFor),deletedAt,deletedByUserAt]);



}

/// @nodoc
abstract mixin class _$JobChatMessageModelCopyWith<$Res> implements $JobChatMessageModelCopyWith<$Res> {
  factory _$JobChatMessageModelCopyWith(_JobChatMessageModel value, $Res Function(_JobChatMessageModel) _then) = __$JobChatMessageModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeToJson: false, readValue: JobChatMessageModel._readUid) String uid,@JsonKey(readValue: JobChatMessageModel._readServerUid) String? serverUid, String jobId, String? senderUid, List<JobChatMessageContentModel> content,@JsonKey(unknownEnumValue: JobChatMessageType.message) JobChatMessageType type, Map<String, dynamic>? metadata, String? actionPerformed,@DateTimeConverter() DateTime createdByAuthorAt,@JsonKey(includeToJson: false)@DateTimeNullableConverter() DateTime? createdAt,@JsonKey(includeToJson: false)@DateTimeNullableConverter() DateTime? updatedAt,@JsonKey(includeToJson: false)@DateTimeNullableConverter() DateTime? seenAt,@JsonKey(includeToJson: false)@DateTimeNullableConverter() DateTime? deliveredAt,@JsonKey(includeToJson: false, includeFromJson: false) bool isMe,@JsonKey(includeToJson: false) bool active,@JsonKey(includeToJson: false) bool deleted, String? deletedByUid, String? deletedByUserType, List<String> deletedFor,@DateTimeNullableConverter() DateTime? deletedAt,@DateTimeNullableConverter() DateTime? deletedByUserAt
});




}
/// @nodoc
class __$JobChatMessageModelCopyWithImpl<$Res>
    implements _$JobChatMessageModelCopyWith<$Res> {
  __$JobChatMessageModelCopyWithImpl(this._self, this._then);

  final _JobChatMessageModel _self;
  final $Res Function(_JobChatMessageModel) _then;

/// Create a copy of JobChatMessageModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? serverUid = freezed,Object? jobId = null,Object? senderUid = freezed,Object? content = null,Object? type = null,Object? metadata = freezed,Object? actionPerformed = freezed,Object? createdByAuthorAt = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? seenAt = freezed,Object? deliveredAt = freezed,Object? isMe = null,Object? active = null,Object? deleted = null,Object? deletedByUid = freezed,Object? deletedByUserType = freezed,Object? deletedFor = null,Object? deletedAt = freezed,Object? deletedByUserAt = freezed,}) {
  return _then(_JobChatMessageModel(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,serverUid: freezed == serverUid ? _self.serverUid : serverUid // ignore: cast_nullable_to_non_nullable
as String?,jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,senderUid: freezed == senderUid ? _self.senderUid : senderUid // ignore: cast_nullable_to_non_nullable
as String?,content: null == content ? _self._content : content // ignore: cast_nullable_to_non_nullable
as List<JobChatMessageContentModel>,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as JobChatMessageType,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,actionPerformed: freezed == actionPerformed ? _self.actionPerformed : actionPerformed // ignore: cast_nullable_to_non_nullable
as String?,createdByAuthorAt: null == createdByAuthorAt ? _self.createdByAuthorAt : createdByAuthorAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,seenAt: freezed == seenAt ? _self.seenAt : seenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deliveredAt: freezed == deliveredAt ? _self.deliveredAt : deliveredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isMe: null == isMe ? _self.isMe : isMe // ignore: cast_nullable_to_non_nullable
as bool,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,deleted: null == deleted ? _self.deleted : deleted // ignore: cast_nullable_to_non_nullable
as bool,deletedByUid: freezed == deletedByUid ? _self.deletedByUid : deletedByUid // ignore: cast_nullable_to_non_nullable
as String?,deletedByUserType: freezed == deletedByUserType ? _self.deletedByUserType : deletedByUserType // ignore: cast_nullable_to_non_nullable
as String?,deletedFor: null == deletedFor ? _self._deletedFor : deletedFor // ignore: cast_nullable_to_non_nullable
as List<String>,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deletedByUserAt: freezed == deletedByUserAt ? _self.deletedByUserAt : deletedByUserAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
