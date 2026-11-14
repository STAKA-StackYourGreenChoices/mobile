import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/utils/scan_parser.dart';

String? gtinOf(String raw) => switch (parseScan(raw)) {
  ScanGtin(:final gtin) => gtin,
  ScanRejected() => null,
};

ScanRejection? rejectionOf(String raw) => switch (parseScan(raw)) {
  ScanRejected(:final reason) => reason,
  ScanGtin() => null,
};

void main() {
  test('barcode digits of every GTIN length, separators ignored', () {
    expect(gtinOf('96385074'), '96385074');
    expect(gtinOf('036000291452'), '036000291452');
    expect(gtinOf('8901234500019'), '8901234500019');
    expect(gtinOf('08901234500019'), '08901234500019');
    expect(gtinOf(' 890-1234 500019 '), '8901234500019');
  });

  test('GS1 Digital Link QR codes give the GTIN after /01/', () {
    expect(gtinOf('https://id.gs1.org/01/09506000134352'), '09506000134352');
    expect(
      gtinOf('https://brand.example/01/09506000134352/21/ABC'),
      '09506000134352',
    );
    expect(
      gtinOf('https://id.gs1.org/01/09506000134352?lot=7'),
      '09506000134352',
    );
  });

  test('wrong digit counts say how many digits there were', () {
    final result = parseScan('12345');
    expect(result, isA<ScanRejected>());
    result as ScanRejected;
    expect(result.reason, ScanRejection.wrongLength);
    expect(result.digitCount, 5);
  });

  test("the website's other rejections", () {
    expect(rejectionOf('   '), ScanRejection.empty);
    expect(rejectionOf('https://staka.example/about'), ScanRejection.website);
    expect(rejectionOf('HTTP://EXAMPLE.COM'), ScanRejection.website);
    expect(rejectionOf('hello'), ScanRejection.notABarcode);
  });
}
