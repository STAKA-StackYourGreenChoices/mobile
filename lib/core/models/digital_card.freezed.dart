// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'digital_card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DigitalCard {

 String get id; DateTime get createdAt; String get ownerName; Product get product; Ownership get ownership;/// Present while the tag is publicly shared.
 ShareLink? get share;
/// Create a copy of DigitalCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DigitalCardCopyWith<DigitalCard> get copyWith => _$DigitalCardCopyWithImpl<DigitalCard>(this as DigitalCard, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DigitalCard;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DigitalCard&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.ownerName, _this.ownerName) || other.ownerName == _this.ownerName)&&(identical(other.product, _this.product) || other.product == _this.product)&&(identical(other.ownership, _this.ownership) || other.ownership == _this.ownership)&&(identical(other.share, _this.share) || other.share == _this.share));
}


@override
int get hashCode {
  final _this = this as DigitalCard;
  return Object.hash(runtimeType,_this.id,_this.createdAt,_this.ownerName,_this.product,_this.ownership,_this.share);
}

@override
String toString() {
  final _this = this as DigitalCard;
  return 'DigitalCard(id: ${_this.id}, createdAt: ${_this.createdAt}, ownerName: ${_this.ownerName}, product: ${_this.product}, ownership: ${_this.ownership}, share: ${_this.share})';
}


}

/// @nodoc
abstract mixin class $DigitalCardCopyWith<$Res>  {
  factory $DigitalCardCopyWith(DigitalCard value, $Res Function(DigitalCard) _then) = _$DigitalCardCopyWithImpl;
@useResult
$Res call({
 String id, DateTime createdAt, String ownerName, Product product, Ownership ownership, ShareLink? share
});


$ProductCopyWith<$Res> get product;$OwnershipCopyWith<$Res> get ownership;$ShareLinkCopyWith<$Res>? get share;

}
/// @nodoc
class _$DigitalCardCopyWithImpl<$Res>
    implements $DigitalCardCopyWith<$Res> {
  _$DigitalCardCopyWithImpl(this._self, this._then);

  final DigitalCard _self;
  final $Res Function(DigitalCard) _then;

/// Create a copy of DigitalCard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = null,Object? ownerName = null,Object? product = null,Object? ownership = null,Object? share = freezed,}) {
  return _then(DigitalCard(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,ownerName: null == ownerName ? _self.ownerName : ownerName // ignore: cast_nullable_to_non_nullable
as String,product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as Product,ownership: null == ownership ? _self.ownership : ownership // ignore: cast_nullable_to_non_nullable
as Ownership,share: freezed == share ? _self.share : share // ignore: cast_nullable_to_non_nullable
as ShareLink?,
  ));
}
/// Create a copy of DigitalCard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductCopyWith<$Res> get product {
  
  return $ProductCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}/// Create a copy of DigitalCard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwnershipCopyWith<$Res> get ownership {
  
  return $OwnershipCopyWith<$Res>(_self.ownership, (value) {
    return _then(_self.copyWith(ownership: value));
  });
}/// Create a copy of DigitalCard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShareLinkCopyWith<$Res>? get share {
    if (_self.share == null) {
    return null;
  }

  return $ShareLinkCopyWith<$Res>(_self.share!, (value) {
    return _then(_self.copyWith(share: value));
  });
}
}


/// Adds pattern-matching-related methods to [DigitalCard].
extension DigitalCardPatterns on DigitalCard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DigitalCard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DigitalCard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DigitalCard value)  $default,){
final _that = this;
switch (_that) {
case _DigitalCard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DigitalCard value)?  $default,){
final _that = this;
switch (_that) {
case _DigitalCard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  String ownerName,  Product product,  Ownership ownership,  ShareLink? share)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DigitalCard() when $default != null:
return $default(_that.id,_that.createdAt,_that.ownerName,_that.product,_that.ownership,_that.share);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  String ownerName,  Product product,  Ownership ownership,  ShareLink? share)  $default,) {final _that = this;
switch (_that) {
case _DigitalCard():
return $default(_that.id,_that.createdAt,_that.ownerName,_that.product,_that.ownership,_that.share);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime createdAt,  String ownerName,  Product product,  Ownership ownership,  ShareLink? share)?  $default,) {final _that = this;
switch (_that) {
case _DigitalCard() when $default != null:
return $default(_that.id,_that.createdAt,_that.ownerName,_that.product,_that.ownership,_that.share);case _:
  return null;

}
}

}

/// @nodoc


class _DigitalCard implements DigitalCard {
  const _DigitalCard({required this.id, required this.createdAt, required this.ownerName, required this.product, required this.ownership, this.share});
  

@override final  String id;
@override final  DateTime createdAt;
@override final  String ownerName;
@override final  Product product;
@override final  Ownership ownership;
/// Present while the tag is publicly shared.
@override final  ShareLink? share;

/// Create a copy of DigitalCard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DigitalCardCopyWith<_DigitalCard> get copyWith => __$DigitalCardCopyWithImpl<_DigitalCard>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DigitalCard&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.ownerName, ownerName) || other.ownerName == ownerName)&&(identical(other.product, product) || other.product == product)&&(identical(other.ownership, ownership) || other.ownership == ownership)&&(identical(other.share, share) || other.share == share));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,createdAt,ownerName,product,ownership,share);
}

@override
String toString() {
    return 'DigitalCard(id: $id, createdAt: $createdAt, ownerName: $ownerName, product: $product, ownership: $ownership, share: $share)';
}


}

/// @nodoc
abstract mixin class _$DigitalCardCopyWith<$Res> implements $DigitalCardCopyWith<$Res> {
  factory _$DigitalCardCopyWith(_DigitalCard value, $Res Function(_DigitalCard) _then) = __$DigitalCardCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime createdAt, String ownerName, Product product, Ownership ownership, ShareLink? share
});


@override $ProductCopyWith<$Res> get product;@override $OwnershipCopyWith<$Res> get ownership;@override $ShareLinkCopyWith<$Res>? get share;

}
/// @nodoc
class __$DigitalCardCopyWithImpl<$Res>
    implements _$DigitalCardCopyWith<$Res> {
  __$DigitalCardCopyWithImpl(this._self, this._then);

  final _DigitalCard _self;
  final $Res Function(_DigitalCard) _then;

/// Create a copy of DigitalCard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? createdAt = null,Object? ownerName = null,Object? product = null,Object? ownership = null,Object? share = freezed,}) {
  return _then(_DigitalCard(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,ownerName: null == ownerName ? _self.ownerName : ownerName // ignore: cast_nullable_to_non_nullable
as String,product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as Product,ownership: null == ownership ? _self.ownership : ownership // ignore: cast_nullable_to_non_nullable
as Ownership,share: freezed == share ? _self.share : share // ignore: cast_nullable_to_non_nullable
as ShareLink?,
  ));
}

/// Create a copy of DigitalCard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductCopyWith<$Res> get product {
  
  return $ProductCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}/// Create a copy of DigitalCard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwnershipCopyWith<$Res> get ownership {
  
  return $OwnershipCopyWith<$Res>(_self.ownership, (value) {
    return _then(_self.copyWith(ownership: value));
  });
}/// Create a copy of DigitalCard
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShareLinkCopyWith<$Res>? get share {
    if (_self.share == null) {
    return null;
  }

  return $ShareLinkCopyWith<$Res>(_self.share!, (value) {
    return _then(_self.copyWith(share: value));
  });
}
}

// dart format on
