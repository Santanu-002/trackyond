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

 List<TeamMemberStatusModel> get teamMembersStatus; JobCountsModel get jobCounts; List<JobModel> get recentJobs;
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
 List<TeamMemberStatusModel> teamMembersStatus, JobCountsModel jobCounts, List<JobModel> recentJobs
});


$JobCountsModelCopyWith<$Res> get jobCounts;

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
as JobCountsModel,recentJobs: null == recentJobs ? _self.recentJobs : recentJobs // ignore: cast_nullable_to_non_nullable
as List<JobModel>,
  ));
}
/// Create a copy of OwnerDashboardModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JobCountsModelCopyWith<$Res> get jobCounts {
  
  return $JobCountsModelCopyWith<$Res>(_self.jobCounts, (value) {
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TeamMemberStatusModel> teamMembersStatus,  JobCountsModel jobCounts,  List<JobModel> recentJobs)?  $default,{required TResult orElse(),}) {final _that = this;
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TeamMemberStatusModel> teamMembersStatus,  JobCountsModel jobCounts,  List<JobModel> recentJobs)  $default,) {final _that = this;
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TeamMemberStatusModel> teamMembersStatus,  JobCountsModel jobCounts,  List<JobModel> recentJobs)?  $default,) {final _that = this;
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

@override final  JobCountsModel jobCounts;
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
 List<TeamMemberStatusModel> teamMembersStatus, JobCountsModel jobCounts, List<JobModel> recentJobs
});


@override $JobCountsModelCopyWith<$Res> get jobCounts;

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
as JobCountsModel,recentJobs: null == recentJobs ? _self._recentJobs : recentJobs // ignore: cast_nullable_to_non_nullable
as List<JobModel>,
  ));
}

/// Create a copy of OwnerDashboardModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JobCountsModelCopyWith<$Res> get jobCounts {
  
  return $JobCountsModelCopyWith<$Res>(_self.jobCounts, (value) {
    return _then(_self.copyWith(jobCounts: value));
  });
}
}


/// @nodoc
mixin _$JobCountsModel {

 int get pending; int get inProgress; int get completed; int get cancelled;
/// Create a copy of JobCountsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobCountsModelCopyWith<JobCountsModel> get copyWith => _$JobCountsModelCopyWithImpl<JobCountsModel>(this as JobCountsModel, _$identity);

  /// Serializes this JobCountsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobCountsModel&&(identical(other.pending, pending) || other.pending == pending)&&(identical(other.inProgress, inProgress) || other.inProgress == inProgress)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.cancelled, cancelled) || other.cancelled == cancelled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pending,inProgress,completed,cancelled);

@override
String toString() {
  return 'JobCountsModel(pending: $pending, inProgress: $inProgress, completed: $completed, cancelled: $cancelled)';
}


}

/// @nodoc
abstract mixin class $JobCountsModelCopyWith<$Res>  {
  factory $JobCountsModelCopyWith(JobCountsModel value, $Res Function(JobCountsModel) _then) = _$JobCountsModelCopyWithImpl;
@useResult
$Res call({
 int pending, int inProgress, int completed, int cancelled
});




}
/// @nodoc
class _$JobCountsModelCopyWithImpl<$Res>
    implements $JobCountsModelCopyWith<$Res> {
  _$JobCountsModelCopyWithImpl(this._self, this._then);

  final JobCountsModel _self;
  final $Res Function(JobCountsModel) _then;

/// Create a copy of JobCountsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pending = null,Object? inProgress = null,Object? completed = null,Object? cancelled = null,}) {
  return _then(_self.copyWith(
pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as int,inProgress: null == inProgress ? _self.inProgress : inProgress // ignore: cast_nullable_to_non_nullable
as int,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as int,cancelled: null == cancelled ? _self.cancelled : cancelled // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [JobCountsModel].
extension JobCountsModelPatterns on JobCountsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobCountsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobCountsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobCountsModel value)  $default,){
final _that = this;
switch (_that) {
case _JobCountsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobCountsModel value)?  $default,){
final _that = this;
switch (_that) {
case _JobCountsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int pending,  int inProgress,  int completed,  int cancelled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobCountsModel() when $default != null:
return $default(_that.pending,_that.inProgress,_that.completed,_that.cancelled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int pending,  int inProgress,  int completed,  int cancelled)  $default,) {final _that = this;
switch (_that) {
case _JobCountsModel():
return $default(_that.pending,_that.inProgress,_that.completed,_that.cancelled);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int pending,  int inProgress,  int completed,  int cancelled)?  $default,) {final _that = this;
switch (_that) {
case _JobCountsModel() when $default != null:
return $default(_that.pending,_that.inProgress,_that.completed,_that.cancelled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JobCountsModel extends JobCountsModel {
  const _JobCountsModel({this.pending = 0, this.inProgress = 0, this.completed = 0, this.cancelled = 0}): super._();
  factory _JobCountsModel.fromJson(Map<String, dynamic> json) => _$JobCountsModelFromJson(json);

@override@JsonKey() final  int pending;
@override@JsonKey() final  int inProgress;
@override@JsonKey() final  int completed;
@override@JsonKey() final  int cancelled;

/// Create a copy of JobCountsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobCountsModelCopyWith<_JobCountsModel> get copyWith => __$JobCountsModelCopyWithImpl<_JobCountsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JobCountsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobCountsModel&&(identical(other.pending, pending) || other.pending == pending)&&(identical(other.inProgress, inProgress) || other.inProgress == inProgress)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.cancelled, cancelled) || other.cancelled == cancelled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pending,inProgress,completed,cancelled);

@override
String toString() {
  return 'JobCountsModel(pending: $pending, inProgress: $inProgress, completed: $completed, cancelled: $cancelled)';
}


}

/// @nodoc
abstract mixin class _$JobCountsModelCopyWith<$Res> implements $JobCountsModelCopyWith<$Res> {
  factory _$JobCountsModelCopyWith(_JobCountsModel value, $Res Function(_JobCountsModel) _then) = __$JobCountsModelCopyWithImpl;
@override @useResult
$Res call({
 int pending, int inProgress, int completed, int cancelled
});




}
/// @nodoc
class __$JobCountsModelCopyWithImpl<$Res>
    implements _$JobCountsModelCopyWith<$Res> {
  __$JobCountsModelCopyWithImpl(this._self, this._then);

  final _JobCountsModel _self;
  final $Res Function(_JobCountsModel) _then;

/// Create a copy of JobCountsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pending = null,Object? inProgress = null,Object? completed = null,Object? cancelled = null,}) {
  return _then(_JobCountsModel(
pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as int,inProgress: null == inProgress ? _self.inProgress : inProgress // ignore: cast_nullable_to_non_nullable
as int,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as int,cancelled: null == cancelled ? _self.cancelled : cancelled // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
