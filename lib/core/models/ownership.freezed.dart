// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ownership.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OwnershipDispute {

 DisputeStatus get status; String? get resolution;
/// Create a copy of OwnershipDispute
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OwnershipDisputeCopyWith<OwnershipDispute> get copyWith => _$OwnershipDisputeCopyWithImpl<OwnershipDispute>(this as OwnershipDispute, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OwnershipDispute;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OwnershipDispute&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.resolution, _this.resolution) || other.resolution == _this.resolution));
}


@override
int get hashCode {
  final _this = this as OwnershipDispute;
  return Object.hash(runtimeType,_this.status,_this.resolution);
}

@override
String toString() {
  final _this = this as OwnershipDispute;
  return 'OwnershipDispute(status: ${_this.status}, resolution: ${_this.resolution})';
}


}

/// @nodoc
abstract mixin class $OwnershipDisputeCopyWith<$Res>  {
  factory $OwnershipDisputeCopyWith(OwnershipDispute value, $Res Function(OwnershipDispute) _then) = _$OwnershipDisputeCopyWithImpl;
@useResult
$Res call({
 DisputeStatus status, String? resolution
});




}
/// @nodoc
class _$OwnershipDisputeCopyWithImpl<$Res>
    implements $OwnershipDisputeCopyWith<$Res> {
  _$OwnershipDisputeCopyWithImpl(this._self, this._then);

  final OwnershipDispute _self;
  final $Res Function(OwnershipDispute) _then;

/// Create a copy of OwnershipDispute
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? resolution = freezed,}) {
  return _then(OwnershipDispute(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DisputeStatus,resolution: freezed == resolution ? _self.resolution : resolution // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OwnershipDispute].
extension OwnershipDisputePatterns on OwnershipDispute {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OwnershipDispute value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OwnershipDispute() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OwnershipDispute value)  $default,){
final _that = this;
switch (_that) {
case _OwnershipDispute():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OwnershipDispute value)?  $default,){
final _that = this;
switch (_that) {
case _OwnershipDispute() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DisputeStatus status,  String? resolution)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OwnershipDispute() when $default != null:
return $default(_that.status,_that.resolution);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DisputeStatus status,  String? resolution)  $default,) {final _that = this;
switch (_that) {
case _OwnershipDispute():
return $default(_that.status,_that.resolution);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DisputeStatus status,  String? resolution)?  $default,) {final _that = this;
switch (_that) {
case _OwnershipDispute() when $default != null:
return $default(_that.status,_that.resolution);case _:
  return null;

}
}

}

/// @nodoc


class _OwnershipDispute implements OwnershipDispute {
  const _OwnershipDispute({required this.status, this.resolution});
  

@override final  DisputeStatus status;
@override final  String? resolution;

/// Create a copy of OwnershipDispute
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OwnershipDisputeCopyWith<_OwnershipDispute> get copyWith => __$OwnershipDisputeCopyWithImpl<_OwnershipDispute>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OwnershipDispute&&(identical(other.status, status) || other.status == status)&&(identical(other.resolution, resolution) || other.resolution == resolution));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,resolution);
}

@override
String toString() {
    return 'OwnershipDispute(status: $status, resolution: $resolution)';
}


}

/// @nodoc
abstract mixin class _$OwnershipDisputeCopyWith<$Res> implements $OwnershipDisputeCopyWith<$Res> {
  factory _$OwnershipDisputeCopyWith(_OwnershipDispute value, $Res Function(_OwnershipDispute) _then) = __$OwnershipDisputeCopyWithImpl;
@override @useResult
$Res call({
 DisputeStatus status, String? resolution
});




}
/// @nodoc
class __$OwnershipDisputeCopyWithImpl<$Res>
    implements _$OwnershipDisputeCopyWith<$Res> {
  __$OwnershipDisputeCopyWithImpl(this._self, this._then);

  final _OwnershipDispute _self;
  final $Res Function(_OwnershipDispute) _then;

/// Create a copy of OwnershipDispute
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? resolution = freezed,}) {
  return _then(_OwnershipDispute(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DisputeStatus,resolution: freezed == resolution ? _self.resolution : resolution // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$Ownership {

 OwnershipStatus get status; int get receiptAttemptsUsed; int get receiptAttemptsLeft; ClaimMethod? get method; DateTime? get verifiedAt; DateTime? get pendingSince; String? get lastRejectionReason; ClaimDecider? get decidedBy; String? get brandName; OwnershipDispute? get dispute;
/// Create a copy of Ownership
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OwnershipCopyWith<Ownership> get copyWith => _$OwnershipCopyWithImpl<Ownership>(this as Ownership, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Ownership;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Ownership&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.receiptAttemptsUsed, _this.receiptAttemptsUsed) || other.receiptAttemptsUsed == _this.receiptAttemptsUsed)&&(identical(other.receiptAttemptsLeft, _this.receiptAttemptsLeft) || other.receiptAttemptsLeft == _this.receiptAttemptsLeft)&&(identical(other.method, _this.method) || other.method == _this.method)&&(identical(other.verifiedAt, _this.verifiedAt) || other.verifiedAt == _this.verifiedAt)&&(identical(other.pendingSince, _this.pendingSince) || other.pendingSince == _this.pendingSince)&&(identical(other.lastRejectionReason, _this.lastRejectionReason) || other.lastRejectionReason == _this.lastRejectionReason)&&(identical(other.decidedBy, _this.decidedBy) || other.decidedBy == _this.decidedBy)&&(identical(other.brandName, _this.brandName) || other.brandName == _this.brandName)&&(identical(other.dispute, _this.dispute) || other.dispute == _this.dispute));
}


@override
int get hashCode {
  final _this = this as Ownership;
  return Object.hash(runtimeType,_this.status,_this.receiptAttemptsUsed,_this.receiptAttemptsLeft,_this.method,_this.verifiedAt,_this.pendingSince,_this.lastRejectionReason,_this.decidedBy,_this.brandName,_this.dispute);
}

@override
String toString() {
  final _this = this as Ownership;
  return 'Ownership(status: ${_this.status}, receiptAttemptsUsed: ${_this.receiptAttemptsUsed}, receiptAttemptsLeft: ${_this.receiptAttemptsLeft}, method: ${_this.method}, verifiedAt: ${_this.verifiedAt}, pendingSince: ${_this.pendingSince}, lastRejectionReason: ${_this.lastRejectionReason}, decidedBy: ${_this.decidedBy}, brandName: ${_this.brandName}, dispute: ${_this.dispute})';
}


}

/// @nodoc
abstract mixin class $OwnershipCopyWith<$Res>  {
  factory $OwnershipCopyWith(Ownership value, $Res Function(Ownership) _then) = _$OwnershipCopyWithImpl;
@useResult
$Res call({
 OwnershipStatus status, int receiptAttemptsUsed, int receiptAttemptsLeft, ClaimMethod? method, DateTime? verifiedAt, DateTime? pendingSince, String? lastRejectionReason, ClaimDecider? decidedBy, String? brandName, OwnershipDispute? dispute
});


$OwnershipDisputeCopyWith<$Res>? get dispute;

}
/// @nodoc
class _$OwnershipCopyWithImpl<$Res>
    implements $OwnershipCopyWith<$Res> {
  _$OwnershipCopyWithImpl(this._self, this._then);

  final Ownership _self;
  final $Res Function(Ownership) _then;

/// Create a copy of Ownership
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? receiptAttemptsUsed = null,Object? receiptAttemptsLeft = null,Object? method = freezed,Object? verifiedAt = freezed,Object? pendingSince = freezed,Object? lastRejectionReason = freezed,Object? decidedBy = freezed,Object? brandName = freezed,Object? dispute = freezed,}) {
  return _then(Ownership(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OwnershipStatus,receiptAttemptsUsed: null == receiptAttemptsUsed ? _self.receiptAttemptsUsed : receiptAttemptsUsed // ignore: cast_nullable_to_non_nullable
as int,receiptAttemptsLeft: null == receiptAttemptsLeft ? _self.receiptAttemptsLeft : receiptAttemptsLeft // ignore: cast_nullable_to_non_nullable
as int,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as ClaimMethod?,verifiedAt: freezed == verifiedAt ? _self.verifiedAt : verifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,pendingSince: freezed == pendingSince ? _self.pendingSince : pendingSince // ignore: cast_nullable_to_non_nullable
as DateTime?,lastRejectionReason: freezed == lastRejectionReason ? _self.lastRejectionReason : lastRejectionReason // ignore: cast_nullable_to_non_nullable
as String?,decidedBy: freezed == decidedBy ? _self.decidedBy : decidedBy // ignore: cast_nullable_to_non_nullable
as ClaimDecider?,brandName: freezed == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String?,dispute: freezed == dispute ? _self.dispute : dispute // ignore: cast_nullable_to_non_nullable
as OwnershipDispute?,
  ));
}
/// Create a copy of Ownership
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwnershipDisputeCopyWith<$Res>? get dispute {
    if (_self.dispute == null) {
    return null;
  }

  return $OwnershipDisputeCopyWith<$Res>(_self.dispute!, (value) {
    return _then(_self.copyWith(dispute: value));
  });
}
}


/// Adds pattern-matching-related methods to [Ownership].
extension OwnershipPatterns on Ownership {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Ownership value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Ownership() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Ownership value)  $default,){
final _that = this;
switch (_that) {
case _Ownership():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Ownership value)?  $default,){
final _that = this;
switch (_that) {
case _Ownership() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( OwnershipStatus status,  int receiptAttemptsUsed,  int receiptAttemptsLeft,  ClaimMethod? method,  DateTime? verifiedAt,  DateTime? pendingSince,  String? lastRejectionReason,  ClaimDecider? decidedBy,  String? brandName,  OwnershipDispute? dispute)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Ownership() when $default != null:
return $default(_that.status,_that.receiptAttemptsUsed,_that.receiptAttemptsLeft,_that.method,_that.verifiedAt,_that.pendingSince,_that.lastRejectionReason,_that.decidedBy,_that.brandName,_that.dispute);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( OwnershipStatus status,  int receiptAttemptsUsed,  int receiptAttemptsLeft,  ClaimMethod? method,  DateTime? verifiedAt,  DateTime? pendingSince,  String? lastRejectionReason,  ClaimDecider? decidedBy,  String? brandName,  OwnershipDispute? dispute)  $default,) {final _that = this;
switch (_that) {
case _Ownership():
return $default(_that.status,_that.receiptAttemptsUsed,_that.receiptAttemptsLeft,_that.method,_that.verifiedAt,_that.pendingSince,_that.lastRejectionReason,_that.decidedBy,_that.brandName,_that.dispute);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( OwnershipStatus status,  int receiptAttemptsUsed,  int receiptAttemptsLeft,  ClaimMethod? method,  DateTime? verifiedAt,  DateTime? pendingSince,  String? lastRejectionReason,  ClaimDecider? decidedBy,  String? brandName,  OwnershipDispute? dispute)?  $default,) {final _that = this;
switch (_that) {
case _Ownership() when $default != null:
return $default(_that.status,_that.receiptAttemptsUsed,_that.receiptAttemptsLeft,_that.method,_that.verifiedAt,_that.pendingSince,_that.lastRejectionReason,_that.decidedBy,_that.brandName,_that.dispute);case _:
  return null;

}
}

}

/// @nodoc


class _Ownership extends Ownership {
  const _Ownership({required this.status, required this.receiptAttemptsUsed, required this.receiptAttemptsLeft, this.method, this.verifiedAt, this.pendingSince, this.lastRejectionReason, this.decidedBy, this.brandName, this.dispute}): super._();
  

@override final  OwnershipStatus status;
@override final  int receiptAttemptsUsed;
@override final  int receiptAttemptsLeft;
@override final  ClaimMethod? method;
@override final  DateTime? verifiedAt;
@override final  DateTime? pendingSince;
@override final  String? lastRejectionReason;
@override final  ClaimDecider? decidedBy;
@override final  String? brandName;
@override final  OwnershipDispute? dispute;

/// Create a copy of Ownership
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OwnershipCopyWith<_Ownership> get copyWith => __$OwnershipCopyWithImpl<_Ownership>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Ownership&&(identical(other.status, status) || other.status == status)&&(identical(other.receiptAttemptsUsed, receiptAttemptsUsed) || other.receiptAttemptsUsed == receiptAttemptsUsed)&&(identical(other.receiptAttemptsLeft, receiptAttemptsLeft) || other.receiptAttemptsLeft == receiptAttemptsLeft)&&(identical(other.method, method) || other.method == method)&&(identical(other.verifiedAt, verifiedAt) || other.verifiedAt == verifiedAt)&&(identical(other.pendingSince, pendingSince) || other.pendingSince == pendingSince)&&(identical(other.lastRejectionReason, lastRejectionReason) || other.lastRejectionReason == lastRejectionReason)&&(identical(other.decidedBy, decidedBy) || other.decidedBy == decidedBy)&&(identical(other.brandName, brandName) || other.brandName == brandName)&&(identical(other.dispute, dispute) || other.dispute == dispute));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,receiptAttemptsUsed,receiptAttemptsLeft,method,verifiedAt,pendingSince,lastRejectionReason,decidedBy,brandName,dispute);
}

@override
String toString() {
    return 'Ownership(status: $status, receiptAttemptsUsed: $receiptAttemptsUsed, receiptAttemptsLeft: $receiptAttemptsLeft, method: $method, verifiedAt: $verifiedAt, pendingSince: $pendingSince, lastRejectionReason: $lastRejectionReason, decidedBy: $decidedBy, brandName: $brandName, dispute: $dispute)';
}


}

/// @nodoc
abstract mixin class _$OwnershipCopyWith<$Res> implements $OwnershipCopyWith<$Res> {
  factory _$OwnershipCopyWith(_Ownership value, $Res Function(_Ownership) _then) = __$OwnershipCopyWithImpl;
@override @useResult
$Res call({
 OwnershipStatus status, int receiptAttemptsUsed, int receiptAttemptsLeft, ClaimMethod? method, DateTime? verifiedAt, DateTime? pendingSince, String? lastRejectionReason, ClaimDecider? decidedBy, String? brandName, OwnershipDispute? dispute
});


@override $OwnershipDisputeCopyWith<$Res>? get dispute;

}
/// @nodoc
class __$OwnershipCopyWithImpl<$Res>
    implements _$OwnershipCopyWith<$Res> {
  __$OwnershipCopyWithImpl(this._self, this._then);

  final _Ownership _self;
  final $Res Function(_Ownership) _then;

/// Create a copy of Ownership
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? receiptAttemptsUsed = null,Object? receiptAttemptsLeft = null,Object? method = freezed,Object? verifiedAt = freezed,Object? pendingSince = freezed,Object? lastRejectionReason = freezed,Object? decidedBy = freezed,Object? brandName = freezed,Object? dispute = freezed,}) {
  return _then(_Ownership(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OwnershipStatus,receiptAttemptsUsed: null == receiptAttemptsUsed ? _self.receiptAttemptsUsed : receiptAttemptsUsed // ignore: cast_nullable_to_non_nullable
as int,receiptAttemptsLeft: null == receiptAttemptsLeft ? _self.receiptAttemptsLeft : receiptAttemptsLeft // ignore: cast_nullable_to_non_nullable
as int,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as ClaimMethod?,verifiedAt: freezed == verifiedAt ? _self.verifiedAt : verifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,pendingSince: freezed == pendingSince ? _self.pendingSince : pendingSince // ignore: cast_nullable_to_non_nullable
as DateTime?,lastRejectionReason: freezed == lastRejectionReason ? _self.lastRejectionReason : lastRejectionReason // ignore: cast_nullable_to_non_nullable
as String?,decidedBy: freezed == decidedBy ? _self.decidedBy : decidedBy // ignore: cast_nullable_to_non_nullable
as ClaimDecider?,brandName: freezed == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String?,dispute: freezed == dispute ? _self.dispute : dispute // ignore: cast_nullable_to_non_nullable
as OwnershipDispute?,
  ));
}

/// Create a copy of Ownership
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwnershipDisputeCopyWith<$Res>? get dispute {
    if (_self.dispute == null) {
    return null;
  }

  return $OwnershipDisputeCopyWith<$Res>(_self.dispute!, (value) {
    return _then(_self.copyWith(dispute: value));
  });
}
}

// dart format on
