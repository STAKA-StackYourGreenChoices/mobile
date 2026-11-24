// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_brand.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReviewBrand {

 BrandApplication get application; int? get memberCount; bool get hasDocument; DateTime? get reviewedAt;
/// Create a copy of ReviewBrand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewBrandCopyWith<ReviewBrand> get copyWith => _$ReviewBrandCopyWithImpl<ReviewBrand>(this as ReviewBrand, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ReviewBrand;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewBrand&&(identical(other.application, _this.application) || other.application == _this.application)&&(identical(other.memberCount, _this.memberCount) || other.memberCount == _this.memberCount)&&(identical(other.hasDocument, _this.hasDocument) || other.hasDocument == _this.hasDocument)&&(identical(other.reviewedAt, _this.reviewedAt) || other.reviewedAt == _this.reviewedAt));
}


@override
int get hashCode {
  final _this = this as ReviewBrand;
  return Object.hash(runtimeType,_this.application,_this.memberCount,_this.hasDocument,_this.reviewedAt);
}

@override
String toString() {
  final _this = this as ReviewBrand;
  return 'ReviewBrand(application: ${_this.application}, memberCount: ${_this.memberCount}, hasDocument: ${_this.hasDocument}, reviewedAt: ${_this.reviewedAt})';
}


}

/// @nodoc
abstract mixin class $ReviewBrandCopyWith<$Res>  {
  factory $ReviewBrandCopyWith(ReviewBrand value, $Res Function(ReviewBrand) _then) = _$ReviewBrandCopyWithImpl;
@useResult
$Res call({
 BrandApplication application, int? memberCount, bool hasDocument, DateTime? reviewedAt
});


$BrandApplicationCopyWith<$Res> get application;

}
/// @nodoc
class _$ReviewBrandCopyWithImpl<$Res>
    implements $ReviewBrandCopyWith<$Res> {
  _$ReviewBrandCopyWithImpl(this._self, this._then);

  final ReviewBrand _self;
  final $Res Function(ReviewBrand) _then;

/// Create a copy of ReviewBrand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? application = null,Object? memberCount = freezed,Object? hasDocument = null,Object? reviewedAt = freezed,}) {
  return _then(ReviewBrand(
application: null == application ? _self.application : application // ignore: cast_nullable_to_non_nullable
as BrandApplication,memberCount: freezed == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int?,hasDocument: null == hasDocument ? _self.hasDocument : hasDocument // ignore: cast_nullable_to_non_nullable
as bool,reviewedAt: freezed == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of ReviewBrand
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BrandApplicationCopyWith<$Res> get application {
  
  return $BrandApplicationCopyWith<$Res>(_self.application, (value) {
    return _then(_self.copyWith(application: value));
  });
}
}


/// Adds pattern-matching-related methods to [ReviewBrand].
extension ReviewBrandPatterns on ReviewBrand {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReviewBrand value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReviewBrand() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReviewBrand value)  $default,){
final _that = this;
switch (_that) {
case _ReviewBrand():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReviewBrand value)?  $default,){
final _that = this;
switch (_that) {
case _ReviewBrand() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BrandApplication application,  int? memberCount,  bool hasDocument,  DateTime? reviewedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReviewBrand() when $default != null:
return $default(_that.application,_that.memberCount,_that.hasDocument,_that.reviewedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BrandApplication application,  int? memberCount,  bool hasDocument,  DateTime? reviewedAt)  $default,) {final _that = this;
switch (_that) {
case _ReviewBrand():
return $default(_that.application,_that.memberCount,_that.hasDocument,_that.reviewedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BrandApplication application,  int? memberCount,  bool hasDocument,  DateTime? reviewedAt)?  $default,) {final _that = this;
switch (_that) {
case _ReviewBrand() when $default != null:
return $default(_that.application,_that.memberCount,_that.hasDocument,_that.reviewedAt);case _:
  return null;

}
}

}

/// @nodoc


class _ReviewBrand extends ReviewBrand {
  const _ReviewBrand({required this.application, this.memberCount, this.hasDocument = false, this.reviewedAt}): super._();
  

@override final  BrandApplication application;
@override final  int? memberCount;
@override@JsonKey() final  bool hasDocument;
@override final  DateTime? reviewedAt;

/// Create a copy of ReviewBrand
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewBrandCopyWith<_ReviewBrand> get copyWith => __$ReviewBrandCopyWithImpl<_ReviewBrand>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReviewBrand&&(identical(other.application, application) || other.application == application)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount)&&(identical(other.hasDocument, hasDocument) || other.hasDocument == hasDocument)&&(identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,application,memberCount,hasDocument,reviewedAt);
}

@override
String toString() {
    return 'ReviewBrand(application: $application, memberCount: $memberCount, hasDocument: $hasDocument, reviewedAt: $reviewedAt)';
}


}

/// @nodoc
abstract mixin class _$ReviewBrandCopyWith<$Res> implements $ReviewBrandCopyWith<$Res> {
  factory _$ReviewBrandCopyWith(_ReviewBrand value, $Res Function(_ReviewBrand) _then) = __$ReviewBrandCopyWithImpl;
@override @useResult
$Res call({
 BrandApplication application, int? memberCount, bool hasDocument, DateTime? reviewedAt
});


@override $BrandApplicationCopyWith<$Res> get application;

}
/// @nodoc
class __$ReviewBrandCopyWithImpl<$Res>
    implements _$ReviewBrandCopyWith<$Res> {
  __$ReviewBrandCopyWithImpl(this._self, this._then);

  final _ReviewBrand _self;
  final $Res Function(_ReviewBrand) _then;

/// Create a copy of ReviewBrand
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? application = null,Object? memberCount = freezed,Object? hasDocument = null,Object? reviewedAt = freezed,}) {
  return _then(_ReviewBrand(
application: null == application ? _self.application : application // ignore: cast_nullable_to_non_nullable
as BrandApplication,memberCount: freezed == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int?,hasDocument: null == hasDocument ? _self.hasDocument : hasDocument // ignore: cast_nullable_to_non_nullable
as bool,reviewedAt: freezed == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of ReviewBrand
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BrandApplicationCopyWith<$Res> get application {
  
  return $BrandApplicationCopyWith<$Res>(_self.application, (value) {
    return _then(_self.copyWith(application: value));
  });
}
}

// dart format on
