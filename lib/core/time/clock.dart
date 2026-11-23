import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'clock.g.dart';

/// The current time. Screens with countdowns read it through this provider
/// so tests can move time forward without waiting (guide: no
/// `Future.delayed` in tests).
@Riverpod(keepAlive: true)
DateTime Function() clock(Ref ref) => DateTime.now;
