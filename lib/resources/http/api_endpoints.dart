class ApiEndpoints {
  static const String base = 'http://novapay.ai/api/customer';
  
  static const String account = 'account';

  static const String activeLocation = "location";

  static const String register = "auth/register";
  static const String login = "auth/login";
  static const String logout = "auth/logout";
  static const String checkPassword = "auth/password-check";
  static const String requestPasswordReset = "auth/request-reset";
  static const String resetPassword = "auth/reset-password";

  static const String business = 'business';

  static const String self = 'me';

  static const String help = 'help';
  static const String helpReply = 'help-reply';

  static const String geoLocation = "geo-location";

  static const String photo = 'avatar';

  static const String profile = 'profile';

  static const String refund = 'refund';

  static const String transactionIssue = 'transaction-issue';

  static const String transaction = 'transaction';

  static const String unassignedTransaction = 'unassigned-transaction';
}