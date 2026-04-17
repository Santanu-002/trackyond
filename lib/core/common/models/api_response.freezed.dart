// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ApiResponse<T> {

 bool get success; String get message; T? get data;
/// Create a copy of ApiResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiResponseCopyWith<T, ApiResponse<T>> get copyWith => _$ApiResponseCopyWithImpl<T, ApiResponse<T>>(this as ApiResponse<T>, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiResponse<T>&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, data));
}


@override
int get hashCode => Object.hash(runtimeType,success,message,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'ApiResponse<$T>(success: $success, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $ApiResponseCopyWith<T,$Res>  {
  factory $ApiResponseCopyWith(ApiResponse<T> value, $Res Function(ApiResponse<T>) _then) = _$ApiResponseCopyWithImpl;
@useResult
$Res call({
 bool success, String message, T? data
});




}
/// @nodoc
class _$ApiResponseCopyWithImpl<T,$Res>
    implements $ApiResponseCopyWith<T, $Res> {
  _$ApiResponseCopyWithImpl(this._self, this._then);

  final ApiResponse<T> _self;
  final $Res Function(ApiResponse<T>) _then;

/// Create a copy of ApiResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? message = null,Object? data = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T?,
  ));
}

}


/// Adds pattern-matching-related methods to [ApiResponse].
extension ApiResponsePatterns<T> on ApiResponse<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ApiResponseSuccess<T> value)?  success,TResult Function( ApiResponseError<T> value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ApiResponseSuccess() when success != null:
return success(_that);case ApiResponseError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ApiResponseSuccess<T> value)  success,required TResult Function( ApiResponseError<T> value)  error,}){
final _that = this;
switch (_that) {
case ApiResponseSuccess():
return success(_that);case ApiResponseError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ApiResponseSuccess<T> value)?  success,TResult? Function( ApiResponseError<T> value)?  error,}){
final _that = this;
switch (_that) {
case ApiResponseSuccess() when success != null:
return success(_that);case ApiResponseError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( bool success,  String message,  T? data)?  success,TResult Function( bool success,  String message,  T? data,  int? statusCode)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ApiResponseSuccess() when success != null:
return success(_that.success,_that.message,_that.data);case ApiResponseError() when error != null:
return error(_that.success,_that.message,_that.data,_that.statusCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( bool success,  String message,  T? data)  success,required TResult Function( bool success,  String message,  T? data,  int? statusCode)  error,}) {final _that = this;
switch (_that) {
case ApiResponseSuccess():
return success(_that.success,_that.message,_that.data);case ApiResponseError():
return error(_that.success,_that.message,_that.data,_that.statusCode);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( bool success,  String message,  T? data)?  success,TResult? Function( bool success,  String message,  T? data,  int? statusCode)?  error,}) {final _that = this;
switch (_that) {
case ApiResponseSuccess() when success != null:
return success(_that.success,_that.message,_that.data);case ApiResponseError() when error != null:
return error(_that.success,_that.message,_that.data,_that.statusCode);case _:
  return null;

}
}

}

/// @nodoc


class ApiResponseSuccess<T> implements ApiResponse<T> {
  const ApiResponseSuccess({required this.success, required this.message, this.data});
  

@override final  bool success;
@override final  String message;
@override final  T? data;

/// Create a copy of ApiResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiResponseSuccessCopyWith<T, ApiResponseSuccess<T>> get copyWith => _$ApiResponseSuccessCopyWithImpl<T, ApiResponseSuccess<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiResponseSuccess<T>&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, data));
}


@override
int get hashCode => Object.hash(runtimeType,success,message,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'ApiResponse<$T>.success(success: $success, message: $message, data: $data)';
}


}

/// @nodoc
abstract mixin class $ApiResponseSuccessCopyWith<T,$Res> implements $ApiResponseCopyWith<T, $Res> {
  factory $ApiResponseSuccessCopyWith(ApiResponseSuccess<T> value, $Res Function(ApiResponseSuccess<T>) _then) = _$ApiResponseSuccessCopyWithImpl;
@override @useResult
$Res call({
 bool success, String message, T? data
});




}
/// @nodoc
class _$ApiResponseSuccessCopyWithImpl<T,$Res>
    implements $ApiResponseSuccessCopyWith<T, $Res> {
  _$ApiResponseSuccessCopyWithImpl(this._self, this._then);

  final ApiResponseSuccess<T> _self;
  final $Res Function(ApiResponseSuccess<T>) _then;

/// Create a copy of ApiResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? message = null,Object? data = freezed,}) {
  return _then(ApiResponseSuccess<T>(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T?,
  ));
}


}

/// @nodoc


class ApiResponseError<T> implements ApiResponse<T> {
  const ApiResponseError({required this.success, required this.message, this.data, this.statusCode});
  

@override final  bool success;
@override final  String message;
@override final  T? data;
 final  int? statusCode;

/// Create a copy of ApiResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiResponseErrorCopyWith<T, ApiResponseError<T>> get copyWith => _$ApiResponseErrorCopyWithImpl<T, ApiResponseError<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiResponseError<T>&&(identical(other.success, success) || other.success == success)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode));
}


@override
int get hashCode => Object.hash(runtimeType,success,message,const DeepCollectionEquality().hash(data),statusCode);

@override
String toString() {
  return 'ApiResponse<$T>.error(success: $success, message: $message, data: $data, statusCode: $statusCode)';
}


}

/// @nodoc
abstract mixin class $ApiResponseErrorCopyWith<T,$Res> implements $ApiResponseCopyWith<T, $Res> {
  factory $ApiResponseErrorCopyWith(ApiResponseError<T> value, $Res Function(ApiResponseError<T>) _then) = _$ApiResponseErrorCopyWithImpl;
@override @useResult
$Res call({
 bool success, String message, T? data, int? statusCode
});




}
/// @nodoc
class _$ApiResponseErrorCopyWithImpl<T,$Res>
    implements $ApiResponseErrorCopyWith<T, $Res> {
  _$ApiResponseErrorCopyWithImpl(this._self, this._then);

  final ApiResponseError<T> _self;
  final $Res Function(ApiResponseError<T>) _then;

/// Create a copy of ApiResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? message = null,Object? data = freezed,Object? statusCode = freezed,}) {
  return _then(ApiResponseError<T>(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T?,statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
