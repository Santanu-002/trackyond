// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_status_query_options_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TeamStatusQueryOptionsModel {

@JsonKey(name: 'status_filter', includeIfNull: false)@AttendanceStatusNullableConverter() AttendanceStatus? get status; String? get order; int? get limit;
/// Create a copy of TeamStatusQueryOptionsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeamStatusQueryOptionsModelCopyWith<TeamStatusQueryOptionsModel> get copyWith => _$TeamStatusQueryOptionsModelCopyWithImpl<TeamStatusQueryOptionsModel>(this as TeamStatusQueryOptionsModel, _$identity);

  /// Serializes this TeamStatusQueryOptionsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeamStatusQueryOptionsModel&&(identical(other.status, status) || other.status == status)&&(identical(other.order, order) || other.order == order)&&(identical(other.limit, limit) || other.limit == limit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,order,limit);

@override
String toString() {
  return 'TeamStatusQueryOptionsModel(status: $status, order: $order, limit: $limit)';
}


}

/// @nodoc
abstract mixin class $TeamStatusQueryOptionsModelCopyWith<$Res>  {
  factory $TeamStatusQueryOptionsModelCopyWith(TeamStatusQueryOptionsModel value, $Res Function(TeamStatusQueryOptionsModel) _then) = _$TeamStatusQueryOptionsModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'status_filter', includeIfNull: false)@AttendanceStatusNullableConverter() AttendanceStatus? status, String? order, int? limit
});




}
/// @nodoc
class _$TeamStatusQueryOptionsModelCopyWithImpl<$Res>
    implements $TeamStatusQueryOptionsModelCopyWith<$Res> {
  _$TeamStatusQueryOptionsModelCopyWithImpl(this._self, this._then);

  final TeamStatusQueryOptionsModel _self;
  final $Res Function(TeamStatusQueryOptionsModel) _then;

/// Create a copy of TeamStatusQueryOptionsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = freezed,Object? order = freezed,Object? limit = freezed,}) {
  return _then(_self.copyWith(
status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AttendanceStatus?,order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as String?,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [TeamStatusQueryOptionsModel].
extension TeamStatusQueryOptionsModelPatterns on TeamStatusQueryOptionsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeamStatusQueryOptionsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeamStatusQueryOptionsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeamStatusQueryOptionsModel value)  $default,){
final _that = this;
switch (_that) {
case _TeamStatusQueryOptionsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeamStatusQueryOptionsModel value)?  $default,){
final _that = this;
switch (_that) {
case _TeamStatusQueryOptionsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'status_filter', includeIfNull: false)@AttendanceStatusNullableConverter()  AttendanceStatus? status,  String? order,  int? limit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeamStatusQueryOptionsModel() when $default != null:
return $default(_that.status,_that.order,_that.limit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'status_filter', includeIfNull: false)@AttendanceStatusNullableConverter()  AttendanceStatus? status,  String? order,  int? limit)  $default,) {final _that = this;
switch (_that) {
case _TeamStatusQueryOptionsModel():
return $default(_that.status,_that.order,_that.limit);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'status_filter', includeIfNull: false)@AttendanceStatusNullableConverter()  AttendanceStatus? status,  String? order,  int? limit)?  $default,) {final _that = this;
switch (_that) {
case _TeamStatusQueryOptionsModel() when $default != null:
return $default(_that.status,_that.order,_that.limit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TeamStatusQueryOptionsModel extends TeamStatusQueryOptionsModel {
  const _TeamStatusQueryOptionsModel({@JsonKey(name: 'status_filter', includeIfNull: false)@AttendanceStatusNullableConverter() this.status, this.order, this.limit}): super._();
  factory _TeamStatusQueryOptionsModel.fromJson(Map<String, dynamic> json) => _$TeamStatusQueryOptionsModelFromJson(json);

@override@JsonKey(name: 'status_filter', includeIfNull: false)@AttendanceStatusNullableConverter() final  AttendanceStatus? status;
@override final  String? order;
@override final  int? limit;

/// Create a copy of TeamStatusQueryOptionsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeamStatusQueryOptionsModelCopyWith<_TeamStatusQueryOptionsModel> get copyWith => __$TeamStatusQueryOptionsModelCopyWithImpl<_TeamStatusQueryOptionsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeamStatusQueryOptionsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeamStatusQueryOptionsModel&&(identical(other.status, status) || other.status == status)&&(identical(other.order, order) || other.order == order)&&(identical(other.limit, limit) || other.limit == limit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,order,limit);

@override
String toString() {
  return 'TeamStatusQueryOptionsModel(status: $status, order: $order, limit: $limit)';
}


}

/// @nodoc
abstract mixin class _$TeamStatusQueryOptionsModelCopyWith<$Res> implements $TeamStatusQueryOptionsModelCopyWith<$Res> {
  factory _$TeamStatusQueryOptionsModelCopyWith(_TeamStatusQueryOptionsModel value, $Res Function(_TeamStatusQueryOptionsModel) _then) = __$TeamStatusQueryOptionsModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'status_filter', includeIfNull: false)@AttendanceStatusNullableConverter() AttendanceStatus? status, String? order, int? limit
});




}
/// @nodoc
class __$TeamStatusQueryOptionsModelCopyWithImpl<$Res>
    implements _$TeamStatusQueryOptionsModelCopyWith<$Res> {
  __$TeamStatusQueryOptionsModelCopyWithImpl(this._self, this._then);

  final _TeamStatusQueryOptionsModel _self;
  final $Res Function(_TeamStatusQueryOptionsModel) _then;

/// Create a copy of TeamStatusQueryOptionsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = freezed,Object? order = freezed,Object? limit = freezed,}) {
  return _then(_TeamStatusQueryOptionsModel(
status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AttendanceStatus?,order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as String?,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
