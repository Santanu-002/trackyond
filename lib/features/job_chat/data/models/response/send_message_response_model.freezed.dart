// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'send_message_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SendMessageResponseModel {

 JobChatMessageModel get message; List<JobChatMessageModel> get messages; List<String> get allowedActions; JobModel? get job;
/// Create a copy of SendMessageResponseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SendMessageResponseModelCopyWith<SendMessageResponseModel> get copyWith => _$SendMessageResponseModelCopyWithImpl<SendMessageResponseModel>(this as SendMessageResponseModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SendMessageResponseModel&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.messages, messages)&&const DeepCollectionEquality().equals(other.allowedActions, allowedActions)&&(identical(other.job, job) || other.job == job));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(messages),const DeepCollectionEquality().hash(allowedActions),job);

@override
String toString() {
  return 'SendMessageResponseModel(message: $message, messages: $messages, allowedActions: $allowedActions, job: $job)';
}


}

/// @nodoc
abstract mixin class $SendMessageResponseModelCopyWith<$Res>  {
  factory $SendMessageResponseModelCopyWith(SendMessageResponseModel value, $Res Function(SendMessageResponseModel) _then) = _$SendMessageResponseModelCopyWithImpl;
@useResult
$Res call({
 JobChatMessageModel message, List<JobChatMessageModel> messages, List<String> allowedActions, JobModel? job
});


$JobChatMessageModelCopyWith<$Res> get message;$JobModelCopyWith<$Res>? get job;

}
/// @nodoc
class _$SendMessageResponseModelCopyWithImpl<$Res>
    implements $SendMessageResponseModelCopyWith<$Res> {
  _$SendMessageResponseModelCopyWithImpl(this._self, this._then);

  final SendMessageResponseModel _self;
  final $Res Function(SendMessageResponseModel) _then;

/// Create a copy of SendMessageResponseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? messages = null,Object? allowedActions = null,Object? job = freezed,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as JobChatMessageModel,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<JobChatMessageModel>,allowedActions: null == allowedActions ? _self.allowedActions : allowedActions // ignore: cast_nullable_to_non_nullable
as List<String>,job: freezed == job ? _self.job : job // ignore: cast_nullable_to_non_nullable
as JobModel?,
  ));
}
/// Create a copy of SendMessageResponseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JobChatMessageModelCopyWith<$Res> get message {
  
  return $JobChatMessageModelCopyWith<$Res>(_self.message, (value) {
    return _then(_self.copyWith(message: value));
  });
}/// Create a copy of SendMessageResponseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JobModelCopyWith<$Res>? get job {
    if (_self.job == null) {
    return null;
  }

  return $JobModelCopyWith<$Res>(_self.job!, (value) {
    return _then(_self.copyWith(job: value));
  });
}
}


/// Adds pattern-matching-related methods to [SendMessageResponseModel].
extension SendMessageResponseModelPatterns on SendMessageResponseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SendMessageResponseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SendMessageResponseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SendMessageResponseModel value)  $default,){
final _that = this;
switch (_that) {
case _SendMessageResponseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SendMessageResponseModel value)?  $default,){
final _that = this;
switch (_that) {
case _SendMessageResponseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( JobChatMessageModel message,  List<JobChatMessageModel> messages,  List<String> allowedActions,  JobModel? job)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SendMessageResponseModel() when $default != null:
return $default(_that.message,_that.messages,_that.allowedActions,_that.job);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( JobChatMessageModel message,  List<JobChatMessageModel> messages,  List<String> allowedActions,  JobModel? job)  $default,) {final _that = this;
switch (_that) {
case _SendMessageResponseModel():
return $default(_that.message,_that.messages,_that.allowedActions,_that.job);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( JobChatMessageModel message,  List<JobChatMessageModel> messages,  List<String> allowedActions,  JobModel? job)?  $default,) {final _that = this;
switch (_that) {
case _SendMessageResponseModel() when $default != null:
return $default(_that.message,_that.messages,_that.allowedActions,_that.job);case _:
  return null;

}
}

}

/// @nodoc


class _SendMessageResponseModel extends SendMessageResponseModel {
  const _SendMessageResponseModel({required this.message, final  List<JobChatMessageModel> messages = const [], required final  List<String> allowedActions, this.job}): _messages = messages,_allowedActions = allowedActions,super._();
  

@override final  JobChatMessageModel message;
 final  List<JobChatMessageModel> _messages;
@override@JsonKey() List<JobChatMessageModel> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

 final  List<String> _allowedActions;
@override List<String> get allowedActions {
  if (_allowedActions is EqualUnmodifiableListView) return _allowedActions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allowedActions);
}

@override final  JobModel? job;

/// Create a copy of SendMessageResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SendMessageResponseModelCopyWith<_SendMessageResponseModel> get copyWith => __$SendMessageResponseModelCopyWithImpl<_SendMessageResponseModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SendMessageResponseModel&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._messages, _messages)&&const DeepCollectionEquality().equals(other._allowedActions, _allowedActions)&&(identical(other.job, job) || other.job == job));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(_messages),const DeepCollectionEquality().hash(_allowedActions),job);

@override
String toString() {
  return 'SendMessageResponseModel(message: $message, messages: $messages, allowedActions: $allowedActions, job: $job)';
}


}

/// @nodoc
abstract mixin class _$SendMessageResponseModelCopyWith<$Res> implements $SendMessageResponseModelCopyWith<$Res> {
  factory _$SendMessageResponseModelCopyWith(_SendMessageResponseModel value, $Res Function(_SendMessageResponseModel) _then) = __$SendMessageResponseModelCopyWithImpl;
@override @useResult
$Res call({
 JobChatMessageModel message, List<JobChatMessageModel> messages, List<String> allowedActions, JobModel? job
});


@override $JobChatMessageModelCopyWith<$Res> get message;@override $JobModelCopyWith<$Res>? get job;

}
/// @nodoc
class __$SendMessageResponseModelCopyWithImpl<$Res>
    implements _$SendMessageResponseModelCopyWith<$Res> {
  __$SendMessageResponseModelCopyWithImpl(this._self, this._then);

  final _SendMessageResponseModel _self;
  final $Res Function(_SendMessageResponseModel) _then;

/// Create a copy of SendMessageResponseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? messages = null,Object? allowedActions = null,Object? job = freezed,}) {
  return _then(_SendMessageResponseModel(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as JobChatMessageModel,messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<JobChatMessageModel>,allowedActions: null == allowedActions ? _self._allowedActions : allowedActions // ignore: cast_nullable_to_non_nullable
as List<String>,job: freezed == job ? _self.job : job // ignore: cast_nullable_to_non_nullable
as JobModel?,
  ));
}

/// Create a copy of SendMessageResponseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JobChatMessageModelCopyWith<$Res> get message {
  
  return $JobChatMessageModelCopyWith<$Res>(_self.message, (value) {
    return _then(_self.copyWith(message: value));
  });
}/// Create a copy of SendMessageResponseModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JobModelCopyWith<$Res>? get job {
    if (_self.job == null) {
    return null;
  }

  return $JobModelCopyWith<$Res>(_self.job!, (value) {
    return _then(_self.copyWith(job: value));
  });
}
}

// dart format on
