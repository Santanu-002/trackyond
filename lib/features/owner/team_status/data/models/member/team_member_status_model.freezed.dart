// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_member_status_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TeamMemberStatusModel {

 MemberProfileModel get profile; AttendanceModel? get todayAttendance;
/// Create a copy of TeamMemberStatusModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeamMemberStatusModelCopyWith<TeamMemberStatusModel> get copyWith => _$TeamMemberStatusModelCopyWithImpl<TeamMemberStatusModel>(this as TeamMemberStatusModel, _$identity);

  /// Serializes this TeamMemberStatusModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeamMemberStatusModel&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.todayAttendance, todayAttendance) || other.todayAttendance == todayAttendance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,profile,todayAttendance);

@override
String toString() {
  return 'TeamMemberStatusModel(profile: $profile, todayAttendance: $todayAttendance)';
}


}

/// @nodoc
abstract mixin class $TeamMemberStatusModelCopyWith<$Res>  {
  factory $TeamMemberStatusModelCopyWith(TeamMemberStatusModel value, $Res Function(TeamMemberStatusModel) _then) = _$TeamMemberStatusModelCopyWithImpl;
@useResult
$Res call({
 MemberProfileModel profile, AttendanceModel? todayAttendance
});


$MemberProfileModelCopyWith<$Res> get profile;$AttendanceModelCopyWith<$Res>? get todayAttendance;

}
/// @nodoc
class _$TeamMemberStatusModelCopyWithImpl<$Res>
    implements $TeamMemberStatusModelCopyWith<$Res> {
  _$TeamMemberStatusModelCopyWithImpl(this._self, this._then);

  final TeamMemberStatusModel _self;
  final $Res Function(TeamMemberStatusModel) _then;

/// Create a copy of TeamMemberStatusModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? profile = null,Object? todayAttendance = freezed,}) {
  return _then(_self.copyWith(
profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as MemberProfileModel,todayAttendance: freezed == todayAttendance ? _self.todayAttendance : todayAttendance // ignore: cast_nullable_to_non_nullable
as AttendanceModel?,
  ));
}
/// Create a copy of TeamMemberStatusModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MemberProfileModelCopyWith<$Res> get profile {
  
  return $MemberProfileModelCopyWith<$Res>(_self.profile, (value) {
    return _then(_self.copyWith(profile: value));
  });
}/// Create a copy of TeamMemberStatusModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttendanceModelCopyWith<$Res>? get todayAttendance {
    if (_self.todayAttendance == null) {
    return null;
  }

  return $AttendanceModelCopyWith<$Res>(_self.todayAttendance!, (value) {
    return _then(_self.copyWith(todayAttendance: value));
  });
}
}


/// Adds pattern-matching-related methods to [TeamMemberStatusModel].
extension TeamMemberStatusModelPatterns on TeamMemberStatusModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeamMemberStatusModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeamMemberStatusModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeamMemberStatusModel value)  $default,){
final _that = this;
switch (_that) {
case _TeamMemberStatusModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeamMemberStatusModel value)?  $default,){
final _that = this;
switch (_that) {
case _TeamMemberStatusModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MemberProfileModel profile,  AttendanceModel? todayAttendance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeamMemberStatusModel() when $default != null:
return $default(_that.profile,_that.todayAttendance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MemberProfileModel profile,  AttendanceModel? todayAttendance)  $default,) {final _that = this;
switch (_that) {
case _TeamMemberStatusModel():
return $default(_that.profile,_that.todayAttendance);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MemberProfileModel profile,  AttendanceModel? todayAttendance)?  $default,) {final _that = this;
switch (_that) {
case _TeamMemberStatusModel() when $default != null:
return $default(_that.profile,_that.todayAttendance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TeamMemberStatusModel extends TeamMemberStatusModel {
  const _TeamMemberStatusModel({required this.profile, this.todayAttendance}): super._();
  factory _TeamMemberStatusModel.fromJson(Map<String, dynamic> json) => _$TeamMemberStatusModelFromJson(json);

@override final  MemberProfileModel profile;
@override final  AttendanceModel? todayAttendance;

/// Create a copy of TeamMemberStatusModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeamMemberStatusModelCopyWith<_TeamMemberStatusModel> get copyWith => __$TeamMemberStatusModelCopyWithImpl<_TeamMemberStatusModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeamMemberStatusModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeamMemberStatusModel&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.todayAttendance, todayAttendance) || other.todayAttendance == todayAttendance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,profile,todayAttendance);

@override
String toString() {
  return 'TeamMemberStatusModel(profile: $profile, todayAttendance: $todayAttendance)';
}


}

/// @nodoc
abstract mixin class _$TeamMemberStatusModelCopyWith<$Res> implements $TeamMemberStatusModelCopyWith<$Res> {
  factory _$TeamMemberStatusModelCopyWith(_TeamMemberStatusModel value, $Res Function(_TeamMemberStatusModel) _then) = __$TeamMemberStatusModelCopyWithImpl;
@override @useResult
$Res call({
 MemberProfileModel profile, AttendanceModel? todayAttendance
});


@override $MemberProfileModelCopyWith<$Res> get profile;@override $AttendanceModelCopyWith<$Res>? get todayAttendance;

}
/// @nodoc
class __$TeamMemberStatusModelCopyWithImpl<$Res>
    implements _$TeamMemberStatusModelCopyWith<$Res> {
  __$TeamMemberStatusModelCopyWithImpl(this._self, this._then);

  final _TeamMemberStatusModel _self;
  final $Res Function(_TeamMemberStatusModel) _then;

/// Create a copy of TeamMemberStatusModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? profile = null,Object? todayAttendance = freezed,}) {
  return _then(_TeamMemberStatusModel(
profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as MemberProfileModel,todayAttendance: freezed == todayAttendance ? _self.todayAttendance : todayAttendance // ignore: cast_nullable_to_non_nullable
as AttendanceModel?,
  ));
}

/// Create a copy of TeamMemberStatusModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MemberProfileModelCopyWith<$Res> get profile {
  
  return $MemberProfileModelCopyWith<$Res>(_self.profile, (value) {
    return _then(_self.copyWith(profile: value));
  });
}/// Create a copy of TeamMemberStatusModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttendanceModelCopyWith<$Res>? get todayAttendance {
    if (_self.todayAttendance == null) {
    return null;
  }

  return $AttendanceModelCopyWith<$Res>(_self.todayAttendance!, (value) {
    return _then(_self.copyWith(todayAttendance: value));
  });
}
}

// dart format on
