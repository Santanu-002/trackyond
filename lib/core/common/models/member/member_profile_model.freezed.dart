// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'member_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MemberProfileModel {

 String get accountUid; String get userUid; String get name; String get phone; String get designation; String? get gender; String? get image; String? get companyUid; String? get createdBy;
/// Create a copy of MemberProfileModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemberProfileModelCopyWith<MemberProfileModel> get copyWith => _$MemberProfileModelCopyWithImpl<MemberProfileModel>(this as MemberProfileModel, _$identity);

  /// Serializes this MemberProfileModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemberProfileModel&&(identical(other.accountUid, accountUid) || other.accountUid == accountUid)&&(identical(other.userUid, userUid) || other.userUid == userUid)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.designation, designation) || other.designation == designation)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.image, image) || other.image == image)&&(identical(other.companyUid, companyUid) || other.companyUid == companyUid)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accountUid,userUid,name,phone,designation,gender,image,companyUid,createdBy);

@override
String toString() {
  return 'MemberProfileModel(accountUid: $accountUid, userUid: $userUid, name: $name, phone: $phone, designation: $designation, gender: $gender, image: $image, companyUid: $companyUid, createdBy: $createdBy)';
}


}

/// @nodoc
abstract mixin class $MemberProfileModelCopyWith<$Res>  {
  factory $MemberProfileModelCopyWith(MemberProfileModel value, $Res Function(MemberProfileModel) _then) = _$MemberProfileModelCopyWithImpl;
@useResult
$Res call({
 String accountUid, String userUid, String name, String phone, String designation, String? gender, String? image, String? companyUid, String? createdBy
});




}
/// @nodoc
class _$MemberProfileModelCopyWithImpl<$Res>
    implements $MemberProfileModelCopyWith<$Res> {
  _$MemberProfileModelCopyWithImpl(this._self, this._then);

  final MemberProfileModel _self;
  final $Res Function(MemberProfileModel) _then;

/// Create a copy of MemberProfileModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountUid = null,Object? userUid = null,Object? name = null,Object? phone = null,Object? designation = null,Object? gender = freezed,Object? image = freezed,Object? companyUid = freezed,Object? createdBy = freezed,}) {
  return _then(_self.copyWith(
accountUid: null == accountUid ? _self.accountUid : accountUid // ignore: cast_nullable_to_non_nullable
as String,userUid: null == userUid ? _self.userUid : userUid // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,designation: null == designation ? _self.designation : designation // ignore: cast_nullable_to_non_nullable
as String,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,companyUid: freezed == companyUid ? _self.companyUid : companyUid // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MemberProfileModel].
extension MemberProfileModelPatterns on MemberProfileModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemberProfileModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemberProfileModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemberProfileModel value)  $default,){
final _that = this;
switch (_that) {
case _MemberProfileModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemberProfileModel value)?  $default,){
final _that = this;
switch (_that) {
case _MemberProfileModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String accountUid,  String userUid,  String name,  String phone,  String designation,  String? gender,  String? image,  String? companyUid,  String? createdBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MemberProfileModel() when $default != null:
return $default(_that.accountUid,_that.userUid,_that.name,_that.phone,_that.designation,_that.gender,_that.image,_that.companyUid,_that.createdBy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String accountUid,  String userUid,  String name,  String phone,  String designation,  String? gender,  String? image,  String? companyUid,  String? createdBy)  $default,) {final _that = this;
switch (_that) {
case _MemberProfileModel():
return $default(_that.accountUid,_that.userUid,_that.name,_that.phone,_that.designation,_that.gender,_that.image,_that.companyUid,_that.createdBy);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String accountUid,  String userUid,  String name,  String phone,  String designation,  String? gender,  String? image,  String? companyUid,  String? createdBy)?  $default,) {final _that = this;
switch (_that) {
case _MemberProfileModel() when $default != null:
return $default(_that.accountUid,_that.userUid,_that.name,_that.phone,_that.designation,_that.gender,_that.image,_that.companyUid,_that.createdBy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MemberProfileModel extends MemberProfileModel {
  const _MemberProfileModel({required this.accountUid, required this.userUid, required this.name, required this.phone, required this.designation, this.gender, this.image, this.companyUid, this.createdBy}): super._();
  factory _MemberProfileModel.fromJson(Map<String, dynamic> json) => _$MemberProfileModelFromJson(json);

@override final  String accountUid;
@override final  String userUid;
@override final  String name;
@override final  String phone;
@override final  String designation;
@override final  String? gender;
@override final  String? image;
@override final  String? companyUid;
@override final  String? createdBy;

/// Create a copy of MemberProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemberProfileModelCopyWith<_MemberProfileModel> get copyWith => __$MemberProfileModelCopyWithImpl<_MemberProfileModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemberProfileModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemberProfileModel&&(identical(other.accountUid, accountUid) || other.accountUid == accountUid)&&(identical(other.userUid, userUid) || other.userUid == userUid)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.designation, designation) || other.designation == designation)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.image, image) || other.image == image)&&(identical(other.companyUid, companyUid) || other.companyUid == companyUid)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accountUid,userUid,name,phone,designation,gender,image,companyUid,createdBy);

@override
String toString() {
  return 'MemberProfileModel(accountUid: $accountUid, userUid: $userUid, name: $name, phone: $phone, designation: $designation, gender: $gender, image: $image, companyUid: $companyUid, createdBy: $createdBy)';
}


}

/// @nodoc
abstract mixin class _$MemberProfileModelCopyWith<$Res> implements $MemberProfileModelCopyWith<$Res> {
  factory _$MemberProfileModelCopyWith(_MemberProfileModel value, $Res Function(_MemberProfileModel) _then) = __$MemberProfileModelCopyWithImpl;
@override @useResult
$Res call({
 String accountUid, String userUid, String name, String phone, String designation, String? gender, String? image, String? companyUid, String? createdBy
});




}
/// @nodoc
class __$MemberProfileModelCopyWithImpl<$Res>
    implements _$MemberProfileModelCopyWith<$Res> {
  __$MemberProfileModelCopyWithImpl(this._self, this._then);

  final _MemberProfileModel _self;
  final $Res Function(_MemberProfileModel) _then;

/// Create a copy of MemberProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountUid = null,Object? userUid = null,Object? name = null,Object? phone = null,Object? designation = null,Object? gender = freezed,Object? image = freezed,Object? companyUid = freezed,Object? createdBy = freezed,}) {
  return _then(_MemberProfileModel(
accountUid: null == accountUid ? _self.accountUid : accountUid // ignore: cast_nullable_to_non_nullable
as String,userUid: null == userUid ? _self.userUid : userUid // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,designation: null == designation ? _self.designation : designation // ignore: cast_nullable_to_non_nullable
as String,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,companyUid: freezed == companyUid ? _self.companyUid : companyUid // ignore: cast_nullable_to_non_nullable
as String?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
