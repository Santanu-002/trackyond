// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'worker_dashboard_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkerDashboardModel {

 AttendanceStatusModel get attendanceStatus; List<JobModel> get recentJobs; WorkerDashboardModelStats get jobCounts;
/// Create a copy of WorkerDashboardModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkerDashboardModelCopyWith<WorkerDashboardModel> get copyWith => _$WorkerDashboardModelCopyWithImpl<WorkerDashboardModel>(this as WorkerDashboardModel, _$identity);

  /// Serializes this WorkerDashboardModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkerDashboardModel&&(identical(other.attendanceStatus, attendanceStatus) || other.attendanceStatus == attendanceStatus)&&const DeepCollectionEquality().equals(other.recentJobs, recentJobs)&&(identical(other.jobCounts, jobCounts) || other.jobCounts == jobCounts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,attendanceStatus,const DeepCollectionEquality().hash(recentJobs),jobCounts);

@override
String toString() {
  return 'WorkerDashboardModel(attendanceStatus: $attendanceStatus, recentJobs: $recentJobs, jobCounts: $jobCounts)';
}


}

/// @nodoc
abstract mixin class $WorkerDashboardModelCopyWith<$Res>  {
  factory $WorkerDashboardModelCopyWith(WorkerDashboardModel value, $Res Function(WorkerDashboardModel) _then) = _$WorkerDashboardModelCopyWithImpl;
@useResult
$Res call({
 AttendanceStatusModel attendanceStatus, List<JobModel> recentJobs, WorkerDashboardModelStats jobCounts
});


$AttendanceStatusModelCopyWith<$Res> get attendanceStatus;$WorkerDashboardModelStatsCopyWith<$Res> get jobCounts;

}
/// @nodoc
class _$WorkerDashboardModelCopyWithImpl<$Res>
    implements $WorkerDashboardModelCopyWith<$Res> {
  _$WorkerDashboardModelCopyWithImpl(this._self, this._then);

  final WorkerDashboardModel _self;
  final $Res Function(WorkerDashboardModel) _then;

/// Create a copy of WorkerDashboardModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? attendanceStatus = null,Object? recentJobs = null,Object? jobCounts = null,}) {
  return _then(_self.copyWith(
attendanceStatus: null == attendanceStatus ? _self.attendanceStatus : attendanceStatus // ignore: cast_nullable_to_non_nullable
as AttendanceStatusModel,recentJobs: null == recentJobs ? _self.recentJobs : recentJobs // ignore: cast_nullable_to_non_nullable
as List<JobModel>,jobCounts: null == jobCounts ? _self.jobCounts : jobCounts // ignore: cast_nullable_to_non_nullable
as WorkerDashboardModelStats,
  ));
}
/// Create a copy of WorkerDashboardModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttendanceStatusModelCopyWith<$Res> get attendanceStatus {
  
  return $AttendanceStatusModelCopyWith<$Res>(_self.attendanceStatus, (value) {
    return _then(_self.copyWith(attendanceStatus: value));
  });
}/// Create a copy of WorkerDashboardModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkerDashboardModelStatsCopyWith<$Res> get jobCounts {
  
  return $WorkerDashboardModelStatsCopyWith<$Res>(_self.jobCounts, (value) {
    return _then(_self.copyWith(jobCounts: value));
  });
}
}


/// Adds pattern-matching-related methods to [WorkerDashboardModel].
extension WorkerDashboardModelPatterns on WorkerDashboardModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkerDashboardModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkerDashboardModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkerDashboardModel value)  $default,){
final _that = this;
switch (_that) {
case _WorkerDashboardModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkerDashboardModel value)?  $default,){
final _that = this;
switch (_that) {
case _WorkerDashboardModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AttendanceStatusModel attendanceStatus,  List<JobModel> recentJobs,  WorkerDashboardModelStats jobCounts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkerDashboardModel() when $default != null:
return $default(_that.attendanceStatus,_that.recentJobs,_that.jobCounts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AttendanceStatusModel attendanceStatus,  List<JobModel> recentJobs,  WorkerDashboardModelStats jobCounts)  $default,) {final _that = this;
switch (_that) {
case _WorkerDashboardModel():
return $default(_that.attendanceStatus,_that.recentJobs,_that.jobCounts);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AttendanceStatusModel attendanceStatus,  List<JobModel> recentJobs,  WorkerDashboardModelStats jobCounts)?  $default,) {final _that = this;
switch (_that) {
case _WorkerDashboardModel() when $default != null:
return $default(_that.attendanceStatus,_that.recentJobs,_that.jobCounts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkerDashboardModel extends WorkerDashboardModel {
  const _WorkerDashboardModel({required this.attendanceStatus, required final  List<JobModel> recentJobs, required this.jobCounts}): _recentJobs = recentJobs,super._();
  factory _WorkerDashboardModel.fromJson(Map<String, dynamic> json) => _$WorkerDashboardModelFromJson(json);

@override final  AttendanceStatusModel attendanceStatus;
 final  List<JobModel> _recentJobs;
@override List<JobModel> get recentJobs {
  if (_recentJobs is EqualUnmodifiableListView) return _recentJobs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentJobs);
}

@override final  WorkerDashboardModelStats jobCounts;

/// Create a copy of WorkerDashboardModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkerDashboardModelCopyWith<_WorkerDashboardModel> get copyWith => __$WorkerDashboardModelCopyWithImpl<_WorkerDashboardModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkerDashboardModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkerDashboardModel&&(identical(other.attendanceStatus, attendanceStatus) || other.attendanceStatus == attendanceStatus)&&const DeepCollectionEquality().equals(other._recentJobs, _recentJobs)&&(identical(other.jobCounts, jobCounts) || other.jobCounts == jobCounts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,attendanceStatus,const DeepCollectionEquality().hash(_recentJobs),jobCounts);

@override
String toString() {
  return 'WorkerDashboardModel(attendanceStatus: $attendanceStatus, recentJobs: $recentJobs, jobCounts: $jobCounts)';
}


}

/// @nodoc
abstract mixin class _$WorkerDashboardModelCopyWith<$Res> implements $WorkerDashboardModelCopyWith<$Res> {
  factory _$WorkerDashboardModelCopyWith(_WorkerDashboardModel value, $Res Function(_WorkerDashboardModel) _then) = __$WorkerDashboardModelCopyWithImpl;
@override @useResult
$Res call({
 AttendanceStatusModel attendanceStatus, List<JobModel> recentJobs, WorkerDashboardModelStats jobCounts
});


@override $AttendanceStatusModelCopyWith<$Res> get attendanceStatus;@override $WorkerDashboardModelStatsCopyWith<$Res> get jobCounts;

}
/// @nodoc
class __$WorkerDashboardModelCopyWithImpl<$Res>
    implements _$WorkerDashboardModelCopyWith<$Res> {
  __$WorkerDashboardModelCopyWithImpl(this._self, this._then);

  final _WorkerDashboardModel _self;
  final $Res Function(_WorkerDashboardModel) _then;

/// Create a copy of WorkerDashboardModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? attendanceStatus = null,Object? recentJobs = null,Object? jobCounts = null,}) {
  return _then(_WorkerDashboardModel(
attendanceStatus: null == attendanceStatus ? _self.attendanceStatus : attendanceStatus // ignore: cast_nullable_to_non_nullable
as AttendanceStatusModel,recentJobs: null == recentJobs ? _self._recentJobs : recentJobs // ignore: cast_nullable_to_non_nullable
as List<JobModel>,jobCounts: null == jobCounts ? _self.jobCounts : jobCounts // ignore: cast_nullable_to_non_nullable
as WorkerDashboardModelStats,
  ));
}

/// Create a copy of WorkerDashboardModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttendanceStatusModelCopyWith<$Res> get attendanceStatus {
  
  return $AttendanceStatusModelCopyWith<$Res>(_self.attendanceStatus, (value) {
    return _then(_self.copyWith(attendanceStatus: value));
  });
}/// Create a copy of WorkerDashboardModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkerDashboardModelStatsCopyWith<$Res> get jobCounts {
  
  return $WorkerDashboardModelStatsCopyWith<$Res>(_self.jobCounts, (value) {
    return _then(_self.copyWith(jobCounts: value));
  });
}
}


/// @nodoc
mixin _$WorkerDashboardModelStats {

 JobSummaryStatsModel get todayStats; JobSummaryStatsModel get overallStats;
/// Create a copy of WorkerDashboardModelStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkerDashboardModelStatsCopyWith<WorkerDashboardModelStats> get copyWith => _$WorkerDashboardModelStatsCopyWithImpl<WorkerDashboardModelStats>(this as WorkerDashboardModelStats, _$identity);

  /// Serializes this WorkerDashboardModelStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkerDashboardModelStats&&(identical(other.todayStats, todayStats) || other.todayStats == todayStats)&&(identical(other.overallStats, overallStats) || other.overallStats == overallStats));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,todayStats,overallStats);

@override
String toString() {
  return 'WorkerDashboardModelStats(todayStats: $todayStats, overallStats: $overallStats)';
}


}

/// @nodoc
abstract mixin class $WorkerDashboardModelStatsCopyWith<$Res>  {
  factory $WorkerDashboardModelStatsCopyWith(WorkerDashboardModelStats value, $Res Function(WorkerDashboardModelStats) _then) = _$WorkerDashboardModelStatsCopyWithImpl;
@useResult
$Res call({
 JobSummaryStatsModel todayStats, JobSummaryStatsModel overallStats
});


$JobSummaryStatsModelCopyWith<$Res> get todayStats;$JobSummaryStatsModelCopyWith<$Res> get overallStats;

}
/// @nodoc
class _$WorkerDashboardModelStatsCopyWithImpl<$Res>
    implements $WorkerDashboardModelStatsCopyWith<$Res> {
  _$WorkerDashboardModelStatsCopyWithImpl(this._self, this._then);

  final WorkerDashboardModelStats _self;
  final $Res Function(WorkerDashboardModelStats) _then;

/// Create a copy of WorkerDashboardModelStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? todayStats = null,Object? overallStats = null,}) {
  return _then(_self.copyWith(
todayStats: null == todayStats ? _self.todayStats : todayStats // ignore: cast_nullable_to_non_nullable
as JobSummaryStatsModel,overallStats: null == overallStats ? _self.overallStats : overallStats // ignore: cast_nullable_to_non_nullable
as JobSummaryStatsModel,
  ));
}
/// Create a copy of WorkerDashboardModelStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JobSummaryStatsModelCopyWith<$Res> get todayStats {
  
  return $JobSummaryStatsModelCopyWith<$Res>(_self.todayStats, (value) {
    return _then(_self.copyWith(todayStats: value));
  });
}/// Create a copy of WorkerDashboardModelStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JobSummaryStatsModelCopyWith<$Res> get overallStats {
  
  return $JobSummaryStatsModelCopyWith<$Res>(_self.overallStats, (value) {
    return _then(_self.copyWith(overallStats: value));
  });
}
}


/// Adds pattern-matching-related methods to [WorkerDashboardModelStats].
extension WorkerDashboardModelStatsPatterns on WorkerDashboardModelStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkerDashboardModelStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkerDashboardModelStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkerDashboardModelStats value)  $default,){
final _that = this;
switch (_that) {
case _WorkerDashboardModelStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkerDashboardModelStats value)?  $default,){
final _that = this;
switch (_that) {
case _WorkerDashboardModelStats() when $default != null:
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
case _WorkerDashboardModelStats() when $default != null:
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
case _WorkerDashboardModelStats():
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
case _WorkerDashboardModelStats() when $default != null:
return $default(_that.todayStats,_that.overallStats);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkerDashboardModelStats extends WorkerDashboardModelStats {
  const _WorkerDashboardModelStats({required this.todayStats, required this.overallStats}): super._();
  factory _WorkerDashboardModelStats.fromJson(Map<String, dynamic> json) => _$WorkerDashboardModelStatsFromJson(json);

@override final  JobSummaryStatsModel todayStats;
@override final  JobSummaryStatsModel overallStats;

/// Create a copy of WorkerDashboardModelStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkerDashboardModelStatsCopyWith<_WorkerDashboardModelStats> get copyWith => __$WorkerDashboardModelStatsCopyWithImpl<_WorkerDashboardModelStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkerDashboardModelStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkerDashboardModelStats&&(identical(other.todayStats, todayStats) || other.todayStats == todayStats)&&(identical(other.overallStats, overallStats) || other.overallStats == overallStats));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,todayStats,overallStats);

@override
String toString() {
  return 'WorkerDashboardModelStats(todayStats: $todayStats, overallStats: $overallStats)';
}


}

/// @nodoc
abstract mixin class _$WorkerDashboardModelStatsCopyWith<$Res> implements $WorkerDashboardModelStatsCopyWith<$Res> {
  factory _$WorkerDashboardModelStatsCopyWith(_WorkerDashboardModelStats value, $Res Function(_WorkerDashboardModelStats) _then) = __$WorkerDashboardModelStatsCopyWithImpl;
@override @useResult
$Res call({
 JobSummaryStatsModel todayStats, JobSummaryStatsModel overallStats
});


@override $JobSummaryStatsModelCopyWith<$Res> get todayStats;@override $JobSummaryStatsModelCopyWith<$Res> get overallStats;

}
/// @nodoc
class __$WorkerDashboardModelStatsCopyWithImpl<$Res>
    implements _$WorkerDashboardModelStatsCopyWith<$Res> {
  __$WorkerDashboardModelStatsCopyWithImpl(this._self, this._then);

  final _WorkerDashboardModelStats _self;
  final $Res Function(_WorkerDashboardModelStats) _then;

/// Create a copy of WorkerDashboardModelStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? todayStats = null,Object? overallStats = null,}) {
  return _then(_WorkerDashboardModelStats(
todayStats: null == todayStats ? _self.todayStats : todayStats // ignore: cast_nullable_to_non_nullable
as JobSummaryStatsModel,overallStats: null == overallStats ? _self.overallStats : overallStats // ignore: cast_nullable_to_non_nullable
as JobSummaryStatsModel,
  ));
}

/// Create a copy of WorkerDashboardModelStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JobSummaryStatsModelCopyWith<$Res> get todayStats {
  
  return $JobSummaryStatsModelCopyWith<$Res>(_self.todayStats, (value) {
    return _then(_self.copyWith(todayStats: value));
  });
}/// Create a copy of WorkerDashboardModelStats
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
