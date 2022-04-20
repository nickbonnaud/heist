import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/transaction/issue.dart';
import 'package:heist/resources/enums/issue_type.dart';
import 'package:heist/resources/http/mock_responses.dart';

void main() {
  group("Issue Tests", () {

    test("Issue can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generateIssue();
      var issue = Issue.fromJson(json: json);
      expect(issue, isA<Issue>());
    });

    test("Issue can format updated at to DateTime", () {
      final Map<String, dynamic> json = MockResponses.generateIssue();
      var issue = Issue.fromJson(json: json);
      expect(issue.updatedAt, isA<DateTime>());
    });

    test("Issue can format string IssueType to enum IssueType", () {
      final Map<String, dynamic> json = MockResponses.generateIssue();
      var issue = Issue.fromJson(json: json);
      expect(issue.type, isA<IssueType>());
    });

    test("Issue can format enum IssueType to string IssueType", () {
      final Map<String, dynamic> json = MockResponses.generateIssue();
      var issue = Issue.fromJson(json: json);
      expect(issue.type, isA<IssueType>());

      expect(issue.typeToString, isA<String>());

      expect(Issue.enumToString(type: IssueType.errorInBill), isA<String>());
    });

    test("Issue can update it's attributes", () {
      Map<String, dynamic> json = MockResponses.generateIssue();
      while (json['resolved'] == true) {
        json = MockResponses.generateIssue();
      }
      var issue = Issue.fromJson(json: json);
      expect(issue.resolved == true, false);

      issue = issue.update(resolved: true);
      expect(issue.resolved == true, true);
    });
  });
}