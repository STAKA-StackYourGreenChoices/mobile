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
mixin _$Ownership {

 OwnershipStatus get status; int get receiptAttemptsUsed; int get receiptAttemptsLeft; ClaimMethod? get method; DateTime? get verifiedAt; DateTime? get pendingSince; String? get lastRejectionReason;
/// Create a copy of Ownership
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OwnershipCopyWith<Ownership> get copyWith => _$OwnershipCopyWithImpl<Ownership>(this as Ownership, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Ownership;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Ownership&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.receiptAttemptsUsed, _this.receiptAttemptsUsed) || other.receiptAttemptsUsed == _this.receiptAttemptsUsed)&&(identical(other.receiptAttemptsLeft, _this.receiptAttemptsLeft) || other.receiptAttemptsLeft == _this.receiptAttemptsLeft)&&(identical(other.method, _this.method) || other.method == _this.method)&&(identical(other.verifiedAt, _this.verifiedAt) || other.verifiedAt == _this.verifiedAt)&&(identical(other.pendingSince, _this.pendingSince) || other.pendingSince == _this.pendingSince)&&(identical(other.lastRejectionReason, _this.lastRejectionReason) || other.lastRejectionReason == _this.lastRejectionReason));
}


@override
int get hashCode {
  final _this = this as Ownership;
  return Object.hash(runtimeType,_this.status,_this.receiptAttemptsUsed,_this.receiptAttemptsLeft,_this.method,_this.verifiedAt,_this.pendingSince,_this.lastRejectionReason);
}

@override
String toString() {
  final _this = this as Ownership;
  return 'Ownership(status: ${_this.status}, receiptAttemptsUsed: ${_this.receiptAttemptsUsed}, receiptAttemptsLeft: ${_this.receiptAttemptsLeft}, method: ${_this.method}, verifiedAt: ${_this.verifiedAt}, pendingSince: ${_this.pendingSince}, lastRejectionReason: ${_this.lastRejectionReason})';
}


}

/// @nodoc
abstract mixin class $OwnershipCopyWith<$Res>  {
  factory $OwnershipCopyWith(Ownership value, $Res Function(Ownership) _then) = _$OwnershipCopyWithImpl;
@useResult
$Res call({
 OwnershipStatus status, int receiptAttemptsUsed, int receiptAttemptsLeft, ClaimMethod? method, DateTime? verifiedAt, DateTime? pendingSince, String? lastRejectionReason
});




}
/// @nodoc
class _$OwnershipCopyWithImpl<$Res>
    implements $OwnershipCopyWith<$Res> {
  _$OwnershipCopyWithImpl(this._self, this._then);

  final Ownership _self;
  final $Res Function(Ownership) _then;

/// Create a copy of Ownership
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? receiptAttemptsUsed = null,Object? receiptAttemptsLeft = null,Object? method = freezed,Object? verifiedAt = freezed,Object? pendingSince = freezed,Object? lastRejectionReason = freezed,}) {
  return _then(Ownership(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OwnershipStatus,receiptAttemptsUsed: null == receiptAttemptsUsed ? _self.receiptAttemptsUsed : receiptAttemptsUsed // ignore: cast_nullable_to_non_nullable
as int,receiptAttemptsLeft: null == receiptAttemptsLeft ? _self.receiptAttemptsLeft : receiptAttemptsLeft // ignore: cast_nullable_to_non_nullable
as int,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as ClaimMethod?,verifiedAt: freezed == verifiedAt ? _self.verifiedAt : verifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,pendingSince: freezed == pendingSince ? _self.pendingSince : pendingSince // ignore: cast_nullable_to_non_nullable
as DateTime?,lastRejectionReason: freezed == lastRejectionReason ? _self.lastRejectionReason : lastRejectionReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( OwnershipStatus status,  int receiptAttemptsUsed,  int receiptAttemptsLeft,  ClaimMethod? method,  DateTime? verifiedAt,  DateTime? pendingSince,  String? lastRejectionReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Ownership() when $default != null:
return $default(_that.status,_that.receiptAttemptsUsed,_that.receiptAttemptsLeft,_that.method,_that.verifiedAt,_that.pendingSince,_that.lastRejectionReason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( OwnershipStatus status,  int receiptAttemptsUsed,  int receiptAttemptsLeft,  ClaimMethod? method,  DateTime? verifiedAt,  DateTime? pendingSince,  String? lastRejectionReason)  $default,) {final _that = this;
switch (_that) {
case _Ownership():
return $default(_that.status,_that.receiptAttemptsUsed,_that.receiptAttemptsLeft,_that.method,_that.verifiedAt,_that.pendingSince,_that.lastRejectionReason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( OwnershipStatus status,  int receiptAttemptsUsed,  int receiptAttemptsLeft,  ClaimMethod? method,  DateTime? verifiedAt,  DateTime? pendingSince,  String? lastRejectionReason)?  $default,) {final _that = this;
switch (_that) {
case _Ownership() when $default != null:
return $default(_that.status,_that.receiptAttemptsUsed,_that.receiptAttemptsLeft,_that.method,_that.verifiedAt,_that.pendingSince,_that.lastRejectionReason);case _:
  return null;

}
}

}

/// @nodoc


class _Ownership extends Ownership {
  const _Ownership({required this.status, required this.receiptAttemptsUsed, required this.receiptAttemptsLeft, this.method, this.verifiedAt, this.pendingSince, this.lastRejectionReason}): super._();
  

@override final  OwnershipStatus status;
@override final  int receiptAttemptsUsed;
@override final  int receiptAttemptsLeft;
@override final  ClaimMethod? method;
@override final  DateTime? verifiedAt;
@override final  DateTime? pendingSince;
@override final  String? lastRejectionReason;

/// Create a copy of Ownership
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OwnershipCopyWith<_Ownership> get copyWith => __$OwnershipCopyWithImpl<_Ownership>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Ownership&&(identical(other.status, status) || other.status == status)&&(identical(other.receiptAttemptsUsed, receiptAttemptsUsed) || other.receiptAttemptsUsed == receiptAttemptsUsed)&&(identical(other.receiptAttemptsLeft, receiptAttemptsLeft) || other.receiptAttemptsLeft == receiptAttemptsLeft)&&(identical(other.method, method) || other.method == method)&&(identical(other.verifiedAt, verifiedAt) || other.verifiedAt == verifiedAt)&&(identical(other.pendingSince, pendingSince) || other.pendingSince == pendingSince)&&(identical(other.lastRejectionReason, lastRejectionReason) || other.lastRejectionReason == lastRejectionReason));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,receiptAttemptsUsed,receiptAttemptsLeft,method,verifiedAt,pendingSince,lastRejectionReason);
}

@override
String toString() {
    return 'Ownership(status: $status, receiptAttemptsUsed: $receiptAttemptsUsed, receiptAttemptsLeft: $receiptAttemptsLeft, method: $method, verifiedAt: $verifiedAt, pendingSince: $pendingSince, lastRejectionReason: $lastRejectionReason)';
}


}

/// @nodoc
abstract mixin class _$OwnershipCopyWith<$Res> implements $OwnershipCopyWith<$Res> {
  factory _$OwnershipCopyWith(_Ownership value, $Res Function(_Ownership) _then) = __$OwnershipCopyWithImpl;
@override @useResult
$Res call({
 OwnershipStatus status, int receiptAttemptsUsed, int receiptAttemptsLeft, ClaimMethod? method, DateTime? verifiedAt, DateTime? pendingSince, String? lastRejectionReason
});




}
/// @nodoc
class __$OwnershipCopyWithImpl<$Res>
    implements _$OwnershipCopyWith<$Res> {
  __$OwnershipCopyWithImpl(this._self, this._then);

  final _Ownership _self;
  final $Res Function(_Ownership) _then;

/// Create a copy of Ownership
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? receiptAttemptsUsed = null,Object? receiptAttemptsLeft = null,Object? method = freezed,Object? verifiedAt = freezed,Object? pendingSince = freezed,Object? lastRejectionReason = freezed,}) {
  return _then(_Ownership(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OwnershipStatus,receiptAttemptsUsed: null == receiptAttemptsUsed ? _self.receiptAttemptsUsed : receiptAttemptsUsed // ignore: cast_nullable_to_non_nullable
as int,receiptAttemptsLeft: null == receiptAttemptsLeft ? _self.receiptAttemptsLeft : receiptAttemptsLeft // ignore: cast_nullable_to_non_nullable
as int,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as ClaimMethod?,verifiedAt: freezed == verifiedAt ? _self.verifiedAt : verifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,pendingSince: freezed == pendingSince ? _self.pendingSince : pendingSince // ignore: cast_nullable_to_non_nullable
as DateTime?,lastRejectionReason: freezed == lastRejectionReason ? _self.lastRejectionReason : lastRejectionReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
