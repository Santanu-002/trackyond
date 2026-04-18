// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'worker_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkerProfileModel {

 String get uid; String get name; String get phone; String get designation; String? get gender; String? get image;
/// Create a copy of WorkerProfileModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkerProfileModelCopyWith<WorkerProfileModel> get copyWith => _$WorkerProfileModelCopyWithImpl<WorkerProfileModel>(this as WorkerProfileModel, _$identity);

  /// Serializes this WorkerProfileModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkerProfileModel&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.designation, designation) || other.designation == designation)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.image, image) || other.image == image));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,name,phone,designation,gender,image);

@override
String toString() {
  return 'WorkerProfileModel(uid: $uid, name: $name, phone: $phone, designation: $designation, gender: $gender, image: $image)';
}


}

/// @nodoc
abstract mixin class $WorkerProfileModelCopyWith<$Res>  {
  factory $WorkerProfileModelCopyWith(WorkerProfileModel value, $Res Function(WorkerProfileModel) _then) = _$WorkerProfileModelCopyWithImpl;
@useResult
$Res call({
 String uid, String name, String phone, String designation, String? gender, String? image
});




}
/// @nodoc
class _$WorkerProfileModelCopyWithImpl<$Res>
    implements $WorkerProfileModelCopyWith<$Res> {
  _$WorkerProfileModelCopyWithImpl(this._self, this._then);

  final WorkerProfileModel _self;
  final $Res Function(WorkerProfileModel) _then;

/// Create a copy of WorkerProfileModel
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


/// Adds pattern-matching-related methods to [WorkerProfileModel].
extension WorkerProfileModelPatterns on WorkerProfileModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkerProfileModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkerProfileModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkerProfileModel value)  $default,){
final _that = this;
switch (_that) {
case _WorkerProfileModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkerProfileModel value)?  $default,){
final _that = this;
switch (_that) {
case _WorkerProfileModel() when $default != null:
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
case _WorkerProfileModel() when $default != null:
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
case _WorkerProfileModel():
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
case _WorkerProfileModel() when $default != null:
return $default(_that.uid,_that.name,_that.phone,_that.designation,_that.gender,_that.image);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkerProfileModel extends WorkerProfileModel {
  const _WorkerProfileModel({required this.uid, required this.name, required this.phone, required this.designation, this.gender, this.image}): super._();
  factory _WorkerProfileModel.fromJson(Map<String, dynamic> json) => _$WorkerProfileModelFromJson(json);

@override final  String uid;
@override final  String name;
@override final  String phone;
@override final  String designation;
@override final  String? gender;
@override final  String? image;

/// Create a copy of WorkerProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkerProfileModelCopyWith<_WorkerProfileModel> get copyWith => __$WorkerProfileModelCopyWithImpl<_WorkerProfileModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkerProfileModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkerProfileModel&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.designation, designation) || other.designation == designation)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.image, image) || other.image == image));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,name,phone,designation,gender,image);

@override
String toString() {
  return 'WorkerProfileModel(uid: $uid, name: $name, phone: $phone, designation: $designation, gender: $gender, image: $image)';
}


}

/// @nodoc
abstract mixin class _$WorkerProfileModelCopyWith<$Res> implements $WorkerProfileModelCopyWith<$Res> {
  factory _$WorkerProfileModelCopyWith(_WorkerProfileModel value, $Res Function(_WorkerProfileModel) _then) = __$WorkerProfileModelCopyWithImpl;
@override @useResult
$Res call({
 String uid, String name, String phone, String designation, String? gender, String? image
});




}
/// @nodoc
class __$WorkerProfileModelCopyWithImpl<$Res>
    implements _$WorkerProfileModelCopyWith<$Res> {
  __$WorkerProfileModelCopyWithImpl(this._self, this._then);

  final _WorkerProfileModel _self;
  final $Res Function(_WorkerProfileModel) _then;

/// Create a copy of WorkerProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? name = null,Object? phone = null,Object? designation = null,Object? gender = freezed,Object? image = freezed,}) {
  return _then(_WorkerProfileModel(
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
