import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/tokens.dart';
import '../explore_controller.dart';

/// Page 10's `.search` — the app's **only** real search input.
///
/// Page 09's identical-looking row is a tap target that hands off here, so
/// there is one query implementation and one set of results. The design's
/// `.clear` button is the × on the right.
///
/// Typing is debounced 350 ms: `q` is a server-side search, and a request per
/// keystroke would both hammer the API and let an early response overwrite a
/// later one.
class ExploreSearchField extends ConsumerStatefulWidget {
  const ExploreSearchField({super.key});

  @override
  ConsumerState<ExploreSearchField> createState() =>
      _ExploreSearchFieldState();
}

class _ExploreSearchFieldState extends ConsumerState<ExploreSearchField> {
  final _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 350),
      () => ref.read(exploreQueryProvider.notifier).set(value),
    );
    // Rebuilds for the × only; the query itself waits for the timer.
    setState(() {});
  }

  void _clear() {
    _debounce?.cancel();
    _controller.clear();
    ref.read(exploreQueryProvider.notifier).set('');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: HFColors.panelSoft,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: HFColors.searchOutline, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            height: 30,
            width: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: HFColors.searchIconWash,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.search, size: 16, color: HFColors.primary),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: _onChanged,
              textInputAction: TextInputAction.search,
              style: const TextStyle(
                fontFamily: HFFonts.body,
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: HFColors.ink,
              ),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: 'Trainer name or fitness goal...',
                hintStyle: TextStyle(
                  fontFamily: HFFonts.body,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: HFColors.softMuted,
                ),
              ),
            ),
          ),
          if (_controller.text.isNotEmpty)
            Semantics(
              button: true,
              label: 'Clear search',
              child: InkWell(
                onTap: _clear,
                customBorder: const CircleBorder(),
                child: Container(
                  height: 25,
                  width: 25,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: HFColors.clearWash,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 14,
                    color: HFColors.actionInk,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
