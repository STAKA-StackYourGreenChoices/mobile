// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Product {

 String get id; String get gtin; String get sku; String get name; Brand get brand; DateTime get createdAt; DateTime get updatedAt; String? get description; String? get imageUrl; SustainabilityInfo? get sustainabilityInfo;
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCopyWith<Product> get copyWith => _$ProductCopyWithImpl<Product>(this as Product, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Product;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Product&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.gtin, _this.gtin) || other.gtin == _this.gtin)&&(identical(other.sku, _this.sku) || other.sku == _this.sku)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.brand, _this.brand) || other.brand == _this.brand)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.imageUrl, _this.imageUrl) || other.imageUrl == _this.imageUrl)&&(identical(other.sustainabilityInfo, _this.sustainabilityInfo) || other.sustainabilityInfo == _this.sustainabilityInfo));
}


@override
int get hashCode {
  final _this = this as Product;
  return Object.hash(runtimeType,_this.id,_this.gtin,_this.sku,_this.name,_this.brand,_this.createdAt,_this.updatedAt,_this.description,_this.imageUrl,_this.sustainabilityInfo);
}

@override
String toString() {
  final _this = this as Product;
  return 'Product(id: ${_this.id}, gtin: ${_this.gtin}, sku: ${_this.sku}, name: ${_this.name}, brand: ${_this.brand}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, description: ${_this.description}, imageUrl: ${_this.imageUrl}, sustainabilityInfo: ${_this.sustainabilityInfo})';
}


}

/// @nodoc
abstract mixin class $ProductCopyWith<$Res>  {
  factory $ProductCopyWith(Product value, $Res Function(Product) _then) = _$ProductCopyWithImpl;
@useResult
$Res call({
 String id, String gtin, String sku, String name, Brand brand, DateTime createdAt, DateTime updatedAt, String? description, String? imageUrl, SustainabilityInfo? sustainabilityInfo
});


$BrandCopyWith<$Res> get brand;$SustainabilityInfoCopyWith<$Res>? get sustainabilityInfo;

}
/// @nodoc
class _$ProductCopyWithImpl<$Res>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._self, this._then);

  final Product _self;
  final $Res Function(Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? gtin = null,Object? sku = null,Object? name = null,Object? brand = null,Object? createdAt = null,Object? updatedAt = null,Object? description = freezed,Object? imageUrl = freezed,Object? sustainabilityInfo = freezed,}) {
  return _then(Product(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,gtin: null == gtin ? _self.gtin : gtin // ignore: cast_nullable_to_non_nullable
as String,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as Brand,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,sustainabilityInfo: freezed == sustainabilityInfo ? _self.sustainabilityInfo : sustainabilityInfo // ignore: cast_nullable_to_non_nullable
as SustainabilityInfo?,
  ));
}
/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BrandCopyWith<$Res> get brand {
  
  return $BrandCopyWith<$Res>(_self.brand, (value) {
    return _then(_self.copyWith(brand: value));
  });
}/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SustainabilityInfoCopyWith<$Res>? get sustainabilityInfo {
    if (_self.sustainabilityInfo == null) {
    return null;
  }

  return $SustainabilityInfoCopyWith<$Res>(_self.sustainabilityInfo!, (value) {
    return _then(_self.copyWith(sustainabilityInfo: value));
  });
}
}


/// Adds pattern-matching-related methods to [Product].
extension ProductPatterns on Product {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Product value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Product value)  $default,){
final _that = this;
switch (_that) {
case _Product():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Product value)?  $default,){
final _that = this;
switch (_that) {
case _Product() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String gtin,  String sku,  String name,  Brand brand,  DateTime createdAt,  DateTime updatedAt,  String? description,  String? imageUrl,  SustainabilityInfo? sustainabilityInfo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.gtin,_that.sku,_that.name,_that.brand,_that.createdAt,_that.updatedAt,_that.description,_that.imageUrl,_that.sustainabilityInfo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String gtin,  String sku,  String name,  Brand brand,  DateTime createdAt,  DateTime updatedAt,  String? description,  String? imageUrl,  SustainabilityInfo? sustainabilityInfo)  $default,) {final _that = this;
switch (_that) {
case _Product():
return $default(_that.id,_that.gtin,_that.sku,_that.name,_that.brand,_that.createdAt,_that.updatedAt,_that.description,_that.imageUrl,_that.sustainabilityInfo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String gtin,  String sku,  String name,  Brand brand,  DateTime createdAt,  DateTime updatedAt,  String? description,  String? imageUrl,  SustainabilityInfo? sustainabilityInfo)?  $default,) {final _that = this;
switch (_that) {
case _Product() when $default != null:
return $default(_that.id,_that.gtin,_that.sku,_that.name,_that.brand,_that.createdAt,_that.updatedAt,_that.description,_that.imageUrl,_that.sustainabilityInfo);case _:
  return null;

}
}

}

/// @nodoc


class _Product implements Product {
  const _Product({required this.id, required this.gtin, required this.sku, required this.name, required this.brand, required this.createdAt, required this.updatedAt, this.description, this.imageUrl, this.sustainabilityInfo});
  

@override final  String id;
@override final  String gtin;
@override final  String sku;
@override final  String name;
@override final  Brand brand;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String? description;
@override final  String? imageUrl;
@override final  SustainabilityInfo? sustainabilityInfo;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCopyWith<_Product> get copyWith => __$ProductCopyWithImpl<_Product>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Product&&(identical(other.id, id) || other.id == id)&&(identical(other.gtin, gtin) || other.gtin == gtin)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.description, description) || other.description == description)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.sustainabilityInfo, sustainabilityInfo) || other.sustainabilityInfo == sustainabilityInfo));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,gtin,sku,name,brand,createdAt,updatedAt,description,imageUrl,sustainabilityInfo);
}

@override
String toString() {
    return 'Product(id: $id, gtin: $gtin, sku: $sku, name: $name, brand: $brand, createdAt: $createdAt, updatedAt: $updatedAt, description: $description, imageUrl: $imageUrl, sustainabilityInfo: $sustainabilityInfo)';
}


}

/// @nodoc
abstract mixin class _$ProductCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$ProductCopyWith(_Product value, $Res Function(_Product) _then) = __$ProductCopyWithImpl;
@override @useResult
$Res call({
 String id, String gtin, String sku, String name, Brand brand, DateTime createdAt, DateTime updatedAt, String? description, String? imageUrl, SustainabilityInfo? sustainabilityInfo
});


@override $BrandCopyWith<$Res> get brand;@override $SustainabilityInfoCopyWith<$Res>? get sustainabilityInfo;

}
/// @nodoc
class __$ProductCopyWithImpl<$Res>
    implements _$ProductCopyWith<$Res> {
  __$ProductCopyWithImpl(this._self, this._then);

  final _Product _self;
  final $Res Function(_Product) _then;

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? gtin = null,Object? sku = null,Object? name = null,Object? brand = null,Object? createdAt = null,Object? updatedAt = null,Object? description = freezed,Object? imageUrl = freezed,Object? sustainabilityInfo = freezed,}) {
  return _then(_Product(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,gtin: null == gtin ? _self.gtin : gtin // ignore: cast_nullable_to_non_nullable
as String,sku: null == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as Brand,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,sustainabilityInfo: freezed == sustainabilityInfo ? _self.sustainabilityInfo : sustainabilityInfo // ignore: cast_nullable_to_non_nullable
as SustainabilityInfo?,
  ));
}

/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BrandCopyWith<$Res> get brand {
  
  return $BrandCopyWith<$Res>(_self.brand, (value) {
    return _then(_self.copyWith(brand: value));
  });
}/// Create a copy of Product
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SustainabilityInfoCopyWith<$Res>? get sustainabilityInfo {
    if (_self.sustainabilityInfo == null) {
    return null;
  }

  return $SustainabilityInfoCopyWith<$Res>(_self.sustainabilityInfo!, (value) {
    return _then(_self.copyWith(sustainabilityInfo: value));
  });
}
}

// dart format on
