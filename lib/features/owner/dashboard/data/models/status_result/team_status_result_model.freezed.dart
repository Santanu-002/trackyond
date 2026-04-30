// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_status_result_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TeamStatusResultModel {

 List<TeamMemberStatusModel> get members; TeamStatusStatsModel get stats;
/// Create a copy of TeamStatusResultModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeamStatusResultModelCopyWith<TeamStatusResultModel> get copyWith => _$TeamStatusResultModelCopyWithImpl<TeamStatusResultModel>(this as TeamStatusResultModel, _$identity);

  /// Serializes this TeamStatusResultModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeamStatusResultModel&&const DeepCollectionEquality().equals(other.members, members)&&(identical(other.stats, stats) || other.stats == stats));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(members),stats);

@override
String toString() {
  return 'TeamStatusResultModel(members: $members, stats: $stats)';
}


}

/// @nodoc
abstract mixin class $TeamStatusResultModelCopyWith<$Res>  {
  factory $TeamStatusResultModelCopyWith(TeamStatusResultModel value, $Res Function(TeamStatusResultModel) _then) = _$TeamStatusResultModelCopyWithImpl;
@useResult
$Res call({
 List<TeamMemberStatusModel> members, TeamStatusStatsModel stats
});


$TeamStatusStatsModelCopyWith<$Res> get stats;

}
/// @nodoc
class _$TeamStatusResultModelCopyWithImpl<$Res>
    implements $TeamStatusResultModelCopyWith<$Res> {
  _$TeamStatusResultModelCopyWithImpl(this._self, this._then);

  final TeamStatusResultModel _self;
  final $Res Function(TeamStatusResultModel) _then;

/// Create a copy of TeamStatusResultModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? members = null,Object? stats = null,}) {
  return _then(_self.copyWith(
members: null == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<TeamMemberStatusModel>,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as TeamStatusStatsModel,
  ));
}
/// Create a copy of TeamStatusResultModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeamStatusStatsModelCopyWith<$Res> get stats {
  
  return $TeamStatusStatsModelCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}
}


/// Adds pattern-matching-related methods to [TeamStatusResultModel].
extension TeamStatusResultModelPatterns on TeamStatusResultModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeamStatusResultModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeamStatusResultModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeamStatusResultModel value)  $default,){
final _that = this;
switch (_that) {
case _TeamStatusResultModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeamStatusResultModel value)?  $default,){
final _that = this;
switch (_that) {
case _TeamStatusResultModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TeamMemberStatusModel> members,  TeamStatusStatsModel stats)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeamStatusResultModel() when $default != null:
return $default(_that.members,_that.stats);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TeamMemberStatusModel> members,  TeamStatusStatsModel stats)  $default,) {final _that = this;
switch (_that) {
case _TeamStatusResultModel():
return $default(_that.members,_that.stats);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TeamMemberStatusModel> members,  TeamStatusStatsModel stats)?  $default,) {final _that = this;
switch (_that) {
case _TeamStatusResultModel() when $default != null:
return $default(_that.members,_that.stats);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TeamStatusResultModel extends TeamStatusResultModel {
  const _TeamStatusResultModel({required final  List<TeamMemberStatusModel> members, required this.stats}): _members = members,super._();
  factory _TeamStatusResultModel.fromJson(Map<String, dynamic> json) => _$TeamStatusResultModelFromJson(json);

 final  List<TeamMemberStatusModel> _members;
@override List<TeamMemberStatusModel> get members {
  if (_members is EqualUnmodifiableListView) return _members;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_members);
}

@override final  TeamStatusStatsModel stats;

/// Create a copy of TeamStatusResultModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeamStatusResultModelCopyWith<_TeamStatusResultModel> get copyWith => __$TeamStatusResultModelCopyWithImpl<_TeamStatusResultModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeamStatusResultModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeamStatusResultModel&&const DeepCollectionEquality().equals(other._members, _members)&&(identical(other.stats, stats) || other.stats == stats));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_members),stats);

@override
String toString() {
  return 'TeamStatusResultModel(members: $members, stats: $stats)';
}


}

/// @nodoc
abstract mixin class _$TeamStatusResultModelCopyWith<$Res> implements $TeamStatusResultModelCopyWith<$Res> {
  factory _$TeamStatusResultModelCopyWith(_TeamStatusResultModel value, $Res Function(_TeamStatusResultModel) _then) = __$TeamStatusResultModelCopyWithImpl;
@override @useResult
$Res call({
 List<TeamMemberStatusModel> members, TeamStatusStatsModel stats
});


@override $TeamStatusStatsModelCopyWith<$Res> get stats;

}
/// @nodoc
class __$TeamStatusResultModelCopyWithImpl<$Res>
    implements _$TeamStatusResultModelCopyWith<$Res> {
  __$TeamStatusResultModelCopyWithImpl(this._self, this._then);

  final _TeamStatusResultModel _self;
  final $Res Function(_TeamStatusResultModel) _then;

/// Create a copy of TeamStatusResultModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? members = null,Object? stats = null,}) {
  return _then(_TeamStatusResultModel(
members: null == members ? _self._members : members // ignore: cast_nullable_to_non_nullable
as List<TeamMemberStatusModel>,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as TeamStatusStatsModel,
  ));
}

/// Create a copy of TeamStatusResultModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeamStatusStatsModelCopyWith<$Res> get stats {
  
  return $TeamStatusStatsModelCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}
}

// dart format on
