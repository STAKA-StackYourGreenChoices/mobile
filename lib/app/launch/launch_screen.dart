import 'package:material_ui/material_ui.dart';

import 'package:staka/shared/widgets/feedback/app_loader.dart';

/// Shown for the moment the saved session is being checked at launch.
class LaunchScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(body: AppLoader());
}
