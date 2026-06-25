// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AttendanceModel {

 int get id; String get profileUid; String get userUid; String get companyUid;@DateTimeConverter() DateTime get startAt;@DateTimeNullableConverter() DateTime? get endAt; double? get startLatitude; double? get startLongitude; double? get endLatitude; double? get endLongitude; double? get workHours; String? get startAddress; String? get endAddress;@AttendanceStatusConverter() AttendanceStatus get status;
/// Create a copy of AttendanceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceModelCopyWith<AttendanceModel> get copyWith => _$AttendanceModelCopyWithImpl<AttendanceModel>(this as AttendanceModel, _$identity);

  /// Serializes this AttendanceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceModel&&super == other&&(identical(other.id, id) || other.id == id)&&(identical(other.profileUid, profileUid) || other.profileUid == profileUid)&&(identical(other.userUid, userUid) || other.userUid == userUid)&&(identical(other.companyUid, companyUid) || other.companyUid == companyUid)&&(identical(other.startAt, startAt) || other.startAt == startAt)&&(identical(other.endAt, endAt) || other.endAt == endAt)&&(identical(other.startLatitude, startLatitude) || other.startLatitude == startLatitude)&&(identical(other.startLongitude, startLongitude) || other.startLongitude == startLongitude)&&(identical(other.endLatitude, endLatitude) || other.endLatitude == endLatitude)&&(identical(other.endLongitude, endLongitude) || other.endLongitude == endLongitude)&&(identical(other.workHours, workHours) || other.workHours == workHours)&&(identical(other.startAddress, startAddress) || other.startAddress == startAddress)&&(identical(other.endAddress, endAddress) || other.endAddress == endAddress)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,super.hashCode,id,profileUid,userUid,companyUid,startAt,endAt,startLatitude,startLongitude,endLatitude,endLongitude,workHours,startAddress,endAddress,status);



}

/// @nodoc
abstract mixin class $AttendanceModelCopyWith<$Res>  {
  factory $AttendanceModelCopyWith(AttendanceModel value, $Res Function(AttendanceModel) _then) = _$AttendanceModelCopyWithImpl;
@useResult
$Res call({
 int id, String profileUid, String userUid, String companyUid,@DateTimeConverter() DateTime startAt,@DateTimeNullableConverter() DateTime? endAt, double? startLatitude, double? startLongitude, double? endLatitude, double? endLongitude, double? workHours, String? startAddress, String? endAddress,@AttendanceStatusConverter() AttendanceStatus status
});




}
/// @nodoc
class _$AttendanceModelCopyWithImpl<$Res>
    implements $AttendanceModelCopyWith<$Res> {
  _$AttendanceModelCopyWithImpl(this._self, this._then);

  final AttendanceModel _self;
  final $Res Function(AttendanceModel) _then;

/// Create a copy of AttendanceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? profileUid = null,Object? userUid = null,Object? companyUid = null,Object? startAt = null,Object? endAt = freezed,Object? startLatitude = freezed,Object? startLongitude = freezed,Object? endLatitude = freezed,Object? endLongitude = freezed,Object? workHours = freezed,Object? startAddress = freezed,Object? endAddress = freezed,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,profileUid: null == profileUid ? _self.profileUid : profileUid // ignore: cast_nullable_to_non_nullable
as String,userUid: null == userUid ? _self.userUid : userUid // ignore: cast_nullable_to_non_nullable
as String,companyUid: null == companyUid ? _self.companyUid : companyUid // ignore: cast_nullable_to_non_nullable
as String,startAt: null == startAt ? _self.startAt : startAt // ignore: cast_nullable_to_non_nullable
as DateTime,endAt: freezed == endAt ? _self.endAt : endAt // ignore: cast_nullable_to_non_nullable
as DateTime?,startLatitude: freezed == startLatitude ? _self.startLatitude : startLatitude // ignore: cast_nullable_to_non_nullable
as double?,startLongitude: freezed == startLongitude ? _self.startLongitude : startLongitude // ignore: cast_nullable_to_non_nullable
as double?,endLatitude: freezed == endLatitude ? _self.endLatitude : endLatitude // ignore: cast_nullable_to_non_nullable
as double?,endLongitude: freezed == endLongitude ? _self.endLongitude : endLongitude // ignore: cast_nullable_to_non_nullable
as double?,workHours: freezed == workHours ? _self.workHours : workHours // ignore: cast_nullable_to_non_nullable
as double?,startAddress: freezed == startAddress ? _self.startAddress : startAddress // ignore: cast_nullable_to_non_nullable
as String?,endAddress: freezed == endAddress ? _self.endAddress : endAddress // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AttendanceStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [AttendanceModel].
extension AttendanceModelPatterns on AttendanceModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceModel value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceModel value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String profileUid,  String userUid,  String companyUid, @DateTimeConverter()  DateTime startAt, @DateTimeNullableConverter()  DateTime? endAt,  double? startLatitude,  double? startLongitude,  double? endLatitude,  double? endLongitude,  double? workHours,  String? startAddress,  String? endAddress, @AttendanceStatusConverter()  AttendanceStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceModel() when $default != null:
return $default(_that.id,_that.profileUid,_that.userUid,_that.companyUid,_that.startAt,_that.endAt,_that.startLatitude,_that.startLongitude,_that.endLatitude,_that.endLongitude,_that.workHours,_that.startAddress,_that.endAddress,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String profileUid,  String userUid,  String companyUid, @DateTimeConverter()  DateTime startAt, @DateTimeNullableConverter()  DateTime? endAt,  double? startLatitude,  double? startLongitude,  double? endLatitude,  double? endLongitude,  double? workHours,  String? startAddress,  String? endAddress, @AttendanceStatusConverter()  AttendanceStatus status)  $default,) {final _that = this;
switch (_that) {
case _AttendanceModel():
return $default(_that.id,_that.profileUid,_that.userUid,_that.companyUid,_that.startAt,_that.endAt,_that.startLatitude,_that.startLongitude,_that.endLatitude,_that.endLongitude,_that.workHours,_that.startAddress,_that.endAddress,_that.status);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String profileUid,  String userUid,  String companyUid, @DateTimeConverter()  DateTime startAt, @DateTimeNullableConverter()  DateTime? endAt,  double? startLatitude,  double? startLongitude,  double? endLatitude,  double? endLongitude,  double? workHours,  String? startAddress,  String? endAddress, @AttendanceStatusConverter()  AttendanceStatus status)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceModel() when $default != null:
return $default(_that.id,_that.profileUid,_that.userUid,_that.companyUid,_that.startAt,_that.endAt,_that.startLatitude,_that.startLongitude,_that.endLatitude,_that.endLongitude,_that.workHours,_that.startAddress,_that.endAddress,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttendanceModel extends AttendanceModel {
  const _AttendanceModel({required this.id, required this.profileUid, required this.userUid, required this.companyUid, @DateTimeConverter() required this.startAt, @DateTimeNullableConverter() this.endAt, this.startLatitude, this.startLongitude, this.endLatitude, this.endLongitude, this.workHours, this.startAddress, this.endAddress, @AttendanceStatusConverter() required this.status}): super._();
  factory _AttendanceModel.fromJson(Map<String, dynamic> json) => _$AttendanceModelFromJson(json);

@override final  int id;
@override final  String profileUid;
@override final  String userUid;
@override final  String companyUid;
@override@DateTimeConverter() final  DateTime startAt;
@override@DateTimeNullableConverter() final  DateTime? endAt;
@override final  double? startLatitude;
@override final  double? startLongitude;
@override final  double? endLatitude;
@override final  double? endLongitude;
@override final  double? workHours;
@override final  String? startAddress;
@override final  String? endAddress;
@override@AttendanceStatusConverter() final  AttendanceStatus status;

/// Create a copy of AttendanceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceModelCopyWith<_AttendanceModel> get copyWith => __$AttendanceModelCopyWithImpl<_AttendanceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttendanceModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceModel&&super == other&&(identical(other.id, id) || other.id == id)&&(identical(other.profileUid, profileUid) || other.profileUid == profileUid)&&(identical(other.userUid, userUid) || other.userUid == userUid)&&(identical(other.companyUid, companyUid) || other.companyUid == companyUid)&&(identical(other.startAt, startAt) || other.startAt == startAt)&&(identical(other.endAt, endAt) || other.endAt == endAt)&&(identical(other.startLatitude, startLatitude) || other.startLatitude == startLatitude)&&(identical(other.startLongitude, startLongitude) || other.startLongitude == startLongitude)&&(identical(other.endLatitude, endLatitude) || other.endLatitude == endLatitude)&&(identical(other.endLongitude, endLongitude) || other.endLongitude == endLongitude)&&(identical(other.workHours, workHours) || other.workHours == workHours)&&(identical(other.startAddress, startAddress) || other.startAddress == startAddress)&&(identical(other.endAddress, endAddress) || other.endAddress == endAddress)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,super.hashCode,id,profileUid,userUid,companyUid,startAt,endAt,startLatitude,startLongitude,endLatitude,endLongitude,workHours,startAddress,endAddress,status);



}

/// @nodoc
abstract mixin class _$AttendanceModelCopyWith<$Res> implements $AttendanceModelCopyWith<$Res> {
  factory _$AttendanceModelCopyWith(_AttendanceModel value, $Res Function(_AttendanceModel) _then) = __$AttendanceModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String profileUid, String userUid, String companyUid,@DateTimeConverter() DateTime startAt,@DateTimeNullableConverter() DateTime? endAt, double? startLatitude, double? startLongitude, double? endLatitude, double? endLongitude, double? workHours, String? startAddress, String? endAddress,@AttendanceStatusConverter() AttendanceStatus status
});




}
/// @nodoc
class __$AttendanceModelCopyWithImpl<$Res>
    implements _$AttendanceModelCopyWith<$Res> {
  __$AttendanceModelCopyWithImpl(this._self, this._then);

  final _AttendanceModel _self;
  final $Res Function(_AttendanceModel) _then;

/// Create a copy of AttendanceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? profileUid = null,Object? userUid = null,Object? companyUid = null,Object? startAt = null,Object? endAt = freezed,Object? startLatitude = freezed,Object? startLongitude = freezed,Object? endLatitude = freezed,Object? endLongitude = freezed,Object? workHours = freezed,Object? startAddress = freezed,Object? endAddress = freezed,Object? status = null,}) {
  return _then(_AttendanceModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,profileUid: null == profileUid ? _self.profileUid : profileUid // ignore: cast_nullable_to_non_nullable
as String,userUid: null == userUid ? _self.userUid : userUid // ignore: cast_nullable_to_non_nullable
as String,companyUid: null == companyUid ? _self.companyUid : companyUid // ignore: cast_nullable_to_non_nullable
as String,startAt: null == startAt ? _self.startAt : startAt // ignore: cast_nullable_to_non_nullable
as DateTime,endAt: freezed == endAt ? _self.endAt : endAt // ignore: cast_nullable_to_non_nullable
as DateTime?,startLatitude: freezed == startLatitude ? _self.startLatitude : startLatitude // ignore: cast_nullable_to_non_nullable
as double?,startLongitude: freezed == startLongitude ? _self.startLongitude : startLongitude // ignore: cast_nullable_to_non_nullable
as double?,endLatitude: freezed == endLatitude ? _self.endLatitude : endLatitude // ignore: cast_nullable_to_non_nullable
as double?,endLongitude: freezed == endLongitude ? _self.endLongitude : endLongitude // ignore: cast_nullable_to_non_nullable
as double?,workHours: freezed == workHours ? _self.workHours : workHours // ignore: cast_nullable_to_non_nullable
as double?,startAddress: freezed == startAddress ? _self.startAddress : startAddress // ignore: cast_nullable_to_non_nullable
as String?,endAddress: freezed == endAddress ? _self.endAddress : endAddress // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AttendanceStatus,
  ));
}


}

// dart format on
