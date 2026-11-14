import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/features/tags/domain/models/picked_receipt.dart';

part 'receipt_picker.g.dart';

/// Where a receipt comes from on a phone.
enum ReceiptSource { camera, photos, pdf }

/// Lets the shopper pick a receipt; null when they cancel.
abstract interface class ReceiptPicker {
  Future<PickedReceipt?> pick(ReceiptSource source);
}

/// The device pickers. Tests override this with a fake.
@riverpod
ReceiptPicker receiptPicker(Ref ref) => const DeviceReceiptPicker();

class DeviceReceiptPicker implements ReceiptPicker {
  const new();

  /// Phone photos are often several MB; scaling to 2400 px at quality 85
  /// keeps a receipt readable and well under the API's 5 MB limit (and makes
  /// iOS hand back a JPEG, which the API accepts, rather than HEIC).
  static const _maxSide = 2400.0;
  static const _quality = 85;

  @override
  Future<PickedReceipt?> pick(ReceiptSource source) {
    return switch (source) {
      ReceiptSource.camera || ReceiptSource.photos => _photo(source),
      ReceiptSource.pdf => _pdf(),
    };
  }

  Future<PickedReceipt?> _photo(ReceiptSource source) async {
    final photo = await ImagePicker().pickImage(
      source: source == ReceiptSource.camera
          ? ImageSource.camera
          : ImageSource.gallery,
      maxWidth: _maxSide,
      maxHeight: _maxSide,
      imageQuality: _quality,
    );
    if (photo == null) return null;
    return PickedReceipt(name: photo.name, bytes: await photo.readAsBytes());
  }

  Future<PickedReceipt?> _pdf() async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: const ['pdf'],
    );
    if (file == null) return null;
    return PickedReceipt(name: file.name, bytes: await file.readAsBytes());
  }
}
