// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'owner_dashboard_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OwnerDashboardModel {

 List<TeamMemberStatusModel> get teamMembersStatus; OwnerDashboardModelStats get jobCounts; List<JobModel> get recentJobs;
/// Create a copy of OwnerDashboardModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OwnerDashboardModelCopyWith<OwnerDashboardModel> get copyWith => _$OwnerDashboardModelCopyWithImpl<OwnerDashboardModel>(this as OwnerDashboardModel, _$identity);

  /// Serializes this OwnerDashboardModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OwnerDashboardModel&&const DeepCollectionEquality().equals(other.teamMembersStatus, teamMembersStatus)&&(identical(other.jobCounts, jobCounts) || other.jobCounts == jobCounts)&&const DeepCollectionEquality().equals(other.recentJobs, recentJobs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(teamMembersStatus),jobCounts,const DeepCollectionEquality().hash(recentJobs));

@override
String toString() {
  return 'OwnerDashboardModel(teamMembersStatus: $teamMembersStatus, jobCounts: $jobCounts, recentJobs: $recentJobs)';
}


}

/// @nodoc
abstract mixin class $OwnerDashboardModelCopyWith<$Res>  {
  factory $OwnerDashboardModelCopyWith(OwnerDashboardModel value, $Res Function(OwnerDashboardModel) _then) = _$OwnerDashboardModelCopyWithImpl;
@useResult
$Res call({
 List<TeamMemberStatusModel> teamMembersStatus, OwnerDashboardModelStats jobCounts, List<JobModel> recentJobs
});


$OwnerDashboardModelStatsCopyWith<$Res> get jobCounts;

}
/// @nodoc
class _$OwnerDashboardModelCopyWithImpl<$Res>
    implements $OwnerDashboardModelCopyWith<$Res> {
  _$OwnerDashboardModelCopyWithImpl(this._self, this._then);

  final OwnerDashboardModel _self;
  final $Res Function(OwnerDashboardModel) _then;

/// Create a copy of OwnerDashboardModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? teamMembersStatus = null,Object? jobCounts = null,Object? recentJobs = null,}) {
  return _then(_self.copyWith(
teamMembersStatus: null == teamMembersStatus ? _self.teamMembersStatus : teamMembersStatus // ignore: cast_nullable_to_non_nullable
as List<TeamMemberStatusModel>,jobCounts: null == jobCounts ? _self.jobCounts : jobCounts // ignore: cast_nullable_to_non_nullable
as OwnerDashboardModelStats,recentJobs: null == recentJobs ? _self.recentJobs : recentJobs // ignore: cast_nullable_to_non_nullable
as List<JobModel>,
  ));
}
/// Create a copy of OwnerDashboardModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwnerDashboardModelStatsCopyWith<$Res> get jobCounts {
  
  return $OwnerDashboardModelStatsCopyWith<$Res>(_self.jobCounts, (value) {
    return _then(_self.copyWith(jobCounts: value));
  });
}
}


/// Adds pattern-matching-related methods to [OwnerDashboardModel].
extension OwnerDashboardModelPatterns on OwnerDashboardModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OwnerDashboardModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OwnerDashboardModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OwnerDashboardModel value)  $default,){
final _that = this;
switch (_that) {
case _OwnerDashboardModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OwnerDashboardModel value)?  $default,){
final _that = this;
switch (_that) {
case _OwnerDashboardModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TeamMemberStatusModel> teamMembersStatus,  OwnerDashboardModelStats jobCounts,  List<JobModel> recentJobs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OwnerDashboardModel() when $default != null:
return $default(_that.teamMembersStatus,_that.jobCounts,_that.recentJobs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TeamMemberStatusModel> teamMembersStatus,  OwnerDashboardModelStats jobCounts,  List<JobModel> recentJobs)  $default,) {final _that = this;
switch (_that) {
case _OwnerDashboardModel():
return $default(_that.teamMembersStatus,_that.jobCounts,_that.recentJobs);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TeamMemberStatusModel> teamMembersStatus,  OwnerDashboardModelStats jobCounts,  List<JobModel> recentJobs)?  $default,) {final _that = this;
switch (_that) {
case _OwnerDashboardModel() when $default != null:
return $default(_that.teamMembersStatus,_that.jobCounts,_that.recentJobs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OwnerDashboardModel extends OwnerDashboardModel {
  const _OwnerDashboardModel({required final  List<TeamMemberStatusModel> teamMembersStatus, required this.jobCounts, required final  List<JobModel> recentJobs}): _teamMembersStatus = teamMembersStatus,_recentJobs = recentJobs,super._();
  factory _OwnerDashboardModel.fromJson(Map<String, dynamic> json) => _$OwnerDashboardModelFromJson(json);

 final  List<TeamMemberStatusModel> _teamMembersStatus;
@override List<TeamMemberStatusModel> get teamMembersStatus {
  if (_teamMembersStatus is EqualUnmodifiableListView) return _teamMembersStatus;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_teamMembersStatus);
}

@override final  OwnerDashboardModelStats jobCounts;
 final  List<JobModel> _recentJobs;
@override List<JobModel> get recentJobs {
  if (_recentJobs is EqualUnmodifiableListView) return _recentJobs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentJobs);
}


/// Create a copy of OwnerDashboardModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OwnerDashboardModelCopyWith<_OwnerDashboardModel> get copyWith => __$OwnerDashboardModelCopyWithImpl<_OwnerDashboardModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OwnerDashboardModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OwnerDashboardModel&&const DeepCollectionEquality().equals(other._teamMembersStatus, _teamMembersStatus)&&(identical(other.jobCounts, jobCounts) || other.jobCounts == jobCounts)&&const DeepCollectionEquality().equals(other._recentJobs, _recentJobs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_teamMembersStatus),jobCounts,const DeepCollectionEquality().hash(_recentJobs));

@override
String toString() {
  return 'OwnerDashboardModel(teamMembersStatus: $teamMembersStatus, jobCounts: $jobCounts, recentJobs: $recentJobs)';
}


}

/// @nodoc
abstract mixin class _$OwnerDashboardModelCopyWith<$Res> implements $OwnerDashboardModelCopyWith<$Res> {
  factory _$OwnerDashboardModelCopyWith(_OwnerDashboardModel value, $Res Function(_OwnerDashboardModel) _then) = __$OwnerDashboardModelCopyWithImpl;
@override @useResult
$Res call({
 List<TeamMemberStatusModel> teamMembersStatus, OwnerDashboardModelStats jobCounts, List<JobModel> recentJobs
});


@override $OwnerDashboardModelStatsCopyWith<$Res> get jobCounts;

}
/// @nodoc
class __$OwnerDashboardModelCopyWithImpl<$Res>
    implements _$OwnerDashboardModelCopyWith<$Res> {
  __$OwnerDashboardModelCopyWithImpl(this._self, this._then);

  final _OwnerDashboardModel _self;
  final $Res Function(_OwnerDashboardModel) _then;

/// Create a copy of OwnerDashboardModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? teamMembersStatus = null,Object? jobCounts = null,Object? recentJobs = null,}) {
  return _then(_OwnerDashboardModel(
teamMembersStatus: null == teamMembersStatus ? _self._teamMembersStatus : teamMembersStatus // ignore: cast_nullable_to_non_nullable
as List<TeamMemberStatusModel>,jobCounts: null == jobCounts ? _self.jobCounts : jobCounts // ignore: cast_nullable_to_non_nullable
as OwnerDashboardModelStats,recentJobs: null == recentJobs ? _self._recentJobs : recentJobs // ignore: cast_nullable_to_non_nullable
as List<JobModel>,
  ));
}

/// Create a copy of OwnerDashboardModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwnerDashboardModelStatsCopyWith<$Res> get jobCounts {
  
  return $OwnerDashboardModelStatsCopyWith<$Res>(_self.jobCounts, (value) {
    return _then(_self.copyWith(jobCounts: value));
  });
}
}


/// @nodoc
mixin _$OwnerDashboardModelStats {

 JobSummaryStatsModel get todayStats; JobSummaryStatsModel get overallStats;
/// Create a copy of OwnerDashboardModelStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OwnerDashboardModelStatsCopyWith<OwnerDashboardModelStats> get copyWith => _$OwnerDashboardModelStatsCopyWithImpl<OwnerDashboardModelStats>(this as OwnerDashboardModelStats, _$identity);

  /// Serializes this OwnerDashboardModelStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OwnerDashboardModelStats&&(identical(other.todayStats, todayStats) || other.todayStats == todayStats)&&(identical(other.overallStats, overallStats) || other.overallStats == overallStats));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,todayStats,overallStats);

@override
String toString() {
  return 'OwnerDashboardModelStats(todayStats: $todayStats, overallStats: $overallStats)';
}


}

/// @nodoc
abstract mixin class $OwnerDashboardModelStatsCopyWith<$Res>  {
  factory $OwnerDashboardModelStatsCopyWith(OwnerDashboardModelStats value, $Res Function(OwnerDashboardModelStats) _then) = _$OwnerDashboardModelStatsCopyWithImpl;
@useResult
$Res call({
 JobSummaryStatsModel todayStats, JobSummaryStatsModel overallStats
});


$JobSummaryStatsModelCopyWith<$Res> get todayStats;$JobSummaryStatsModelCopyWith<$Res> get overallStats;

}
/// @nodoc
class _$OwnerDashboardModelStatsCopyWithImpl<$Res>
    implements $OwnerDashboardModelStatsCopyWith<$Res> {
  _$OwnerDashboardModelStatsCopyWithImpl(this._self, this._then);

  final OwnerDashboardModelStats _self;
  final $Res Function(OwnerDashboardModelStats) _then;

/// Create a copy of OwnerDashboardModelStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? todayStats = null,Object? overallStats = null,}) {
  return _then(_self.copyWith(
todayStats: null == todayStats ? _self.todayStats : todayStats // ignore: cast_nullable_to_non_nullable
as JobSummaryStatsModel,overallStats: null == overallStats ? _self.overallStats : overallStats // ignore: cast_nullable_to_non_nullable
as JobSummaryStatsModel,
  ));
}
/// Create a copy of OwnerDashboardModelStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JobSummaryStatsModelCopyWith<$Res> get todayStats {
  
  return $JobSummaryStatsModelCopyWith<$Res>(_self.todayStats, (value) {
    return _then(_self.copyWith(todayStats: value));
  });
}/// Create a copy of OwnerDashboardModelStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JobSummaryStatsModelCopyWith<$Res> get overallStats {
  
  return $JobSummaryStatsModelCopyWith<$Res>(_self.overallStats, (value) {
    return _then(_self.copyWith(overallStats: value));
  });
}
}


/// Adds pattern-matching-related methods to [OwnerDashboardModelStats].
extension OwnerDashboardModelStatsPatterns on OwnerDashboardModelStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OwnerDashboardModelStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OwnerDashboardModelStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OwnerDashboardModelStats value)  $default,){
final _that = this;
switch (_that) {
case _OwnerDashboardModelStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OwnerDashboardModelStats value)?  $default,){
final _that = this;
switch (_that) {
case _OwnerDashboardModelStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( JobSummaryStatsModel todayStats,  JobSummaryStatsModel overallStats)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OwnerDashboardModelStats() when $default != null:
return $default(_that.todayStats,_that.overallStats);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( JobSummaryStatsModel todayStats,  JobSummaryStatsModel overallStats)  $default,) {final _that = this;
switch (_that) {
case _OwnerDashboardModelStats():
return $default(_that.todayStats,_that.overallStats);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( JobSummaryStatsModel todayStats,  JobSummaryStatsModel overallStats)?  $default,) {final _that = this;
switch (_that) {
case _OwnerDashboardModelStats() when $default != null:
return $default(_that.todayStats,_that.overallStats);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OwnerDashboardModelStats extends OwnerDashboardModelStats {
  const _OwnerDashboardModelStats({required this.todayStats, required this.overallStats}): super._();
  factory _OwnerDashboardModelStats.fromJson(Map<String, dynamic> json) => _$OwnerDashboardModelStatsFromJson(json);

@override final  JobSummaryStatsModel todayStats;
@override final  JobSummaryStatsModel overallStats;

/// Create a copy of OwnerDashboardModelStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OwnerDashboardModelStatsCopyWith<_OwnerDashboardModelStats> get copyWith => __$OwnerDashboardModelStatsCopyWithImpl<_OwnerDashboardModelStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OwnerDashboardModelStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OwnerDashboardModelStats&&(identical(other.todayStats, todayStats) || other.todayStats == todayStats)&&(identical(other.overallStats, overallStats) || other.overallStats == overallStats));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,todayStats,overallStats);

@override
String toString() {
  return 'OwnerDashboardModelStats(todayStats: $todayStats, overallStats: $overallStats)';
}


}

/// @nodoc
abstract mixin class _$OwnerDashboardModelStatsCopyWith<$Res> implements $OwnerDashboardModelStatsCopyWith<$Res> {
  factory _$OwnerDashboardModelStatsCopyWith(_OwnerDashboardModelStats value, $Res Function(_OwnerDashboardModelStats) _then) = __$OwnerDashboardModelStatsCopyWithImpl;
@override @useResult
$Res call({
 JobSummaryStatsModel todayStats, JobSummaryStatsModel overallStats
});


@override $JobSummaryStatsModelCopyWith<$Res> get todayStats;@override $JobSummaryStatsModelCopyWith<$Res> get overallStats;

}
/// @nodoc
class __$OwnerDashboardModelStatsCopyWithImpl<$Res>
    implements _$OwnerDashboardModelStatsCopyWith<$Res> {
  __$OwnerDashboardModelStatsCopyWithImpl(this._self, this._then);

  final _OwnerDashboardModelStats _self;
  final $Res Function(_OwnerDashboardModelStats) _then;

/// Create a copy of OwnerDashboardModelStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? todayStats = null,Object? overallStats = null,}) {
  return _then(_OwnerDashboardModelStats(
todayStats: null == todayStats ? _self.todayStats : todayStats // ignore: cast_nullable_to_non_nullable
as JobSummaryStatsModel,overallStats: null == overallStats ? _self.overallStats : overallStats // ignore: cast_nullable_to_non_nullable
as JobSummaryStatsModel,
  ));
}

/// Create a copy of OwnerDashboardModelStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JobSummaryStatsModelCopyWith<$Res> get todayStats {
  
  return $JobSummaryStatsModelCopyWith<$Res>(_self.todayStats, (value) {
    return _then(_self.copyWith(todayStats: value));
  });
}/// Create a copy of OwnerDashboardModelStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JobSummaryStatsModelCopyWith<$Res> get overallStats {
  
  return $JobSummaryStatsModelCopyWith<$Res>(_self.overallStats, (value) {
    return _then(_self.copyWith(overallStats: value));
  });
}
}

// dart format on
