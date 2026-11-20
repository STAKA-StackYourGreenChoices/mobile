import 'package:intl/intl.dart';

/// "14 Nov 2026": day, short month, year — the website's `formatDate`
/// (en-GB). Shown in the phone's local time.
String formatDate(DateTime date) =>
    DateFormat('d MMM y').format(date.toLocal());
