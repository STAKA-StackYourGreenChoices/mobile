import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/brand_membership.dart';
import 'package:staka/features/brand_portal/domain/models/brand_member.dart';
import 'package:staka/features/brand_portal/domain/models/brand_profile.dart';
import 'package:staka/features/brand_portal/domain/repositories/brand_portal_repository.dart';

import 'auth_fakes.dart';

/// Answers from scripts and records what was asked: `members` for each
/// team load (the last one repeats), `profile` for Settings, `saves`,
/// `invites` and `removes` in order. `saved`, `invited` and `removed`
/// record each change.
class FakeBrandPortalRepository implements BrandPortalRepository {
  new({
    List<Result<List<BrandMember>>> members = const [Ok([])],
    Result<BrandProfile>? profile,
    List<Result<BrandProfile>> saves = const [],
    List<Result<void>> invites = const [],
    List<Result<void>> removes = const [],
  }) : _members = [...members],
       profile = profile ?? Ok(brandProfile()),
       _saves = [...saves],
       _invites = [...invites],
       _removes = [...removes];

  final List<Result<List<BrandMember>>> _members;
  final Result<BrandProfile> profile;
  final List<Result<BrandProfile>> _saves;
  final List<Result<void>> _invites;
  final List<Result<void>> _removes;

  final List<String> memberLoads = [];
  final List<(String, BrandProfileDraft)> saved = [];
  final List<(String, String, BrandRole)> invited = [];
  final List<(String, String)> removed = [];

  @override
  Future<Result<List<BrandMember>>> fetchMembers(String brandId) async {
    memberLoads.add(brandId);
    return _members.length == 1 ? _members.first : _members.removeAt(0);
  }

  @override
  Future<Result<BrandProfile>> fetchProfile(String brandId) async => profile;

  @override
  Future<Result<BrandProfile>> updateProfile(
    String brandId,
    BrandProfileDraft draft,
  ) async {
    saved.add((brandId, draft));
    return _saves.removeAt(0);
  }

  @override
  Future<Result<void>> invite(
    String brandId, {
    required String emailOrPhone,
    required BrandRole role,
  }) async {
    invited.add((brandId, emailOrPhone, role));
    return _invites.removeAt(0);
  }

  @override
  Future<Result<void>> removeMember(String brandId, String userId) async {
    removed.add((brandId, userId));
    return _removes.removeAt(0);
  }
}

/// `brands[]` entry of `GET /auth/me`.
Map<String, Object?> membershipJson({
  String id = 'b1',
  String name = 'Terra Threads',
  String role = 'OWNER',
  String status = 'ACTIVE',
}) => {'id': id, 'name': name, 'logoUrl': null, 'role': role, 'status': status};

/// Ada (`userJson`) with [brands].
Map<String, Object?> memberUserJson(List<Map<String, Object?>> brands) => {
  ...userJson(),
  'brands': brands,
};

BrandProfile brandProfile({
  String id = 'b1',
  String name = 'Terra Threads',
  String? logoUrl,
}) => BrandProfile(
  id: id,
  name: name,
  status: BrandStatus.active,
  legalName: 'Terra Threads Private Limited',
  description: 'Organic cotton basics, made in Tiruppur.',
  websiteUrl: 'https://terrathreads.example',
  logoUrl: logoUrl,
  contactEmail: 'hello@terrathreads.example',
  contactPhone: '+919876543210',
);

const adaOwner = BrandMember(
  userId: 'u1',
  name: 'Ada Lovelace',
  role: BrandRole.owner,
  email: 'ada@example.com',
);

const ravi = BrandMember(
  userId: 'u7',
  name: 'Ravi Kumar',
  role: BrandRole.staff,
  phone: '+919812345678',
);
