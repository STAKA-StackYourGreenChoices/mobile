import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/brand_summary.dart';
import 'package:staka/features/admin/brands/domain/models/brand_draft.dart';
import 'package:staka/features/admin/brands/domain/repositories/admin_brand_repository.dart';

/// Answers the brand list from `lists` in order (the last one repeats),
/// saves and deletes from the `saves` and `deletes` scripts, recording
/// them in [saved] and [deleted].
class FakeAdminBrandRepository implements AdminBrandRepository {
  new({
    List<Result<List<BrandSummary>>> lists = const [Ok([])],
    List<Result<BrandSummary>> saves = const [],
    List<Result<void>> deletes = const [],
  }) : _lists = [...lists],
       _saves = [...saves],
       _deletes = [...deletes];

  final List<Result<List<BrandSummary>>> _lists;
  final List<Result<BrandSummary>> _saves;
  final List<Result<void>> _deletes;
  int fetches = 0;

  /// (brand id or null for a new one, what was sent).
  final List<(String?, BrandDraft)> saved = [];
  final List<String> deleted = [];

  @override
  Future<Result<List<BrandSummary>>> fetchBrands() async {
    fetches++;
    return _lists.length > 1 ? _lists.removeAt(0) : _lists.single;
  }

  @override
  Future<Result<BrandSummary>> createBrand(BrandDraft draft) async {
    saved.add((null, draft));
    return _saves.removeAt(0);
  }

  @override
  Future<Result<BrandSummary>> updateBrand(String id, BrandDraft draft) async {
    saved.add((id, draft));
    return _saves.removeAt(0);
  }

  @override
  Future<Result<void>> deleteBrand(String id) async {
    deleted.add(id);
    return _deletes.removeAt(0);
  }
}
