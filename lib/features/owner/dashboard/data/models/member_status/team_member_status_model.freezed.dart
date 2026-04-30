// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_member_status_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TeamMemberStatusModel {

 String get accountUid; String get userUid; String get name; String? get designation; String? get phone; String? get image;@AttendanceStatusConverter() AttendanceStatus get status;@DateTimeNullableConverter() DateTime? get startAt; String? get currentLocation;
/// Create a copy of TeamMemberStatusModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeamMemberStatusModelCopyWith<TeamMemberStatusModel> get copyWith => _$TeamMemberStatusModelCopyWithImpl<TeamMemberStatusModel>(this as TeamMemberStatusModel, _$identity);

  /// Serializes this TeamMemberStatusModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeamMemberStatusModel&&(identical(other.accountUid, accountUid) || other.accountUid == accountUid)&&(identical(other.userUid, userUid) || other.userUid == userUid)&&(identical(other.name, name) || other.name == name)&&(identical(other.designation, designation) || other.designation == designation)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.image, image) || other.image == image)&&(identical(other.status, status) || other.status == status)&&(identical(other.startAt, startAt) || other.startAt == startAt)&&(identical(other.currentLocation, currentLocation) || other.currentLocation == currentLocation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accountUid,userUid,name,designation,phone,image,status,startAt,currentLocation);

@override
String toString() {
  return 'TeamMemberStatusModel(accountUid: $accountUid, userUid: $userUid, name: $name, designation: $designation, phone: $phone, image: $image, status: $status, startAt: $startAt, currentLocation: $currentLocation)';
}


}

/// @nodoc
abstract mixin class $TeamMemberStatusModelCopyWith<$Res>  {
  factory $TeamMemberStatusModelCopyWith(TeamMemberStatusModel value, $Res Function(TeamMemberStatusModel) _then) = _$TeamMemberStatusModelCopyWithImpl;
@useResult
$Res call({
 String accountUid, String userUid, String name, String? designation, String? phone, String? image,@AttendanceStatusConverter() AttendanceStatus status,@DateTimeNullableConverter() DateTime? startAt, String? currentLocation
});




}
/// @nodoc
class _$TeamMemberStatusModelCopyWithImpl<$Res>
    implements $TeamMemberStatusModelCopyWith<$Res> {
  _$TeamMemberStatusModelCopyWithImpl(this._self, this._then);

  final TeamMemberStatusModel _self;
  final $Res Function(TeamMemberStatusModel) _then;

/// Create a copy of TeamMemberStatusModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountUid = null,Object? userUid = null,Object? name = null,Object? designation = freezed,Object? phone = freezed,Object? image = freezed,Object? status = null,Object? startAt = freezed,Object? currentLocation = freezed,}) {
  return _then(_self.copyWith(
accountUid: null == accountUid ? _self.accountUid : accountUid // ignore: cast_nullable_to_non_nullable
as String,userUid: null == userUid ? _self.userUid : userUid // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,designation: freezed == designation ? _self.designation : designation // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AttendanceStatus,startAt: freezed == startAt ? _self.startAt : startAt // ignore: cast_nullable_to_non_nullable
as DateTime?,currentLocation: freezed == currentLocation ? _self.currentLocation : currentLocation // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TeamMemberStatusModel].
extension TeamMemberStatusModelPatterns on TeamMemberStatusModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeamMemberStatusModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeamMemberStatusModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeamMemberStatusModel value)  $default,){
final _that = this;
switch (_that) {
case _TeamMemberStatusModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeamMemberStatusModel value)?  $default,){
final _that = this;
switch (_that) {
case _TeamMemberStatusModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String accountUid,  String userUid,  String name,  String? designation,  String? phone,  String? image, @AttendanceStatusConverter()  AttendanceStatus status, @DateTimeNullableConverter()  DateTime? startAt,  String? currentLocation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeamMemberStatusModel() when $default != null:
return $default(_that.accountUid,_that.userUid,_that.name,_that.designation,_that.phone,_that.image,_that.status,_that.startAt,_that.currentLocation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String accountUid,  String userUid,  String name,  String? designation,  String? phone,  String? image, @AttendanceStatusConverter()  AttendanceStatus status, @DateTimeNullableConverter()  DateTime? startAt,  String? currentLocation)  $default,) {final _that = this;
switch (_that) {
case _TeamMemberStatusModel():
return $default(_that.accountUid,_that.userUid,_that.name,_that.designation,_that.phone,_that.image,_that.status,_that.startAt,_that.currentLocation);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String accountUid,  String userUid,  String name,  String? designation,  String? phone,  String? image, @AttendanceStatusConverter()  AttendanceStatus status, @DateTimeNullableConverter()  DateTime? startAt,  String? currentLocation)?  $default,) {final _that = this;
switch (_that) {
case _TeamMemberStatusModel() when $default != null:
return $default(_that.accountUid,_that.userUid,_that.name,_that.designation,_that.phone,_that.image,_that.status,_that.startAt,_that.currentLocation);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TeamMemberStatusModel extends TeamMemberStatusModel {
  const _TeamMemberStatusModel({required this.accountUid, this.userUid = '', required this.name, this.designation, this.phone, this.image, @AttendanceStatusConverter() required this.status, @DateTimeNullableConverter() this.startAt, this.currentLocation}): super._();
  factory _TeamMemberStatusModel.fromJson(Map<String, dynamic> json) => _$TeamMemberStatusModelFromJson(json);

@override final  String accountUid;
@override@JsonKey() final  String userUid;
@override final  String name;
@override final  String? designation;
@override final  String? phone;
@override final  String? image;
@override@AttendanceStatusConverter() final  AttendanceStatus status;
@override@DateTimeNullableConverter() final  DateTime? startAt;
@override final  String? currentLocation;

/// Create a copy of TeamMemberStatusModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeamMemberStatusModelCopyWith<_TeamMemberStatusModel> get copyWith => __$TeamMemberStatusModelCopyWithImpl<_TeamMemberStatusModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeamMemberStatusModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeamMemberStatusModel&&(identical(other.accountUid, accountUid) || other.accountUid == accountUid)&&(identical(other.userUid, userUid) || other.userUid == userUid)&&(identical(other.name, name) || other.name == name)&&(identical(other.designation, designation) || other.designation == designation)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.image, image) || other.image == image)&&(identical(other.status, status) || other.status == status)&&(identical(other.startAt, startAt) || other.startAt == startAt)&&(identical(other.currentLocation, currentLocation) || other.currentLocation == currentLocation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accountUid,userUid,name,designation,phone,image,status,startAt,currentLocation);

@override
String toString() {
  return 'TeamMemberStatusModel(accountUid: $accountUid, userUid: $userUid, name: $name, designation: $designation, phone: $phone, image: $image, status: $status, startAt: $startAt, currentLocation: $currentLocation)';
}


}

/// @nodoc
abstract mixin class _$TeamMemberStatusModelCopyWith<$Res> implements $TeamMemberStatusModelCopyWith<$Res> {
  factory _$TeamMemberStatusModelCopyWith(_TeamMemberStatusModel value, $Res Function(_TeamMemberStatusModel) _then) = __$TeamMemberStatusModelCopyWithImpl;
@override @useResult
$Res call({
 String accountUid, String userUid, String name, String? designation, String? phone, String? image,@AttendanceStatusConverter() AttendanceStatus status,@DateTimeNullableConverter() DateTime? startAt, String? currentLocation
});




}
/// @nodoc
class __$TeamMemberStatusModelCopyWithImpl<$Res>
    implements _$TeamMemberStatusModelCopyWith<$Res> {
  __$TeamMemberStatusModelCopyWithImpl(this._self, this._then);

  final _TeamMemberStatusModel _self;
  final $Res Function(_TeamMemberStatusModel) _then;

/// Create a copy of TeamMemberStatusModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountUid = null,Object? userUid = null,Object? name = null,Object? designation = freezed,Object? phone = freezed,Object? image = freezed,Object? status = null,Object? startAt = freezed,Object? currentLocation = freezed,}) {
  return _then(_TeamMemberStatusModel(
accountUid: null == accountUid ? _self.accountUid : accountUid // ignore: cast_nullable_to_non_nullable
as String,userUid: null == userUid ? _self.userUid : userUid // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,designation: freezed == designation ? _self.designation : designation // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AttendanceStatus,startAt: freezed == startAt ? _self.startAt : startAt // ignore: cast_nullable_to_non_nullable
as DateTime?,currentLocation: freezed == currentLocation ? _self.currentLocation : currentLocation // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
