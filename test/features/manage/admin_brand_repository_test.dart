import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/catalog/brands_api.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/brand_summary.dart';
import 'package:staka/features/manage/brands/data/datasources/brand_editor_remote_data_source.dart';
import 'package:staka/features/manage/brands/data/repositories/admin_brand_repository_impl.dart';
import 'package:staka/features/manage/brands/domain/models/brand_draft.dart';

import '../../helpers/fake_http_adapter.dart';

const Map<String, Object> _brand = {
  'id': 'b1',
  'name': 'Terra Threads',
  'productCount': 0,
  'createdAt': '2026-11-01T00:00:00.000Z',
};

(AdminBrandRepositoryImpl, FakeHttpAdapter) _repository(FakeReply reply) {
  final adapter = FakeHttpAdapter([reply]);
  final dio = Dio(BaseOptions(baseUrl: 'http://api.test'))
    ..httpClientAdapter = adapter;
  return (
    AdminBrandRepositoryImpl(BrandsApi(dio), BrandEditorRemoteDataSource(dio)),
    adapter,
  );
}

void main() {
  const draft = BrandDraft(name: 'Terra Threads');

  test('add: POST with only what was typed', () async {
    final (repository, adapter) = _repository(json(201, _brand));

    final result = await repository.createBrand(draft);

    final request = adapter.requests.single;
    expect((request.method, request.path), ('POST', '/brands'));
    expect(request.data, {'name': 'Terra Threads'});
    expect((result as Ok<BrandSummary>).value.id, 'b1');
  });

  test('edit: PATCH, empty fields sent as null to clear them', () async {
    final (repository, adapter) = _repository(json(200, _brand));

    await repository.updateBrand('b1', draft);

    final request = adapter.requests.single;
    expect((request.method, request.path), ('PATCH', '/brands/b1'));
    expect(request.data, {
      'name': 'Terra Threads',
      'description': null,
      'logoUrl': null,
    });
  });

  test('a taken name is a conflict', () async {
    final (repository, _) = _repository(
      json(409, {
        'message': 'A brand with this name already exists',
        'statusCode': 409,
      }),
    );

    final result = await repository.createBrand(draft);

    expect((result as Err<BrandSummary>).failure, isA<ConflictFailure>());
  });

  test('delete: DELETE /brands/:id', () async {
    final (repository, adapter) = _repository(
      (_) async => ResponseBody.fromString('', 204),
    );

    final result = await repository.deleteBrand('b1');

    expect(adapter.requests.single.method, 'DELETE');
    expect(adapter.requests.single.path, '/brands/b1');
    expect(result, isA<Ok<void>>());
  });
}
