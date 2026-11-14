/// GTINs are stored as 14 digits; shoppers see the 13-digit EAN printed on
/// the label when it fits — the website's `displayGtin`.
String displayGtin(String gtin) =>
    gtin.startsWith('0') ? gtin.substring(1) : gtin;
