import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/features/manage/claims/data/repositories/admin_claim_repository_impl.dart';
import 'package:staka/features/manage/claims/domain/models/claim.dart';
import 'package:staka/features/manage/shared/manage_scope.dart';

part 'claim_receipt_provider.g.dart';

/// A claim's receipt, fetched with the admin's token. Shared by the review
/// page's preview and the full-screen viewer above it, so it loads once.
@riverpod
Future<Result<ClaimReceipt>> claimReceipt(
  Ref ref,
  ManageScope scope,
  String claimId,
) => ref.read(adminClaimRepositoryProvider(scope)).fetchReceipt(claimId);
