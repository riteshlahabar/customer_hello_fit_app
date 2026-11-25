import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';

/// Page 40's `.section` heading plus the `.info` card under it.
///
/// Two sections draw it — Personal Information and Account — so the card, the
/// hairline between rows and the `.ico` plate live here once.
class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({
    super.key,
    required this.heading,
    required this.rows,
  });

  final String heading;
  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 17, bottom: 9),
          child: Text(
            heading,
            style: const TextStyle(
              fontFamily: HFFonts.display,
              fontWeight: FontWeight.w400,
              fontSize: 19,
              color: HFColors.ink,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
          decoration: BoxDecoration(
            color: HFColors.panelSoft,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: HFColors.cardLine),
          ),
          child: Column(children: rows),
        ),
      ],
    );
  }
}

/// One `.item`. The `.arrow` chevron is drawn only when the row leads
/// somewhere — the design puts one on every row, but the mobile number has no
/// destination: it is the login identity and the API changes it only by
/// verifying a new number, for which there is no route.
class ProfileInfoRow extends StatelessWidget {
  const ProfileInfoRow({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.titleFirst = false,
    this.onTap,
    this.last = false,
  });

  final IconData icon;

  /// The bold line. The design puts the value in bold under a small caption
  /// for Personal Information, and the label in bold over a small description
  /// for Account — [titleFirst] picks which way round the pair is drawn.
  final String title;
  final String? subtitle;
  final bool titleFirst;
  final VoidCallback? onTap;

  /// `.item:last-child` drops the hairline.
  final bool last;

  @override
  Widget build(BuildContext context) {
    final small = Text(
      subtitle ?? '',
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontFamily: HFFonts.body,
        fontSize: 7,
        height: 1.6,
        color: HFColors.muted,
      ),
    );
    final big = Text(
      title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontFamily: HFFonts.body,
        fontSize: 9,
        fontWeight: FontWeight.w700,
        height: 1.5,
        color: HFColors.ink,
      ),
    );

    final row = Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: BoxDecoration(
        border: last
            ? null
            : const Border(bottom: BorderSide(color: HFColors.cardLine)),
      ),
      child: Row(
        children: [
          Container(
            height: 31,
            width: 31,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: HFColors.searchFill,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 15, color: HFColors.labelInk),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: titleFirst
                  ? [big, if (subtitle != null) small]
                  : [if (subtitle != null) small, big],
            ),
          ),
          if (onTap != null)
            const Icon(
              Icons.chevron_right,
              size: 18,
              color: HFColors.taupe,
            ),
        ],
      ),
    );

    if (onTap == null) return row;

    return InkWell(onTap: onTap, child: row);
  }
}
