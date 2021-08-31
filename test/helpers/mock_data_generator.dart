import 'package:heist/models/business/beacon.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/models/help_ticket/help_ticket.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/models/unassigned_transaction/unassigned_transaction_resource.dart';
import 'package:heist/resources/http/mock_responses.dart';

class MockDataGenerator {

  Business createBusiness() {
    return Business.fromJson(json: MockResponses.generateBusiness());
  }

  Beacon createBeacon() {
    return Beacon.fromJson(json: MockResponses.generateBeacon());
  }

  TransactionResource createTransactionResource() {
    return TransactionResource.fromJson(json: MockResponses.generateTransactionResource());
  }

  Customer createCustomer() {
    return Customer.fromJson(json: MockResponses.generateCustomer());
  }

  HelpTicket createHelpTicket() {
    return HelpTicket.fromJson(json: MockResponses.generateHelpTicket());
  }

  UnassignedTransactionResource createUnassignedTransaction() {
    return UnassignedTransactionResource.fromJson(json: MockResponses.generateUnassignedTransactionResource());
  }
}