// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_filter_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationFilterRequestModel {

 int get limit; int get offset;@JsonKey(includeIfNull: false) bool? get isRead; bool get isNewestFirst;
/// Create a copy of NotificationFilterRequestModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationFilterRequestModelCopyWith<NotificationFilterRequestModel> get copyWith => _$NotificationFilterRequestModelCopyWithImpl<NotificationFilterRequestModel>(this as NotificationFilterRequestModel, _$identity);

  /// Serializes this NotificationFilterRequestModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationFilterRequestModel&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.offset, offset) || other.offset == offset)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.isNewestFirst, isNewestFirst) || other.isNewestFirst == isNewestFirst));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,limit,offset,isRead,isNewestFirst);

@override
String toString() {
  return 'NotificationFilterRequestModel(limit: $limit, offset: $offset, isRead: $isRead, isNewestFirst: $isNewestFirst)';
}


}

/// @nodoc
abstract mixin class $NotificationFilterRequestModelCopyWith<$Res>  {
  factory $NotificationFilterRequestModelCopyWith(NotificationFilterRequestModel value, $Res Function(NotificationFilterRequestModel) _then) = _$NotificationFilterRequestModelCopyWithImpl;
@useResult
$Res call({
 int limit, int offset,@JsonKey(includeIfNull: false) bool? isRead, bool isNewestFirst
});




}
/// @nodoc
class _$NotificationFilterRequestModelCopyWithImpl<$Res>
    implements $NotificationFilterRequestModelCopyWith<$Res> {
  _$NotificationFilterRequestModelCopyWithImpl(this._self, this._then);

  final NotificationFilterRequestModel _self;
  final $Res Function(NotificationFilterRequestModel) _then;

/// Create a copy of NotificationFilterRequestModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? limit = null,Object? offset = null,Object? isRead = freezed,Object? isNewestFirst = null,}) {
  return _then(_self.copyWith(
limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int,isRead: freezed == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool?,isNewestFirst: null == isNewestFirst ? _self.isNewestFirst : isNewestFirst // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationFilterRequestModel].
extension NotificationFilterRequestModelPatterns on NotificationFilterRequestModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationFilterRequestModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationFilterRequestModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationFilterRequestModel value)  $default,){
final _that = this;
switch (_that) {
case _NotificationFilterRequestModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationFilterRequestModel value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationFilterRequestModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int limit,  int offset, @JsonKey(includeIfNull: false)  bool? isRead,  bool isNewestFirst)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationFilterRequestModel() when $default != null:
return $default(_that.limit,_that.offset,_that.isRead,_that.isNewestFirst);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int limit,  int offset, @JsonKey(includeIfNull: false)  bool? isRead,  bool isNewestFirst)  $default,) {final _that = this;
switch (_that) {
case _NotificationFilterRequestModel():
return $default(_that.limit,_that.offset,_that.isRead,_that.isNewestFirst);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int limit,  int offset, @JsonKey(includeIfNull: false)  bool? isRead,  bool isNewestFirst)?  $default,) {final _that = this;
switch (_that) {
case _NotificationFilterRequestModel() when $default != null:
return $default(_that.limit,_that.offset,_that.isRead,_that.isNewestFirst);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationFilterRequestModel implements NotificationFilterRequestModel {
  const _NotificationFilterRequestModel({required this.limit, required this.offset, @JsonKey(includeIfNull: false) this.isRead, required this.isNewestFirst});
  factory _NotificationFilterRequestModel.fromJson(Map<String, dynamic> json) => _$NotificationFilterRequestModelFromJson(json);

@override final  int limit;
@override final  int offset;
@override@JsonKey(includeIfNull: false) final  bool? isRead;
@override final  bool isNewestFirst;

/// Create a copy of NotificationFilterRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationFilterRequestModelCopyWith<_NotificationFilterRequestModel> get copyWith => __$NotificationFilterRequestModelCopyWithImpl<_NotificationFilterRequestModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationFilterRequestModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationFilterRequestModel&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.offset, offset) || other.offset == offset)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.isNewestFirst, isNewestFirst) || other.isNewestFirst == isNewestFirst));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,limit,offset,isRead,isNewestFirst);

@override
String toString() {
  return 'NotificationFilterRequestModel(limit: $limit, offset: $offset, isRead: $isRead, isNewestFirst: $isNewestFirst)';
}


}

/// @nodoc
abstract mixin class _$NotificationFilterRequestModelCopyWith<$Res> implements $NotificationFilterRequestModelCopyWith<$Res> {
  factory _$NotificationFilterRequestModelCopyWith(_NotificationFilterRequestModel value, $Res Function(_NotificationFilterRequestModel) _then) = __$NotificationFilterRequestModelCopyWithImpl;
@override @useResult
$Res call({
 int limit, int offset,@JsonKey(includeIfNull: false) bool? isRead, bool isNewestFirst
});




}
/// @nodoc
class __$NotificationFilterRequestModelCopyWithImpl<$Res>
    implements _$NotificationFilterRequestModelCopyWith<$Res> {
  __$NotificationFilterRequestModelCopyWithImpl(this._self, this._then);

  final _NotificationFilterRequestModel _self;
  final $Res Function(_NotificationFilterRequestModel) _then;

/// Create a copy of NotificationFilterRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? limit = null,Object? offset = null,Object? isRead = freezed,Object? isNewestFirst = null,}) {
  return _then(_NotificationFilterRequestModel(
limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int,isRead: freezed == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool?,isNewestFirst: null == isNewestFirst ? _self.isNewestFirst : isNewestFirst // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
