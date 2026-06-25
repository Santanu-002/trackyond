// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_summary_stats_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JobSummaryStatsModel {

 int get pending; int get inProgress; int get completed; int get cancelled; int get completedToday; int get totalAssigned;
/// Create a copy of JobSummaryStatsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobSummaryStatsModelCopyWith<JobSummaryStatsModel> get copyWith => _$JobSummaryStatsModelCopyWithImpl<JobSummaryStatsModel>(this as JobSummaryStatsModel, _$identity);

  /// Serializes this JobSummaryStatsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobSummaryStatsModel&&super == other&&(identical(other.pending, pending) || other.pending == pending)&&(identical(other.inProgress, inProgress) || other.inProgress == inProgress)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.cancelled, cancelled) || other.cancelled == cancelled)&&(identical(other.completedToday, completedToday) || other.completedToday == completedToday)&&(identical(other.totalAssigned, totalAssigned) || other.totalAssigned == totalAssigned));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,super.hashCode,pending,inProgress,completed,cancelled,completedToday,totalAssigned);



}

/// @nodoc
abstract mixin class $JobSummaryStatsModelCopyWith<$Res>  {
  factory $JobSummaryStatsModelCopyWith(JobSummaryStatsModel value, $Res Function(JobSummaryStatsModel) _then) = _$JobSummaryStatsModelCopyWithImpl;
@useResult
$Res call({
 int pending, int inProgress, int completed, int cancelled, int completedToday, int totalAssigned
});




}
/// @nodoc
class _$JobSummaryStatsModelCopyWithImpl<$Res>
    implements $JobSummaryStatsModelCopyWith<$Res> {
  _$JobSummaryStatsModelCopyWithImpl(this._self, this._then);

  final JobSummaryStatsModel _self;
  final $Res Function(JobSummaryStatsModel) _then;

/// Create a copy of JobSummaryStatsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pending = null,Object? inProgress = null,Object? completed = null,Object? cancelled = null,Object? completedToday = null,Object? totalAssigned = null,}) {
  return _then(_self.copyWith(
pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as int,inProgress: null == inProgress ? _self.inProgress : inProgress // ignore: cast_nullable_to_non_nullable
as int,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as int,cancelled: null == cancelled ? _self.cancelled : cancelled // ignore: cast_nullable_to_non_nullable
as int,completedToday: null == completedToday ? _self.completedToday : completedToday // ignore: cast_nullable_to_non_nullable
as int,totalAssigned: null == totalAssigned ? _self.totalAssigned : totalAssigned // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [JobSummaryStatsModel].
extension JobSummaryStatsModelPatterns on JobSummaryStatsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobSummaryStatsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobSummaryStatsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobSummaryStatsModel value)  $default,){
final _that = this;
switch (_that) {
case _JobSummaryStatsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobSummaryStatsModel value)?  $default,){
final _that = this;
switch (_that) {
case _JobSummaryStatsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int pending,  int inProgress,  int completed,  int cancelled,  int completedToday,  int totalAssigned)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobSummaryStatsModel() when $default != null:
return $default(_that.pending,_that.inProgress,_that.completed,_that.cancelled,_that.completedToday,_that.totalAssigned);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int pending,  int inProgress,  int completed,  int cancelled,  int completedToday,  int totalAssigned)  $default,) {final _that = this;
switch (_that) {
case _JobSummaryStatsModel():
return $default(_that.pending,_that.inProgress,_that.completed,_that.cancelled,_that.completedToday,_that.totalAssigned);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int pending,  int inProgress,  int completed,  int cancelled,  int completedToday,  int totalAssigned)?  $default,) {final _that = this;
switch (_that) {
case _JobSummaryStatsModel() when $default != null:
return $default(_that.pending,_that.inProgress,_that.completed,_that.cancelled,_that.completedToday,_that.totalAssigned);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JobSummaryStatsModel extends JobSummaryStatsModel {
  const _JobSummaryStatsModel({this.pending = 0, this.inProgress = 0, this.completed = 0, this.cancelled = 0, this.completedToday = 0, this.totalAssigned = 0}): super._();
  factory _JobSummaryStatsModel.fromJson(Map<String, dynamic> json) => _$JobSummaryStatsModelFromJson(json);

@override@JsonKey() final  int pending;
@override@JsonKey() final  int inProgress;
@override@JsonKey() final  int completed;
@override@JsonKey() final  int cancelled;
@override@JsonKey() final  int completedToday;
@override@JsonKey() final  int totalAssigned;

/// Create a copy of JobSummaryStatsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobSummaryStatsModelCopyWith<_JobSummaryStatsModel> get copyWith => __$JobSummaryStatsModelCopyWithImpl<_JobSummaryStatsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JobSummaryStatsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobSummaryStatsModel&&super == other&&(identical(other.pending, pending) || other.pending == pending)&&(identical(other.inProgress, inProgress) || other.inProgress == inProgress)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.cancelled, cancelled) || other.cancelled == cancelled)&&(identical(other.completedToday, completedToday) || other.completedToday == completedToday)&&(identical(other.totalAssigned, totalAssigned) || other.totalAssigned == totalAssigned));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,super.hashCode,pending,inProgress,completed,cancelled,completedToday,totalAssigned);



}

/// @nodoc
abstract mixin class _$JobSummaryStatsModelCopyWith<$Res> implements $JobSummaryStatsModelCopyWith<$Res> {
  factory _$JobSummaryStatsModelCopyWith(_JobSummaryStatsModel value, $Res Function(_JobSummaryStatsModel) _then) = __$JobSummaryStatsModelCopyWithImpl;
@override @useResult
$Res call({
 int pending, int inProgress, int completed, int cancelled, int completedToday, int totalAssigned
});




}
/// @nodoc
class __$JobSummaryStatsModelCopyWithImpl<$Res>
    implements _$JobSummaryStatsModelCopyWith<$Res> {
  __$JobSummaryStatsModelCopyWithImpl(this._self, this._then);

  final _JobSummaryStatsModel _self;
  final $Res Function(_JobSummaryStatsModel) _then;

/// Create a copy of JobSummaryStatsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pending = null,Object? inProgress = null,Object? completed = null,Object? cancelled = null,Object? completedToday = null,Object? totalAssigned = null,}) {
  return _then(_JobSummaryStatsModel(
pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as int,inProgress: null == inProgress ? _self.inProgress : inProgress // ignore: cast_nullable_to_non_nullable
as int,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as int,cancelled: null == cancelled ? _self.cancelled : cancelled // ignore: cast_nullable_to_non_nullable
as int,completedToday: null == completedToday ? _self.completedToday : completedToday // ignore: cast_nullable_to_non_nullable
as int,totalAssigned: null == totalAssigned ? _self.totalAssigned : totalAssigned // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
