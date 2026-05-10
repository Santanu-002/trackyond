// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_status_stats_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TeamStatusStatsModel {

 int get total; int get working; int get notStarted;
/// Create a copy of TeamStatusStatsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeamStatusStatsModelCopyWith<TeamStatusStatsModel> get copyWith => _$TeamStatusStatsModelCopyWithImpl<TeamStatusStatsModel>(this as TeamStatusStatsModel, _$identity);

  /// Serializes this TeamStatusStatsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeamStatusStatsModel&&(identical(other.total, total) || other.total == total)&&(identical(other.working, working) || other.working == working)&&(identical(other.notStarted, notStarted) || other.notStarted == notStarted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,working,notStarted);

@override
String toString() {
  return 'TeamStatusStatsModel(total: $total, working: $working, notStarted: $notStarted)';
}


}

/// @nodoc
abstract mixin class $TeamStatusStatsModelCopyWith<$Res>  {
  factory $TeamStatusStatsModelCopyWith(TeamStatusStatsModel value, $Res Function(TeamStatusStatsModel) _then) = _$TeamStatusStatsModelCopyWithImpl;
@useResult
$Res call({
 int total, int working, int notStarted
});




}
/// @nodoc
class _$TeamStatusStatsModelCopyWithImpl<$Res>
    implements $TeamStatusStatsModelCopyWith<$Res> {
  _$TeamStatusStatsModelCopyWithImpl(this._self, this._then);

  final TeamStatusStatsModel _self;
  final $Res Function(TeamStatusStatsModel) _then;

/// Create a copy of TeamStatusStatsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? working = null,Object? notStarted = null,}) {
  return _then(_self.copyWith(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,working: null == working ? _self.working : working // ignore: cast_nullable_to_non_nullable
as int,notStarted: null == notStarted ? _self.notStarted : notStarted // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TeamStatusStatsModel].
extension TeamStatusStatsModelPatterns on TeamStatusStatsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeamStatusStatsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeamStatusStatsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeamStatusStatsModel value)  $default,){
final _that = this;
switch (_that) {
case _TeamStatusStatsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeamStatusStatsModel value)?  $default,){
final _that = this;
switch (_that) {
case _TeamStatusStatsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int total,  int working,  int notStarted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeamStatusStatsModel() when $default != null:
return $default(_that.total,_that.working,_that.notStarted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int total,  int working,  int notStarted)  $default,) {final _that = this;
switch (_that) {
case _TeamStatusStatsModel():
return $default(_that.total,_that.working,_that.notStarted);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int total,  int working,  int notStarted)?  $default,) {final _that = this;
switch (_that) {
case _TeamStatusStatsModel() when $default != null:
return $default(_that.total,_that.working,_that.notStarted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TeamStatusStatsModel extends TeamStatusStatsModel {
  const _TeamStatusStatsModel({required this.total, required this.working, required this.notStarted}): super._();
  factory _TeamStatusStatsModel.fromJson(Map<String, dynamic> json) => _$TeamStatusStatsModelFromJson(json);

@override final  int total;
@override final  int working;
@override final  int notStarted;

/// Create a copy of TeamStatusStatsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeamStatusStatsModelCopyWith<_TeamStatusStatsModel> get copyWith => __$TeamStatusStatsModelCopyWithImpl<_TeamStatusStatsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeamStatusStatsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeamStatusStatsModel&&(identical(other.total, total) || other.total == total)&&(identical(other.working, working) || other.working == working)&&(identical(other.notStarted, notStarted) || other.notStarted == notStarted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,working,notStarted);

@override
String toString() {
  return 'TeamStatusStatsModel(total: $total, working: $working, notStarted: $notStarted)';
}


}

/// @nodoc
abstract mixin class _$TeamStatusStatsModelCopyWith<$Res> implements $TeamStatusStatsModelCopyWith<$Res> {
  factory _$TeamStatusStatsModelCopyWith(_TeamStatusStatsModel value, $Res Function(_TeamStatusStatsModel) _then) = __$TeamStatusStatsModelCopyWithImpl;
@override @useResult
$Res call({
 int total, int working, int notStarted
});




}
/// @nodoc
class __$TeamStatusStatsModelCopyWithImpl<$Res>
    implements _$TeamStatusStatsModelCopyWith<$Res> {
  __$TeamStatusStatsModelCopyWithImpl(this._self, this._then);

  final _TeamStatusStatsModel _self;
  final $Res Function(_TeamStatusStatsModel) _then;

/// Create a copy of TeamStatusStatsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? working = null,Object? notStarted = null,}) {
  return _then(_TeamStatusStatsModel(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,working: null == working ? _self.working : working // ignore: cast_nullable_to_non_nullable
as int,notStarted: null == notStarted ? _self.notStarted : notStarted // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
