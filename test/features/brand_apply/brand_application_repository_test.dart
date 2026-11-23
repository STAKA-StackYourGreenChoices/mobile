import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/catalog/brands_api.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/features/brand_apply/data/datasources/brand_application_remote_data_source.dart';
import 'package:staka/features/brand_apply/data/repositories/brand_application_repository_impl.dart';
import 'package:staka/features/brand_apply/domain/models/brand_application.dart';
import 'package:staka/features/brand_apply/domain/models/brand_application_draft.dart';

import '../../helpers/brand_apply_fakes.dart';
import '../../helpers/fake_http_adapter.dart';

Map<String, Object?> _brandJson({
  String id = 'ba1',
  String status = 'PENDING',
  String? statusReason,
  String? appliedAt = '2026-11-20T09:00:00.000Z',
}) => {
  'id': id,
  'name': 'Terra Threads',
  'legalName': 'Terra Threads Private Limited',
  'status': status,
  'statusReason': statusReason,
  'contactEmail': 'hello@terrathreads.example',
  'appliedAt': appliedAt,
};

const _minimal = BrandApplicationDraft(
  name: 'Terra Threads',
  legalName: 'Terra Threads Private Limited',
  contactEmail: 'hello@terrathreads.example',
);

void main() {
  late FakeHttpAdapter api;

  BrandApplicationRepositoryImpl repository() {
    final dio = Dio(BaseOptions(baseUrl: 'http://api.test'))
      ..httpClientAdapter = api;
    return BrandApplicationRepositoryImpl(
      BrandApplicationRemoteDataSource(dio),
      BrandsApi(dio),
    );
  }

  test('my applications read every status, newest first', () async {
    api = FakeHttpAdapter([
      json(200, [
        _brandJson(
          id: 'old',
          status: 'ACTIVE',
          appliedAt: '2026-10-01T00:00:00Z',
        ),
        _brandJson(
          id: 'new',
          status: 'REJECTED',
          statusReason: 'The document is unreadable',
        ),
        _brandJson(id: 'paused', status: 'SUSPENDED', appliedAt: null),
        _brandJson(id: 'later', status: 'SOMETHING_NEW'),
      ]),
    ]);

    final result = await repository().fetchMine();

    expect(api.requests.single.path, '/me/brand-applications');
    final applications = (result as Ok<List<BrandApplication>>).value;
    expect(
      [for (final a in applications) (a.id, a.status)],
      [
        ('new', BrandApplicationStatus.rejected),
        // An unknown status is still being checked.
        ('later', BrandApplicationStatus.pending),
        ('old', BrandApplicationStatus.approved),
        ('paused', BrandApplicationStatus.suspended),
      ],
    );
    expect(applications.first.statusReason, 'The document is unreadable');
  });

  test(
    'an application is multipart, without the empty optional fields',
    () async {
      api = FakeHttpAdapter([json(201, _brandJson())]);

      final result = await repository().apply(_minimal);

      final request = api.requests.single;
      expect((request.method, request.path), ('POST', '/brand-applications'));
      final form = request.data as FormData;
      expect(Map.fromEntries(form.fields), {
        'name': 'Terra Threads',
        'legalName': 'Terra Threads Private Limited',
        'contactEmail': 'hello@terrathreads.example',
      });
      expect(form.files, isEmpty);
      expect(
        (result as Ok<BrandApplication>).value.status,
        BrandApplicationStatus.pending,
      );
    },
  );

  test('every field and both files go under the API names', () async {
    api = FakeHttpAdapter([json(201, _brandJson())]);

    await repository().apply(
      BrandApplicationDraft(
        name: 'Terra Threads',
        legalName: 'Terra Threads Private Limited',
        contactEmail: 'hello@terrathreads.example',
        contactPhone: '+919876543210',
        websiteUrl: 'https://terrathreads.example',
        gstin: '33AAACT1234F1Z5',
        description: 'Organic cotton basics.',
        existingBrandId: 'b7',
        logo: logoFile(),
        document: bigFile('gst.pdf', 10),
      ),
    );

    final form = api.requests.single.data as FormData;
    expect(Map.fromEntries(form.fields), {
      'name': 'Terra Threads',
      'legalName': 'Terra Threads Private Limited',
      'contactEmail': 'hello@terrathreads.example',
      'contactPhone': '+919876543210',
      'websiteUrl': 'https://terrathreads.example',
      'gstin': '33AAACT1234F1Z5',
      'description': 'Organic cotton basics.',
      'existingBrandId': 'b7',
    });
    expect(
      [for (final file in form.files) (file.key, file.value.filename)],
      [('logo', 'logo.png'), ('document', 'gst.pdf')],
    );
  });

  test('resubmitting patches that application', () async {
    api = FakeHttpAdapter([json(200, _brandJson())]);

    await repository().resubmit('ba1', _minimal);

    final request = api.requests.single;
    expect(
      (request.method, request.path),
      ('PATCH', '/brand-applications/ba1'),
    );
  });

  test('a 409 means the name already runs itself on STAKA', () async {
    api = FakeHttpAdapter([
      json(409, {'message': 'A brand with this name is already on STAKA'}),
    ]);

    final result = await repository().apply(_minimal);

    expect((result as Err).failure, isA<ConflictFailure>());
  });
}
