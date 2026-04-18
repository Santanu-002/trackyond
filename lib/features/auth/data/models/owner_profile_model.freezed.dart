// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'owner_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OwnerProfileModel {

 String get uid; String get phone; bool get isNewUser;
/// Create a copy of OwnerProfileModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OwnerProfileModelCopyWith<OwnerProfileModel> get copyWith => _$OwnerProfileModelCopyWithImpl<OwnerProfileModel>(this as OwnerProfileModel, _$identity);

  /// Serializes this OwnerProfileModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OwnerProfileModel&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.isNewUser, isNewUser) || other.isNewUser == isNewUser));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,phone,isNewUser);

@override
String toString() {
  return 'OwnerProfileModel(uid: $uid, phone: $phone, isNewUser: $isNewUser)';
}


}

/// @nodoc
abstract mixin class $OwnerProfileModelCopyWith<$Res>  {
  factory $OwnerProfileModelCopyWith(OwnerProfileModel value, $Res Function(OwnerProfileModel) _then) = _$OwnerProfileModelCopyWithImpl;
@useResult
$Res call({
 String uid, String phone, bool isNewUser
});




}
/// @nodoc
class _$OwnerProfileModelCopyWithImpl<$Res>
    implements $OwnerProfileModelCopyWith<$Res> {
  _$OwnerProfileModelCopyWithImpl(this._self, this._then);

  final OwnerProfileModel _self;
  final $Res Function(OwnerProfileModel) _then;

/// Create a copy of OwnerProfileModel
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


/// Adds pattern-matching-related methods to [OwnerProfileModel].
extension OwnerProfileModelPatterns on OwnerProfileModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OwnerProfileModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OwnerProfileModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OwnerProfileModel value)  $default,){
final _that = this;
switch (_that) {
case _OwnerProfileModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OwnerProfileModel value)?  $default,){
final _that = this;
switch (_that) {
case _OwnerProfileModel() when $default != null:
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
case _OwnerProfileModel() when $default != null:
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
case _OwnerProfileModel():
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
case _OwnerProfileModel() when $default != null:
return $default(_that.uid,_that.phone,_that.isNewUser);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OwnerProfileModel extends OwnerProfileModel {
  const _OwnerProfileModel({required this.uid, required this.phone, required this.isNewUser}): super._();
  factory _OwnerProfileModel.fromJson(Map<String, dynamic> json) => _$OwnerProfileModelFromJson(json);

@override final  String uid;
@override final  String phone;
@override final  bool isNewUser;

/// Create a copy of OwnerProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OwnerProfileModelCopyWith<_OwnerProfileModel> get copyWith => __$OwnerProfileModelCopyWithImpl<_OwnerProfileModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OwnerProfileModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OwnerProfileModel&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.isNewUser, isNewUser) || other.isNewUser == isNewUser));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,phone,isNewUser);

@override
String toString() {
  return 'OwnerProfileModel(uid: $uid, phone: $phone, isNewUser: $isNewUser)';
}


}

/// @nodoc
abstract mixin class _$OwnerProfileModelCopyWith<$Res> implements $OwnerProfileModelCopyWith<$Res> {
  factory _$OwnerProfileModelCopyWith(_OwnerProfileModel value, $Res Function(_OwnerProfileModel) _then) = __$OwnerProfileModelCopyWithImpl;
@override @useResult
$Res call({
 String uid, String phone, bool isNewUser
});




}
/// @nodoc
class __$OwnerProfileModelCopyWithImpl<$Res>
    implements _$OwnerProfileModelCopyWith<$Res> {
  __$OwnerProfileModelCopyWithImpl(this._self, this._then);

  final _OwnerProfileModel _self;
  final $Res Function(_OwnerProfileModel) _then;

/// Create a copy of OwnerProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? phone = null,Object? isNewUser = null,}) {
  return _then(_OwnerProfileModel(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,isNewUser: null == isNewUser ? _self.isNewUser : isNewUser // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
