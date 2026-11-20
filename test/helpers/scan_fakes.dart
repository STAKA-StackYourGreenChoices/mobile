import 'package:material_ui/material_ui.dart';

/// Stands in for the camera in tests: a button that "reads" [gtin].
class FakeScanCamera extends StatelessWidget {
  const new({
    required this.onGtinFound,
    this.gtin = '08901234500019',
    super.key,
  });

  final ValueChanged<String> onGtinFound;
  final String gtin;

  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: () => onGtinFound(gtin),
    child: const Text('Simulate scan'),
  );
}
