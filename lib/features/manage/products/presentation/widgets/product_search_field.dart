import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';

/// The search box: searches when the keyboard's search key is pressed (the
/// website submits its form), with an x that clears the search. Follows
/// [value] when the filters are cleared elsewhere.
class ProductSearchField extends StatefulWidget {
  const new({required this.value, required this.onSearch, super.key});

  /// The search the list is showing.
  final String value;
  final ValueChanged<String> onSearch;

  @override
  State<ProductSearchField> createState() => _ProductSearchFieldState();
}

class _ProductSearchFieldState extends State<ProductSearchField> {
  late final _controller = TextEditingController(text: widget.value);

  @override
  void didUpdateWidget(ProductSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    if (widget.value.isNotEmpty) widget.onSearch('');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Semantics(
      label: l10n.searchProductsLabel,
      child: TextField(
        controller: _controller,
        textInputAction: TextInputAction.search,
        onSubmitted: (text) => widget.onSearch(text.trim()),
        style: context.text.bodyLarge,
        decoration: InputDecoration(
          hintText: l10n.searchProductsHint,
          prefixIcon: Icon(
            Icons.search_rounded,
            color: context.colors.inkMuted,
          ),
          suffixIcon: ListenableBuilder(
            listenable: _controller,
            builder: (_, _) => _controller.text.isEmpty
                ? const SizedBox.shrink()
                : IconButton(
                    tooltip: l10n.clearSearch,
                    icon: const Icon(Icons.close_rounded),
                    onPressed: _clear,
                  ),
          ),
        ),
      ),
    );
  }
}
