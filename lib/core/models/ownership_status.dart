/// Where a shopper is in proving they own a piece (API `OwnershipStatus`).
enum OwnershipStatus {
  /// Nothing sent yet.
  unverified,

  /// A receipt is waiting for an admin.
  pending,

  /// The last receipt was turned down; another can be sent.
  rejected,

  /// All 5 receipt uploads were used.
  blocked,

  /// Proven by a paid order or an approved receipt.
  verified,
}
