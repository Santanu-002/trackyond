// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'company_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CompanyResponseModel {

@JsonKey(name: 'ownerProfile') MemberProfileModel get memberProfile; CompanyModel get company;
/// Create a copy of CompanyResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompanyResponseModelCopyWith<CompanyResponseModel> get copyWith => _$CompanyResponseModelCopyWithImpl<CompanyResponseModel>(this as CompanyResponseModel, _$identity);

  /// Serializes this CompanyResponseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompanyResponseModel&&super == other&&(identical(other.memberProfile, memberProfile) || other.memberProfile == memberProfile)&&(identical(other.company, company) || other.company == company));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,super.hashCode,memberProfile,company);



}

/// @nodoc
abstract mixin class $CompanyResponseModelCopyWith<$Res>  {
  factory $CompanyResponseModelCopyWith(CompanyResponseModel value, $Res Function(CompanyResponseModel) _then) = _$CompanyResponseModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'ownerProfile') MemberProfileModel memberProfile, CompanyModel company
});


$MemberProfileModelCopyWith<$Res> get memberProfile;$CompanyModelCopyWith<$Res> get company;

}
/// @nodoc
class _$CompanyResponseModelCopyWithImpl<$Res>
    implements $CompanyResponseModelCopyWith<$Res> {
  _$CompanyResponseModelCopyWithImpl(this._self, this._then);

  final CompanyResponseModel _self;
  final $Res Function(CompanyResponseModel) _then;

/// Create a copy of CompanyResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? memberProfile = null,Object? company = null,}) {
  return _then(_self.copyWith(
memberProfile: null == memberProfile ? _self.memberProfile : memberProfile // ignore: cast_nullable_to_non_nullable
as MemberProfileModel,company: null == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as CompanyModel,
  ));
}
/// Create a copy of CompanyResponseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MemberProfileModelCopyWith<$Res> get memberProfile {
  
  return $MemberProfileModelCopyWith<$Res>(_self.memberProfile, (value) {
    return _then(_self.copyWith(memberProfile: value));
  });
}/// Create a copy of CompanyResponseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CompanyModelCopyWith<$Res> get company {
  
  return $CompanyModelCopyWith<$Res>(_self.company, (value) {
    return _then(_self.copyWith(company: value));
  });
}
}


/// Adds pattern-matching-related methods to [CompanyResponseModel].
extension CompanyResponseModelPatterns on CompanyResponseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CompanyResponseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CompanyResponseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CompanyResponseModel value)  $default,){
final _that = this;
switch (_that) {
case _CompanyResponseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CompanyResponseModel value)?  $default,){
final _that = this;
switch (_that) {
case _CompanyResponseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'ownerProfile')  MemberProfileModel memberProfile,  CompanyModel company)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CompanyResponseModel() when $default != null:
return $default(_that.memberProfile,_that.company);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'ownerProfile')  MemberProfileModel memberProfile,  CompanyModel company)  $default,) {final _that = this;
switch (_that) {
case _CompanyResponseModel():
return $default(_that.memberProfile,_that.company);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'ownerProfile')  MemberProfileModel memberProfile,  CompanyModel company)?  $default,) {final _that = this;
switch (_that) {
case _CompanyResponseModel() when $default != null:
return $default(_that.memberProfile,_that.company);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CompanyResponseModel extends CompanyResponseModel {
  const _CompanyResponseModel({@JsonKey(name: 'ownerProfile') required this.memberProfile, required this.company}): super._();
  factory _CompanyResponseModel.fromJson(Map<String, dynamic> json) => _$CompanyResponseModelFromJson(json);

@override@JsonKey(name: 'ownerProfile') final  MemberProfileModel memberProfile;
@override final  CompanyModel company;

/// Create a copy of CompanyResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompanyResponseModelCopyWith<_CompanyResponseModel> get copyWith => __$CompanyResponseModelCopyWithImpl<_CompanyResponseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CompanyResponseModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompanyResponseModel&&super == other&&(identical(other.memberProfile, memberProfile) || other.memberProfile == memberProfile)&&(identical(other.company, company) || other.company == company));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,super.hashCode,memberProfile,company);



}

/// @nodoc
abstract mixin class _$CompanyResponseModelCopyWith<$Res> implements $CompanyResponseModelCopyWith<$Res> {
  factory _$CompanyResponseModelCopyWith(_CompanyResponseModel value, $Res Function(_CompanyResponseModel) _then) = __$CompanyResponseModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'ownerProfile') MemberProfileModel memberProfile, CompanyModel company
});


@override $MemberProfileModelCopyWith<$Res> get memberProfile;@override $CompanyModelCopyWith<$Res> get company;

}
/// @nodoc
class __$CompanyResponseModelCopyWithImpl<$Res>
    implements _$CompanyResponseModelCopyWith<$Res> {
  __$CompanyResponseModelCopyWithImpl(this._self, this._then);

  final _CompanyResponseModel _self;
  final $Res Function(_CompanyResponseModel) _then;

/// Create a copy of CompanyResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? memberProfile = null,Object? company = null,}) {
  return _then(_CompanyResponseModel(
memberProfile: null == memberProfile ? _self.memberProfile : memberProfile // ignore: cast_nullable_to_non_nullable
as MemberProfileModel,company: null == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as CompanyModel,
  ));
}

/// Create a copy of CompanyResponseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MemberProfileModelCopyWith<$Res> get memberProfile {
  
  return $MemberProfileModelCopyWith<$Res>(_self.memberProfile, (value) {
    return _then(_self.copyWith(memberProfile: value));
  });
}/// Create a copy of CompanyResponseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CompanyModelCopyWith<$Res> get company {
  
  return $CompanyModelCopyWith<$Res>(_self.company, (value) {
    return _then(_self.copyWith(company: value));
  });
}
}

// dart format on
