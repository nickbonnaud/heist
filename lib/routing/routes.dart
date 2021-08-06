class Routes {
  static const String app = '/';
  static const String home = "/home";

  static const String auth = '/auth';
  static const String requestReset= '/auth/request-reset';
  static const String resetPassword = '/auth/reset-password';

  static const String onboard = '/onboard';
  static const String onboardProfile = '/onboard/profile';
  static const String onboardPermissions = '/onboard/permissions';

  static const String receipt = '/receipt';

  static const String business = '/business';

  static const String tutorial = '/tutorial';

  static const String transactions = '/transactions';
  static const String transactionsBusinessName = '/transactions/find-business-name';
  static const String transactionsIdentifier = '/transactions/find-identifier';

  static const String refunds = '/refunds';
  static const String refundsBusinessName = '/refunds/find-business-name';
  static const String refundsTransactionIdentifier = '/refunds/find-transaction-identifier';
  static const String refundsIdentifier = '/refunds/find-identifier';

  static const String settings = '/settings';
  static const String profile = '/settings/profile';
  static const String email = '/settings/email';
  static const String password = '/settings/password';
  static const String tips = '/settings/tips';

  static const String helpTickets = '/help-tickets';

  static const String reportIssue = '/report-issue';
}