/// Initials from a person's name, for an avatar with no photograph behind it.
///
/// **There is no photo column on `CustomerProfile`** — §3.2's payload is name,
/// gender, mobile, email, dob, goal and health notes, and there is no customer
/// upload route — so every avatar in the app is drawn from initials. Page 09's
/// circle and page 40's rounded square both want the same two letters, so the
/// rule lives here rather than in either widget.
///
/// Pure, and tested: a blank name, one word, three words and runs of
/// whitespace all have to land somewhere sensible, and a `name[0]` on an empty
/// string throws.
String hfInitials(String? name) {
  final trimmed = name?.trim() ?? '';
  if (trimmed.isEmpty) return '';

  return trimmed
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .take(2)
      .map((part) => part[0].toUpperCase())
      .join();
}
