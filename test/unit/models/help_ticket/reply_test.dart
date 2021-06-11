import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/help_ticket/reply.dart';
import 'package:heist/resources/http/mock_responses.dart';

main() {
  group("Reply Tests", () {

    test("Reply can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generateReply();
      var reply = Reply.fromJson(json: json);
      expect(reply, isA<Reply>());
    });

    test("Reply formats createdAt to DateTime", () {
      final Map<String, dynamic> json = MockResponses.generateReply();
      var reply = Reply.fromJson(json: json);
      expect(reply.createdAt, isA<DateTime>());
    });

    test("Reply can update it's attributes", () {
      Map<String, dynamic> json = MockResponses.generateReply();
      while (json['read'] == true) {
        json = MockResponses.generateReply();
      }

      var reply = Reply.fromJson(json: json);
      expect(reply.read == true, false);
      
      reply = reply.update(read: true);
      expect(reply.read == true, true);
    });
  });
}