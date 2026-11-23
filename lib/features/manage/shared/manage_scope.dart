import 'package:flutter/foundation.dart' show immutable;

/// Whose catalog and claims a management screen works on (V2-12).
///
/// The same screens serve STAKA admins (every brand) and a brand's own team
/// (that brand only). The API keeps them apart by path: admin endpoints sit
/// at the root (`/products`), a brand's under `/brand/:brandId`
/// (`/brand/:brandId/products`). Repositories build their paths with
/// [path]; providers are keyed by the scope, so the two sides never share a
/// list or a cache.
@immutable
sealed class ManageScope {
  const new();

  /// [adminPath] (e.g. `/claims/c1`) as this scope calls it.
  String path(String adminPath);
}

/// A STAKA admin: every brand's products and claims.
final class AdminScope extends ManageScope {
  const new();

  @override
  String path(String adminPath) => adminPath;

  @override
  bool operator ==(Object other) => other is AdminScope;

  @override
  int get hashCode => (AdminScope).hashCode;

  @override
  String toString() => 'AdminScope()';
}

/// A member of [brandId]'s team: that brand's products and claims only.
final class BrandScope extends ManageScope {
  const new(this.brandId);

  final String brandId;

  @override
  String path(String adminPath) => '/brand/$brandId$adminPath';

  @override
  bool operator ==(Object other) =>
      other is BrandScope && other.brandId == brandId;

  @override
  int get hashCode => Object.hash(BrandScope, brandId);

  @override
  String toString() => 'BrandScope($brandId)';
}
