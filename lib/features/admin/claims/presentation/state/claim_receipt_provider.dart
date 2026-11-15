import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/features/admin/claims/data/repositories/admin_claim_repository_impl.dart';
import 'package:staka/features/admin/claims/domain/models/claim.dart';

part 'claim_receipt_provider.g.dart';

/// A claim's receipt, fetched with the admin's token. Shared by the review
/// page's preview and the full-screen viewer above it, so it loads once.
@riverpod
Future<Result<ClaimReceipt>> claimReceipt(Ref ref, String claimId) =>
    ref.read(adminClaimRepositoryProvider).fetchReceipt(claimId);
