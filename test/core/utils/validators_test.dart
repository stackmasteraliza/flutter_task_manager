import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager_app/core/utils/validators.dart';

void main() {
  group('Validators', () {
    test('validateUsername returns error for empty value', () {
      expect(Validators.validateUsername(''), isNotNull);
    });

    test('validatePassword returns null for valid value', () {
      expect(Validators.validatePassword('abcd1234'), isNull);
    });

    test('validateTaskTitle returns error for short title', () {
      expect(Validators.validateTaskTitle('ab'), isNotNull);
    });
  });
}
