import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';

/// Screen chrome for every route: app bar, safe area, the standard 16 dp
/// side padding, and a 640 dp content cap so tablets don't stretch text.
///
/// [isScrollable] wraps [body] in a scroll view for forms and detail pages.
/// Screens showing a network list pass false and use `ListView.builder`
/// (guide §7.1 rule 6).
class AppScaffold extends StatelessWidget {
  const new({
    required this.body,
    this.title,
    this.actions,
    this.isScrollable = true,
    super.key,
  });

  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final bool isScrollable;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: switch (title) {
        final title? => AppBar(title: Text(title), actions: actions),
        null => null,
      },
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppSizes.maxProseWidth),
            child: isScrollable ? _ScrollingBody(body) : _FixedBody(body),
          ),
        ),
      ),
    );
  }
}

const _padding = EdgeInsetsDirectional.fromSTEB(
  AppSpacing.md,
  AppSpacing.md,
  AppSpacing.md,
  AppSpacing.lg,
);

class _ScrollingBody extends StatelessWidget {
  const new(this.child);

  final Widget child;

  @override
  Widget build(BuildContext context) =>
      SingleChildScrollView(padding: _padding, child: child);
}

class _FixedBody extends StatelessWidget {
  const new(this.child);

  final Widget child;

  @override
  Widget build(BuildContext context) =>
      Padding(padding: _padding, child: child);
}
