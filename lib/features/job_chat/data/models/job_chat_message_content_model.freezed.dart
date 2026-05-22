// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_chat_message_content_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JobChatMessageContentModel {

 int get id; String get type; String? get content; Map<String, dynamic>? get metadata; String? get actionPerformed;
/// Create a copy of JobChatMessageContentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobChatMessageContentModelCopyWith<JobChatMessageContentModel> get copyWith => _$JobChatMessageContentModelCopyWithImpl<JobChatMessageContentModel>(this as JobChatMessageContentModel, _$identity);

  /// Serializes this JobChatMessageContentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobChatMessageContentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other.metadata, metadata)&&(identical(other.actionPerformed, actionPerformed) || other.actionPerformed == actionPerformed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,content,const DeepCollectionEquality().hash(metadata),actionPerformed);

@override
String toString() {
  return 'JobChatMessageContentModel(id: $id, type: $type, content: $content, metadata: $metadata, actionPerformed: $actionPerformed)';
}


}

/// @nodoc
abstract mixin class $JobChatMessageContentModelCopyWith<$Res>  {
  factory $JobChatMessageContentModelCopyWith(JobChatMessageContentModel value, $Res Function(JobChatMessageContentModel) _then) = _$JobChatMessageContentModelCopyWithImpl;
@useResult
$Res call({
 int id, String type, String? content, Map<String, dynamic>? metadata, String? actionPerformed
});




}
/// @nodoc
class _$JobChatMessageContentModelCopyWithImpl<$Res>
    implements $JobChatMessageContentModelCopyWith<$Res> {
  _$JobChatMessageContentModelCopyWithImpl(this._self, this._then);

  final JobChatMessageContentModel _self;
  final $Res Function(JobChatMessageContentModel) _then;

/// Create a copy of JobChatMessageContentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? content = freezed,Object? metadata = freezed,Object? actionPerformed = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,actionPerformed: freezed == actionPerformed ? _self.actionPerformed : actionPerformed // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [JobChatMessageContentModel].
extension JobChatMessageContentModelPatterns on JobChatMessageContentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobChatMessageContentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobChatMessageContentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobChatMessageContentModel value)  $default,){
final _that = this;
switch (_that) {
case _JobChatMessageContentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobChatMessageContentModel value)?  $default,){
final _that = this;
switch (_that) {
case _JobChatMessageContentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String type,  String? content,  Map<String, dynamic>? metadata,  String? actionPerformed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobChatMessageContentModel() when $default != null:
return $default(_that.id,_that.type,_that.content,_that.metadata,_that.actionPerformed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String type,  String? content,  Map<String, dynamic>? metadata,  String? actionPerformed)  $default,) {final _that = this;
switch (_that) {
case _JobChatMessageContentModel():
return $default(_that.id,_that.type,_that.content,_that.metadata,_that.actionPerformed);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String type,  String? content,  Map<String, dynamic>? metadata,  String? actionPerformed)?  $default,) {final _that = this;
switch (_that) {
case _JobChatMessageContentModel() when $default != null:
return $default(_that.id,_that.type,_that.content,_that.metadata,_that.actionPerformed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JobChatMessageContentModel extends JobChatMessageContentModel {
  const _JobChatMessageContentModel({required this.id, required this.type, this.content, final  Map<String, dynamic>? metadata, this.actionPerformed}): _metadata = metadata,super._();
  factory _JobChatMessageContentModel.fromJson(Map<String, dynamic> json) => _$JobChatMessageContentModelFromJson(json);

@override final  int id;
@override final  String type;
@override final  String? content;
 final  Map<String, dynamic>? _metadata;
@override Map<String, dynamic>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  String? actionPerformed;

/// Create a copy of JobChatMessageContentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobChatMessageContentModelCopyWith<_JobChatMessageContentModel> get copyWith => __$JobChatMessageContentModelCopyWithImpl<_JobChatMessageContentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JobChatMessageContentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobChatMessageContentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other._metadata, _metadata)&&(identical(other.actionPerformed, actionPerformed) || other.actionPerformed == actionPerformed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,content,const DeepCollectionEquality().hash(_metadata),actionPerformed);

@override
String toString() {
  return 'JobChatMessageContentModel(id: $id, type: $type, content: $content, metadata: $metadata, actionPerformed: $actionPerformed)';
}


}

/// @nodoc
abstract mixin class _$JobChatMessageContentModelCopyWith<$Res> implements $JobChatMessageContentModelCopyWith<$Res> {
  factory _$JobChatMessageContentModelCopyWith(_JobChatMessageContentModel value, $Res Function(_JobChatMessageContentModel) _then) = __$JobChatMessageContentModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String type, String? content, Map<String, dynamic>? metadata, String? actionPerformed
});




}
/// @nodoc
class __$JobChatMessageContentModelCopyWithImpl<$Res>
    implements _$JobChatMessageContentModelCopyWith<$Res> {
  __$JobChatMessageContentModelCopyWithImpl(this._self, this._then);

  final _JobChatMessageContentModel _self;
  final $Res Function(_JobChatMessageContentModel) _then;

/// Create a copy of JobChatMessageContentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? content = freezed,Object? metadata = freezed,Object? actionPerformed = freezed,}) {
  return _then(_JobChatMessageContentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,actionPerformed: freezed == actionPerformed ? _self.actionPerformed : actionPerformed // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
