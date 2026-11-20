// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'brand_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BrandSummary {

 String get id; String get name; int get productCount; DateTime get createdAt; String? get description; String? get logoUrl;
/// Create a copy of BrandSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BrandSummaryCopyWith<BrandSummary> get copyWith => _$BrandSummaryCopyWithImpl<BrandSummary>(this as BrandSummary, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BrandSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BrandSummary&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.productCount, _this.productCount) || other.productCount == _this.productCount)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.logoUrl, _this.logoUrl) || other.logoUrl == _this.logoUrl));
}


@override
int get hashCode {
  final _this = this as BrandSummary;
  return Object.hash(runtimeType,_this.id,_this.name,_this.productCount,_this.createdAt,_this.description,_this.logoUrl);
}

@override
String toString() {
  final _this = this as BrandSummary;
  return 'BrandSummary(id: ${_this.id}, name: ${_this.name}, productCount: ${_this.productCount}, createdAt: ${_this.createdAt}, description: ${_this.description}, logoUrl: ${_this.logoUrl})';
}


}

/// @nodoc
abstract mixin class $BrandSummaryCopyWith<$Res>  {
  factory $BrandSummaryCopyWith(BrandSummary value, $Res Function(BrandSummary) _then) = _$BrandSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String name, int productCount, DateTime createdAt, String? description, String? logoUrl
});




}
/// @nodoc
class _$BrandSummaryCopyWithImpl<$Res>
    implements $BrandSummaryCopyWith<$Res> {
  _$BrandSummaryCopyWithImpl(this._self, this._then);

  final BrandSummary _self;
  final $Res Function(BrandSummary) _then;

/// Create a copy of BrandSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? productCount = null,Object? createdAt = null,Object? description = freezed,Object? logoUrl = freezed,}) {
  return _then(BrandSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,productCount: null == productCount ? _self.productCount : productCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BrandSummary].
extension BrandSummaryPatterns on BrandSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BrandSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BrandSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BrandSummary value)  $default,){
final _that = this;
switch (_that) {
case _BrandSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BrandSummary value)?  $default,){
final _that = this;
switch (_that) {
case _BrandSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int productCount,  DateTime createdAt,  String? description,  String? logoUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BrandSummary() when $default != null:
return $default(_that.id,_that.name,_that.productCount,_that.createdAt,_that.description,_that.logoUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int productCount,  DateTime createdAt,  String? description,  String? logoUrl)  $default,) {final _that = this;
switch (_that) {
case _BrandSummary():
return $default(_that.id,_that.name,_that.productCount,_that.createdAt,_that.description,_that.logoUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int productCount,  DateTime createdAt,  String? description,  String? logoUrl)?  $default,) {final _that = this;
switch (_that) {
case _BrandSummary() when $default != null:
return $default(_that.id,_that.name,_that.productCount,_that.createdAt,_that.description,_that.logoUrl);case _:
  return null;

}
}

}

/// @nodoc


class _BrandSummary implements BrandSummary {
  const _BrandSummary({required this.id, required this.name, required this.productCount, required this.createdAt, this.description, this.logoUrl});
  

@override final  String id;
@override final  String name;
@override final  int productCount;
@override final  DateTime createdAt;
@override final  String? description;
@override final  String? logoUrl;

/// Create a copy of BrandSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BrandSummaryCopyWith<_BrandSummary> get copyWith => __$BrandSummaryCopyWithImpl<_BrandSummary>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BrandSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.productCount, productCount) || other.productCount == productCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.description, description) || other.description == description)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,productCount,createdAt,description,logoUrl);
}

@override
String toString() {
    return 'BrandSummary(id: $id, name: $name, productCount: $productCount, createdAt: $createdAt, description: $description, logoUrl: $logoUrl)';
}


}

/// @nodoc
abstract mixin class _$BrandSummaryCopyWith<$Res> implements $BrandSummaryCopyWith<$Res> {
  factory _$BrandSummaryCopyWith(_BrandSummary value, $Res Function(_BrandSummary) _then) = __$BrandSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int productCount, DateTime createdAt, String? description, String? logoUrl
});




}
/// @nodoc
class __$BrandSummaryCopyWithImpl<$Res>
    implements _$BrandSummaryCopyWith<$Res> {
  __$BrandSummaryCopyWithImpl(this._self, this._then);

  final _BrandSummary _self;
  final $Res Function(_BrandSummary) _then;

/// Create a copy of BrandSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? productCount = null,Object? createdAt = null,Object? description = freezed,Object? logoUrl = freezed,}) {
  return _then(_BrandSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,productCount: null == productCount ? _self.productCount : productCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
