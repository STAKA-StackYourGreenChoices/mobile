import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:staka/app/router/router.dart';
import 'package:staka/app/router/session_redirect.dart';
import 'package:staka/app/shell/shell_tab.dart';
import 'package:staka/core/api_models/user_dto.dart';
import 'package:staka/core/api_models/user_mapper.dart';
import 'package:staka/core/auth/session_state.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/brand_membership.dart';
import 'package:staka/core/models/user.dart';
import 'package:staka/features/brand_portal/data/datasources/brand_portal_remote_data_source.dart';
import 'package:staka/features/brand_portal/data/repositories/brand_portal_repository_impl.dart';
import 'package:staka/features/brand_portal/domain/models/brand_member.dart';
import 'package:staka/features/brand_portal/domain/models/brand_profile.dart';

import '../../helpers/auth_fakes.dart';
import '../../helpers/brand_apply_fakes.dart';
import '../../helpers/brand_portal_fakes.dart';
import '../../helpers/fake_http_adapter.dart';

User _userWith(List<Map<String, Object?>> brands) =>
    UserDto.fromJson(memberUserJson(brands)).toDomain();

void main() {
  group('memberships from /auth/me', () {
    test('roles and statuses are read; unknown ones give fewer rights', () {
      final user = _userWith([
        membershipJson(),
        membershipJson(id: 'b2', role: 'STAFF', status: 'SUSPENDED'),
        membershipJson(id: 'b3', role: 'NEW_ROLE', status: 'PENDING'),
        membershipJson(id: 'b4', status: 'REJECTED'),
      ]);

      expect(
        [for (final b in user.brands) (b.id, b.role, b.status)],
        [
          ('b1', BrandRole.owner, BrandStatus.active),
          ('b2', BrandRole.staff, BrandStatus.suspended),
          ('b3', BrandRole.staff, BrandStatus.pending),
          ('b4', BrandRole.owner, BrandStatus.rejected),
        ],
      );
      // Approved and paused brands are in the tab; applications are not.
      expect([for (final b in user.portalBrands) b.id], ['b1', 'b2']);
      expect(user.hasBrandPortal, isTrue);
    });

    test('an API without brands, or only applications: no Brand tab', () {
      expect(UserDto.fromJson(userJson()).toDomain().brands, isEmpty);
      expect(
        _userWith([membershipJson(status: 'PENDING')]).hasBrandPortal,
        isFalse,
      );
    });
  });

  group('Brand tab access', () {
    final member = SignedIn(_userWith([membershipJson()]));
    final shopper = SignedIn(UserDto.fromJson(userJson()).toDomain());

    test('only brand members reach /brand', () {
      expect(redirectFor(member, '/brand'), isNull);
      expect(redirectFor(member, '/brand/team'), isNull);
      expect(redirectFor(shopper, '/brand'), '/wardrobe');
      expect(redirectFor(shopper, '/brand/settings'), '/wardrobe');
      // Not a Brand tab route.
      expect(redirectFor(shopper, '/account/brand'), isNull);
    });

    test('gaining or losing the Brand tab refreshes the routes', () {
      expect(routingKeyOf(member), isNot(routingKeyOf(shopper)));
    });

    test('the tab shows between Scan and Admin, for members only', () {
      expect(visibleTabs(isAdmin: false, hasBrandPortal: false), [
        ShellTab.wardrobe,
        ShellTab.scan,
        ShellTab.account,
      ]);
      expect(visibleTabs(isAdmin: true, hasBrandPortal: true), [
        ShellTab.wardrobe,
        ShellTab.scan,
        ShellTab.brand,
        ShellTab.admin,
        ShellTab.account,
      ]);
    });
  });

  group('BrandPortalRepository', () {
    late FakeHttpAdapter api;

    BrandPortalRepositoryImpl repository() => BrandPortalRepositoryImpl(
      BrandPortalRemoteDataSource(
        Dio(BaseOptions(baseUrl: 'http://api.test'))..httpClientAdapter = api,
      ),
    );

    test('the team reads flat or nested people, owners first', () async {
      api = FakeHttpAdapter([
        json(200, [
          {
            'userId': 'u7',
            'role': 'STAFF',
            'user': {
              'id': 'u7',
              'name': 'Ravi Kumar',
              'phone': '+919812345678',
            },
          },
          {
            'userId': 'u1',
            'name': 'Ada Lovelace',
            'email': 'ada@example.com',
            'role': 'OWNER',
          },
        ]),
      ]);

      final result = await repository().fetchMembers('b1');

      expect(api.requests.single.path, '/brand/b1/members');
      expect((result as Ok<List<BrandMember>>).value, [adaOwner, ravi]);
    });

    test('an invite posts who and the role', () async {
      api = FakeHttpAdapter([
        json(201, {'id': 'i1'}),
      ]);

      await repository().invite(
        'b1',
        emailOrPhone: '+919812345678',
        role: BrandRole.staff,
      );

      final request = api.requests.single;
      expect((request.method, request.path), ('POST', '/brand/b1/members'));
      expect(request.data, {'emailOrPhone': '+919812345678', 'role': 'STAFF'});
    });

    test(
      'removing deletes the membership; the last owner is refused',
      () async {
        api = FakeHttpAdapter([
          json(400, {'message': 'A brand needs at least one owner'}),
        ]);

        final result = await repository().removeMember('b1', 'u1');

        final request = api.requests.single;
        expect(
          (request.method, request.path),
          ('DELETE', '/brand/b1/members/u1'),
        );
        expect(
          messageOf((result as Err).failure),
          'A brand needs at least one owner',
        );
      },
    );

    test('settings read the profile and patch it as multipart', () async {
      api = FakeHttpAdapter([
        json(200, {
          'id': 'b1',
          'name': 'Terra Threads',
          'status': 'ACTIVE',
          'contactEmail': 'hello@terrathreads.example',
        }),
        json(200, {'id': 'b1', 'name': 'Terra', 'status': 'ACTIVE'}),
      ]);

      final profile = await repository().fetchProfile('b1');
      final saved = await repository().updateProfile(
        'b1',
        BrandProfileDraft(
          name: 'Terra',
          contactEmail: 'hello@terrathreads.example',
          websiteUrl: 'https://terra.example',
          logo: logoFile(),
        ),
      );

      expect((profile as Ok<BrandProfile>).value.status, BrandStatus.active);
      expect((saved as Ok<BrandProfile>).value.name, 'Terra');
      final patch = api.requests.last;
      expect((patch.method, patch.path), ('PATCH', '/brand/b1'));
      final form = patch.data as FormData;
      expect(Map.fromEntries(form.fields), {
        'name': 'Terra',
        'contactEmail': 'hello@terrathreads.example',
        'websiteUrl': 'https://terra.example',
      });
      expect([for (final f in form.files) f.key], ['logo']);
    });
  });
}

/// The API's first message.
String? messageOf(Failure failure) =>
    failure is ApiFailure ? failure.message : null;
