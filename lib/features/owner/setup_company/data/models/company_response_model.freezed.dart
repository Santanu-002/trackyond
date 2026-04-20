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

 MemberProfileModel get memberProfile; CompanyDetailModel get company;
/// Create a copy of CompanyResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompanyResponseModelCopyWith<CompanyResponseModel> get copyWith => _$CompanyResponseModelCopyWithImpl<CompanyResponseModel>(this as CompanyResponseModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompanyResponseModel&&(identical(other.memberProfile, memberProfile) || other.memberProfile == memberProfile)&&(identical(other.company, company) || other.company == company));
}


@override
int get hashCode => Object.hash(runtimeType,memberProfile,company);

@override
String toString() {
  return 'CompanyResponseModel(memberProfile: $memberProfile, company: $company)';
}


}

/// @nodoc
abstract mixin class $CompanyResponseModelCopyWith<$Res>  {
  factory $CompanyResponseModelCopyWith(CompanyResponseModel value, $Res Function(CompanyResponseModel) _then) = _$CompanyResponseModelCopyWithImpl;
@useResult
$Res call({
 MemberProfileModel memberProfile, CompanyDetailModel company
});


$MemberProfileModelCopyWith<$Res> get memberProfile;$CompanyDetailModelCopyWith<$Res> get company;

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
as CompanyDetailModel,
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
$CompanyDetailModelCopyWith<$Res> get company {
  
  return $CompanyDetailModelCopyWith<$Res>(_self.company, (value) {
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MemberProfileModel memberProfile,  CompanyDetailModel company)?  $default,{required TResult orElse(),}) {final _that = this;
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MemberProfileModel memberProfile,  CompanyDetailModel company)  $default,) {final _that = this;
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MemberProfileModel memberProfile,  CompanyDetailModel company)?  $default,) {final _that = this;
switch (_that) {
case _CompanyResponseModel() when $default != null:
return $default(_that.memberProfile,_that.company);case _:
  return null;

}
}

}

/// @nodoc


class _CompanyResponseModel extends CompanyResponseModel {
  const _CompanyResponseModel({required this.memberProfile, required this.company}): super._();
  

@override final  MemberProfileModel memberProfile;
@override final  CompanyDetailModel company;

/// Create a copy of CompanyResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompanyResponseModelCopyWith<_CompanyResponseModel> get copyWith => __$CompanyResponseModelCopyWithImpl<_CompanyResponseModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompanyResponseModel&&(identical(other.memberProfile, memberProfile) || other.memberProfile == memberProfile)&&(identical(other.company, company) || other.company == company));
}


@override
int get hashCode => Object.hash(runtimeType,memberProfile,company);

@override
String toString() {
  return 'CompanyResponseModel(memberProfile: $memberProfile, company: $company)';
}


}

/// @nodoc
abstract mixin class _$CompanyResponseModelCopyWith<$Res> implements $CompanyResponseModelCopyWith<$Res> {
  factory _$CompanyResponseModelCopyWith(_CompanyResponseModel value, $Res Function(_CompanyResponseModel) _then) = __$CompanyResponseModelCopyWithImpl;
@override @useResult
$Res call({
 MemberProfileModel memberProfile, CompanyDetailModel company
});


@override $MemberProfileModelCopyWith<$Res> get memberProfile;@override $CompanyDetailModelCopyWith<$Res> get company;

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
as CompanyDetailModel,
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
$CompanyDetailModelCopyWith<$Res> get company {
  
  return $CompanyDetailModelCopyWith<$Res>(_self.company, (value) {
    return _then(_self.copyWith(company: value));
  });
}
}

/// @nodoc
mixin _$CompanyDetailModel {

 String get companyId; String get companyName; String get userPhoneNo; int get teamSize; String get createdAt;
/// Create a copy of CompanyDetailModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompanyDetailModelCopyWith<CompanyDetailModel> get copyWith => _$CompanyDetailModelCopyWithImpl<CompanyDetailModel>(this as CompanyDetailModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompanyDetailModel&&(identical(other.companyId, companyId) || other.companyId == companyId)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.userPhoneNo, userPhoneNo) || other.userPhoneNo == userPhoneNo)&&(identical(other.teamSize, teamSize) || other.teamSize == teamSize)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,companyId,companyName,userPhoneNo,teamSize,createdAt);

@override
String toString() {
  return 'CompanyDetailModel(companyId: $companyId, companyName: $companyName, userPhoneNo: $userPhoneNo, teamSize: $teamSize, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $CompanyDetailModelCopyWith<$Res>  {
  factory $CompanyDetailModelCopyWith(CompanyDetailModel value, $Res Function(CompanyDetailModel) _then) = _$CompanyDetailModelCopyWithImpl;
@useResult
$Res call({
 String companyId, String companyName, String userPhoneNo, int teamSize, String createdAt
});




}
/// @nodoc
class _$CompanyDetailModelCopyWithImpl<$Res>
    implements $CompanyDetailModelCopyWith<$Res> {
  _$CompanyDetailModelCopyWithImpl(this._self, this._then);

  final CompanyDetailModel _self;
  final $Res Function(CompanyDetailModel) _then;

/// Create a copy of CompanyDetailModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? companyId = null,Object? companyName = null,Object? userPhoneNo = null,Object? teamSize = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
companyId: null == companyId ? _self.companyId : companyId // ignore: cast_nullable_to_non_nullable
as String,companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,userPhoneNo: null == userPhoneNo ? _self.userPhoneNo : userPhoneNo // ignore: cast_nullable_to_non_nullable
as String,teamSize: null == teamSize ? _self.teamSize : teamSize // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CompanyDetailModel].
extension CompanyDetailModelPatterns on CompanyDetailModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CompanyDetailModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CompanyDetailModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CompanyDetailModel value)  $default,){
final _that = this;
switch (_that) {
case _CompanyDetailModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CompanyDetailModel value)?  $default,){
final _that = this;
switch (_that) {
case _CompanyDetailModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String companyId,  String companyName,  String userPhoneNo,  int teamSize,  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CompanyDetailModel() when $default != null:
return $default(_that.companyId,_that.companyName,_that.userPhoneNo,_that.teamSize,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String companyId,  String companyName,  String userPhoneNo,  int teamSize,  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _CompanyDetailModel():
return $default(_that.companyId,_that.companyName,_that.userPhoneNo,_that.teamSize,_that.createdAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String companyId,  String companyName,  String userPhoneNo,  int teamSize,  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _CompanyDetailModel() when $default != null:
return $default(_that.companyId,_that.companyName,_that.userPhoneNo,_that.teamSize,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _CompanyDetailModel extends CompanyDetailModel {
  const _CompanyDetailModel({required this.companyId, required this.companyName, required this.userPhoneNo, required this.teamSize, required this.createdAt}): super._();
  

@override final  String companyId;
@override final  String companyName;
@override final  String userPhoneNo;
@override final  int teamSize;
@override final  String createdAt;

/// Create a copy of CompanyDetailModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompanyDetailModelCopyWith<_CompanyDetailModel> get copyWith => __$CompanyDetailModelCopyWithImpl<_CompanyDetailModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompanyDetailModel&&(identical(other.companyId, companyId) || other.companyId == companyId)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.userPhoneNo, userPhoneNo) || other.userPhoneNo == userPhoneNo)&&(identical(other.teamSize, teamSize) || other.teamSize == teamSize)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,companyId,companyName,userPhoneNo,teamSize,createdAt);

@override
String toString() {
  return 'CompanyDetailModel(companyId: $companyId, companyName: $companyName, userPhoneNo: $userPhoneNo, teamSize: $teamSize, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$CompanyDetailModelCopyWith<$Res> implements $CompanyDetailModelCopyWith<$Res> {
  factory _$CompanyDetailModelCopyWith(_CompanyDetailModel value, $Res Function(_CompanyDetailModel) _then) = __$CompanyDetailModelCopyWithImpl;
@override @useResult
$Res call({
 String companyId, String companyName, String userPhoneNo, int teamSize, String createdAt
});




}
/// @nodoc
class __$CompanyDetailModelCopyWithImpl<$Res>
    implements _$CompanyDetailModelCopyWith<$Res> {
  __$CompanyDetailModelCopyWithImpl(this._self, this._then);

  final _CompanyDetailModel _self;
  final $Res Function(_CompanyDetailModel) _then;

/// Create a copy of CompanyDetailModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? companyId = null,Object? companyName = null,Object? userPhoneNo = null,Object? teamSize = null,Object? createdAt = null,}) {
  return _then(_CompanyDetailModel(
companyId: null == companyId ? _self.companyId : companyId // ignore: cast_nullable_to_non_nullable
as String,companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,userPhoneNo: null == userPhoneNo ? _self.userPhoneNo : userPhoneNo // ignore: cast_nullable_to_non_nullable
as String,teamSize: null == teamSize ? _self.teamSize : teamSize // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
