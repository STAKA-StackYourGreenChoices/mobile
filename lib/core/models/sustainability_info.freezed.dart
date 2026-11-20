// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sustainability_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SustainabilityInfo {

 int get carbonScoreGrams; int get recyclabilityPercent; bool get isVerified; DateTime? get verifiedAt; String? get certifierName;
/// Create a copy of SustainabilityInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SustainabilityInfoCopyWith<SustainabilityInfo> get copyWith => _$SustainabilityInfoCopyWithImpl<SustainabilityInfo>(this as SustainabilityInfo, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SustainabilityInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SustainabilityInfo&&(identical(other.carbonScoreGrams, _this.carbonScoreGrams) || other.carbonScoreGrams == _this.carbonScoreGrams)&&(identical(other.recyclabilityPercent, _this.recyclabilityPercent) || other.recyclabilityPercent == _this.recyclabilityPercent)&&(identical(other.isVerified, _this.isVerified) || other.isVerified == _this.isVerified)&&(identical(other.verifiedAt, _this.verifiedAt) || other.verifiedAt == _this.verifiedAt)&&(identical(other.certifierName, _this.certifierName) || other.certifierName == _this.certifierName));
}


@override
int get hashCode {
  final _this = this as SustainabilityInfo;
  return Object.hash(runtimeType,_this.carbonScoreGrams,_this.recyclabilityPercent,_this.isVerified,_this.verifiedAt,_this.certifierName);
}

@override
String toString() {
  final _this = this as SustainabilityInfo;
  return 'SustainabilityInfo(carbonScoreGrams: ${_this.carbonScoreGrams}, recyclabilityPercent: ${_this.recyclabilityPercent}, isVerified: ${_this.isVerified}, verifiedAt: ${_this.verifiedAt}, certifierName: ${_this.certifierName})';
}


}

/// @nodoc
abstract mixin class $SustainabilityInfoCopyWith<$Res>  {
  factory $SustainabilityInfoCopyWith(SustainabilityInfo value, $Res Function(SustainabilityInfo) _then) = _$SustainabilityInfoCopyWithImpl;
@useResult
$Res call({
 int carbonScoreGrams, int recyclabilityPercent, bool isVerified, DateTime? verifiedAt, String? certifierName
});




}
/// @nodoc
class _$SustainabilityInfoCopyWithImpl<$Res>
    implements $SustainabilityInfoCopyWith<$Res> {
  _$SustainabilityInfoCopyWithImpl(this._self, this._then);

  final SustainabilityInfo _self;
  final $Res Function(SustainabilityInfo) _then;

/// Create a copy of SustainabilityInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? carbonScoreGrams = null,Object? recyclabilityPercent = null,Object? isVerified = null,Object? verifiedAt = freezed,Object? certifierName = freezed,}) {
  return _then(SustainabilityInfo(
carbonScoreGrams: null == carbonScoreGrams ? _self.carbonScoreGrams : carbonScoreGrams // ignore: cast_nullable_to_non_nullable
as int,recyclabilityPercent: null == recyclabilityPercent ? _self.recyclabilityPercent : recyclabilityPercent // ignore: cast_nullable_to_non_nullable
as int,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,verifiedAt: freezed == verifiedAt ? _self.verifiedAt : verifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,certifierName: freezed == certifierName ? _self.certifierName : certifierName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SustainabilityInfo].
extension SustainabilityInfoPatterns on SustainabilityInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SustainabilityInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SustainabilityInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SustainabilityInfo value)  $default,){
final _that = this;
switch (_that) {
case _SustainabilityInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SustainabilityInfo value)?  $default,){
final _that = this;
switch (_that) {
case _SustainabilityInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int carbonScoreGrams,  int recyclabilityPercent,  bool isVerified,  DateTime? verifiedAt,  String? certifierName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SustainabilityInfo() when $default != null:
return $default(_that.carbonScoreGrams,_that.recyclabilityPercent,_that.isVerified,_that.verifiedAt,_that.certifierName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int carbonScoreGrams,  int recyclabilityPercent,  bool isVerified,  DateTime? verifiedAt,  String? certifierName)  $default,) {final _that = this;
switch (_that) {
case _SustainabilityInfo():
return $default(_that.carbonScoreGrams,_that.recyclabilityPercent,_that.isVerified,_that.verifiedAt,_that.certifierName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int carbonScoreGrams,  int recyclabilityPercent,  bool isVerified,  DateTime? verifiedAt,  String? certifierName)?  $default,) {final _that = this;
switch (_that) {
case _SustainabilityInfo() when $default != null:
return $default(_that.carbonScoreGrams,_that.recyclabilityPercent,_that.isVerified,_that.verifiedAt,_that.certifierName);case _:
  return null;

}
}

}

/// @nodoc


class _SustainabilityInfo implements SustainabilityInfo {
  const _SustainabilityInfo({required this.carbonScoreGrams, required this.recyclabilityPercent, required this.isVerified, this.verifiedAt, this.certifierName});
  

@override final  int carbonScoreGrams;
@override final  int recyclabilityPercent;
@override final  bool isVerified;
@override final  DateTime? verifiedAt;
@override final  String? certifierName;

/// Create a copy of SustainabilityInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SustainabilityInfoCopyWith<_SustainabilityInfo> get copyWith => __$SustainabilityInfoCopyWithImpl<_SustainabilityInfo>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SustainabilityInfo&&(identical(other.carbonScoreGrams, carbonScoreGrams) || other.carbonScoreGrams == carbonScoreGrams)&&(identical(other.recyclabilityPercent, recyclabilityPercent) || other.recyclabilityPercent == recyclabilityPercent)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.verifiedAt, verifiedAt) || other.verifiedAt == verifiedAt)&&(identical(other.certifierName, certifierName) || other.certifierName == certifierName));
}


@override
int get hashCode {
    return Object.hash(runtimeType,carbonScoreGrams,recyclabilityPercent,isVerified,verifiedAt,certifierName);
}

@override
String toString() {
    return 'SustainabilityInfo(carbonScoreGrams: $carbonScoreGrams, recyclabilityPercent: $recyclabilityPercent, isVerified: $isVerified, verifiedAt: $verifiedAt, certifierName: $certifierName)';
}


}

/// @nodoc
abstract mixin class _$SustainabilityInfoCopyWith<$Res> implements $SustainabilityInfoCopyWith<$Res> {
  factory _$SustainabilityInfoCopyWith(_SustainabilityInfo value, $Res Function(_SustainabilityInfo) _then) = __$SustainabilityInfoCopyWithImpl;
@override @useResult
$Res call({
 int carbonScoreGrams, int recyclabilityPercent, bool isVerified, DateTime? verifiedAt, String? certifierName
});




}
/// @nodoc
class __$SustainabilityInfoCopyWithImpl<$Res>
    implements _$SustainabilityInfoCopyWith<$Res> {
  __$SustainabilityInfoCopyWithImpl(this._self, this._then);

  final _SustainabilityInfo _self;
  final $Res Function(_SustainabilityInfo) _then;

/// Create a copy of SustainabilityInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? carbonScoreGrams = null,Object? recyclabilityPercent = null,Object? isVerified = null,Object? verifiedAt = freezed,Object? certifierName = freezed,}) {
  return _then(_SustainabilityInfo(
carbonScoreGrams: null == carbonScoreGrams ? _self.carbonScoreGrams : carbonScoreGrams // ignore: cast_nullable_to_non_nullable
as int,recyclabilityPercent: null == recyclabilityPercent ? _self.recyclabilityPercent : recyclabilityPercent // ignore: cast_nullable_to_non_nullable
as int,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,verifiedAt: freezed == verifiedAt ? _self.verifiedAt : verifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,certifierName: freezed == certifierName ? _self.certifierName : certifierName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
