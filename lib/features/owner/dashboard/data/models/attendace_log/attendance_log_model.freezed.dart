// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance_log_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AttendanceLogModel {

 String get logUid; String get accountUid; String get userUid; String get name; String get status;@DateTimeConverter() DateTime get startAt;@DateTimeNullableConverter() DateTime? get endAt; String? get startLocation; String? get endLocation;
/// Create a copy of AttendanceLogModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceLogModelCopyWith<AttendanceLogModel> get copyWith => _$AttendanceLogModelCopyWithImpl<AttendanceLogModel>(this as AttendanceLogModel, _$identity);

  /// Serializes this AttendanceLogModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceLogModel&&(identical(other.logUid, logUid) || other.logUid == logUid)&&(identical(other.accountUid, accountUid) || other.accountUid == accountUid)&&(identical(other.userUid, userUid) || other.userUid == userUid)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.startAt, startAt) || other.startAt == startAt)&&(identical(other.endAt, endAt) || other.endAt == endAt)&&(identical(other.startLocation, startLocation) || other.startLocation == startLocation)&&(identical(other.endLocation, endLocation) || other.endLocation == endLocation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,logUid,accountUid,userUid,name,status,startAt,endAt,startLocation,endLocation);

@override
String toString() {
  return 'AttendanceLogModel(logUid: $logUid, accountUid: $accountUid, userUid: $userUid, name: $name, status: $status, startAt: $startAt, endAt: $endAt, startLocation: $startLocation, endLocation: $endLocation)';
}


}

/// @nodoc
abstract mixin class $AttendanceLogModelCopyWith<$Res>  {
  factory $AttendanceLogModelCopyWith(AttendanceLogModel value, $Res Function(AttendanceLogModel) _then) = _$AttendanceLogModelCopyWithImpl;
@useResult
$Res call({
 String logUid, String accountUid, String userUid, String name, String status,@DateTimeConverter() DateTime startAt,@DateTimeNullableConverter() DateTime? endAt, String? startLocation, String? endLocation
});




}
/// @nodoc
class _$AttendanceLogModelCopyWithImpl<$Res>
    implements $AttendanceLogModelCopyWith<$Res> {
  _$AttendanceLogModelCopyWithImpl(this._self, this._then);

  final AttendanceLogModel _self;
  final $Res Function(AttendanceLogModel) _then;

/// Create a copy of AttendanceLogModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? logUid = null,Object? accountUid = null,Object? userUid = null,Object? name = null,Object? status = null,Object? startAt = null,Object? endAt = freezed,Object? startLocation = freezed,Object? endLocation = freezed,}) {
  return _then(_self.copyWith(
logUid: null == logUid ? _self.logUid : logUid // ignore: cast_nullable_to_non_nullable
as String,accountUid: null == accountUid ? _self.accountUid : accountUid // ignore: cast_nullable_to_non_nullable
as String,userUid: null == userUid ? _self.userUid : userUid // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startAt: null == startAt ? _self.startAt : startAt // ignore: cast_nullable_to_non_nullable
as DateTime,endAt: freezed == endAt ? _self.endAt : endAt // ignore: cast_nullable_to_non_nullable
as DateTime?,startLocation: freezed == startLocation ? _self.startLocation : startLocation // ignore: cast_nullable_to_non_nullable
as String?,endLocation: freezed == endLocation ? _self.endLocation : endLocation // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AttendanceLogModel].
extension AttendanceLogModelPatterns on AttendanceLogModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceLogModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceLogModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceLogModel value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceLogModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceLogModel value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceLogModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String logUid,  String accountUid,  String userUid,  String name,  String status, @DateTimeConverter()  DateTime startAt, @DateTimeNullableConverter()  DateTime? endAt,  String? startLocation,  String? endLocation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceLogModel() when $default != null:
return $default(_that.logUid,_that.accountUid,_that.userUid,_that.name,_that.status,_that.startAt,_that.endAt,_that.startLocation,_that.endLocation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String logUid,  String accountUid,  String userUid,  String name,  String status, @DateTimeConverter()  DateTime startAt, @DateTimeNullableConverter()  DateTime? endAt,  String? startLocation,  String? endLocation)  $default,) {final _that = this;
switch (_that) {
case _AttendanceLogModel():
return $default(_that.logUid,_that.accountUid,_that.userUid,_that.name,_that.status,_that.startAt,_that.endAt,_that.startLocation,_that.endLocation);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String logUid,  String accountUid,  String userUid,  String name,  String status, @DateTimeConverter()  DateTime startAt, @DateTimeNullableConverter()  DateTime? endAt,  String? startLocation,  String? endLocation)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceLogModel() when $default != null:
return $default(_that.logUid,_that.accountUid,_that.userUid,_that.name,_that.status,_that.startAt,_that.endAt,_that.startLocation,_that.endLocation);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttendanceLogModel extends AttendanceLogModel {
  const _AttendanceLogModel({required this.logUid, required this.accountUid, required this.userUid, required this.name, required this.status, @DateTimeConverter() required this.startAt, @DateTimeNullableConverter() this.endAt, this.startLocation, this.endLocation}): super._();
  factory _AttendanceLogModel.fromJson(Map<String, dynamic> json) => _$AttendanceLogModelFromJson(json);

@override final  String logUid;
@override final  String accountUid;
@override final  String userUid;
@override final  String name;
@override final  String status;
@override@DateTimeConverter() final  DateTime startAt;
@override@DateTimeNullableConverter() final  DateTime? endAt;
@override final  String? startLocation;
@override final  String? endLocation;

/// Create a copy of AttendanceLogModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceLogModelCopyWith<_AttendanceLogModel> get copyWith => __$AttendanceLogModelCopyWithImpl<_AttendanceLogModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttendanceLogModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceLogModel&&(identical(other.logUid, logUid) || other.logUid == logUid)&&(identical(other.accountUid, accountUid) || other.accountUid == accountUid)&&(identical(other.userUid, userUid) || other.userUid == userUid)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.startAt, startAt) || other.startAt == startAt)&&(identical(other.endAt, endAt) || other.endAt == endAt)&&(identical(other.startLocation, startLocation) || other.startLocation == startLocation)&&(identical(other.endLocation, endLocation) || other.endLocation == endLocation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,logUid,accountUid,userUid,name,status,startAt,endAt,startLocation,endLocation);

@override
String toString() {
  return 'AttendanceLogModel(logUid: $logUid, accountUid: $accountUid, userUid: $userUid, name: $name, status: $status, startAt: $startAt, endAt: $endAt, startLocation: $startLocation, endLocation: $endLocation)';
}


}

/// @nodoc
abstract mixin class _$AttendanceLogModelCopyWith<$Res> implements $AttendanceLogModelCopyWith<$Res> {
  factory _$AttendanceLogModelCopyWith(_AttendanceLogModel value, $Res Function(_AttendanceLogModel) _then) = __$AttendanceLogModelCopyWithImpl;
@override @useResult
$Res call({
 String logUid, String accountUid, String userUid, String name, String status,@DateTimeConverter() DateTime startAt,@DateTimeNullableConverter() DateTime? endAt, String? startLocation, String? endLocation
});




}
/// @nodoc
class __$AttendanceLogModelCopyWithImpl<$Res>
    implements _$AttendanceLogModelCopyWith<$Res> {
  __$AttendanceLogModelCopyWithImpl(this._self, this._then);

  final _AttendanceLogModel _self;
  final $Res Function(_AttendanceLogModel) _then;

/// Create a copy of AttendanceLogModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? logUid = null,Object? accountUid = null,Object? userUid = null,Object? name = null,Object? status = null,Object? startAt = null,Object? endAt = freezed,Object? startLocation = freezed,Object? endLocation = freezed,}) {
  return _then(_AttendanceLogModel(
logUid: null == logUid ? _self.logUid : logUid // ignore: cast_nullable_to_non_nullable
as String,accountUid: null == accountUid ? _self.accountUid : accountUid // ignore: cast_nullable_to_non_nullable
as String,userUid: null == userUid ? _self.userUid : userUid // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,startAt: null == startAt ? _self.startAt : startAt // ignore: cast_nullable_to_non_nullable
as DateTime,endAt: freezed == endAt ? _self.endAt : endAt // ignore: cast_nullable_to_non_nullable
as DateTime?,startLocation: freezed == startLocation ? _self.startLocation : startLocation // ignore: cast_nullable_to_non_nullable
as String?,endLocation: freezed == endLocation ? _self.endLocation : endLocation // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
