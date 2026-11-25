import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/tokens.dart';
import '../saved_controller.dart';

/// Page 43's `.search` — a **local** filter over the saved cards.
///
/// Flatter and squarer than page 10's input, which is its own design: soft
/// ground, hairline border, 13px radius, and the magnifier as a bare orange
/// glyph rather than in a tinted square.
///
/// **No debounce**, unlike page 10: this filters a list already in memory, so
/// every keystroke can take effect at once. `.search:focus-within` turns the
/// border orange, which is what `focusColor` cannot do on a bare container —
/// hence the explicit [FocusNode].
class SavedSearchField extends ConsumerStatefulWidget {
  const SavedSearchField({super.key});

  @override
  ConsumerState<SavedSearchField> createState() => _SavedSearchFieldState();
}

class _SavedSearchFieldState extends ConsumerState<SavedSearchField> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focus.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focused = _focus.hasFocus;

    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: HFColors.panelSoft,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: focused ? HFColors.primary : HFColors.cardLine,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 17, color: HFColors.primary),
          const SizedBox(width: 9),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focus,
              textInputAction: TextInputAction.search,
              onChanged: ref.read(savedQueryProvider.notifier).set,
              style: const TextStyle(
                fontFamily: HFFonts.body,
                fontSize: 10,
                color: HFColors.ink,
              ),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                hintText: 'Search trainers or specialties...',
                hintStyle: TextStyle(
                  fontFamily: HFFonts.body,
                  fontSize: 10,
                  color: HFColors.muted,
                ),
              ),
            ),
          ),
          if (_controller.text.isNotEmpty)
            Semantics(
              button: true,
              label: 'Clear search',
              child: InkWell(
                onTap: () {
                  _controller.clear();
                  ref.read(savedQueryProvider.notifier).set('');
                  setState(() {});
                },
                customBorder: const CircleBorder(),
                child: const Icon(
                  Icons.close,
                  size: 14,
                  color: HFColors.actionInk,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
