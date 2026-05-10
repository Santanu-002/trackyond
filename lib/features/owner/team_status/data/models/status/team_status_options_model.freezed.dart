// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_status_options_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TeamStatusOptionsModel {

 String? get statusFilter; String? get order;
/// Create a copy of TeamStatusOptionsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeamStatusOptionsModelCopyWith<TeamStatusOptionsModel> get copyWith => _$TeamStatusOptionsModelCopyWithImpl<TeamStatusOptionsModel>(this as TeamStatusOptionsModel, _$identity);

  /// Serializes this TeamStatusOptionsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeamStatusOptionsModel&&(identical(other.statusFilter, statusFilter) || other.statusFilter == statusFilter)&&(identical(other.order, order) || other.order == order));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,statusFilter,order);

@override
String toString() {
  return 'TeamStatusOptionsModel(statusFilter: $statusFilter, order: $order)';
}


}

/// @nodoc
abstract mixin class $TeamStatusOptionsModelCopyWith<$Res>  {
  factory $TeamStatusOptionsModelCopyWith(TeamStatusOptionsModel value, $Res Function(TeamStatusOptionsModel) _then) = _$TeamStatusOptionsModelCopyWithImpl;
@useResult
$Res call({
 String? statusFilter, String? order
});




}
/// @nodoc
class _$TeamStatusOptionsModelCopyWithImpl<$Res>
    implements $TeamStatusOptionsModelCopyWith<$Res> {
  _$TeamStatusOptionsModelCopyWithImpl(this._self, this._then);

  final TeamStatusOptionsModel _self;
  final $Res Function(TeamStatusOptionsModel) _then;

/// Create a copy of TeamStatusOptionsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? statusFilter = freezed,Object? order = freezed,}) {
  return _then(_self.copyWith(
statusFilter: freezed == statusFilter ? _self.statusFilter : statusFilter // ignore: cast_nullable_to_non_nullable
as String?,order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TeamStatusOptionsModel].
extension TeamStatusOptionsModelPatterns on TeamStatusOptionsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeamStatusOptionsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeamStatusOptionsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeamStatusOptionsModel value)  $default,){
final _that = this;
switch (_that) {
case _TeamStatusOptionsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeamStatusOptionsModel value)?  $default,){
final _that = this;
switch (_that) {
case _TeamStatusOptionsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? statusFilter,  String? order)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeamStatusOptionsModel() when $default != null:
return $default(_that.statusFilter,_that.order);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? statusFilter,  String? order)  $default,) {final _that = this;
switch (_that) {
case _TeamStatusOptionsModel():
return $default(_that.statusFilter,_that.order);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? statusFilter,  String? order)?  $default,) {final _that = this;
switch (_that) {
case _TeamStatusOptionsModel() when $default != null:
return $default(_that.statusFilter,_that.order);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TeamStatusOptionsModel extends TeamStatusOptionsModel {
  const _TeamStatusOptionsModel({this.statusFilter, this.order}): super._();
  factory _TeamStatusOptionsModel.fromJson(Map<String, dynamic> json) => _$TeamStatusOptionsModelFromJson(json);

@override final  String? statusFilter;
@override final  String? order;

/// Create a copy of TeamStatusOptionsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeamStatusOptionsModelCopyWith<_TeamStatusOptionsModel> get copyWith => __$TeamStatusOptionsModelCopyWithImpl<_TeamStatusOptionsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeamStatusOptionsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeamStatusOptionsModel&&(identical(other.statusFilter, statusFilter) || other.statusFilter == statusFilter)&&(identical(other.order, order) || other.order == order));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,statusFilter,order);

@override
String toString() {
  return 'TeamStatusOptionsModel(statusFilter: $statusFilter, order: $order)';
}


}

/// @nodoc
abstract mixin class _$TeamStatusOptionsModelCopyWith<$Res> implements $TeamStatusOptionsModelCopyWith<$Res> {
  factory _$TeamStatusOptionsModelCopyWith(_TeamStatusOptionsModel value, $Res Function(_TeamStatusOptionsModel) _then) = __$TeamStatusOptionsModelCopyWithImpl;
@override @useResult
$Res call({
 String? statusFilter, String? order
});




}
/// @nodoc
class __$TeamStatusOptionsModelCopyWithImpl<$Res>
    implements _$TeamStatusOptionsModelCopyWith<$Res> {
  __$TeamStatusOptionsModelCopyWithImpl(this._self, this._then);

  final _TeamStatusOptionsModel _self;
  final $Res Function(_TeamStatusOptionsModel) _then;

/// Create a copy of TeamStatusOptionsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? statusFilter = freezed,Object? order = freezed,}) {
  return _then(_TeamStatusOptionsModel(
statusFilter: freezed == statusFilter ? _self.statusFilter : statusFilter // ignore: cast_nullable_to_non_nullable
as String?,order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
