import 'package:freezed_annotation/freezed_annotation.dart';

part 'share_link.freezed.dart';

/// The public link to a verified tag: `<website>/t/<slug>`.
@freezed
abstract class ShareLink with _$ShareLink {
  const factory({required String slug, required DateTime createdAt}) =
      _ShareLink;
}
