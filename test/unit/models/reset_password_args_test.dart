import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/reset_password_args.dart';

void main() {
  group("Reset Password Args Tests", () {

    test("Reset Password Args can update it's attributes", () {
      final ResetPasswordArgs oldArgs = ResetPasswordArgs(email: faker.internet.email());

      expect(oldArgs.resetCode, null);

      final ResetPasswordArgs newArgs = oldArgs.update(resetCode: faker.guid.guid());
      expect(newArgs.resetCode != null, true);
      expect(newArgs.email, oldArgs.email);
    });
  });
}