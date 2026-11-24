import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/sharing/share_target.dart';

/// Where a link was shared, as people say it ("WhatsApp", "QR code").
String channelName(ShareChannel channel, AppLocalizations l10n) =>
    switch (channel) {
      ShareChannel.whatsapp => l10n.channelWhatsApp,
      ShareChannel.instagram => l10n.channelInstagram,
      ShareChannel.facebook => l10n.channelFacebook,
      ShareChannel.x => l10n.channelX,
      ShareChannel.linkedin => l10n.channelLinkedIn,
      ShareChannel.copy => l10n.channelCopiedLink,
      ShareChannel.qr => l10n.channelQr,
      ShareChannel.embed => l10n.channelEmbed,
      ShareChannel.other => l10n.channelOther,
    };
