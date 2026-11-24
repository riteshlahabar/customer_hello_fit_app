import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/tokens.dart';

/// The six boxes from page 06.
///
/// Behaviour copied from the design's own script: typing advances, backspace
/// on an empty box steps back, and pasting a six-digit code fills the row.
/// The paste case matters most — Android autofills an SMS code as one string,
/// and six single-character fields would otherwise swallow five digits.
class OtpCodeField extends StatefulWidget {
  const OtpCodeField({
    super.key,
    required this.onChanged,
    required this.onCompleted,
    this.enabled = true,
    this.length = 6,
  });

  final ValueChanged<String> onChanged;

  /// Fired once the last box is filled, so the customer does not have to
  /// reach for the button.
  final ValueChanged<String> onCompleted;
  final bool enabled;
  final int length;

  @override
  State<OtpCodeField> createState() => OtpCodeFieldState();
}

class OtpCodeFieldState extends State<OtpCodeField> {
  late final List<TextEditingController> _boxes = List.generate(
    widget.length,
    (_) => TextEditingController(),
  );
  late final List<FocusNode> _focus = List.generate(
    widget.length,
    (_) => FocusNode(),
  );

  /// What each box held before the current edit, so a character typed into
  /// an already-filled box can be told apart from a pasted string.
  late final List<String> _previous = List.filled(widget.length, '');

  @override
  void initState() {
    super.initState();

    // Backspace in an empty box steps back a place. Handled on the node the
    // field already owns rather than a KeyboardListener, which would need a
    // seventh focus node per box and leak one on every rebuild.
    for (var i = 1; i < widget.length; i++) {
      _focus[i].onKeyEvent = (node, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.backspace &&
            _boxes[i].text.isEmpty) {
          _focus[i - 1].requestFocus();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      };
    }
  }

  @override
  void dispose() {
    for (final c in _boxes) {
      c.dispose();
    }
    for (final f in _focus) {
      f.dispose();
    }
    super.dispose();
  }

  String get _code => _boxes.map((c) => c.text).join();

  /// Lets the screen clear the row after a wrong or expired code.
  void clear() {
    for (var j = 0; j < widget.length; j++) {
      _boxes[j].clear();
      _previous[j] = '';
    }
    widget.onChanged('');
    if (mounted) _focus.first.requestFocus();
  }

  /// Drops a whole code into the row — the development convenience code the
  /// backend returns while no SMS provider is configured.
  void fill(String code) => _spread(code.replaceAll(RegExp(r'\D'), ''), from: 0);

  void _handle(int i, String value) {
    var digits = value.replaceAll(RegExp(r'\D'), '');

    if (digits.length > 1) {
      // Typing over a filled box arrives as "old+new"; anything else of
      // length two or more is a paste or an SMS autofill.
      if (digits.length == 2 && digits[0] == _previous[i]) {
        digits = digits[1];
      } else {
        _spread(digits, from: digits.length >= widget.length ? 0 : i);
        return;
      }
    }

    _boxes[i].text = digits;
    if (digits.isNotEmpty && i < widget.length - 1) {
      _focus[i + 1].requestFocus();
    }

    _report();
  }

  /// A pasted or autofilled code arrives in one box; lay it across the rest.
  void _spread(String digits, {required int from}) {
    for (var j = 0; from + j < widget.length && j < digits.length; j++) {
      _boxes[from + j].text = digits[j];
    }

    final last = (from + digits.length).clamp(0, widget.length - 1);
    _focus[last].requestFocus();
    _report();
  }

  void _report() {
    final code = _code;
    for (var j = 0; j < widget.length; j++) {
      _previous[j] = _boxes[j].text;
    }

    widget.onChanged(code);
    if (code.length == widget.length) {
      FocusScope.of(context).unfocus();
      widget.onCompleted(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < widget.length; i++) ...[
          if (i > 0) const SizedBox(width: 10),
          _Box(
            controller: _boxes[i],
            focus: _focus[i],
            enabled: widget.enabled,
            onChanged: (v) => _handle(i, v),
          ),
        ],
      ],
    );
  }
}

class _Box extends StatelessWidget {
  const _Box({
    required this.controller,
    required this.focus,
    required this.enabled,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focus;
  final bool enabled;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 43,
      height: 53,
      child: TextField(
        controller: controller,
        focusNode: focus,
        enabled: enabled,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        // Not `maxLength: 1`: a pasted six-digit code must reach the handler
        // whole so it can be spread across the row.
        onChanged: onChanged,
        autofillHints: const [AutofillHints.oneTimeCode],
        style: const TextStyle(
          fontFamily: HFFonts.body,
          fontSize: 19,
          fontWeight: FontWeight.w700,
          color: HFColors.ink,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(HFRadius.control),
            borderSide: const BorderSide(color: Color(0xFFE7E1DC)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(HFRadius.control),
            borderSide: const BorderSide(color: HFColors.primary, width: 1.5),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(HFRadius.control),
            borderSide: const BorderSide(color: Color(0xFFE7E1DC)),
          ),
        ),
      ),
    );
  }
}
