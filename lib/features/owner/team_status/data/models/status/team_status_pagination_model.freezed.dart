// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_status_pagination_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TeamStatusPaginationModel {

 int get limit; int get totalItems;
/// Create a copy of TeamStatusPaginationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeamStatusPaginationModelCopyWith<TeamStatusPaginationModel> get copyWith => _$TeamStatusPaginationModelCopyWithImpl<TeamStatusPaginationModel>(this as TeamStatusPaginationModel, _$identity);

  /// Serializes this TeamStatusPaginationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeamStatusPaginationModel&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.totalItems, totalItems) || other.totalItems == totalItems));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,limit,totalItems);

@override
String toString() {
  return 'TeamStatusPaginationModel(limit: $limit, totalItems: $totalItems)';
}


}

/// @nodoc
abstract mixin class $TeamStatusPaginationModelCopyWith<$Res>  {
  factory $TeamStatusPaginationModelCopyWith(TeamStatusPaginationModel value, $Res Function(TeamStatusPaginationModel) _then) = _$TeamStatusPaginationModelCopyWithImpl;
@useResult
$Res call({
 int limit, int totalItems
});




}
/// @nodoc
class _$TeamStatusPaginationModelCopyWithImpl<$Res>
    implements $TeamStatusPaginationModelCopyWith<$Res> {
  _$TeamStatusPaginationModelCopyWithImpl(this._self, this._then);

  final TeamStatusPaginationModel _self;
  final $Res Function(TeamStatusPaginationModel) _then;

/// Create a copy of TeamStatusPaginationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? limit = null,Object? totalItems = null,}) {
  return _then(_self.copyWith(
limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,totalItems: null == totalItems ? _self.totalItems : totalItems // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TeamStatusPaginationModel].
extension TeamStatusPaginationModelPatterns on TeamStatusPaginationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeamStatusPaginationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeamStatusPaginationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeamStatusPaginationModel value)  $default,){
final _that = this;
switch (_that) {
case _TeamStatusPaginationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeamStatusPaginationModel value)?  $default,){
final _that = this;
switch (_that) {
case _TeamStatusPaginationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int limit,  int totalItems)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeamStatusPaginationModel() when $default != null:
return $default(_that.limit,_that.totalItems);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int limit,  int totalItems)  $default,) {final _that = this;
switch (_that) {
case _TeamStatusPaginationModel():
return $default(_that.limit,_that.totalItems);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int limit,  int totalItems)?  $default,) {final _that = this;
switch (_that) {
case _TeamStatusPaginationModel() when $default != null:
return $default(_that.limit,_that.totalItems);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TeamStatusPaginationModel extends TeamStatusPaginationModel {
  const _TeamStatusPaginationModel({required this.limit, required this.totalItems}): super._();
  factory _TeamStatusPaginationModel.fromJson(Map<String, dynamic> json) => _$TeamStatusPaginationModelFromJson(json);

@override final  int limit;
@override final  int totalItems;

/// Create a copy of TeamStatusPaginationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeamStatusPaginationModelCopyWith<_TeamStatusPaginationModel> get copyWith => __$TeamStatusPaginationModelCopyWithImpl<_TeamStatusPaginationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeamStatusPaginationModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeamStatusPaginationModel&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.totalItems, totalItems) || other.totalItems == totalItems));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,limit,totalItems);

@override
String toString() {
  return 'TeamStatusPaginationModel(limit: $limit, totalItems: $totalItems)';
}


}

/// @nodoc
abstract mixin class _$TeamStatusPaginationModelCopyWith<$Res> implements $TeamStatusPaginationModelCopyWith<$Res> {
  factory _$TeamStatusPaginationModelCopyWith(_TeamStatusPaginationModel value, $Res Function(_TeamStatusPaginationModel) _then) = __$TeamStatusPaginationModelCopyWithImpl;
@override @useResult
$Res call({
 int limit, int totalItems
});




}
/// @nodoc
class __$TeamStatusPaginationModelCopyWithImpl<$Res>
    implements _$TeamStatusPaginationModelCopyWith<$Res> {
  __$TeamStatusPaginationModelCopyWithImpl(this._self, this._then);

  final _TeamStatusPaginationModel _self;
  final $Res Function(_TeamStatusPaginationModel) _then;

/// Create a copy of TeamStatusPaginationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? limit = null,Object? totalItems = null,}) {
  return _then(_TeamStatusPaginationModel(
limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,totalItems: null == totalItems ? _self.totalItems : totalItems // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
