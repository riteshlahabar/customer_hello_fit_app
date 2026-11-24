import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/tokens.dart';

/// The `.field` box from the designs: a bordered pill that turns orange with
/// a soft glow on focus, optionally carrying a `+91` prefix or a trailing
/// action. The caption above it is `.field-label`.
///
/// It wraps a bare [TextField] rather than using the theme's
/// `InputDecoration`, because the design's focus ring is drawn outside the
/// border and an `OutlineInputBorder` cannot do that.
class HFTextField extends StatefulWidget {
  const HFTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.prefix,
    this.trailing,
    this.keyboardType,
    this.inputFormatters,
    this.maxLength,
    this.obscure = false,
    this.enabled = true,
    this.autofillHints,
    this.textCapitalization = TextCapitalization.none,
    this.onSubmitted,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;

  /// Drawn left of the input behind a hairline divider, as `+91` is.
  final String? prefix;
  final Widget? trailing;

  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final bool obscure;
  final bool enabled;
  final Iterable<String>? autofillHints;
  final TextCapitalization textCapitalization;
  final ValueChanged<String>? onSubmitted;

  @override
  State<HFTextField> createState() => _HFTextFieldState();
}

class _HFTextFieldState extends State<HFTextField> {
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focused = _focus.hasFocus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontFamily: HFFonts.body,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: HFColors.labelInk,
          ),
        ),
        const SizedBox(height: HFSpacing.sm),
        AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          height: 51,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(HFRadius.control),
            border: Border.all(
              color: focused ? HFColors.primary : HFColors.fieldBorder,
            ),
            boxShadow: focused
                ? const [BoxShadow(color: Color(0x12E33E29), blurRadius: 0, spreadRadius: 3)]
                : null,
          ),
          child: Row(
            children: [
              if (widget.prefix != null) ...[
                Text(
                  widget.prefix!,
                  style: const TextStyle(
                    fontFamily: HFFonts.body,
                    fontSize: 12,
                    color: HFColors.muted,
                  ),
                ),
                const SizedBox(width: 10),
                Container(width: 1, height: 22, color: HFColors.fieldBorder),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focus,
                  enabled: widget.enabled,
                  obscureText: widget.obscure,
                  keyboardType: widget.keyboardType,
                  inputFormatters: widget.inputFormatters,
                  maxLength: widget.maxLength,
                  autofillHints: widget.autofillHints,
                  textCapitalization: widget.textCapitalization,
                  onSubmitted: widget.onSubmitted,
                  style: const TextStyle(
                    fontFamily: HFFonts.body,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: HFColors.ink,
                  ),
                  decoration: InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    counterText: '',
                    hintText: widget.hint,
                    hintStyle: const TextStyle(
                      fontFamily: HFFonts.body,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: HFColors.faintMuted,
                    ),
                  ),
                ),
              ),
              if (widget.trailing != null) widget.trailing!,
            ],
          ),
        ),
      ],
    );
  }
}
