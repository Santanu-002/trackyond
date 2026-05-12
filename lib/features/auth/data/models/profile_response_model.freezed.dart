// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProfileResponseModel {

 MemberProfileModel? get profile; CompanyModel? get company;
/// Create a copy of ProfileResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileResponseModelCopyWith<ProfileResponseModel> get copyWith => _$ProfileResponseModelCopyWithImpl<ProfileResponseModel>(this as ProfileResponseModel, _$identity);

  /// Serializes this ProfileResponseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileResponseModel&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.company, company) || other.company == company));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,profile,company);

@override
String toString() {
  return 'ProfileResponseModel(profile: $profile, company: $company)';
}


}

/// @nodoc
abstract mixin class $ProfileResponseModelCopyWith<$Res>  {
  factory $ProfileResponseModelCopyWith(ProfileResponseModel value, $Res Function(ProfileResponseModel) _then) = _$ProfileResponseModelCopyWithImpl;
@useResult
$Res call({
 MemberProfileModel? profile, CompanyModel? company
});


$MemberProfileModelCopyWith<$Res>? get profile;$CompanyModelCopyWith<$Res>? get company;

}
/// @nodoc
class _$ProfileResponseModelCopyWithImpl<$Res>
    implements $ProfileResponseModelCopyWith<$Res> {
  _$ProfileResponseModelCopyWithImpl(this._self, this._then);

  final ProfileResponseModel _self;
  final $Res Function(ProfileResponseModel) _then;

/// Create a copy of ProfileResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? profile = freezed,Object? company = freezed,}) {
  return _then(_self.copyWith(
profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as MemberProfileModel?,company: freezed == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as CompanyModel?,
  ));
}
/// Create a copy of ProfileResponseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MemberProfileModelCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $MemberProfileModelCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}/// Create a copy of ProfileResponseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CompanyModelCopyWith<$Res>? get company {
    if (_self.company == null) {
    return null;
  }

  return $CompanyModelCopyWith<$Res>(_self.company!, (value) {
    return _then(_self.copyWith(company: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProfileResponseModel].
extension ProfileResponseModelPatterns on ProfileResponseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileResponseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileResponseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileResponseModel value)  $default,){
final _that = this;
switch (_that) {
case _ProfileResponseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileResponseModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileResponseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MemberProfileModel? profile,  CompanyModel? company)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileResponseModel() when $default != null:
return $default(_that.profile,_that.company);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MemberProfileModel? profile,  CompanyModel? company)  $default,) {final _that = this;
switch (_that) {
case _ProfileResponseModel():
return $default(_that.profile,_that.company);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MemberProfileModel? profile,  CompanyModel? company)?  $default,) {final _that = this;
switch (_that) {
case _ProfileResponseModel() when $default != null:
return $default(_that.profile,_that.company);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfileResponseModel extends ProfileResponseModel {
  const _ProfileResponseModel({this.profile, this.company}): super._();
  factory _ProfileResponseModel.fromJson(Map<String, dynamic> json) => _$ProfileResponseModelFromJson(json);

@override final  MemberProfileModel? profile;
@override final  CompanyModel? company;

/// Create a copy of ProfileResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileResponseModelCopyWith<_ProfileResponseModel> get copyWith => __$ProfileResponseModelCopyWithImpl<_ProfileResponseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileResponseModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileResponseModel&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.company, company) || other.company == company));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,profile,company);

@override
String toString() {
  return 'ProfileResponseModel(profile: $profile, company: $company)';
}


}

/// @nodoc
abstract mixin class _$ProfileResponseModelCopyWith<$Res> implements $ProfileResponseModelCopyWith<$Res> {
  factory _$ProfileResponseModelCopyWith(_ProfileResponseModel value, $Res Function(_ProfileResponseModel) _then) = __$ProfileResponseModelCopyWithImpl;
@override @useResult
$Res call({
 MemberProfileModel? profile, CompanyModel? company
});


@override $MemberProfileModelCopyWith<$Res>? get profile;@override $CompanyModelCopyWith<$Res>? get company;

}
/// @nodoc
class __$ProfileResponseModelCopyWithImpl<$Res>
    implements _$ProfileResponseModelCopyWith<$Res> {
  __$ProfileResponseModelCopyWithImpl(this._self, this._then);

  final _ProfileResponseModel _self;
  final $Res Function(_ProfileResponseModel) _then;

/// Create a copy of ProfileResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? profile = freezed,Object? company = freezed,}) {
  return _then(_ProfileResponseModel(
profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as MemberProfileModel?,company: freezed == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as CompanyModel?,
  ));
}

/// Create a copy of ProfileResponseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MemberProfileModelCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $MemberProfileModelCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}/// Create a copy of ProfileResponseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CompanyModelCopyWith<$Res>? get company {
    if (_self.company == null) {
    return null;
  }

  return $CompanyModelCopyWith<$Res>(_self.company!, (value) {
    return _then(_self.copyWith(company: value));
  });
}
}

// dart format on
