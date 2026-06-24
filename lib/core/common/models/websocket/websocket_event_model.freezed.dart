// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'websocket_event_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WebSocketEventModel<T> {

 WebSocketEvents get event; dynamic get type; Map<String, dynamic>? get headers; T? get data;
/// Create a copy of WebSocketEventModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WebSocketEventModelCopyWith<T, WebSocketEventModel<T>> get copyWith => _$WebSocketEventModelCopyWithImpl<T, WebSocketEventModel<T>>(this as WebSocketEventModel<T>, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WebSocketEventModel<T>&&(identical(other.event, event) || other.event == event)&&const DeepCollectionEquality().equals(other.type, type)&&const DeepCollectionEquality().equals(other.headers, headers)&&const DeepCollectionEquality().equals(other.data, data));
}


@override
int get hashCode => Object.hash(runtimeType,event,const DeepCollectionEquality().hash(type),const DeepCollectionEquality().hash(headers),const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'WebSocketEventModel<$T>(event: $event, type: $type, headers: $headers, data: $data)';
}


}

/// @nodoc
abstract mixin class $WebSocketEventModelCopyWith<T,$Res>  {
  factory $WebSocketEventModelCopyWith(WebSocketEventModel<T> value, $Res Function(WebSocketEventModel<T>) _then) = _$WebSocketEventModelCopyWithImpl;
@useResult
$Res call({
 WebSocketEvents event, dynamic type, Map<String, dynamic>? headers, T? data
});




}
/// @nodoc
class _$WebSocketEventModelCopyWithImpl<T,$Res>
    implements $WebSocketEventModelCopyWith<T, $Res> {
  _$WebSocketEventModelCopyWithImpl(this._self, this._then);

  final WebSocketEventModel<T> _self;
  final $Res Function(WebSocketEventModel<T>) _then;

/// Create a copy of WebSocketEventModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? event = null,Object? type = freezed,Object? headers = freezed,Object? data = freezed,}) {
  return _then(_self.copyWith(
event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as WebSocketEvents,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as dynamic,headers: freezed == headers ? _self.headers : headers // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T?,
  ));
}

}


/// Adds pattern-matching-related methods to [WebSocketEventModel].
extension WebSocketEventModelPatterns<T> on WebSocketEventModel<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WebSocketEventModel<T> value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WebSocketEventModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WebSocketEventModel<T> value)  $default,){
final _that = this;
switch (_that) {
case _WebSocketEventModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WebSocketEventModel<T> value)?  $default,){
final _that = this;
switch (_that) {
case _WebSocketEventModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( WebSocketEvents event,  dynamic type,  Map<String, dynamic>? headers,  T? data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WebSocketEventModel() when $default != null:
return $default(_that.event,_that.type,_that.headers,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( WebSocketEvents event,  dynamic type,  Map<String, dynamic>? headers,  T? data)  $default,) {final _that = this;
switch (_that) {
case _WebSocketEventModel():
return $default(_that.event,_that.type,_that.headers,_that.data);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( WebSocketEvents event,  dynamic type,  Map<String, dynamic>? headers,  T? data)?  $default,) {final _that = this;
switch (_that) {
case _WebSocketEventModel() when $default != null:
return $default(_that.event,_that.type,_that.headers,_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _WebSocketEventModel<T> extends WebSocketEventModel<T> {
  const _WebSocketEventModel({required this.event, required this.type, required final  Map<String, dynamic>? headers, required this.data}): _headers = headers,super._();
  

@override final  WebSocketEvents event;
@override final  dynamic type;
 final  Map<String, dynamic>? _headers;
@override Map<String, dynamic>? get headers {
  final value = _headers;
  if (value == null) return null;
  if (_headers is EqualUnmodifiableMapView) return _headers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  T? data;

/// Create a copy of WebSocketEventModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WebSocketEventModelCopyWith<T, _WebSocketEventModel<T>> get copyWith => __$WebSocketEventModelCopyWithImpl<T, _WebSocketEventModel<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WebSocketEventModel<T>&&(identical(other.event, event) || other.event == event)&&const DeepCollectionEquality().equals(other.type, type)&&const DeepCollectionEquality().equals(other._headers, _headers)&&const DeepCollectionEquality().equals(other.data, data));
}


@override
int get hashCode => Object.hash(runtimeType,event,const DeepCollectionEquality().hash(type),const DeepCollectionEquality().hash(_headers),const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'WebSocketEventModel<$T>(event: $event, type: $type, headers: $headers, data: $data)';
}


}

/// @nodoc
abstract mixin class _$WebSocketEventModelCopyWith<T,$Res> implements $WebSocketEventModelCopyWith<T, $Res> {
  factory _$WebSocketEventModelCopyWith(_WebSocketEventModel<T> value, $Res Function(_WebSocketEventModel<T>) _then) = __$WebSocketEventModelCopyWithImpl;
@override @useResult
$Res call({
 WebSocketEvents event, dynamic type, Map<String, dynamic>? headers, T? data
});




}
/// @nodoc
class __$WebSocketEventModelCopyWithImpl<T,$Res>
    implements _$WebSocketEventModelCopyWith<T, $Res> {
  __$WebSocketEventModelCopyWithImpl(this._self, this._then);

  final _WebSocketEventModel<T> _self;
  final $Res Function(_WebSocketEventModel<T>) _then;

/// Create a copy of WebSocketEventModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? event = null,Object? type = freezed,Object? headers = freezed,Object? data = freezed,}) {
  return _then(_WebSocketEventModel<T>(
event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as WebSocketEvents,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as dynamic,headers: freezed == headers ? _self._headers : headers // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T?,
  ));
}


}

// dart format on
