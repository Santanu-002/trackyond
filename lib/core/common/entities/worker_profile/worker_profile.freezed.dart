// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'worker_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkerProfile {

 String get uid; String get name; String get phone; String get designation; String? get gender; String? get image;
/// Create a copy of WorkerProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkerProfileCopyWith<WorkerProfile> get copyWith => _$WorkerProfileCopyWithImpl<WorkerProfile>(this as WorkerProfile, _$identity);

  /// Serializes this WorkerProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkerProfile&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.designation, designation) || other.designation == designation)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.image, image) || other.image == image));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,name,phone,designation,gender,image);

@override
String toString() {
  return 'WorkerProfile(uid: $uid, name: $name, phone: $phone, designation: $designation, gender: $gender, image: $image)';
}


}

/// @nodoc
abstract mixin class $WorkerProfileCopyWith<$Res>  {
  factory $WorkerProfileCopyWith(WorkerProfile value, $Res Function(WorkerProfile) _then) = _$WorkerProfileCopyWithImpl;
@useResult
$Res call({
 String uid, String name, String phone, String designation, String? gender, String? image
});




}
/// @nodoc
class _$WorkerProfileCopyWithImpl<$Res>
    implements $WorkerProfileCopyWith<$Res> {
  _$WorkerProfileCopyWithImpl(this._self, this._then);

  final WorkerProfile _self;
  final $Res Function(WorkerProfile) _then;

/// Create a copy of WorkerProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? name = null,Object? phone = null,Object? designation = null,Object? gender = freezed,Object? image = freezed,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,designation: null == designation ? _self.designation : designation // ignore: cast_nullable_to_non_nullable
as String,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkerProfile].
extension WorkerProfilePatterns on WorkerProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkerProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkerProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkerProfile value)  $default,){
final _that = this;
switch (_that) {
case _WorkerProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkerProfile value)?  $default,){
final _that = this;
switch (_that) {
case _WorkerProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid,  String name,  String phone,  String designation,  String? gender,  String? image)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkerProfile() when $default != null:
return $default(_that.uid,_that.name,_that.phone,_that.designation,_that.gender,_that.image);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid,  String name,  String phone,  String designation,  String? gender,  String? image)  $default,) {final _that = this;
switch (_that) {
case _WorkerProfile():
return $default(_that.uid,_that.name,_that.phone,_that.designation,_that.gender,_that.image);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid,  String name,  String phone,  String designation,  String? gender,  String? image)?  $default,) {final _that = this;
switch (_that) {
case _WorkerProfile() when $default != null:
return $default(_that.uid,_that.name,_that.phone,_that.designation,_that.gender,_that.image);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkerProfile implements WorkerProfile {
  const _WorkerProfile({required this.uid, required this.name, required this.phone, required this.designation, this.gender, this.image});
  factory _WorkerProfile.fromJson(Map<String, dynamic> json) => _$WorkerProfileFromJson(json);

@override final  String uid;
@override final  String name;
@override final  String phone;
@override final  String designation;
@override final  String? gender;
@override final  String? image;

/// Create a copy of WorkerProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkerProfileCopyWith<_WorkerProfile> get copyWith => __$WorkerProfileCopyWithImpl<_WorkerProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkerProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkerProfile&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.designation, designation) || other.designation == designation)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.image, image) || other.image == image));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,name,phone,designation,gender,image);

@override
String toString() {
  return 'WorkerProfile(uid: $uid, name: $name, phone: $phone, designation: $designation, gender: $gender, image: $image)';
}


}

/// @nodoc
abstract mixin class _$WorkerProfileCopyWith<$Res> implements $WorkerProfileCopyWith<$Res> {
  factory _$WorkerProfileCopyWith(_WorkerProfile value, $Res Function(_WorkerProfile) _then) = __$WorkerProfileCopyWithImpl;
@override @useResult
$Res call({
 String uid, String name, String phone, String designation, String? gender, String? image
});




}
/// @nodoc
class __$WorkerProfileCopyWithImpl<$Res>
    implements _$WorkerProfileCopyWith<$Res> {
  __$WorkerProfileCopyWithImpl(this._self, this._then);

  final _WorkerProfile _self;
  final $Res Function(_WorkerProfile) _then;

/// Create a copy of WorkerProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? name = null,Object? phone = null,Object? designation = null,Object? gender = freezed,Object? image = freezed,}) {
  return _then(_WorkerProfile(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,designation: null == designation ? _self.designation : designation // ignore: cast_nullable_to_non_nullable
as String,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
