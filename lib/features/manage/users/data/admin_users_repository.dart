import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/core/network/guard_api.dart';
import 'package:staka/core/rewards/points.dart';

part 'admin_users_repository.g.dart';

/// A shopper as an admin finds them (V2-6 points support).
@immutable
class AdminUser {
  const new({
    required this.id,
    required this.name,
    required this.pointsBalance,
    this.email,
    this.phone,
  });

  final String id;
  final String name;
  final String? email;

  /// E.164 (`+919876543210`).
  final String? phone;
  final int pointsBalance;
}

@immutable
class AdminUserPage {
  const new({required this.items, required this.total});

  final List<AdminUser> items;
  final int total;
}

/// Search shoppers, see their points, adjust them.
abstract interface class AdminUsersRepository {
  /// Name, email or phone; the first [AdminUsersRepositoryLimits.pageSize].
  Future<Result<AdminUserPage>> search(String query);
  Future<Result<AdminUser>> fetchUser(String id);

  /// Same shape as the shopper's own points; [page] starts at 1.
  Future<Result<PointsPage>> fetchPoints(String id, int page);

  /// [delta] can be negative; [note] says why (kept in the history).
  Future<Result<void>> adjustPoints(
    String id, {
    required int delta,
    required String note,
  });
}

abstract final class AdminUsersRepositoryLimits {
  static const pageSize = 20;
}

@riverpod
AdminUsersRepository adminUsersRepository(Ref ref) =>
    ApiAdminUsersRepository(ref.watch(dioProvider));

class ApiAdminUsersRepository implements AdminUsersRepository {
  const new(this._dio);

  final Dio _dio;

  static String _path(String id) => '/admin/users/${Uri.encodeComponent(id)}';

  @override
  Future<Result<AdminUserPage>> search(String query) => guardApi(() async {
    final response = await _dio.get<Object>(
      '/admin/users',
      queryParameters: {
        'q': query,
        'page': 1,
        'limit': AdminUsersRepositoryLimits.pageSize,
      },
    );
    final items = switch (response.data) {
      final List<dynamic> list => list,
      {'items': final List<dynamic> list} => list,
      _ => const <dynamic>[],
    };
    final users = [
      for (final item in items)
        if (item case final Map<String, dynamic> json) _user(json),
    ];
    return AdminUserPage(
      items: users,
      total: switch (response.data) {
        {'total': final num total} => total.toInt(),
        _ => users.length,
      },
    );
  });

  @override
  Future<Result<AdminUser>> fetchUser(String id) => guardApi(() async {
    final response = await _dio.get<Map<String, dynamic>>(_path(id));
    return _user(response.data!);
  });

  @override
  Future<Result<PointsPage>> fetchPoints(String id, int page) =>
      guardApi(() async {
        final response = await _dio.get<Map<String, dynamic>>(
          '${_path(id)}/points',
          queryParameters: {
            'page': page,
            'limit': AdminUsersRepositoryLimits.pageSize,
          },
        );
        return pointsPageFromJson(response.data!);
      });

  @override
  Future<Result<void>> adjustPoints(
    String id, {
    required int delta,
    required String note,
  }) => guardApi(() async {
    await _dio.post<void>(
      '${_path(id)}/points',
      data: {'delta': delta, 'note': note},
    );
  });

  /// `{id, name, email?, phone?, pointsBalance}`.
  static AdminUser _user(Map<String, dynamic> json) => AdminUser(
    id: json['id'] as String,
    name: json['name'] as String? ?? '',
    email: json['email'] as String?,
    phone: json['phone'] as String?,
    pointsBalance: (json['pointsBalance'] as num?)?.toInt() ?? 0,
  );
}
