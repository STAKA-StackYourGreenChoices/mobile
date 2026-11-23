// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'brand_application.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BrandApplication {

 String get id; String get name; String get legalName; BrandApplicationStatus get status;/// Why STAKA rejected or paused the brand.
 String? get statusReason; String? get description; String? get websiteUrl; String? get gstin; String? get contactEmail;/// E.164.
 String? get contactPhone; String? get logoUrl;/// The listed brand this application claims ("My brand is already on
/// STAKA").
 String? get existingBrandId; DateTime? get appliedAt;
/// Create a copy of BrandApplication
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BrandApplicationCopyWith<BrandApplication> get copyWith => _$BrandApplicationCopyWithImpl<BrandApplication>(this as BrandApplication, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BrandApplication;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BrandApplication&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.legalName, _this.legalName) || other.legalName == _this.legalName)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.statusReason, _this.statusReason) || other.statusReason == _this.statusReason)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.websiteUrl, _this.websiteUrl) || other.websiteUrl == _this.websiteUrl)&&(identical(other.gstin, _this.gstin) || other.gstin == _this.gstin)&&(identical(other.contactEmail, _this.contactEmail) || other.contactEmail == _this.contactEmail)&&(identical(other.contactPhone, _this.contactPhone) || other.contactPhone == _this.contactPhone)&&(identical(other.logoUrl, _this.logoUrl) || other.logoUrl == _this.logoUrl)&&(identical(other.existingBrandId, _this.existingBrandId) || other.existingBrandId == _this.existingBrandId)&&(identical(other.appliedAt, _this.appliedAt) || other.appliedAt == _this.appliedAt));
}


@override
int get hashCode {
  final _this = this as BrandApplication;
  return Object.hash(runtimeType,_this.id,_this.name,_this.legalName,_this.status,_this.statusReason,_this.description,_this.websiteUrl,_this.gstin,_this.contactEmail,_this.contactPhone,_this.logoUrl,_this.existingBrandId,_this.appliedAt);
}

@override
String toString() {
  final _this = this as BrandApplication;
  return 'BrandApplication(id: ${_this.id}, name: ${_this.name}, legalName: ${_this.legalName}, status: ${_this.status}, statusReason: ${_this.statusReason}, description: ${_this.description}, websiteUrl: ${_this.websiteUrl}, gstin: ${_this.gstin}, contactEmail: ${_this.contactEmail}, contactPhone: ${_this.contactPhone}, logoUrl: ${_this.logoUrl}, existingBrandId: ${_this.existingBrandId}, appliedAt: ${_this.appliedAt})';
}


}

/// @nodoc
abstract mixin class $BrandApplicationCopyWith<$Res>  {
  factory $BrandApplicationCopyWith(BrandApplication value, $Res Function(BrandApplication) _then) = _$BrandApplicationCopyWithImpl;
@useResult
$Res call({
 String id, String name, String legalName, BrandApplicationStatus status, String? statusReason, String? description, String? websiteUrl, String? gstin, String? contactEmail, String? contactPhone, String? logoUrl, String? existingBrandId, DateTime? appliedAt
});




}
/// @nodoc
class _$BrandApplicationCopyWithImpl<$Res>
    implements $BrandApplicationCopyWith<$Res> {
  _$BrandApplicationCopyWithImpl(this._self, this._then);

  final BrandApplication _self;
  final $Res Function(BrandApplication) _then;

/// Create a copy of BrandApplication
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? legalName = null,Object? status = null,Object? statusReason = freezed,Object? description = freezed,Object? websiteUrl = freezed,Object? gstin = freezed,Object? contactEmail = freezed,Object? contactPhone = freezed,Object? logoUrl = freezed,Object? existingBrandId = freezed,Object? appliedAt = freezed,}) {
  return _then(BrandApplication(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,legalName: null == legalName ? _self.legalName : legalName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BrandApplicationStatus,statusReason: freezed == statusReason ? _self.statusReason : statusReason // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,websiteUrl: freezed == websiteUrl ? _self.websiteUrl : websiteUrl // ignore: cast_nullable_to_non_nullable
as String?,gstin: freezed == gstin ? _self.gstin : gstin // ignore: cast_nullable_to_non_nullable
as String?,contactEmail: freezed == contactEmail ? _self.contactEmail : contactEmail // ignore: cast_nullable_to_non_nullable
as String?,contactPhone: freezed == contactPhone ? _self.contactPhone : contactPhone // ignore: cast_nullable_to_non_nullable
as String?,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,existingBrandId: freezed == existingBrandId ? _self.existingBrandId : existingBrandId // ignore: cast_nullable_to_non_nullable
as String?,appliedAt: freezed == appliedAt ? _self.appliedAt : appliedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BrandApplication].
extension BrandApplicationPatterns on BrandApplication {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BrandApplication value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BrandApplication() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BrandApplication value)  $default,){
final _that = this;
switch (_that) {
case _BrandApplication():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BrandApplication value)?  $default,){
final _that = this;
switch (_that) {
case _BrandApplication() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String legalName,  BrandApplicationStatus status,  String? statusReason,  String? description,  String? websiteUrl,  String? gstin,  String? contactEmail,  String? contactPhone,  String? logoUrl,  String? existingBrandId,  DateTime? appliedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BrandApplication() when $default != null:
return $default(_that.id,_that.name,_that.legalName,_that.status,_that.statusReason,_that.description,_that.websiteUrl,_that.gstin,_that.contactEmail,_that.contactPhone,_that.logoUrl,_that.existingBrandId,_that.appliedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String legalName,  BrandApplicationStatus status,  String? statusReason,  String? description,  String? websiteUrl,  String? gstin,  String? contactEmail,  String? contactPhone,  String? logoUrl,  String? existingBrandId,  DateTime? appliedAt)  $default,) {final _that = this;
switch (_that) {
case _BrandApplication():
return $default(_that.id,_that.name,_that.legalName,_that.status,_that.statusReason,_that.description,_that.websiteUrl,_that.gstin,_that.contactEmail,_that.contactPhone,_that.logoUrl,_that.existingBrandId,_that.appliedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String legalName,  BrandApplicationStatus status,  String? statusReason,  String? description,  String? websiteUrl,  String? gstin,  String? contactEmail,  String? contactPhone,  String? logoUrl,  String? existingBrandId,  DateTime? appliedAt)?  $default,) {final _that = this;
switch (_that) {
case _BrandApplication() when $default != null:
return $default(_that.id,_that.name,_that.legalName,_that.status,_that.statusReason,_that.description,_that.websiteUrl,_that.gstin,_that.contactEmail,_that.contactPhone,_that.logoUrl,_that.existingBrandId,_that.appliedAt);case _:
  return null;

}
}

}

/// @nodoc


class _BrandApplication implements BrandApplication {
  const _BrandApplication({required this.id, required this.name, required this.legalName, required this.status, this.statusReason, this.description, this.websiteUrl, this.gstin, this.contactEmail, this.contactPhone, this.logoUrl, this.existingBrandId, this.appliedAt});
  

@override final  String id;
@override final  String name;
@override final  String legalName;
@override final  BrandApplicationStatus status;
/// Why STAKA rejected or paused the brand.
@override final  String? statusReason;
@override final  String? description;
@override final  String? websiteUrl;
@override final  String? gstin;
@override final  String? contactEmail;
/// E.164.
@override final  String? contactPhone;
@override final  String? logoUrl;
/// The listed brand this application claims ("My brand is already on
/// STAKA").
@override final  String? existingBrandId;
@override final  DateTime? appliedAt;

/// Create a copy of BrandApplication
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BrandApplicationCopyWith<_BrandApplication> get copyWith => __$BrandApplicationCopyWithImpl<_BrandApplication>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BrandApplication&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.legalName, legalName) || other.legalName == legalName)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusReason, statusReason) || other.statusReason == statusReason)&&(identical(other.description, description) || other.description == description)&&(identical(other.websiteUrl, websiteUrl) || other.websiteUrl == websiteUrl)&&(identical(other.gstin, gstin) || other.gstin == gstin)&&(identical(other.contactEmail, contactEmail) || other.contactEmail == contactEmail)&&(identical(other.contactPhone, contactPhone) || other.contactPhone == contactPhone)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.existingBrandId, existingBrandId) || other.existingBrandId == existingBrandId)&&(identical(other.appliedAt, appliedAt) || other.appliedAt == appliedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,legalName,status,statusReason,description,websiteUrl,gstin,contactEmail,contactPhone,logoUrl,existingBrandId,appliedAt);
}

@override
String toString() {
    return 'BrandApplication(id: $id, name: $name, legalName: $legalName, status: $status, statusReason: $statusReason, description: $description, websiteUrl: $websiteUrl, gstin: $gstin, contactEmail: $contactEmail, contactPhone: $contactPhone, logoUrl: $logoUrl, existingBrandId: $existingBrandId, appliedAt: $appliedAt)';
}


}

/// @nodoc
abstract mixin class _$BrandApplicationCopyWith<$Res> implements $BrandApplicationCopyWith<$Res> {
  factory _$BrandApplicationCopyWith(_BrandApplication value, $Res Function(_BrandApplication) _then) = __$BrandApplicationCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String legalName, BrandApplicationStatus status, String? statusReason, String? description, String? websiteUrl, String? gstin, String? contactEmail, String? contactPhone, String? logoUrl, String? existingBrandId, DateTime? appliedAt
});




}
/// @nodoc
class __$BrandApplicationCopyWithImpl<$Res>
    implements _$BrandApplicationCopyWith<$Res> {
  __$BrandApplicationCopyWithImpl(this._self, this._then);

  final _BrandApplication _self;
  final $Res Function(_BrandApplication) _then;

/// Create a copy of BrandApplication
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? legalName = null,Object? status = null,Object? statusReason = freezed,Object? description = freezed,Object? websiteUrl = freezed,Object? gstin = freezed,Object? contactEmail = freezed,Object? contactPhone = freezed,Object? logoUrl = freezed,Object? existingBrandId = freezed,Object? appliedAt = freezed,}) {
  return _then(_BrandApplication(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,legalName: null == legalName ? _self.legalName : legalName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BrandApplicationStatus,statusReason: freezed == statusReason ? _self.statusReason : statusReason // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,websiteUrl: freezed == websiteUrl ? _self.websiteUrl : websiteUrl // ignore: cast_nullable_to_non_nullable
as String?,gstin: freezed == gstin ? _self.gstin : gstin // ignore: cast_nullable_to_non_nullable
as String?,contactEmail: freezed == contactEmail ? _self.contactEmail : contactEmail // ignore: cast_nullable_to_non_nullable
as String?,contactPhone: freezed == contactPhone ? _self.contactPhone : contactPhone // ignore: cast_nullable_to_non_nullable
as String?,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,existingBrandId: freezed == existingBrandId ? _self.existingBrandId : existingBrandId // ignore: cast_nullable_to_non_nullable
as String?,appliedAt: freezed == appliedAt ? _self.appliedAt : appliedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
