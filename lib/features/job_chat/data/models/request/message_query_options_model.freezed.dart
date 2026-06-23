// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_query_options_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MessageQueryOptionsModel {

 int? get limit; int? get offset;@JsonKey(name: 'search') String? get searchQuery;@JsonKey(name: 'type') String? get messageType;
/// Create a copy of MessageQueryOptionsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageQueryOptionsModelCopyWith<MessageQueryOptionsModel> get copyWith => _$MessageQueryOptionsModelCopyWithImpl<MessageQueryOptionsModel>(this as MessageQueryOptionsModel, _$identity);

  /// Serializes this MessageQueryOptionsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageQueryOptionsModel&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.offset, offset) || other.offset == offset)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.messageType, messageType) || other.messageType == messageType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,limit,offset,searchQuery,messageType);

@override
String toString() {
  return 'MessageQueryOptionsModel(limit: $limit, offset: $offset, searchQuery: $searchQuery, messageType: $messageType)';
}


}

/// @nodoc
abstract mixin class $MessageQueryOptionsModelCopyWith<$Res>  {
  factory $MessageQueryOptionsModelCopyWith(MessageQueryOptionsModel value, $Res Function(MessageQueryOptionsModel) _then) = _$MessageQueryOptionsModelCopyWithImpl;
@useResult
$Res call({
 int? limit, int? offset,@JsonKey(name: 'search') String? searchQuery,@JsonKey(name: 'type') String? messageType
});




}
/// @nodoc
class _$MessageQueryOptionsModelCopyWithImpl<$Res>
    implements $MessageQueryOptionsModelCopyWith<$Res> {
  _$MessageQueryOptionsModelCopyWithImpl(this._self, this._then);

  final MessageQueryOptionsModel _self;
  final $Res Function(MessageQueryOptionsModel) _then;

/// Create a copy of MessageQueryOptionsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? limit = freezed,Object? offset = freezed,Object? searchQuery = freezed,Object? messageType = freezed,}) {
  return _then(_self.copyWith(
limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,offset: freezed == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int?,searchQuery: freezed == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String?,messageType: freezed == messageType ? _self.messageType : messageType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MessageQueryOptionsModel].
extension MessageQueryOptionsModelPatterns on MessageQueryOptionsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MessageQueryOptionsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MessageQueryOptionsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MessageQueryOptionsModel value)  $default,){
final _that = this;
switch (_that) {
case _MessageQueryOptionsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MessageQueryOptionsModel value)?  $default,){
final _that = this;
switch (_that) {
case _MessageQueryOptionsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? limit,  int? offset, @JsonKey(name: 'search')  String? searchQuery, @JsonKey(name: 'type')  String? messageType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessageQueryOptionsModel() when $default != null:
return $default(_that.limit,_that.offset,_that.searchQuery,_that.messageType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? limit,  int? offset, @JsonKey(name: 'search')  String? searchQuery, @JsonKey(name: 'type')  String? messageType)  $default,) {final _that = this;
switch (_that) {
case _MessageQueryOptionsModel():
return $default(_that.limit,_that.offset,_that.searchQuery,_that.messageType);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? limit,  int? offset, @JsonKey(name: 'search')  String? searchQuery, @JsonKey(name: 'type')  String? messageType)?  $default,) {final _that = this;
switch (_that) {
case _MessageQueryOptionsModel() when $default != null:
return $default(_that.limit,_that.offset,_that.searchQuery,_that.messageType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MessageQueryOptionsModel extends MessageQueryOptionsModel {
  const _MessageQueryOptionsModel({this.limit, this.offset, @JsonKey(name: 'search') this.searchQuery, @JsonKey(name: 'type') this.messageType}): super._();
  factory _MessageQueryOptionsModel.fromJson(Map<String, dynamic> json) => _$MessageQueryOptionsModelFromJson(json);

@override final  int? limit;
@override final  int? offset;
@override@JsonKey(name: 'search') final  String? searchQuery;
@override@JsonKey(name: 'type') final  String? messageType;

/// Create a copy of MessageQueryOptionsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageQueryOptionsModelCopyWith<_MessageQueryOptionsModel> get copyWith => __$MessageQueryOptionsModelCopyWithImpl<_MessageQueryOptionsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessageQueryOptionsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessageQueryOptionsModel&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.offset, offset) || other.offset == offset)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.messageType, messageType) || other.messageType == messageType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,limit,offset,searchQuery,messageType);

@override
String toString() {
  return 'MessageQueryOptionsModel(limit: $limit, offset: $offset, searchQuery: $searchQuery, messageType: $messageType)';
}


}

/// @nodoc
abstract mixin class _$MessageQueryOptionsModelCopyWith<$Res> implements $MessageQueryOptionsModelCopyWith<$Res> {
  factory _$MessageQueryOptionsModelCopyWith(_MessageQueryOptionsModel value, $Res Function(_MessageQueryOptionsModel) _then) = __$MessageQueryOptionsModelCopyWithImpl;
@override @useResult
$Res call({
 int? limit, int? offset,@JsonKey(name: 'search') String? searchQuery,@JsonKey(name: 'type') String? messageType
});




}
/// @nodoc
class __$MessageQueryOptionsModelCopyWithImpl<$Res>
    implements _$MessageQueryOptionsModelCopyWith<$Res> {
  __$MessageQueryOptionsModelCopyWithImpl(this._self, this._then);

  final _MessageQueryOptionsModel _self;
  final $Res Function(_MessageQueryOptionsModel) _then;

/// Create a copy of MessageQueryOptionsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? limit = freezed,Object? offset = freezed,Object? searchQuery = freezed,Object? messageType = freezed,}) {
  return _then(_MessageQueryOptionsModel(
limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,offset: freezed == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int?,searchQuery: freezed == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String?,messageType: freezed == messageType ? _self.messageType : messageType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
