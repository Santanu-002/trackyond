// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'send_otp_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SendOtpResponseModel {

 String get phone; String get otpId; DateTime get expiresAt; DateTime? get resendableAt; int get remainingAttempts;
/// Create a copy of SendOtpResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SendOtpResponseModelCopyWith<SendOtpResponseModel> get copyWith => _$SendOtpResponseModelCopyWithImpl<SendOtpResponseModel>(this as SendOtpResponseModel, _$identity);

  /// Serializes this SendOtpResponseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SendOtpResponseModel&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.otpId, otpId) || other.otpId == otpId)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.resendableAt, resendableAt) || other.resendableAt == resendableAt)&&(identical(other.remainingAttempts, remainingAttempts) || other.remainingAttempts == remainingAttempts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,phone,otpId,expiresAt,resendableAt,remainingAttempts);

@override
String toString() {
  return 'SendOtpResponseModel(phone: $phone, otpId: $otpId, expiresAt: $expiresAt, resendableAt: $resendableAt, remainingAttempts: $remainingAttempts)';
}


}

/// @nodoc
abstract mixin class $SendOtpResponseModelCopyWith<$Res>  {
  factory $SendOtpResponseModelCopyWith(SendOtpResponseModel value, $Res Function(SendOtpResponseModel) _then) = _$SendOtpResponseModelCopyWithImpl;
@useResult
$Res call({
 String phone, String otpId, DateTime expiresAt, DateTime? resendableAt, int remainingAttempts
});




}
/// @nodoc
class _$SendOtpResponseModelCopyWithImpl<$Res>
    implements $SendOtpResponseModelCopyWith<$Res> {
  _$SendOtpResponseModelCopyWithImpl(this._self, this._then);

  final SendOtpResponseModel _self;
  final $Res Function(SendOtpResponseModel) _then;

/// Create a copy of SendOtpResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phone = null,Object? otpId = null,Object? expiresAt = null,Object? resendableAt = freezed,Object? remainingAttempts = null,}) {
  return _then(_self.copyWith(
phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,otpId: null == otpId ? _self.otpId : otpId // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,resendableAt: freezed == resendableAt ? _self.resendableAt : resendableAt // ignore: cast_nullable_to_non_nullable
as DateTime?,remainingAttempts: null == remainingAttempts ? _self.remainingAttempts : remainingAttempts // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SendOtpResponseModel].
extension SendOtpResponseModelPatterns on SendOtpResponseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SendOtpResponseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SendOtpResponseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SendOtpResponseModel value)  $default,){
final _that = this;
switch (_that) {
case _SendOtpResponseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SendOtpResponseModel value)?  $default,){
final _that = this;
switch (_that) {
case _SendOtpResponseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String phone,  String otpId,  DateTime expiresAt,  DateTime? resendableAt,  int remainingAttempts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SendOtpResponseModel() when $default != null:
return $default(_that.phone,_that.otpId,_that.expiresAt,_that.resendableAt,_that.remainingAttempts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String phone,  String otpId,  DateTime expiresAt,  DateTime? resendableAt,  int remainingAttempts)  $default,) {final _that = this;
switch (_that) {
case _SendOtpResponseModel():
return $default(_that.phone,_that.otpId,_that.expiresAt,_that.resendableAt,_that.remainingAttempts);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String phone,  String otpId,  DateTime expiresAt,  DateTime? resendableAt,  int remainingAttempts)?  $default,) {final _that = this;
switch (_that) {
case _SendOtpResponseModel() when $default != null:
return $default(_that.phone,_that.otpId,_that.expiresAt,_that.resendableAt,_that.remainingAttempts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SendOtpResponseModel extends SendOtpResponseModel {
  const _SendOtpResponseModel({required this.phone, required this.otpId, required this.expiresAt, this.resendableAt, required this.remainingAttempts}): super._();
  factory _SendOtpResponseModel.fromJson(Map<String, dynamic> json) => _$SendOtpResponseModelFromJson(json);

@override final  String phone;
@override final  String otpId;
@override final  DateTime expiresAt;
@override final  DateTime? resendableAt;
@override final  int remainingAttempts;

/// Create a copy of SendOtpResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SendOtpResponseModelCopyWith<_SendOtpResponseModel> get copyWith => __$SendOtpResponseModelCopyWithImpl<_SendOtpResponseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SendOtpResponseModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SendOtpResponseModel&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.otpId, otpId) || other.otpId == otpId)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.resendableAt, resendableAt) || other.resendableAt == resendableAt)&&(identical(other.remainingAttempts, remainingAttempts) || other.remainingAttempts == remainingAttempts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,phone,otpId,expiresAt,resendableAt,remainingAttempts);

@override
String toString() {
  return 'SendOtpResponseModel(phone: $phone, otpId: $otpId, expiresAt: $expiresAt, resendableAt: $resendableAt, remainingAttempts: $remainingAttempts)';
}


}

/// @nodoc
abstract mixin class _$SendOtpResponseModelCopyWith<$Res> implements $SendOtpResponseModelCopyWith<$Res> {
  factory _$SendOtpResponseModelCopyWith(_SendOtpResponseModel value, $Res Function(_SendOtpResponseModel) _then) = __$SendOtpResponseModelCopyWithImpl;
@override @useResult
$Res call({
 String phone, String otpId, DateTime expiresAt, DateTime? resendableAt, int remainingAttempts
});




}
/// @nodoc
class __$SendOtpResponseModelCopyWithImpl<$Res>
    implements _$SendOtpResponseModelCopyWith<$Res> {
  __$SendOtpResponseModelCopyWithImpl(this._self, this._then);

  final _SendOtpResponseModel _self;
  final $Res Function(_SendOtpResponseModel) _then;

/// Create a copy of SendOtpResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phone = null,Object? otpId = null,Object? expiresAt = null,Object? resendableAt = freezed,Object? remainingAttempts = null,}) {
  return _then(_SendOtpResponseModel(
phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,otpId: null == otpId ? _self.otpId : otpId // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,resendableAt: freezed == resendableAt ? _self.resendableAt : resendableAt // ignore: cast_nullable_to_non_nullable
as DateTime?,remainingAttempts: null == remainingAttempts ? _self.remainingAttempts : remainingAttempts // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
