// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'switch_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SwitchProfileModel {

 String get profileUid; String get userUid; String get name; String get designation; String? get image; SwitchProfileCompanyModel get company;@JsonKey(name: 'isPrimary') bool get isPrimary;
/// Create a copy of SwitchProfileModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SwitchProfileModelCopyWith<SwitchProfileModel> get copyWith => _$SwitchProfileModelCopyWithImpl<SwitchProfileModel>(this as SwitchProfileModel, _$identity);

  /// Serializes this SwitchProfileModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SwitchProfileModel&&(identical(other.profileUid, profileUid) || other.profileUid == profileUid)&&(identical(other.userUid, userUid) || other.userUid == userUid)&&(identical(other.name, name) || other.name == name)&&(identical(other.designation, designation) || other.designation == designation)&&(identical(other.image, image) || other.image == image)&&(identical(other.company, company) || other.company == company)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,profileUid,userUid,name,designation,image,company,isPrimary);

@override
String toString() {
  return 'SwitchProfileModel(profileUid: $profileUid, userUid: $userUid, name: $name, designation: $designation, image: $image, company: $company, isPrimary: $isPrimary)';
}


}

/// @nodoc
abstract mixin class $SwitchProfileModelCopyWith<$Res>  {
  factory $SwitchProfileModelCopyWith(SwitchProfileModel value, $Res Function(SwitchProfileModel) _then) = _$SwitchProfileModelCopyWithImpl;
@useResult
$Res call({
 String profileUid, String userUid, String name, String designation, String? image, SwitchProfileCompanyModel company,@JsonKey(name: 'isPrimary') bool isPrimary
});


$SwitchProfileCompanyModelCopyWith<$Res> get company;

}
/// @nodoc
class _$SwitchProfileModelCopyWithImpl<$Res>
    implements $SwitchProfileModelCopyWith<$Res> {
  _$SwitchProfileModelCopyWithImpl(this._self, this._then);

  final SwitchProfileModel _self;
  final $Res Function(SwitchProfileModel) _then;

/// Create a copy of SwitchProfileModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? profileUid = null,Object? userUid = null,Object? name = null,Object? designation = null,Object? image = freezed,Object? company = null,Object? isPrimary = null,}) {
  return _then(_self.copyWith(
profileUid: null == profileUid ? _self.profileUid : profileUid // ignore: cast_nullable_to_non_nullable
as String,userUid: null == userUid ? _self.userUid : userUid // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,designation: null == designation ? _self.designation : designation // ignore: cast_nullable_to_non_nullable
as String,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,company: null == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as SwitchProfileCompanyModel,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of SwitchProfileModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SwitchProfileCompanyModelCopyWith<$Res> get company {
  
  return $SwitchProfileCompanyModelCopyWith<$Res>(_self.company, (value) {
    return _then(_self.copyWith(company: value));
  });
}
}


/// Adds pattern-matching-related methods to [SwitchProfileModel].
extension SwitchProfileModelPatterns on SwitchProfileModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SwitchProfileModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SwitchProfileModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SwitchProfileModel value)  $default,){
final _that = this;
switch (_that) {
case _SwitchProfileModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SwitchProfileModel value)?  $default,){
final _that = this;
switch (_that) {
case _SwitchProfileModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String profileUid,  String userUid,  String name,  String designation,  String? image,  SwitchProfileCompanyModel company, @JsonKey(name: 'isPrimary')  bool isPrimary)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SwitchProfileModel() when $default != null:
return $default(_that.profileUid,_that.userUid,_that.name,_that.designation,_that.image,_that.company,_that.isPrimary);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String profileUid,  String userUid,  String name,  String designation,  String? image,  SwitchProfileCompanyModel company, @JsonKey(name: 'isPrimary')  bool isPrimary)  $default,) {final _that = this;
switch (_that) {
case _SwitchProfileModel():
return $default(_that.profileUid,_that.userUid,_that.name,_that.designation,_that.image,_that.company,_that.isPrimary);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String profileUid,  String userUid,  String name,  String designation,  String? image,  SwitchProfileCompanyModel company, @JsonKey(name: 'isPrimary')  bool isPrimary)?  $default,) {final _that = this;
switch (_that) {
case _SwitchProfileModel() when $default != null:
return $default(_that.profileUid,_that.userUid,_that.name,_that.designation,_that.image,_that.company,_that.isPrimary);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SwitchProfileModel implements SwitchProfileModel {
  const _SwitchProfileModel({required this.profileUid, required this.userUid, required this.name, required this.designation, this.image, required this.company, @JsonKey(name: 'isPrimary') required this.isPrimary});
  factory _SwitchProfileModel.fromJson(Map<String, dynamic> json) => _$SwitchProfileModelFromJson(json);

@override final  String profileUid;
@override final  String userUid;
@override final  String name;
@override final  String designation;
@override final  String? image;
@override final  SwitchProfileCompanyModel company;
@override@JsonKey(name: 'isPrimary') final  bool isPrimary;

/// Create a copy of SwitchProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SwitchProfileModelCopyWith<_SwitchProfileModel> get copyWith => __$SwitchProfileModelCopyWithImpl<_SwitchProfileModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SwitchProfileModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SwitchProfileModel&&(identical(other.profileUid, profileUid) || other.profileUid == profileUid)&&(identical(other.userUid, userUid) || other.userUid == userUid)&&(identical(other.name, name) || other.name == name)&&(identical(other.designation, designation) || other.designation == designation)&&(identical(other.image, image) || other.image == image)&&(identical(other.company, company) || other.company == company)&&(identical(other.isPrimary, isPrimary) || other.isPrimary == isPrimary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,profileUid,userUid,name,designation,image,company,isPrimary);

@override
String toString() {
  return 'SwitchProfileModel(profileUid: $profileUid, userUid: $userUid, name: $name, designation: $designation, image: $image, company: $company, isPrimary: $isPrimary)';
}


}

/// @nodoc
abstract mixin class _$SwitchProfileModelCopyWith<$Res> implements $SwitchProfileModelCopyWith<$Res> {
  factory _$SwitchProfileModelCopyWith(_SwitchProfileModel value, $Res Function(_SwitchProfileModel) _then) = __$SwitchProfileModelCopyWithImpl;
@override @useResult
$Res call({
 String profileUid, String userUid, String name, String designation, String? image, SwitchProfileCompanyModel company,@JsonKey(name: 'isPrimary') bool isPrimary
});


@override $SwitchProfileCompanyModelCopyWith<$Res> get company;

}
/// @nodoc
class __$SwitchProfileModelCopyWithImpl<$Res>
    implements _$SwitchProfileModelCopyWith<$Res> {
  __$SwitchProfileModelCopyWithImpl(this._self, this._then);

  final _SwitchProfileModel _self;
  final $Res Function(_SwitchProfileModel) _then;

/// Create a copy of SwitchProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? profileUid = null,Object? userUid = null,Object? name = null,Object? designation = null,Object? image = freezed,Object? company = null,Object? isPrimary = null,}) {
  return _then(_SwitchProfileModel(
profileUid: null == profileUid ? _self.profileUid : profileUid // ignore: cast_nullable_to_non_nullable
as String,userUid: null == userUid ? _self.userUid : userUid // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,designation: null == designation ? _self.designation : designation // ignore: cast_nullable_to_non_nullable
as String,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,company: null == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as SwitchProfileCompanyModel,isPrimary: null == isPrimary ? _self.isPrimary : isPrimary // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of SwitchProfileModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SwitchProfileCompanyModelCopyWith<$Res> get company {
  
  return $SwitchProfileCompanyModelCopyWith<$Res>(_self.company, (value) {
    return _then(_self.copyWith(company: value));
  });
}
}


/// @nodoc
mixin _$SwitchProfileCompanyModel {

 String get id; String get name;
/// Create a copy of SwitchProfileCompanyModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SwitchProfileCompanyModelCopyWith<SwitchProfileCompanyModel> get copyWith => _$SwitchProfileCompanyModelCopyWithImpl<SwitchProfileCompanyModel>(this as SwitchProfileCompanyModel, _$identity);

  /// Serializes this SwitchProfileCompanyModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SwitchProfileCompanyModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'SwitchProfileCompanyModel(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $SwitchProfileCompanyModelCopyWith<$Res>  {
  factory $SwitchProfileCompanyModelCopyWith(SwitchProfileCompanyModel value, $Res Function(SwitchProfileCompanyModel) _then) = _$SwitchProfileCompanyModelCopyWithImpl;
@useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class _$SwitchProfileCompanyModelCopyWithImpl<$Res>
    implements $SwitchProfileCompanyModelCopyWith<$Res> {
  _$SwitchProfileCompanyModelCopyWithImpl(this._self, this._then);

  final SwitchProfileCompanyModel _self;
  final $Res Function(SwitchProfileCompanyModel) _then;

/// Create a copy of SwitchProfileCompanyModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SwitchProfileCompanyModel].
extension SwitchProfileCompanyModelPatterns on SwitchProfileCompanyModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SwitchProfileCompanyModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SwitchProfileCompanyModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SwitchProfileCompanyModel value)  $default,){
final _that = this;
switch (_that) {
case _SwitchProfileCompanyModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SwitchProfileCompanyModel value)?  $default,){
final _that = this;
switch (_that) {
case _SwitchProfileCompanyModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SwitchProfileCompanyModel() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name)  $default,) {final _that = this;
switch (_that) {
case _SwitchProfileCompanyModel():
return $default(_that.id,_that.name);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _SwitchProfileCompanyModel() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SwitchProfileCompanyModel implements SwitchProfileCompanyModel {
  const _SwitchProfileCompanyModel({required this.id, required this.name});
  factory _SwitchProfileCompanyModel.fromJson(Map<String, dynamic> json) => _$SwitchProfileCompanyModelFromJson(json);

@override final  String id;
@override final  String name;

/// Create a copy of SwitchProfileCompanyModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SwitchProfileCompanyModelCopyWith<_SwitchProfileCompanyModel> get copyWith => __$SwitchProfileCompanyModelCopyWithImpl<_SwitchProfileCompanyModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SwitchProfileCompanyModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SwitchProfileCompanyModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'SwitchProfileCompanyModel(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$SwitchProfileCompanyModelCopyWith<$Res> implements $SwitchProfileCompanyModelCopyWith<$Res> {
  factory _$SwitchProfileCompanyModelCopyWith(_SwitchProfileCompanyModel value, $Res Function(_SwitchProfileCompanyModel) _then) = __$SwitchProfileCompanyModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class __$SwitchProfileCompanyModelCopyWithImpl<$Res>
    implements _$SwitchProfileCompanyModelCopyWith<$Res> {
  __$SwitchProfileCompanyModelCopyWithImpl(this._self, this._then);

  final _SwitchProfileCompanyModel _self;
  final $Res Function(_SwitchProfileCompanyModel) _then;

/// Create a copy of SwitchProfileCompanyModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_SwitchProfileCompanyModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
