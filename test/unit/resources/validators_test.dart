import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/resources/helpers/validators.dart';

void main() {
  group("Validators Tests", () {

    test("Email Validator checks email for validity", () {
      String validEmail = "realEmail@gmail.com";
      String invalidEmail = "bad!email@w=2.ja^";
      expect(Validators.isValidEmail(email: validEmail), true);
      expect(Validators.isValidEmail(email: invalidEmail), false);
    });

    test("Password Validator checks password validity", () {
      String validPassword = "bN!sg7y84&bDs";
      String emptyPassword = "";
      String noUpperCase = "bn!sg7y84&bds";
      String noLowerCase = "BN!SG7Y84&BDS";
      String noDigits = "bN!sgy&bDs";
      String noSpecialCharacters = "bNsg7y84bDs";
      String notMinLength = "Bn7#";

      expect(Validators.isValidPassword(password: validPassword), true);
      expect(Validators.isValidPassword(password: emptyPassword), false);
      expect(Validators.isValidPassword(password: noUpperCase), false);
      expect(Validators.isValidPassword(password: noLowerCase), false);
      expect(Validators.isValidPassword(password: noDigits), false);
      expect(Validators.isValidPassword(password: noSpecialCharacters), false);
      expect(Validators.isValidPassword(password: notMinLength), false);
    });

    test("Password Confirmation Validator checks confirmation validity", () {
      String password = faker.internet.password();
      expect(Validators.isPasswordConfirmationValid(password: password, passwordConfirmation: password), true);
      expect(Validators.isPasswordConfirmationValid(password: password, passwordConfirmation: "s${password}w@X"), false);
    });

    test("Name validator checks name validity", () {
      List<String> validNames = ["Smith", "john-Diaz", "O'Bryan", "St. Clair"];
      validNames.forEach((name) { 
        expect(Validators.isValidName(name: name), true);
      });

      
      List<String> invalidNames = ['', "jake]", 'mohammad!', 'jenna,', 'nick/', r'tyler\', 'britney;', 'daniel"' ];
      invalidNames.forEach((name) {
        expect(Validators.isValidName(name: name), false);
      });
    });

    test("Tip Validator checks tip validity", () {
      int validTip = 10;

      expect(Validators.isValidTip(tip: validTip), true);
    });
  });
}