import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/ownership.dart';

extension DisputeLabels on AppLocalizations {
  String disputeTabLabel(DisputeStatus status) => switch (status) {
    DisputeStatus.open => disputeOpen,
    DisputeStatus.upheld => disputeUpheld,
    DisputeStatus.overturned => disputeOverturned,
  };
}
