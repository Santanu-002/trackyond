// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'queue_task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QueueTask {

 String get id; QueueTaskType get type;@QueuePriorityConverter() QueuePriority get priority; dynamic get payload; QueueTaskStatus get status;@MillisecondsDateTimeConverter() DateTime get createdAt;@MillisecondsDateTimeConverter() DateTime get updatedAt;
/// Create a copy of QueueTask
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QueueTaskCopyWith<QueueTask> get copyWith => _$QueueTaskCopyWithImpl<QueueTask>(this as QueueTask, _$identity);

  /// Serializes this QueueTask to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QueueTask&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.priority, priority) || other.priority == priority)&&const DeepCollectionEquality().equals(other.payload, payload)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,priority,const DeepCollectionEquality().hash(payload),status,createdAt,updatedAt);

@override
String toString() {
  return 'QueueTask(id: $id, type: $type, priority: $priority, payload: $payload, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $QueueTaskCopyWith<$Res>  {
  factory $QueueTaskCopyWith(QueueTask value, $Res Function(QueueTask) _then) = _$QueueTaskCopyWithImpl;
@useResult
$Res call({
 String id, QueueTaskType type,@QueuePriorityConverter() QueuePriority priority, dynamic payload, QueueTaskStatus status,@MillisecondsDateTimeConverter() DateTime createdAt,@MillisecondsDateTimeConverter() DateTime updatedAt
});




}
/// @nodoc
class _$QueueTaskCopyWithImpl<$Res>
    implements $QueueTaskCopyWith<$Res> {
  _$QueueTaskCopyWithImpl(this._self, this._then);

  final QueueTask _self;
  final $Res Function(QueueTask) _then;

/// Create a copy of QueueTask
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? priority = null,Object? payload = freezed,Object? status = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as QueueTaskType,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as QueuePriority,payload: freezed == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as dynamic,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as QueueTaskStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [QueueTask].
extension QueueTaskPatterns on QueueTask {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QueueTask value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QueueTask() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QueueTask value)  $default,){
final _that = this;
switch (_that) {
case _QueueTask():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QueueTask value)?  $default,){
final _that = this;
switch (_that) {
case _QueueTask() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  QueueTaskType type, @QueuePriorityConverter()  QueuePriority priority,  dynamic payload,  QueueTaskStatus status, @MillisecondsDateTimeConverter()  DateTime createdAt, @MillisecondsDateTimeConverter()  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QueueTask() when $default != null:
return $default(_that.id,_that.type,_that.priority,_that.payload,_that.status,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  QueueTaskType type, @QueuePriorityConverter()  QueuePriority priority,  dynamic payload,  QueueTaskStatus status, @MillisecondsDateTimeConverter()  DateTime createdAt, @MillisecondsDateTimeConverter()  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _QueueTask():
return $default(_that.id,_that.type,_that.priority,_that.payload,_that.status,_that.createdAt,_that.updatedAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  QueueTaskType type, @QueuePriorityConverter()  QueuePriority priority,  dynamic payload,  QueueTaskStatus status, @MillisecondsDateTimeConverter()  DateTime createdAt, @MillisecondsDateTimeConverter()  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _QueueTask() when $default != null:
return $default(_that.id,_that.type,_that.priority,_that.payload,_that.status,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QueueTask extends QueueTask {
  const _QueueTask({required this.id, required this.type, @QueuePriorityConverter() required this.priority, required this.payload, required this.status, @MillisecondsDateTimeConverter() required this.createdAt, @MillisecondsDateTimeConverter() required this.updatedAt}): super._();
  factory _QueueTask.fromJson(Map<String, dynamic> json) => _$QueueTaskFromJson(json);

@override final  String id;
@override final  QueueTaskType type;
@override@QueuePriorityConverter() final  QueuePriority priority;
@override final  dynamic payload;
@override final  QueueTaskStatus status;
@override@MillisecondsDateTimeConverter() final  DateTime createdAt;
@override@MillisecondsDateTimeConverter() final  DateTime updatedAt;

/// Create a copy of QueueTask
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QueueTaskCopyWith<_QueueTask> get copyWith => __$QueueTaskCopyWithImpl<_QueueTask>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QueueTaskToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QueueTask&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.priority, priority) || other.priority == priority)&&const DeepCollectionEquality().equals(other.payload, payload)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,priority,const DeepCollectionEquality().hash(payload),status,createdAt,updatedAt);

@override
String toString() {
  return 'QueueTask(id: $id, type: $type, priority: $priority, payload: $payload, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$QueueTaskCopyWith<$Res> implements $QueueTaskCopyWith<$Res> {
  factory _$QueueTaskCopyWith(_QueueTask value, $Res Function(_QueueTask) _then) = __$QueueTaskCopyWithImpl;
@override @useResult
$Res call({
 String id, QueueTaskType type,@QueuePriorityConverter() QueuePriority priority, dynamic payload, QueueTaskStatus status,@MillisecondsDateTimeConverter() DateTime createdAt,@MillisecondsDateTimeConverter() DateTime updatedAt
});




}
/// @nodoc
class __$QueueTaskCopyWithImpl<$Res>
    implements _$QueueTaskCopyWith<$Res> {
  __$QueueTaskCopyWithImpl(this._self, this._then);

  final _QueueTask _self;
  final $Res Function(_QueueTask) _then;

/// Create a copy of QueueTask
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? priority = null,Object? payload = freezed,Object? status = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_QueueTask(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as QueueTaskType,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as QueuePriority,payload: freezed == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as dynamic,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as QueueTaskStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
