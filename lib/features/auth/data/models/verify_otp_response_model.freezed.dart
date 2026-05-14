// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verify_otp_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VerifyOtpResponseModel {

 String get userUid;@JsonKey(name: 'phone') String get phone; bool get isNewUser; String? get primaryProfileUid;@JsonKey(fromJson: UserRole.fromString) UserRole get role; String get accessToken; String get refreshToken; String get accessExpireAt; String get refreshExpireAt; String get tokenIssuedAt; MemberProfileModel? get profile; CompanyModel? get company;
/// Create a copy of VerifyOtpResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VerifyOtpResponseModelCopyWith<VerifyOtpResponseModel> get copyWith => _$VerifyOtpResponseModelCopyWithImpl<VerifyOtpResponseModel>(this as VerifyOtpResponseModel, _$identity);

  /// Serializes this VerifyOtpResponseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VerifyOtpResponseModel&&(identical(other.userUid, userUid) || other.userUid == userUid)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.isNewUser, isNewUser) || other.isNewUser == isNewUser)&&(identical(other.primaryProfileUid, primaryProfileUid) || other.primaryProfileUid == primaryProfileUid)&&(identical(other.role, role) || other.role == role)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.accessExpireAt, accessExpireAt) || other.accessExpireAt == accessExpireAt)&&(identical(other.refreshExpireAt, refreshExpireAt) || other.refreshExpireAt == refreshExpireAt)&&(identical(other.tokenIssuedAt, tokenIssuedAt) || other.tokenIssuedAt == tokenIssuedAt)&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.company, company) || other.company == company));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userUid,phone,isNewUser,primaryProfileUid,role,accessToken,refreshToken,accessExpireAt,refreshExpireAt,tokenIssuedAt,profile,company);

@override
String toString() {
  return 'VerifyOtpResponseModel(userUid: $userUid, phone: $phone, isNewUser: $isNewUser, primaryProfileUid: $primaryProfileUid, role: $role, accessToken: $accessToken, refreshToken: $refreshToken, accessExpireAt: $accessExpireAt, refreshExpireAt: $refreshExpireAt, tokenIssuedAt: $tokenIssuedAt, profile: $profile, company: $company)';
}


}

/// @nodoc
abstract mixin class $VerifyOtpResponseModelCopyWith<$Res>  {
  factory $VerifyOtpResponseModelCopyWith(VerifyOtpResponseModel value, $Res Function(VerifyOtpResponseModel) _then) = _$VerifyOtpResponseModelCopyWithImpl;
@useResult
$Res call({
 String userUid,@JsonKey(name: 'phone') String phone, bool isNewUser, String? primaryProfileUid,@JsonKey(fromJson: UserRole.fromString) UserRole role, String accessToken, String refreshToken, String accessExpireAt, String refreshExpireAt, String tokenIssuedAt, MemberProfileModel? profile, CompanyModel? company
});


$MemberProfileModelCopyWith<$Res>? get profile;$CompanyModelCopyWith<$Res>? get company;

}
/// @nodoc
class _$VerifyOtpResponseModelCopyWithImpl<$Res>
    implements $VerifyOtpResponseModelCopyWith<$Res> {
  _$VerifyOtpResponseModelCopyWithImpl(this._self, this._then);

  final VerifyOtpResponseModel _self;
  final $Res Function(VerifyOtpResponseModel) _then;

/// Create a copy of VerifyOtpResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userUid = null,Object? phone = null,Object? isNewUser = null,Object? primaryProfileUid = freezed,Object? role = null,Object? accessToken = null,Object? refreshToken = null,Object? accessExpireAt = null,Object? refreshExpireAt = null,Object? tokenIssuedAt = null,Object? profile = freezed,Object? company = freezed,}) {
  return _then(_self.copyWith(
userUid: null == userUid ? _self.userUid : userUid // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,isNewUser: null == isNewUser ? _self.isNewUser : isNewUser // ignore: cast_nullable_to_non_nullable
as bool,primaryProfileUid: freezed == primaryProfileUid ? _self.primaryProfileUid : primaryProfileUid // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,accessExpireAt: null == accessExpireAt ? _self.accessExpireAt : accessExpireAt // ignore: cast_nullable_to_non_nullable
as String,refreshExpireAt: null == refreshExpireAt ? _self.refreshExpireAt : refreshExpireAt // ignore: cast_nullable_to_non_nullable
as String,tokenIssuedAt: null == tokenIssuedAt ? _self.tokenIssuedAt : tokenIssuedAt // ignore: cast_nullable_to_non_nullable
as String,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as MemberProfileModel?,company: freezed == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as CompanyModel?,
  ));
}
/// Create a copy of VerifyOtpResponseModel
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
}/// Create a copy of VerifyOtpResponseModel
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


/// Adds pattern-matching-related methods to [VerifyOtpResponseModel].
extension VerifyOtpResponseModelPatterns on VerifyOtpResponseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VerifyOtpResponseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VerifyOtpResponseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VerifyOtpResponseModel value)  $default,){
final _that = this;
switch (_that) {
case _VerifyOtpResponseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VerifyOtpResponseModel value)?  $default,){
final _that = this;
switch (_that) {
case _VerifyOtpResponseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userUid, @JsonKey(name: 'phone')  String phone,  bool isNewUser,  String? primaryProfileUid, @JsonKey(fromJson: UserRole.fromString)  UserRole role,  String accessToken,  String refreshToken,  String accessExpireAt,  String refreshExpireAt,  String tokenIssuedAt,  MemberProfileModel? profile,  CompanyModel? company)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VerifyOtpResponseModel() when $default != null:
return $default(_that.userUid,_that.phone,_that.isNewUser,_that.primaryProfileUid,_that.role,_that.accessToken,_that.refreshToken,_that.accessExpireAt,_that.refreshExpireAt,_that.tokenIssuedAt,_that.profile,_that.company);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userUid, @JsonKey(name: 'phone')  String phone,  bool isNewUser,  String? primaryProfileUid, @JsonKey(fromJson: UserRole.fromString)  UserRole role,  String accessToken,  String refreshToken,  String accessExpireAt,  String refreshExpireAt,  String tokenIssuedAt,  MemberProfileModel? profile,  CompanyModel? company)  $default,) {final _that = this;
switch (_that) {
case _VerifyOtpResponseModel():
return $default(_that.userUid,_that.phone,_that.isNewUser,_that.primaryProfileUid,_that.role,_that.accessToken,_that.refreshToken,_that.accessExpireAt,_that.refreshExpireAt,_that.tokenIssuedAt,_that.profile,_that.company);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userUid, @JsonKey(name: 'phone')  String phone,  bool isNewUser,  String? primaryProfileUid, @JsonKey(fromJson: UserRole.fromString)  UserRole role,  String accessToken,  String refreshToken,  String accessExpireAt,  String refreshExpireAt,  String tokenIssuedAt,  MemberProfileModel? profile,  CompanyModel? company)?  $default,) {final _that = this;
switch (_that) {
case _VerifyOtpResponseModel() when $default != null:
return $default(_that.userUid,_that.phone,_that.isNewUser,_that.primaryProfileUid,_that.role,_that.accessToken,_that.refreshToken,_that.accessExpireAt,_that.refreshExpireAt,_that.tokenIssuedAt,_that.profile,_that.company);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VerifyOtpResponseModel extends VerifyOtpResponseModel {
  const _VerifyOtpResponseModel({required this.userUid, @JsonKey(name: 'phone') required this.phone, this.isNewUser = false, this.primaryProfileUid, @JsonKey(fromJson: UserRole.fromString) required this.role, required this.accessToken, required this.refreshToken, required this.accessExpireAt, required this.refreshExpireAt, required this.tokenIssuedAt, this.profile, this.company}): super._();
  factory _VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) => _$VerifyOtpResponseModelFromJson(json);

@override final  String userUid;
@override@JsonKey(name: 'phone') final  String phone;
@override@JsonKey() final  bool isNewUser;
@override final  String? primaryProfileUid;
@override@JsonKey(fromJson: UserRole.fromString) final  UserRole role;
@override final  String accessToken;
@override final  String refreshToken;
@override final  String accessExpireAt;
@override final  String refreshExpireAt;
@override final  String tokenIssuedAt;
@override final  MemberProfileModel? profile;
@override final  CompanyModel? company;

/// Create a copy of VerifyOtpResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VerifyOtpResponseModelCopyWith<_VerifyOtpResponseModel> get copyWith => __$VerifyOtpResponseModelCopyWithImpl<_VerifyOtpResponseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VerifyOtpResponseModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VerifyOtpResponseModel&&(identical(other.userUid, userUid) || other.userUid == userUid)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.isNewUser, isNewUser) || other.isNewUser == isNewUser)&&(identical(other.primaryProfileUid, primaryProfileUid) || other.primaryProfileUid == primaryProfileUid)&&(identical(other.role, role) || other.role == role)&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.accessExpireAt, accessExpireAt) || other.accessExpireAt == accessExpireAt)&&(identical(other.refreshExpireAt, refreshExpireAt) || other.refreshExpireAt == refreshExpireAt)&&(identical(other.tokenIssuedAt, tokenIssuedAt) || other.tokenIssuedAt == tokenIssuedAt)&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.company, company) || other.company == company));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userUid,phone,isNewUser,primaryProfileUid,role,accessToken,refreshToken,accessExpireAt,refreshExpireAt,tokenIssuedAt,profile,company);

@override
String toString() {
  return 'VerifyOtpResponseModel(userUid: $userUid, phone: $phone, isNewUser: $isNewUser, primaryProfileUid: $primaryProfileUid, role: $role, accessToken: $accessToken, refreshToken: $refreshToken, accessExpireAt: $accessExpireAt, refreshExpireAt: $refreshExpireAt, tokenIssuedAt: $tokenIssuedAt, profile: $profile, company: $company)';
}


}

/// @nodoc
abstract mixin class _$VerifyOtpResponseModelCopyWith<$Res> implements $VerifyOtpResponseModelCopyWith<$Res> {
  factory _$VerifyOtpResponseModelCopyWith(_VerifyOtpResponseModel value, $Res Function(_VerifyOtpResponseModel) _then) = __$VerifyOtpResponseModelCopyWithImpl;
@override @useResult
$Res call({
 String userUid,@JsonKey(name: 'phone') String phone, bool isNewUser, String? primaryProfileUid,@JsonKey(fromJson: UserRole.fromString) UserRole role, String accessToken, String refreshToken, String accessExpireAt, String refreshExpireAt, String tokenIssuedAt, MemberProfileModel? profile, CompanyModel? company
});


@override $MemberProfileModelCopyWith<$Res>? get profile;@override $CompanyModelCopyWith<$Res>? get company;

}
/// @nodoc
class __$VerifyOtpResponseModelCopyWithImpl<$Res>
    implements _$VerifyOtpResponseModelCopyWith<$Res> {
  __$VerifyOtpResponseModelCopyWithImpl(this._self, this._then);

  final _VerifyOtpResponseModel _self;
  final $Res Function(_VerifyOtpResponseModel) _then;

/// Create a copy of VerifyOtpResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userUid = null,Object? phone = null,Object? isNewUser = null,Object? primaryProfileUid = freezed,Object? role = null,Object? accessToken = null,Object? refreshToken = null,Object? accessExpireAt = null,Object? refreshExpireAt = null,Object? tokenIssuedAt = null,Object? profile = freezed,Object? company = freezed,}) {
  return _then(_VerifyOtpResponseModel(
userUid: null == userUid ? _self.userUid : userUid // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,isNewUser: null == isNewUser ? _self.isNewUser : isNewUser // ignore: cast_nullable_to_non_nullable
as bool,primaryProfileUid: freezed == primaryProfileUid ? _self.primaryProfileUid : primaryProfileUid // ignore: cast_nullable_to_non_nullable
as String?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,accessExpireAt: null == accessExpireAt ? _self.accessExpireAt : accessExpireAt // ignore: cast_nullable_to_non_nullable
as String,refreshExpireAt: null == refreshExpireAt ? _self.refreshExpireAt : refreshExpireAt // ignore: cast_nullable_to_non_nullable
as String,tokenIssuedAt: null == tokenIssuedAt ? _self.tokenIssuedAt : tokenIssuedAt // ignore: cast_nullable_to_non_nullable
as String,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as MemberProfileModel?,company: freezed == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as CompanyModel?,
  ));
}

/// Create a copy of VerifyOtpResponseModel
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
}/// Create a copy of VerifyOtpResponseModel
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
