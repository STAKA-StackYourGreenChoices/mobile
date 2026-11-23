// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'brand_membership.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BrandMembership {

 String get id; String get name; BrandRole get role; BrandStatus get status; String? get logoUrl;
/// Create a copy of BrandMembership
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BrandMembershipCopyWith<BrandMembership> get copyWith => _$BrandMembershipCopyWithImpl<BrandMembership>(this as BrandMembership, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BrandMembership;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BrandMembership&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.logoUrl, _this.logoUrl) || other.logoUrl == _this.logoUrl));
}


@override
int get hashCode {
  final _this = this as BrandMembership;
  return Object.hash(runtimeType,_this.id,_this.name,_this.role,_this.status,_this.logoUrl);
}

@override
String toString() {
  final _this = this as BrandMembership;
  return 'BrandMembership(id: ${_this.id}, name: ${_this.name}, role: ${_this.role}, status: ${_this.status}, logoUrl: ${_this.logoUrl})';
}


}

/// @nodoc
abstract mixin class $BrandMembershipCopyWith<$Res>  {
  factory $BrandMembershipCopyWith(BrandMembership value, $Res Function(BrandMembership) _then) = _$BrandMembershipCopyWithImpl;
@useResult
$Res call({
 String id, String name, BrandRole role, BrandStatus status, String? logoUrl
});




}
/// @nodoc
class _$BrandMembershipCopyWithImpl<$Res>
    implements $BrandMembershipCopyWith<$Res> {
  _$BrandMembershipCopyWithImpl(this._self, this._then);

  final BrandMembership _self;
  final $Res Function(BrandMembership) _then;

/// Create a copy of BrandMembership
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? role = null,Object? status = null,Object? logoUrl = freezed,}) {
  return _then(BrandMembership(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as BrandRole,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BrandStatus,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BrandMembership].
extension BrandMembershipPatterns on BrandMembership {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BrandMembership value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BrandMembership() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BrandMembership value)  $default,){
final _that = this;
switch (_that) {
case _BrandMembership():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BrandMembership value)?  $default,){
final _that = this;
switch (_that) {
case _BrandMembership() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  BrandRole role,  BrandStatus status,  String? logoUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BrandMembership() when $default != null:
return $default(_that.id,_that.name,_that.role,_that.status,_that.logoUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  BrandRole role,  BrandStatus status,  String? logoUrl)  $default,) {final _that = this;
switch (_that) {
case _BrandMembership():
return $default(_that.id,_that.name,_that.role,_that.status,_that.logoUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  BrandRole role,  BrandStatus status,  String? logoUrl)?  $default,) {final _that = this;
switch (_that) {
case _BrandMembership() when $default != null:
return $default(_that.id,_that.name,_that.role,_that.status,_that.logoUrl);case _:
  return null;

}
}

}

/// @nodoc


class _BrandMembership extends BrandMembership {
  const _BrandMembership({required this.id, required this.name, required this.role, required this.status, this.logoUrl}): super._();
  

@override final  String id;
@override final  String name;
@override final  BrandRole role;
@override final  BrandStatus status;
@override final  String? logoUrl;

/// Create a copy of BrandMembership
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BrandMembershipCopyWith<_BrandMembership> get copyWith => __$BrandMembershipCopyWithImpl<_BrandMembership>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BrandMembership&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role)&&(identical(other.status, status) || other.status == status)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,role,status,logoUrl);
}

@override
String toString() {
    return 'BrandMembership(id: $id, name: $name, role: $role, status: $status, logoUrl: $logoUrl)';
}


}

/// @nodoc
abstract mixin class _$BrandMembershipCopyWith<$Res> implements $BrandMembershipCopyWith<$Res> {
  factory _$BrandMembershipCopyWith(_BrandMembership value, $Res Function(_BrandMembership) _then) = __$BrandMembershipCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, BrandRole role, BrandStatus status, String? logoUrl
});




}
/// @nodoc
class __$BrandMembershipCopyWithImpl<$Res>
    implements _$BrandMembershipCopyWith<$Res> {
  __$BrandMembershipCopyWithImpl(this._self, this._then);

  final _BrandMembership _self;
  final $Res Function(_BrandMembership) _then;

/// Create a copy of BrandMembership
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? role = null,Object? status = null,Object? logoUrl = freezed,}) {
  return _then(_BrandMembership(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as BrandRole,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BrandStatus,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
