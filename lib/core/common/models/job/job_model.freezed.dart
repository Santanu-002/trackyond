// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JobModel {

 String get jobId; String get jobTitle; String get customerName; String get customerPhone; String? get customerAddress; String get workerAccountUid; String? get workerName; String? get workerImage; String get status; bool get requirePhotoOnStart; bool get requirePhotoOnComplete; bool get captureLocation; DateTime get createdAt; DateTime? get assignedAt; DateTime? get updatedAt; DateTime? get completedAt;
/// Create a copy of JobModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobModelCopyWith<JobModel> get copyWith => _$JobModelCopyWithImpl<JobModel>(this as JobModel, _$identity);

  /// Serializes this JobModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobModel&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.jobTitle, jobTitle) || other.jobTitle == jobTitle)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.customerPhone, customerPhone) || other.customerPhone == customerPhone)&&(identical(other.customerAddress, customerAddress) || other.customerAddress == customerAddress)&&(identical(other.workerAccountUid, workerAccountUid) || other.workerAccountUid == workerAccountUid)&&(identical(other.workerName, workerName) || other.workerName == workerName)&&(identical(other.workerImage, workerImage) || other.workerImage == workerImage)&&(identical(other.status, status) || other.status == status)&&(identical(other.requirePhotoOnStart, requirePhotoOnStart) || other.requirePhotoOnStart == requirePhotoOnStart)&&(identical(other.requirePhotoOnComplete, requirePhotoOnComplete) || other.requirePhotoOnComplete == requirePhotoOnComplete)&&(identical(other.captureLocation, captureLocation) || other.captureLocation == captureLocation)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.assignedAt, assignedAt) || other.assignedAt == assignedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,jobId,jobTitle,customerName,customerPhone,customerAddress,workerAccountUid,workerName,workerImage,status,requirePhotoOnStart,requirePhotoOnComplete,captureLocation,createdAt,assignedAt,updatedAt,completedAt);

@override
String toString() {
  return 'JobModel(jobId: $jobId, jobTitle: $jobTitle, customerName: $customerName, customerPhone: $customerPhone, customerAddress: $customerAddress, workerAccountUid: $workerAccountUid, workerName: $workerName, workerImage: $workerImage, status: $status, requirePhotoOnStart: $requirePhotoOnStart, requirePhotoOnComplete: $requirePhotoOnComplete, captureLocation: $captureLocation, createdAt: $createdAt, assignedAt: $assignedAt, updatedAt: $updatedAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class $JobModelCopyWith<$Res>  {
  factory $JobModelCopyWith(JobModel value, $Res Function(JobModel) _then) = _$JobModelCopyWithImpl;
@useResult
$Res call({
 String jobId, String jobTitle, String customerName, String customerPhone, String? customerAddress, String workerAccountUid, String? workerName, String? workerImage, String status, bool requirePhotoOnStart, bool requirePhotoOnComplete, bool captureLocation, DateTime createdAt, DateTime? assignedAt, DateTime? updatedAt, DateTime? completedAt
});




}
/// @nodoc
class _$JobModelCopyWithImpl<$Res>
    implements $JobModelCopyWith<$Res> {
  _$JobModelCopyWithImpl(this._self, this._then);

  final JobModel _self;
  final $Res Function(JobModel) _then;

/// Create a copy of JobModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? jobId = null,Object? jobTitle = null,Object? customerName = null,Object? customerPhone = null,Object? customerAddress = freezed,Object? workerAccountUid = null,Object? workerName = freezed,Object? workerImage = freezed,Object? status = null,Object? requirePhotoOnStart = null,Object? requirePhotoOnComplete = null,Object? captureLocation = null,Object? createdAt = null,Object? assignedAt = freezed,Object? updatedAt = freezed,Object? completedAt = freezed,}) {
  return _then(_self.copyWith(
jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,jobTitle: null == jobTitle ? _self.jobTitle : jobTitle // ignore: cast_nullable_to_non_nullable
as String,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,customerPhone: null == customerPhone ? _self.customerPhone : customerPhone // ignore: cast_nullable_to_non_nullable
as String,customerAddress: freezed == customerAddress ? _self.customerAddress : customerAddress // ignore: cast_nullable_to_non_nullable
as String?,workerAccountUid: null == workerAccountUid ? _self.workerAccountUid : workerAccountUid // ignore: cast_nullable_to_non_nullable
as String,workerName: freezed == workerName ? _self.workerName : workerName // ignore: cast_nullable_to_non_nullable
as String?,workerImage: freezed == workerImage ? _self.workerImage : workerImage // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,requirePhotoOnStart: null == requirePhotoOnStart ? _self.requirePhotoOnStart : requirePhotoOnStart // ignore: cast_nullable_to_non_nullable
as bool,requirePhotoOnComplete: null == requirePhotoOnComplete ? _self.requirePhotoOnComplete : requirePhotoOnComplete // ignore: cast_nullable_to_non_nullable
as bool,captureLocation: null == captureLocation ? _self.captureLocation : captureLocation // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,assignedAt: freezed == assignedAt ? _self.assignedAt : assignedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [JobModel].
extension JobModelPatterns on JobModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobModel value)  $default,){
final _that = this;
switch (_that) {
case _JobModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobModel value)?  $default,){
final _that = this;
switch (_that) {
case _JobModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String jobId,  String jobTitle,  String customerName,  String customerPhone,  String? customerAddress,  String workerAccountUid,  String? workerName,  String? workerImage,  String status,  bool requirePhotoOnStart,  bool requirePhotoOnComplete,  bool captureLocation,  DateTime createdAt,  DateTime? assignedAt,  DateTime? updatedAt,  DateTime? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobModel() when $default != null:
return $default(_that.jobId,_that.jobTitle,_that.customerName,_that.customerPhone,_that.customerAddress,_that.workerAccountUid,_that.workerName,_that.workerImage,_that.status,_that.requirePhotoOnStart,_that.requirePhotoOnComplete,_that.captureLocation,_that.createdAt,_that.assignedAt,_that.updatedAt,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String jobId,  String jobTitle,  String customerName,  String customerPhone,  String? customerAddress,  String workerAccountUid,  String? workerName,  String? workerImage,  String status,  bool requirePhotoOnStart,  bool requirePhotoOnComplete,  bool captureLocation,  DateTime createdAt,  DateTime? assignedAt,  DateTime? updatedAt,  DateTime? completedAt)  $default,) {final _that = this;
switch (_that) {
case _JobModel():
return $default(_that.jobId,_that.jobTitle,_that.customerName,_that.customerPhone,_that.customerAddress,_that.workerAccountUid,_that.workerName,_that.workerImage,_that.status,_that.requirePhotoOnStart,_that.requirePhotoOnComplete,_that.captureLocation,_that.createdAt,_that.assignedAt,_that.updatedAt,_that.completedAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String jobId,  String jobTitle,  String customerName,  String customerPhone,  String? customerAddress,  String workerAccountUid,  String? workerName,  String? workerImage,  String status,  bool requirePhotoOnStart,  bool requirePhotoOnComplete,  bool captureLocation,  DateTime createdAt,  DateTime? assignedAt,  DateTime? updatedAt,  DateTime? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _JobModel() when $default != null:
return $default(_that.jobId,_that.jobTitle,_that.customerName,_that.customerPhone,_that.customerAddress,_that.workerAccountUid,_that.workerName,_that.workerImage,_that.status,_that.requirePhotoOnStart,_that.requirePhotoOnComplete,_that.captureLocation,_that.createdAt,_that.assignedAt,_that.updatedAt,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JobModel extends JobModel {
  const _JobModel({required this.jobId, required this.jobTitle, required this.customerName, required this.customerPhone, this.customerAddress, required this.workerAccountUid, this.workerName, this.workerImage, required this.status, required this.requirePhotoOnStart, required this.requirePhotoOnComplete, required this.captureLocation, required this.createdAt, this.assignedAt, this.updatedAt, this.completedAt}): super._();
  factory _JobModel.fromJson(Map<String, dynamic> json) => _$JobModelFromJson(json);

@override final  String jobId;
@override final  String jobTitle;
@override final  String customerName;
@override final  String customerPhone;
@override final  String? customerAddress;
@override final  String workerAccountUid;
@override final  String? workerName;
@override final  String? workerImage;
@override final  String status;
@override final  bool requirePhotoOnStart;
@override final  bool requirePhotoOnComplete;
@override final  bool captureLocation;
@override final  DateTime createdAt;
@override final  DateTime? assignedAt;
@override final  DateTime? updatedAt;
@override final  DateTime? completedAt;

/// Create a copy of JobModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobModelCopyWith<_JobModel> get copyWith => __$JobModelCopyWithImpl<_JobModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JobModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobModel&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.jobTitle, jobTitle) || other.jobTitle == jobTitle)&&(identical(other.customerName, customerName) || other.customerName == customerName)&&(identical(other.customerPhone, customerPhone) || other.customerPhone == customerPhone)&&(identical(other.customerAddress, customerAddress) || other.customerAddress == customerAddress)&&(identical(other.workerAccountUid, workerAccountUid) || other.workerAccountUid == workerAccountUid)&&(identical(other.workerName, workerName) || other.workerName == workerName)&&(identical(other.workerImage, workerImage) || other.workerImage == workerImage)&&(identical(other.status, status) || other.status == status)&&(identical(other.requirePhotoOnStart, requirePhotoOnStart) || other.requirePhotoOnStart == requirePhotoOnStart)&&(identical(other.requirePhotoOnComplete, requirePhotoOnComplete) || other.requirePhotoOnComplete == requirePhotoOnComplete)&&(identical(other.captureLocation, captureLocation) || other.captureLocation == captureLocation)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.assignedAt, assignedAt) || other.assignedAt == assignedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,jobId,jobTitle,customerName,customerPhone,customerAddress,workerAccountUid,workerName,workerImage,status,requirePhotoOnStart,requirePhotoOnComplete,captureLocation,createdAt,assignedAt,updatedAt,completedAt);

@override
String toString() {
  return 'JobModel(jobId: $jobId, jobTitle: $jobTitle, customerName: $customerName, customerPhone: $customerPhone, customerAddress: $customerAddress, workerAccountUid: $workerAccountUid, workerName: $workerName, workerImage: $workerImage, status: $status, requirePhotoOnStart: $requirePhotoOnStart, requirePhotoOnComplete: $requirePhotoOnComplete, captureLocation: $captureLocation, createdAt: $createdAt, assignedAt: $assignedAt, updatedAt: $updatedAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$JobModelCopyWith<$Res> implements $JobModelCopyWith<$Res> {
  factory _$JobModelCopyWith(_JobModel value, $Res Function(_JobModel) _then) = __$JobModelCopyWithImpl;
@override @useResult
$Res call({
 String jobId, String jobTitle, String customerName, String customerPhone, String? customerAddress, String workerAccountUid, String? workerName, String? workerImage, String status, bool requirePhotoOnStart, bool requirePhotoOnComplete, bool captureLocation, DateTime createdAt, DateTime? assignedAt, DateTime? updatedAt, DateTime? completedAt
});




}
/// @nodoc
class __$JobModelCopyWithImpl<$Res>
    implements _$JobModelCopyWith<$Res> {
  __$JobModelCopyWithImpl(this._self, this._then);

  final _JobModel _self;
  final $Res Function(_JobModel) _then;

/// Create a copy of JobModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? jobId = null,Object? jobTitle = null,Object? customerName = null,Object? customerPhone = null,Object? customerAddress = freezed,Object? workerAccountUid = null,Object? workerName = freezed,Object? workerImage = freezed,Object? status = null,Object? requirePhotoOnStart = null,Object? requirePhotoOnComplete = null,Object? captureLocation = null,Object? createdAt = null,Object? assignedAt = freezed,Object? updatedAt = freezed,Object? completedAt = freezed,}) {
  return _then(_JobModel(
jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,jobTitle: null == jobTitle ? _self.jobTitle : jobTitle // ignore: cast_nullable_to_non_nullable
as String,customerName: null == customerName ? _self.customerName : customerName // ignore: cast_nullable_to_non_nullable
as String,customerPhone: null == customerPhone ? _self.customerPhone : customerPhone // ignore: cast_nullable_to_non_nullable
as String,customerAddress: freezed == customerAddress ? _self.customerAddress : customerAddress // ignore: cast_nullable_to_non_nullable
as String?,workerAccountUid: null == workerAccountUid ? _self.workerAccountUid : workerAccountUid // ignore: cast_nullable_to_non_nullable
as String,workerName: freezed == workerName ? _self.workerName : workerName // ignore: cast_nullable_to_non_nullable
as String?,workerImage: freezed == workerImage ? _self.workerImage : workerImage // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,requirePhotoOnStart: null == requirePhotoOnStart ? _self.requirePhotoOnStart : requirePhotoOnStart // ignore: cast_nullable_to_non_nullable
as bool,requirePhotoOnComplete: null == requirePhotoOnComplete ? _self.requirePhotoOnComplete : requirePhotoOnComplete // ignore: cast_nullable_to_non_nullable
as bool,captureLocation: null == captureLocation ? _self.captureLocation : captureLocation // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,assignedAt: freezed == assignedAt ? _self.assignedAt : assignedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
