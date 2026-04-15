// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'owner_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OwnerProfile {

 String get uid; String get phone; bool get isNewUser;
/// Create a copy of OwnerProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OwnerProfileCopyWith<OwnerProfile> get copyWith => _$OwnerProfileCopyWithImpl<OwnerProfile>(this as OwnerProfile, _$identity);

  /// Serializes this OwnerProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OwnerProfile&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.isNewUser, isNewUser) || other.isNewUser == isNewUser));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,phone,isNewUser);

@override
String toString() {
  return 'OwnerProfile(uid: $uid, phone: $phone, isNewUser: $isNewUser)';
}


}

/// @nodoc
abstract mixin class $OwnerProfileCopyWith<$Res>  {
  factory $OwnerProfileCopyWith(OwnerProfile value, $Res Function(OwnerProfile) _then) = _$OwnerProfileCopyWithImpl;
@useResult
$Res call({
 String uid, String phone, bool isNewUser
});




}
/// @nodoc
class _$OwnerProfileCopyWithImpl<$Res>
    implements $OwnerProfileCopyWith<$Res> {
  _$OwnerProfileCopyWithImpl(this._self, this._then);

  final OwnerProfile _self;
  final $Res Function(OwnerProfile) _then;

/// Create a copy of OwnerProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? phone = null,Object? isNewUser = null,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,isNewUser: null == isNewUser ? _self.isNewUser : isNewUser // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [OwnerProfile].
extension OwnerProfilePatterns on OwnerProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OwnerProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OwnerProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OwnerProfile value)  $default,){
final _that = this;
switch (_that) {
case _OwnerProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OwnerProfile value)?  $default,){
final _that = this;
switch (_that) {
case _OwnerProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid,  String phone,  bool isNewUser)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OwnerProfile() when $default != null:
return $default(_that.uid,_that.phone,_that.isNewUser);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid,  String phone,  bool isNewUser)  $default,) {final _that = this;
switch (_that) {
case _OwnerProfile():
return $default(_that.uid,_that.phone,_that.isNewUser);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid,  String phone,  bool isNewUser)?  $default,) {final _that = this;
switch (_that) {
case _OwnerProfile() when $default != null:
return $default(_that.uid,_that.phone,_that.isNewUser);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OwnerProfile implements OwnerProfile {
  const _OwnerProfile({required this.uid, required this.phone, required this.isNewUser});
  factory _OwnerProfile.fromJson(Map<String, dynamic> json) => _$OwnerProfileFromJson(json);

@override final  String uid;
@override final  String phone;
@override final  bool isNewUser;

/// Create a copy of OwnerProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OwnerProfileCopyWith<_OwnerProfile> get copyWith => __$OwnerProfileCopyWithImpl<_OwnerProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OwnerProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OwnerProfile&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.isNewUser, isNewUser) || other.isNewUser == isNewUser));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,phone,isNewUser);

@override
String toString() {
  return 'OwnerProfile(uid: $uid, phone: $phone, isNewUser: $isNewUser)';
}


}

/// @nodoc
abstract mixin class _$OwnerProfileCopyWith<$Res> implements $OwnerProfileCopyWith<$Res> {
  factory _$OwnerProfileCopyWith(_OwnerProfile value, $Res Function(_OwnerProfile) _then) = __$OwnerProfileCopyWithImpl;
@override @useResult
$Res call({
 String uid, String phone, bool isNewUser
});




}
/// @nodoc
class __$OwnerProfileCopyWithImpl<$Res>
    implements _$OwnerProfileCopyWith<$Res> {
  __$OwnerProfileCopyWithImpl(this._self, this._then);

  final _OwnerProfile _self;
  final $Res Function(_OwnerProfile) _then;

/// Create a copy of OwnerProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? phone = null,Object? isNewUser = null,}) {
  return _then(_OwnerProfile(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,isNewUser: null == isNewUser ? _self.isNewUser : isNewUser // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
