// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_status_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TeamStatusModel {

 List<TeamMemberStatusModel> get members; TeamStatusStatsModel get stats; TeamStatusOptionsModel get options; TeamStatusPaginationModel get pagination;
/// Create a copy of TeamStatusModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeamStatusModelCopyWith<TeamStatusModel> get copyWith => _$TeamStatusModelCopyWithImpl<TeamStatusModel>(this as TeamStatusModel, _$identity);

  /// Serializes this TeamStatusModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeamStatusModel&&const DeepCollectionEquality().equals(other.members, members)&&(identical(other.stats, stats) || other.stats == stats)&&(identical(other.options, options) || other.options == options)&&(identical(other.pagination, pagination) || other.pagination == pagination));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(members),stats,options,pagination);

@override
String toString() {
  return 'TeamStatusModel(members: $members, stats: $stats, options: $options, pagination: $pagination)';
}


}

/// @nodoc
abstract mixin class $TeamStatusModelCopyWith<$Res>  {
  factory $TeamStatusModelCopyWith(TeamStatusModel value, $Res Function(TeamStatusModel) _then) = _$TeamStatusModelCopyWithImpl;
@useResult
$Res call({
 List<TeamMemberStatusModel> members, TeamStatusStatsModel stats, TeamStatusOptionsModel options, TeamStatusPaginationModel pagination
});


$TeamStatusStatsModelCopyWith<$Res> get stats;$TeamStatusOptionsModelCopyWith<$Res> get options;$TeamStatusPaginationModelCopyWith<$Res> get pagination;

}
/// @nodoc
class _$TeamStatusModelCopyWithImpl<$Res>
    implements $TeamStatusModelCopyWith<$Res> {
  _$TeamStatusModelCopyWithImpl(this._self, this._then);

  final TeamStatusModel _self;
  final $Res Function(TeamStatusModel) _then;

/// Create a copy of TeamStatusModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? members = null,Object? stats = null,Object? options = null,Object? pagination = null,}) {
  return _then(_self.copyWith(
members: null == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<TeamMemberStatusModel>,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as TeamStatusStatsModel,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as TeamStatusOptionsModel,pagination: null == pagination ? _self.pagination : pagination // ignore: cast_nullable_to_non_nullable
as TeamStatusPaginationModel,
  ));
}
/// Create a copy of TeamStatusModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeamStatusStatsModelCopyWith<$Res> get stats {
  
  return $TeamStatusStatsModelCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}/// Create a copy of TeamStatusModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeamStatusOptionsModelCopyWith<$Res> get options {
  
  return $TeamStatusOptionsModelCopyWith<$Res>(_self.options, (value) {
    return _then(_self.copyWith(options: value));
  });
}/// Create a copy of TeamStatusModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeamStatusPaginationModelCopyWith<$Res> get pagination {
  
  return $TeamStatusPaginationModelCopyWith<$Res>(_self.pagination, (value) {
    return _then(_self.copyWith(pagination: value));
  });
}
}


/// Adds pattern-matching-related methods to [TeamStatusModel].
extension TeamStatusModelPatterns on TeamStatusModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeamStatusModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeamStatusModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeamStatusModel value)  $default,){
final _that = this;
switch (_that) {
case _TeamStatusModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeamStatusModel value)?  $default,){
final _that = this;
switch (_that) {
case _TeamStatusModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TeamMemberStatusModel> members,  TeamStatusStatsModel stats,  TeamStatusOptionsModel options,  TeamStatusPaginationModel pagination)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeamStatusModel() when $default != null:
return $default(_that.members,_that.stats,_that.options,_that.pagination);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TeamMemberStatusModel> members,  TeamStatusStatsModel stats,  TeamStatusOptionsModel options,  TeamStatusPaginationModel pagination)  $default,) {final _that = this;
switch (_that) {
case _TeamStatusModel():
return $default(_that.members,_that.stats,_that.options,_that.pagination);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TeamMemberStatusModel> members,  TeamStatusStatsModel stats,  TeamStatusOptionsModel options,  TeamStatusPaginationModel pagination)?  $default,) {final _that = this;
switch (_that) {
case _TeamStatusModel() when $default != null:
return $default(_that.members,_that.stats,_that.options,_that.pagination);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TeamStatusModel extends TeamStatusModel {
  const _TeamStatusModel({required final  List<TeamMemberStatusModel> members, required this.stats, required this.options, required this.pagination}): _members = members,super._();
  factory _TeamStatusModel.fromJson(Map<String, dynamic> json) => _$TeamStatusModelFromJson(json);

 final  List<TeamMemberStatusModel> _members;
@override List<TeamMemberStatusModel> get members {
  if (_members is EqualUnmodifiableListView) return _members;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_members);
}

@override final  TeamStatusStatsModel stats;
@override final  TeamStatusOptionsModel options;
@override final  TeamStatusPaginationModel pagination;

/// Create a copy of TeamStatusModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeamStatusModelCopyWith<_TeamStatusModel> get copyWith => __$TeamStatusModelCopyWithImpl<_TeamStatusModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeamStatusModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeamStatusModel&&const DeepCollectionEquality().equals(other._members, _members)&&(identical(other.stats, stats) || other.stats == stats)&&(identical(other.options, options) || other.options == options)&&(identical(other.pagination, pagination) || other.pagination == pagination));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_members),stats,options,pagination);

@override
String toString() {
  return 'TeamStatusModel(members: $members, stats: $stats, options: $options, pagination: $pagination)';
}


}

/// @nodoc
abstract mixin class _$TeamStatusModelCopyWith<$Res> implements $TeamStatusModelCopyWith<$Res> {
  factory _$TeamStatusModelCopyWith(_TeamStatusModel value, $Res Function(_TeamStatusModel) _then) = __$TeamStatusModelCopyWithImpl;
@override @useResult
$Res call({
 List<TeamMemberStatusModel> members, TeamStatusStatsModel stats, TeamStatusOptionsModel options, TeamStatusPaginationModel pagination
});


@override $TeamStatusStatsModelCopyWith<$Res> get stats;@override $TeamStatusOptionsModelCopyWith<$Res> get options;@override $TeamStatusPaginationModelCopyWith<$Res> get pagination;

}
/// @nodoc
class __$TeamStatusModelCopyWithImpl<$Res>
    implements _$TeamStatusModelCopyWith<$Res> {
  __$TeamStatusModelCopyWithImpl(this._self, this._then);

  final _TeamStatusModel _self;
  final $Res Function(_TeamStatusModel) _then;

/// Create a copy of TeamStatusModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? members = null,Object? stats = null,Object? options = null,Object? pagination = null,}) {
  return _then(_TeamStatusModel(
members: null == members ? _self._members : members // ignore: cast_nullable_to_non_nullable
as List<TeamMemberStatusModel>,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as TeamStatusStatsModel,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as TeamStatusOptionsModel,pagination: null == pagination ? _self.pagination : pagination // ignore: cast_nullable_to_non_nullable
as TeamStatusPaginationModel,
  ));
}

/// Create a copy of TeamStatusModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeamStatusStatsModelCopyWith<$Res> get stats {
  
  return $TeamStatusStatsModelCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}/// Create a copy of TeamStatusModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeamStatusOptionsModelCopyWith<$Res> get options {
  
  return $TeamStatusOptionsModelCopyWith<$Res>(_self.options, (value) {
    return _then(_self.copyWith(options: value));
  });
}/// Create a copy of TeamStatusModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeamStatusPaginationModelCopyWith<$Res> get pagination {
  
  return $TeamStatusPaginationModelCopyWith<$Res>(_self.pagination, (value) {
    return _then(_self.copyWith(pagination: value));
  });
}
}

// dart format on
