// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'queue_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QueueResponse {

 String get action; bool get success; String? get error; Map<String, dynamic>? get data; String? get requestId;
/// Create a copy of QueueResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QueueResponseCopyWith<QueueResponse> get copyWith => _$QueueResponseCopyWithImpl<QueueResponse>(this as QueueResponse, _$identity);

  /// Serializes this QueueResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QueueResponse&&(identical(other.action, action) || other.action == action)&&(identical(other.success, success) || other.success == success)&&(identical(other.error, error) || other.error == error)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.requestId, requestId) || other.requestId == requestId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,action,success,error,const DeepCollectionEquality().hash(data),requestId);

@override
String toString() {
  return 'QueueResponse(action: $action, success: $success, error: $error, data: $data, requestId: $requestId)';
}


}

/// @nodoc
abstract mixin class $QueueResponseCopyWith<$Res>  {
  factory $QueueResponseCopyWith(QueueResponse value, $Res Function(QueueResponse) _then) = _$QueueResponseCopyWithImpl;
@useResult
$Res call({
 String action, bool success, String? error, Map<String, dynamic>? data, String? requestId
});




}
/// @nodoc
class _$QueueResponseCopyWithImpl<$Res>
    implements $QueueResponseCopyWith<$Res> {
  _$QueueResponseCopyWithImpl(this._self, this._then);

  final QueueResponse _self;
  final $Res Function(QueueResponse) _then;

/// Create a copy of QueueResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? action = null,Object? success = null,Object? error = freezed,Object? data = freezed,Object? requestId = freezed,}) {
  return _then(_self.copyWith(
action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,requestId: freezed == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [QueueResponse].
extension QueueResponsePatterns on QueueResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QueueResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QueueResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QueueResponse value)  $default,){
final _that = this;
switch (_that) {
case _QueueResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QueueResponse value)?  $default,){
final _that = this;
switch (_that) {
case _QueueResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String action,  bool success,  String? error,  Map<String, dynamic>? data,  String? requestId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QueueResponse() when $default != null:
return $default(_that.action,_that.success,_that.error,_that.data,_that.requestId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String action,  bool success,  String? error,  Map<String, dynamic>? data,  String? requestId)  $default,) {final _that = this;
switch (_that) {
case _QueueResponse():
return $default(_that.action,_that.success,_that.error,_that.data,_that.requestId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String action,  bool success,  String? error,  Map<String, dynamic>? data,  String? requestId)?  $default,) {final _that = this;
switch (_that) {
case _QueueResponse() when $default != null:
return $default(_that.action,_that.success,_that.error,_that.data,_that.requestId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QueueResponse extends QueueResponse {
  const _QueueResponse({required this.action, required this.success, this.error, final  Map<String, dynamic>? data, this.requestId}): _data = data,super._();
  factory _QueueResponse.fromJson(Map<String, dynamic> json) => _$QueueResponseFromJson(json);

@override final  String action;
@override final  bool success;
@override final  String? error;
 final  Map<String, dynamic>? _data;
@override Map<String, dynamic>? get data {
  final value = _data;
  if (value == null) return null;
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  String? requestId;

/// Create a copy of QueueResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QueueResponseCopyWith<_QueueResponse> get copyWith => __$QueueResponseCopyWithImpl<_QueueResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QueueResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QueueResponse&&(identical(other.action, action) || other.action == action)&&(identical(other.success, success) || other.success == success)&&(identical(other.error, error) || other.error == error)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.requestId, requestId) || other.requestId == requestId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,action,success,error,const DeepCollectionEquality().hash(_data),requestId);

@override
String toString() {
  return 'QueueResponse(action: $action, success: $success, error: $error, data: $data, requestId: $requestId)';
}


}

/// @nodoc
abstract mixin class _$QueueResponseCopyWith<$Res> implements $QueueResponseCopyWith<$Res> {
  factory _$QueueResponseCopyWith(_QueueResponse value, $Res Function(_QueueResponse) _then) = __$QueueResponseCopyWithImpl;
@override @useResult
$Res call({
 String action, bool success, String? error, Map<String, dynamic>? data, String? requestId
});




}
/// @nodoc
class __$QueueResponseCopyWithImpl<$Res>
    implements _$QueueResponseCopyWith<$Res> {
  __$QueueResponseCopyWithImpl(this._self, this._then);

  final _QueueResponse _self;
  final $Res Function(_QueueResponse) _then;

/// Create a copy of QueueResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? action = null,Object? success = null,Object? error = freezed,Object? data = freezed,Object? requestId = freezed,}) {
  return _then(_QueueResponse(
action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,data: freezed == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,requestId: freezed == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
