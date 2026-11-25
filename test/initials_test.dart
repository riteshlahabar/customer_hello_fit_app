import 'package:customer_app/core/text/initials.dart';
import 'package:flutter_test/flutter_test.dart';

/// `hfInitials` is the one piece of real logic behind every avatar in the app
/// — pages 09 and 40 both have no photograph to draw — and a `name[0]` on an
/// empty part throws, so the empty and whitespace cases are the point.
void main() {
  group('hfInitials', () {
    test('takes the first letter of the first two words', () {
      expect(hfInitials('Tejaswini Patil'), 'TP');
      expect(hfInitials('arjun mehta'), 'AM');
    });

    test('stops at two, however many names there are', () {
      expect(hfInitials('Ravi Shankar Kumar Iyer'), 'RS');
    });

    test('one word gives one letter', () {
      expect(hfInitials('Priya'), 'P');
    });

    test('collapses runs of whitespace rather than reading a blank part', () {
      expect(hfInitials('  Rohan   Desai  '), 'RD');
      expect(hfInitials('Neha\tSingh'), 'NS');
    });

    test('empty, blank and null give nothing, not a crash', () {
      // The avatar falls back to its person icon on an empty string, which is
      // what a profile that has not been completed yet looks like.
      expect(hfInitials(''), '');
      expect(hfInitials('   '), '');
      expect(hfInitials(null), '');
    });
  });
}
