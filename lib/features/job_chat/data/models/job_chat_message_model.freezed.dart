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

 String get uid; String? get localId; String get jobId; String get authorType; String? get createdByUid; String? get createdByProfileUid;// We'll mock these for now as they might not be in the initial JSON from old code
 String? get senderName; String? get senderId; List<JobChatMessageContentModel> get content; String get type; Map<String, dynamic>? get metadata;@DateTimeConverter() DateTime get createdByAuthorAt;@DateTimeNullableConverter() DateTime? get createdAt;@DateTimeNullableConverter() DateTime? get updatedAt;@DateTimeNullableConverter() DateTime? get seenAt;@DateTimeNullableConverter() DateTime? get deliveredAt; String get status; bool get isMe; bool get active; bool get deleted;
/// Create a copy of JobChatMessageModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobChatMessageModelCopyWith<JobChatMessageModel> get copyWith => _$JobChatMessageModelCopyWithImpl<JobChatMessageModel>(this as JobChatMessageModel, _$identity);

  /// Serializes this JobChatMessageModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobChatMessageModel&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.localId, localId) || other.localId == localId)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.authorType, authorType) || other.authorType == authorType)&&(identical(other.createdByUid, createdByUid) || other.createdByUid == createdByUid)&&(identical(other.createdByProfileUid, createdByProfileUid) || other.createdByProfileUid == createdByProfileUid)&&(identical(other.senderName, senderName) || other.senderName == senderName)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&const DeepCollectionEquality().equals(other.content, content)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.metadata, metadata)&&(identical(other.createdByAuthorAt, createdByAuthorAt) || other.createdByAuthorAt == createdByAuthorAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.seenAt, seenAt) || other.seenAt == seenAt)&&(identical(other.deliveredAt, deliveredAt) || other.deliveredAt == deliveredAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.isMe, isMe) || other.isMe == isMe)&&(identical(other.active, active) || other.active == active)&&(identical(other.deleted, deleted) || other.deleted == deleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,uid,localId,jobId,authorType,createdByUid,createdByProfileUid,senderName,senderId,const DeepCollectionEquality().hash(content),type,const DeepCollectionEquality().hash(metadata),createdByAuthorAt,createdAt,updatedAt,seenAt,deliveredAt,status,isMe,active,deleted]);

@override
String toString() {
  return 'JobChatMessageModel(uid: $uid, localId: $localId, jobId: $jobId, authorType: $authorType, createdByUid: $createdByUid, createdByProfileUid: $createdByProfileUid, senderName: $senderName, senderId: $senderId, content: $content, type: $type, metadata: $metadata, createdByAuthorAt: $createdByAuthorAt, createdAt: $createdAt, updatedAt: $updatedAt, seenAt: $seenAt, deliveredAt: $deliveredAt, status: $status, isMe: $isMe, active: $active, deleted: $deleted)';
}


}

/// @nodoc
abstract mixin class $JobChatMessageModelCopyWith<$Res>  {
  factory $JobChatMessageModelCopyWith(JobChatMessageModel value, $Res Function(JobChatMessageModel) _then) = _$JobChatMessageModelCopyWithImpl;
@useResult
$Res call({
 String uid, String? localId, String jobId, String authorType, String? createdByUid, String? createdByProfileUid, String? senderName, String? senderId, List<JobChatMessageContentModel> content, String type, Map<String, dynamic>? metadata,@DateTimeConverter() DateTime createdByAuthorAt,@DateTimeNullableConverter() DateTime? createdAt,@DateTimeNullableConverter() DateTime? updatedAt,@DateTimeNullableConverter() DateTime? seenAt,@DateTimeNullableConverter() DateTime? deliveredAt, String status, bool isMe, bool active, bool deleted
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
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? localId = freezed,Object? jobId = null,Object? authorType = null,Object? createdByUid = freezed,Object? createdByProfileUid = freezed,Object? senderName = freezed,Object? senderId = freezed,Object? content = null,Object? type = null,Object? metadata = freezed,Object? createdByAuthorAt = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? seenAt = freezed,Object? deliveredAt = freezed,Object? status = null,Object? isMe = null,Object? active = null,Object? deleted = null,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,localId: freezed == localId ? _self.localId : localId // ignore: cast_nullable_to_non_nullable
as String?,jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,authorType: null == authorType ? _self.authorType : authorType // ignore: cast_nullable_to_non_nullable
as String,createdByUid: freezed == createdByUid ? _self.createdByUid : createdByUid // ignore: cast_nullable_to_non_nullable
as String?,createdByProfileUid: freezed == createdByProfileUid ? _self.createdByProfileUid : createdByProfileUid // ignore: cast_nullable_to_non_nullable
as String?,senderName: freezed == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String?,senderId: freezed == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String?,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as List<JobChatMessageContentModel>,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdByAuthorAt: null == createdByAuthorAt ? _self.createdByAuthorAt : createdByAuthorAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,seenAt: freezed == seenAt ? _self.seenAt : seenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deliveredAt: freezed == deliveredAt ? _self.deliveredAt : deliveredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,isMe: null == isMe ? _self.isMe : isMe // ignore: cast_nullable_to_non_nullable
as bool,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,deleted: null == deleted ? _self.deleted : deleted // ignore: cast_nullable_to_non_nullable
as bool,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid,  String? localId,  String jobId,  String authorType,  String? createdByUid,  String? createdByProfileUid,  String? senderName,  String? senderId,  List<JobChatMessageContentModel> content,  String type,  Map<String, dynamic>? metadata, @DateTimeConverter()  DateTime createdByAuthorAt, @DateTimeNullableConverter()  DateTime? createdAt, @DateTimeNullableConverter()  DateTime? updatedAt, @DateTimeNullableConverter()  DateTime? seenAt, @DateTimeNullableConverter()  DateTime? deliveredAt,  String status,  bool isMe,  bool active,  bool deleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobChatMessageModel() when $default != null:
return $default(_that.uid,_that.localId,_that.jobId,_that.authorType,_that.createdByUid,_that.createdByProfileUid,_that.senderName,_that.senderId,_that.content,_that.type,_that.metadata,_that.createdByAuthorAt,_that.createdAt,_that.updatedAt,_that.seenAt,_that.deliveredAt,_that.status,_that.isMe,_that.active,_that.deleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid,  String? localId,  String jobId,  String authorType,  String? createdByUid,  String? createdByProfileUid,  String? senderName,  String? senderId,  List<JobChatMessageContentModel> content,  String type,  Map<String, dynamic>? metadata, @DateTimeConverter()  DateTime createdByAuthorAt, @DateTimeNullableConverter()  DateTime? createdAt, @DateTimeNullableConverter()  DateTime? updatedAt, @DateTimeNullableConverter()  DateTime? seenAt, @DateTimeNullableConverter()  DateTime? deliveredAt,  String status,  bool isMe,  bool active,  bool deleted)  $default,) {final _that = this;
switch (_that) {
case _JobChatMessageModel():
return $default(_that.uid,_that.localId,_that.jobId,_that.authorType,_that.createdByUid,_that.createdByProfileUid,_that.senderName,_that.senderId,_that.content,_that.type,_that.metadata,_that.createdByAuthorAt,_that.createdAt,_that.updatedAt,_that.seenAt,_that.deliveredAt,_that.status,_that.isMe,_that.active,_that.deleted);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid,  String? localId,  String jobId,  String authorType,  String? createdByUid,  String? createdByProfileUid,  String? senderName,  String? senderId,  List<JobChatMessageContentModel> content,  String type,  Map<String, dynamic>? metadata, @DateTimeConverter()  DateTime createdByAuthorAt, @DateTimeNullableConverter()  DateTime? createdAt, @DateTimeNullableConverter()  DateTime? updatedAt, @DateTimeNullableConverter()  DateTime? seenAt, @DateTimeNullableConverter()  DateTime? deliveredAt,  String status,  bool isMe,  bool active,  bool deleted)?  $default,) {final _that = this;
switch (_that) {
case _JobChatMessageModel() when $default != null:
return $default(_that.uid,_that.localId,_that.jobId,_that.authorType,_that.createdByUid,_that.createdByProfileUid,_that.senderName,_that.senderId,_that.content,_that.type,_that.metadata,_that.createdByAuthorAt,_that.createdAt,_that.updatedAt,_that.seenAt,_that.deliveredAt,_that.status,_that.isMe,_that.active,_that.deleted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JobChatMessageModel extends JobChatMessageModel {
  const _JobChatMessageModel({required this.uid, this.localId, required this.jobId, this.authorType = 'user', this.createdByUid, this.createdByProfileUid, this.senderName, this.senderId, required final  List<JobChatMessageContentModel> content, this.type = 'message', final  Map<String, dynamic>? metadata, @DateTimeConverter() required this.createdByAuthorAt, @DateTimeNullableConverter() this.createdAt, @DateTimeNullableConverter() this.updatedAt, @DateTimeNullableConverter() this.seenAt, @DateTimeNullableConverter() this.deliveredAt, this.status = 'sent', this.isMe = false, this.active = true, this.deleted = false}): _content = content,_metadata = metadata,super._();
  factory _JobChatMessageModel.fromJson(Map<String, dynamic> json) => _$JobChatMessageModelFromJson(json);

@override final  String uid;
@override final  String? localId;
@override final  String jobId;
@override@JsonKey() final  String authorType;
@override final  String? createdByUid;
@override final  String? createdByProfileUid;
// We'll mock these for now as they might not be in the initial JSON from old code
@override final  String? senderName;
@override final  String? senderId;
 final  List<JobChatMessageContentModel> _content;
@override List<JobChatMessageContentModel> get content {
  if (_content is EqualUnmodifiableListView) return _content;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_content);
}

@override@JsonKey() final  String type;
 final  Map<String, dynamic>? _metadata;
@override Map<String, dynamic>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@DateTimeConverter() final  DateTime createdByAuthorAt;
@override@DateTimeNullableConverter() final  DateTime? createdAt;
@override@DateTimeNullableConverter() final  DateTime? updatedAt;
@override@DateTimeNullableConverter() final  DateTime? seenAt;
@override@DateTimeNullableConverter() final  DateTime? deliveredAt;
@override@JsonKey() final  String status;
@override@JsonKey() final  bool isMe;
@override@JsonKey() final  bool active;
@override@JsonKey() final  bool deleted;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobChatMessageModel&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.localId, localId) || other.localId == localId)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.authorType, authorType) || other.authorType == authorType)&&(identical(other.createdByUid, createdByUid) || other.createdByUid == createdByUid)&&(identical(other.createdByProfileUid, createdByProfileUid) || other.createdByProfileUid == createdByProfileUid)&&(identical(other.senderName, senderName) || other.senderName == senderName)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&const DeepCollectionEquality().equals(other._content, _content)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._metadata, _metadata)&&(identical(other.createdByAuthorAt, createdByAuthorAt) || other.createdByAuthorAt == createdByAuthorAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.seenAt, seenAt) || other.seenAt == seenAt)&&(identical(other.deliveredAt, deliveredAt) || other.deliveredAt == deliveredAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.isMe, isMe) || other.isMe == isMe)&&(identical(other.active, active) || other.active == active)&&(identical(other.deleted, deleted) || other.deleted == deleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,uid,localId,jobId,authorType,createdByUid,createdByProfileUid,senderName,senderId,const DeepCollectionEquality().hash(_content),type,const DeepCollectionEquality().hash(_metadata),createdByAuthorAt,createdAt,updatedAt,seenAt,deliveredAt,status,isMe,active,deleted]);

@override
String toString() {
  return 'JobChatMessageModel(uid: $uid, localId: $localId, jobId: $jobId, authorType: $authorType, createdByUid: $createdByUid, createdByProfileUid: $createdByProfileUid, senderName: $senderName, senderId: $senderId, content: $content, type: $type, metadata: $metadata, createdByAuthorAt: $createdByAuthorAt, createdAt: $createdAt, updatedAt: $updatedAt, seenAt: $seenAt, deliveredAt: $deliveredAt, status: $status, isMe: $isMe, active: $active, deleted: $deleted)';
}


}

/// @nodoc
abstract mixin class _$JobChatMessageModelCopyWith<$Res> implements $JobChatMessageModelCopyWith<$Res> {
  factory _$JobChatMessageModelCopyWith(_JobChatMessageModel value, $Res Function(_JobChatMessageModel) _then) = __$JobChatMessageModelCopyWithImpl;
@override @useResult
$Res call({
 String uid, String? localId, String jobId, String authorType, String? createdByUid, String? createdByProfileUid, String? senderName, String? senderId, List<JobChatMessageContentModel> content, String type, Map<String, dynamic>? metadata,@DateTimeConverter() DateTime createdByAuthorAt,@DateTimeNullableConverter() DateTime? createdAt,@DateTimeNullableConverter() DateTime? updatedAt,@DateTimeNullableConverter() DateTime? seenAt,@DateTimeNullableConverter() DateTime? deliveredAt, String status, bool isMe, bool active, bool deleted
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
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? localId = freezed,Object? jobId = null,Object? authorType = null,Object? createdByUid = freezed,Object? createdByProfileUid = freezed,Object? senderName = freezed,Object? senderId = freezed,Object? content = null,Object? type = null,Object? metadata = freezed,Object? createdByAuthorAt = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? seenAt = freezed,Object? deliveredAt = freezed,Object? status = null,Object? isMe = null,Object? active = null,Object? deleted = null,}) {
  return _then(_JobChatMessageModel(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,localId: freezed == localId ? _self.localId : localId // ignore: cast_nullable_to_non_nullable
as String?,jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,authorType: null == authorType ? _self.authorType : authorType // ignore: cast_nullable_to_non_nullable
as String,createdByUid: freezed == createdByUid ? _self.createdByUid : createdByUid // ignore: cast_nullable_to_non_nullable
as String?,createdByProfileUid: freezed == createdByProfileUid ? _self.createdByProfileUid : createdByProfileUid // ignore: cast_nullable_to_non_nullable
as String?,senderName: freezed == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String?,senderId: freezed == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String?,content: null == content ? _self._content : content // ignore: cast_nullable_to_non_nullable
as List<JobChatMessageContentModel>,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdByAuthorAt: null == createdByAuthorAt ? _self.createdByAuthorAt : createdByAuthorAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,seenAt: freezed == seenAt ? _self.seenAt : seenAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deliveredAt: freezed == deliveredAt ? _self.deliveredAt : deliveredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,isMe: null == isMe ? _self.isMe : isMe // ignore: cast_nullable_to_non_nullable
as bool,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,deleted: null == deleted ? _self.deleted : deleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
