// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'enqueue_task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EnqueueTask {

 String get action; Map<String, dynamic> get data; String get requestId;
/// Create a copy of EnqueueTask
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EnqueueTaskCopyWith<EnqueueTask> get copyWith => _$EnqueueTaskCopyWithImpl<EnqueueTask>(this as EnqueueTask, _$identity);

  /// Serializes this EnqueueTask to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EnqueueTask&&(identical(other.action, action) || other.action == action)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.requestId, requestId) || other.requestId == requestId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,action,const DeepCollectionEquality().hash(data),requestId);

@override
String toString() {
  return 'EnqueueTask(action: $action, data: $data, requestId: $requestId)';
}


}

/// @nodoc
abstract mixin class $EnqueueTaskCopyWith<$Res>  {
  factory $EnqueueTaskCopyWith(EnqueueTask value, $Res Function(EnqueueTask) _then) = _$EnqueueTaskCopyWithImpl;
@useResult
$Res call({
 String action, Map<String, dynamic> data, String requestId
});




}
/// @nodoc
class _$EnqueueTaskCopyWithImpl<$Res>
    implements $EnqueueTaskCopyWith<$Res> {
  _$EnqueueTaskCopyWithImpl(this._self, this._then);

  final EnqueueTask _self;
  final $Res Function(EnqueueTask) _then;

/// Create a copy of EnqueueTask
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? action = null,Object? data = null,Object? requestId = null,}) {
  return _then(_self.copyWith(
action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [EnqueueTask].
extension EnqueueTaskPatterns on EnqueueTask {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EnqueueTask value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EnqueueTask() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EnqueueTask value)  $default,){
final _that = this;
switch (_that) {
case _EnqueueTask():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EnqueueTask value)?  $default,){
final _that = this;
switch (_that) {
case _EnqueueTask() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String action,  Map<String, dynamic> data,  String requestId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EnqueueTask() when $default != null:
return $default(_that.action,_that.data,_that.requestId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String action,  Map<String, dynamic> data,  String requestId)  $default,) {final _that = this;
switch (_that) {
case _EnqueueTask():
return $default(_that.action,_that.data,_that.requestId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String action,  Map<String, dynamic> data,  String requestId)?  $default,) {final _that = this;
switch (_that) {
case _EnqueueTask() when $default != null:
return $default(_that.action,_that.data,_that.requestId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EnqueueTask extends EnqueueTask {
  const _EnqueueTask({required this.action, required final  Map<String, dynamic> data, required this.requestId}): _data = data,super._();
  factory _EnqueueTask.fromJson(Map<String, dynamic> json) => _$EnqueueTaskFromJson(json);

@override final  String action;
 final  Map<String, dynamic> _data;
@override Map<String, dynamic> get data {
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_data);
}

@override final  String requestId;

/// Create a copy of EnqueueTask
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EnqueueTaskCopyWith<_EnqueueTask> get copyWith => __$EnqueueTaskCopyWithImpl<_EnqueueTask>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EnqueueTaskToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EnqueueTask&&(identical(other.action, action) || other.action == action)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.requestId, requestId) || other.requestId == requestId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,action,const DeepCollectionEquality().hash(_data),requestId);

@override
String toString() {
  return 'EnqueueTask(action: $action, data: $data, requestId: $requestId)';
}


}

/// @nodoc
abstract mixin class _$EnqueueTaskCopyWith<$Res> implements $EnqueueTaskCopyWith<$Res> {
  factory _$EnqueueTaskCopyWith(_EnqueueTask value, $Res Function(_EnqueueTask) _then) = __$EnqueueTaskCopyWithImpl;
@override @useResult
$Res call({
 String action, Map<String, dynamic> data, String requestId
});




}
/// @nodoc
class __$EnqueueTaskCopyWithImpl<$Res>
    implements _$EnqueueTaskCopyWith<$Res> {
  __$EnqueueTaskCopyWithImpl(this._self, this._then);

  final _EnqueueTask _self;
  final $Res Function(_EnqueueTask) _then;

/// Create a copy of EnqueueTask
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? action = null,Object? data = null,Object? requestId = null,}) {
  return _then(_EnqueueTask(
action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
