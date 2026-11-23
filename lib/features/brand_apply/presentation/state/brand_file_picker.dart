import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/features/brand_apply/domain/models/brand_file.dart';
import 'package:staka/features/tags/presentation/state/receipt_picker.dart';

part 'brand_file_picker.g.dart';

/// Picks a brand's logo and business document; null when cancelled.
abstract interface class BrandFilePicker {
  Future<BrandFile?> pickLogo();

  /// A photo or PDF, like a receipt.
  Future<BrandFile?> pickDocument(ReceiptSource source);
}

/// The device pickers. Tests override this with a fake.
@riverpod
BrandFilePicker brandFilePicker(Ref ref) =>
    DeviceBrandFilePicker(ref.watch(receiptPickerProvider));

class DeviceBrandFilePicker implements BrandFilePicker {
  const new(this._receipts);

  final ReceiptPicker _receipts;

  /// A logo is shown small: 1024 px at quality 90 stays sharp and well
  /// under the API's 2 MB.
  static const _logoSide = 1024.0;
  static const _logoQuality = 90;

  @override
  Future<BrandFile?> pickLogo() async {
    final photo = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: _logoSide,
      maxHeight: _logoSide,
      imageQuality: _logoQuality,
    );
    if (photo == null) return null;
    return BrandFile(name: photo.name, bytes: await photo.readAsBytes());
  }

  /// The receipt picker already scales photos under 5 MB and picks PDFs.
  @override
  Future<BrandFile?> pickDocument(ReceiptSource source) async {
    final picked = await _receipts.pick(source);
    if (picked == null) return null;
    return BrandFile(name: picked.name, bytes: picked.bytes);
  }
}
