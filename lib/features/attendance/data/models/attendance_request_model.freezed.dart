// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AttendanceRequestModel {

 String get accountUid; double get latitude; double get longitude; String? get address;
/// Create a copy of AttendanceRequestModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceRequestModelCopyWith<AttendanceRequestModel> get copyWith => _$AttendanceRequestModelCopyWithImpl<AttendanceRequestModel>(this as AttendanceRequestModel, _$identity);

  /// Serializes this AttendanceRequestModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceRequestModel&&(identical(other.accountUid, accountUid) || other.accountUid == accountUid)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.address, address) || other.address == address));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accountUid,latitude,longitude,address);

@override
String toString() {
  return 'AttendanceRequestModel(accountUid: $accountUid, latitude: $latitude, longitude: $longitude, address: $address)';
}


}

/// @nodoc
abstract mixin class $AttendanceRequestModelCopyWith<$Res>  {
  factory $AttendanceRequestModelCopyWith(AttendanceRequestModel value, $Res Function(AttendanceRequestModel) _then) = _$AttendanceRequestModelCopyWithImpl;
@useResult
$Res call({
 String accountUid, double latitude, double longitude, String? address
});




}
/// @nodoc
class _$AttendanceRequestModelCopyWithImpl<$Res>
    implements $AttendanceRequestModelCopyWith<$Res> {
  _$AttendanceRequestModelCopyWithImpl(this._self, this._then);

  final AttendanceRequestModel _self;
  final $Res Function(AttendanceRequestModel) _then;

/// Create a copy of AttendanceRequestModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountUid = null,Object? latitude = null,Object? longitude = null,Object? address = freezed,}) {
  return _then(_self.copyWith(
accountUid: null == accountUid ? _self.accountUid : accountUid // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AttendanceRequestModel].
extension AttendanceRequestModelPatterns on AttendanceRequestModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceRequestModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceRequestModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceRequestModel value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceRequestModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceRequestModel value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceRequestModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String accountUid,  double latitude,  double longitude,  String? address)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceRequestModel() when $default != null:
return $default(_that.accountUid,_that.latitude,_that.longitude,_that.address);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String accountUid,  double latitude,  double longitude,  String? address)  $default,) {final _that = this;
switch (_that) {
case _AttendanceRequestModel():
return $default(_that.accountUid,_that.latitude,_that.longitude,_that.address);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String accountUid,  double latitude,  double longitude,  String? address)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceRequestModel() when $default != null:
return $default(_that.accountUid,_that.latitude,_that.longitude,_that.address);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttendanceRequestModel implements AttendanceRequestModel {
  const _AttendanceRequestModel({required this.accountUid, required this.latitude, required this.longitude, this.address});
  factory _AttendanceRequestModel.fromJson(Map<String, dynamic> json) => _$AttendanceRequestModelFromJson(json);

@override final  String accountUid;
@override final  double latitude;
@override final  double longitude;
@override final  String? address;

/// Create a copy of AttendanceRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceRequestModelCopyWith<_AttendanceRequestModel> get copyWith => __$AttendanceRequestModelCopyWithImpl<_AttendanceRequestModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttendanceRequestModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceRequestModel&&(identical(other.accountUid, accountUid) || other.accountUid == accountUid)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.address, address) || other.address == address));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accountUid,latitude,longitude,address);

@override
String toString() {
  return 'AttendanceRequestModel(accountUid: $accountUid, latitude: $latitude, longitude: $longitude, address: $address)';
}


}

/// @nodoc
abstract mixin class _$AttendanceRequestModelCopyWith<$Res> implements $AttendanceRequestModelCopyWith<$Res> {
  factory _$AttendanceRequestModelCopyWith(_AttendanceRequestModel value, $Res Function(_AttendanceRequestModel) _then) = __$AttendanceRequestModelCopyWithImpl;
@override @useResult
$Res call({
 String accountUid, double latitude, double longitude, String? address
});




}
/// @nodoc
class __$AttendanceRequestModelCopyWithImpl<$Res>
    implements _$AttendanceRequestModelCopyWith<$Res> {
  __$AttendanceRequestModelCopyWithImpl(this._self, this._then);

  final _AttendanceRequestModel _self;
  final $Res Function(_AttendanceRequestModel) _then;

/// Create a copy of AttendanceRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountUid = null,Object? latitude = null,Object? longitude = null,Object? address = freezed,}) {
  return _then(_AttendanceRequestModel(
accountUid: null == accountUid ? _self.accountUid : accountUid // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
