import 'dart:math';

import 'package:faker/faker.dart';
import 'package:dio/dio.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class MockResponses {
  
  static Map<String, dynamic> mockResponse(RequestOptions options) {
    if (options.path.endsWith("auth/register")) {
      return _mockRegister(options);
    } else if (options.path.endsWith("auth/login")) {
      return _mockLogin(options);
    } else if (options.path.endsWith("auth/logout")) {
      return _mockLogout();
    } else if (options.path.endsWith('password-check')) {
      return _mockCheckValidPassword();
    } else if (options.path.endsWith("request-reset")) {
      return _mockRequestPasswordReset();
    } else if (options.path.endsWith("geo-location")) {
      return _mockOnStart(options);
    } else if (options.path.endsWith('profile')) {
      return _mockStoreProfile(options);
    } else if (options.path.contains('profile/')) {
      return _mockUpdateProfile(options);
    } else if (options.path.endsWith('/me')) {
      return _mockFetchCustomer();
    } else if (options.path.contains('me/')) {
      return _mockUpdateCustomer(options);
    } else if (options.path.contains('avatar/')) {
      return _mockPostPhoto();
    } else if ((options.path.endsWith("transaction") || options.path.contains("/transaction?")) && options.method.toLowerCase() == 'get') {
      return _mockFetchTransactions(options);
    } else if (options.path.contains('account/')) {
      return _mockUpdateAccount(options);
    } else if (options.path.contains('/business') && options.method.toLowerCase() == 'get') {
      return _mockFetchBusinesses(options);
    } else if (options.path.contains('refund') && options.method.toLowerCase() == 'get') {
      return _mockFetchRefunds(options);
    } else if (options.path.contains("unassigned-transaction?business_id")) {
      return _mockFetchUnassigned();
    } else if (options.path.contains("unassigned-transaction/")) {
      return _mockPatchUnassigned();
    } else if (options.path.endsWith("location")) {
      return _postActiveLocation(options);
    } else if (options.path.contains('location/')) {
      return _deleteActiveLocation();
    } else if (options.path.contains('transaction/')) {
      return _mockAcceptTransaction();
    } else if (options.path.endsWith('transaction-issue')) {
      return _mockReportTransactionIssue(options);
    } else if (options.path.contains('transaction-issue/') && options.method.toLowerCase() == 'patch') {
      return _mockReportTransactionIssue(options);
    } else if (options.path.contains('transaction-issue/') && options.method.toLowerCase() == 'delete') {
      return _mockDeleteIssue();
    } else if ((options.path.endsWith("help") || options.path.contains("help?")) && options.method.toLowerCase() == 'get') {
      return _mockFetchHelpTickets(options);
    } else if (options.path.endsWith("help") && options.method.toLowerCase() == 'post') {
      return _mockPostHelpTicket(options.data);
    } else if (options.path.endsWith('help-reply')) {
      return _mockPostHelpTicketReply(options);
    } else if (options.path.contains('/help-reply/')) {
      return _mockPatchRepliesRead();
    } else if (options.path.contains('/help/')) {
      return _mockDeleteHelpTicket();
    } else {
      return { 'data': { "testing": true } };
    }
  }

  static Map<String, dynamic> _mockPostPhoto() {
    return {
      'data': generateCustomer()
    };
  }

  static Map<String, dynamic> _mockCheckValidPassword() {
    return {
      'data': {
        'password_verified': true
      }
    };
  }

  static Map<String, dynamic> _deleteActiveLocation() {
    return {
      'data': {
        'deleted': true
      }
    };
  }
  
  static Map<String, dynamic> _mockRegister(RequestOptions options) {
    return {
      'data': {
        'identifier': faker.guid.guid(),
        'email': options.data['email'],
        'token': "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9sb2NhbGhvc3RcL2FwaVwvY3VzdG9tZXJcL21lIiwiaWF0IjoxNTgyMTM2NDk0LCJleHAiOjE1OTc5MDQ0OTUsIm5iZiI6MTU4MjEzNjQ5NSwianRpIjoiQVZYUnhNOVBsUnNuZDFqRSIsInN1YiI6MSwicHJ2IjoiZGE5YzU1NjBkZTE2MTUzYmE4MTgwYzU4OTNmZDc0OTRhZDU4YWY5ZSJ9._qGQeHTjiT90MT-zV3XOoA154XzOruP8HmwcnS4tNwk",
        'profile': null,
        'account' : generateAccount(),
        'status': {
          'name': 'Profile Account Incomplete',
          'code': 100
        }
      },
      'errors': {
        'email': [null],
        'password': [null]
      }
    };
  }

  static Map<String, dynamic> _mockStoreProfile(RequestOptions options) {
    return {
      'data': {
        'identifier': faker.guid.guid(),
        'email': faker.internet.email(),
        'token': 'not_a_real_token',
        'profile': generateCustomerProfile(),
        'account': generateAccount(),
        'status': {
          'name': 'Ready',
          'code': 101
        }
      }
    };
  }

  static Map<String, dynamic> _mockUpdateProfile(RequestOptions options) {
    return {
      'data': {
        'identifier': faker.guid.guid(),
        'email': faker.internet.email(),
        'token': 'not_a_real_token',
        'profile': generateCustomerProfile(),
        'account': generateAccount(),
        'status': {
          'name': 'Ready',
          'code': 200
        }
      }
    };
  }

  static Map<String, dynamic> _mockFetchCustomer() {
    return {
      'data': {
        'identifier': faker.guid.guid(),
        'email': faker.internet.email(),
        'token': 'not_a_real_token',
        'profile': generateCustomerProfile(),
        'account': generateAccount(),
        'status': {
          'name': 'Ready',
          'code': 200
        }
      }
    };
  }

  static Map<String, dynamic> _mockUpdateCustomer(RequestOptions options) {
    return {
      'data': {
        'identifier': faker.guid.guid(),
        'email': options.data['email'] ?? faker.internet.email(),
        'token': 'not_a_real_token',
        'profile': {
          'identifier': faker.guid.guid(),
          'first_name': faker.person.firstName(),
          'last_name': faker.person.lastName(),
          'photos': {
            'name': 'fake-profile.png',
            'small_url': faker.image.image(width: 250, height: 250, keywords: ['person']),
            'large_url': faker.image.image(width: 500, height: 500, keywords: ['person'])
          }
        },
        'account': {
          'identifier': faker.guid.guid(),
          'tip_rate': 15,
          'quick_tip_rate': 5,
          'primary': 'ach'
        },
        'status': {
          'name': 'Ready',
          'code': 200
        }
      }
    };
  }

  static Map<String, dynamic> _mockLogin(RequestOptions options) {
    return {
      'data': {
        'identifier': faker.guid.guid(),
        'email': options.data['email'],
        'token': "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9sb2NhbGhvc3RcL2FwaVwvY3VzdG9tZXJcL21lIiwiaWF0IjoxNTgyMTM2NDk0LCJleHAiOjE1OTc5MDQ0OTUsIm5iZiI6MTU4MjEzNjQ5NSwianRpIjoiQVZYUnhNOVBsUnNuZDFqRSIsInN1YiI6MSwicHJ2IjoiZGE5YzU1NjBkZTE2MTUzYmE4MTgwYzU4OTNmZDc0OTRhZDU4YWY5ZSJ9._qGQeHTjiT90MT-zV3XOoA154XzOruP8HmwcnS4tNwk",
        'profile': generateCustomerProfile(),
        'account': generateAccount(),
        'status': {
          'name': 'Ready',
          'code': 200
        }
      },
      'errors': {
        'email': [null],
        'password': [null]
      }
    };
  }

  static Map<String, dynamic> _mockLogout() {
    return {
      'data': {
        'customer': null
      },
      'errors': {
        'email': [null],
        'password': [null]
      }
    };
  }

  static Map<String, dynamic> _mockRequestPasswordReset() {
    return {
      'data': {
        'email_sent': true,
        'res': 'passwords.sent'
      }
    };
  }

  static Map<String, dynamic> _mockUpdateAccount(RequestOptions options) {
    return {
      'data': {
        'identifier': faker.guid.guid(),
        'email': faker.internet.email(),
        'token': 'not_a_real_token',
        'profile': generateCustomerProfile(),
        'account': {
          'identifier': faker.guid.guid(),
          'tip_rate': options.data['tip_rate'],
          'quick_tip_rate': options.data['quick_tip_rate'],
          'primary': options.data['primary']
        },
        'status': {
          'name': 'Ready',
          'code': 200
        }
      }
    };
  }

  static Map<String, dynamic> _postActiveLocation(RequestOptions options) {
    return {
      "data": {
        "active_location_id": options.data['beacon_identifier'],
        "beacon_identifier": options.data['beacon_identifier'],
        "transaction_id": null,
        "last_notification":  null
      }
    };
  }

  static Map<String, dynamic> _mockFetchTransactions(RequestOptions options) {
    return _createTransactions(options: options);
  }
  
  static Map<String, dynamic> _mockReportTransactionIssue(RequestOptions options) {
    return {
      "transaction": generateTransaction(),
      "business": generateBusiness(),
      "refunds": [],
      'issue': {
        'identifier': faker.guid.guid(),
        'type': options.data['type'],
        'issue': options.data['issue'],
        'resolved': false,
        'warnings_sent': 0,
        'updated_at': DateTime.now().toIso8601String(),
      }
    };
  }

  static Map<String, dynamic> _mockDeleteIssue() {
    return {
      "transaction": generateTransaction(),
      "business": generateBusiness(),
      "refunds": [],
      'issue': null
    };
  }
  
  static Map<String, dynamic> _mockAcceptTransaction() {
    return {
      "transaction": generateTransaction(),
      "business": generateBusiness(),
      "refund": [],
      'issue': null
    };
  }
  
  static Map<String, dynamic> mockOpenTransaction() {
    return {
      "transaction": {
        "identifier": "3ff9ad40-79c9-11ea-8b92-a9b4a4c53696",
        "employee_id": null,
        "tax": "457",
        "tip": "1636",
        "net_sales": "6088",
        "total": "8181",
        "partial_payment": "0",
        "locked": false,
        "bill_created_at": "2020-05-26T22:04:56.000000Z",
        "updated_at": "2020-05-26T22:04:56.000000Z",
        "status": {
          "name": "open",
          "code": "100"
        },
        "purchased_items": [
          {
            "name": "numquam",
            "sub_name": 'fbjdss',
            "price": "2000",
            "quantity": "3",
            "total": "6000"
          },
          {
            "name": "vel",
            "sub_name": null,
            "price": "500",
            "quantity": "2",
            "total": "1000"
          }
        ]
      },
      "business": {
        "identifier": "3ff30c10-79c9-11ea-a2da-ebb755a8f3fd",
        "profile": {
          "name": "Spencer PLC",
          "website": "wisozk.com",
          "description": "Dignissimos cum quidem neque magnam qui et dolor. Voluptatem error maiores quia repellat veritatis possimus. Molestias id rem hic ipsam.",
          "google_place_id": null,
          "phone": "7912752600",
          "hours": {
            "monday": "Monday: 11:00 AM – 10:00 PM",
            "tuesday": "Tuesday: 11:00 AM – 10:00 PM",
            "wednesday": "Wednesday: 11:00 AM – 10:00 PM",
            "thursday": "Thursday: 11:00 AM – 10:00 PM",
            "friday": "Friday: 11:00 AM – 10:30 PM",
            "saturday": "Saturday: 11:00 AM – 10:30 PM",
            "sunday": "Sunday: 10:30 AM – 9:00 PM",
          }
        },
        'photos': {
        'logo': {
          'name': "logo_2.png",
          'small_url': "https://cdna.artstation.com/p/assets/images/images/021/760/294/micro_square/jip-scheepers-2018-04-25.jpg?1572865897",
          'large_url': "https://cdna.artstation.com/p/assets/images/images/021/760/294/micro_square/jip-scheepers-2018-04-25.jpg?1572865897"
        },
        'banner': {
          'name': "banner_1.png",
          'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
          'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
        },
      },
        "location": {
          "geo": {
            "identifier": "3ff884f0-79c9-11ea-9cdf-4d873094dff7",
            "lat": "40.748440",
            "lng":"-73.985664",
            "radius": "50",
          },
          "beacon": {
            "identifier": "3ff884f0-79c9-11ea-9cdf-4d873094dff7",
            "region_identifier": "3ff871d0-79c9-11ea-8a10-a7f913a9d44b",
            "major": "0",
            "minor": "1"
          },
          "region": {
            "identifier": "3ff871d0-79c9-11ea-8a10-a7f913a9d44b",
            "city": "prosaccoshire",
            "state": "ne",
            "zip": "41232",
            "neighborhood": null
          }
        }
      },
      "refund": [
        // {
        //   "identifier": "125d10b0-895a-11ea-95db-b1ba0de9dfd1",
        //   "total": "952",
        //   "created_at": "2020-04-28 14:10:53",
        //   "status": "refund paid",
        // },
        // {
        //   "identifier": "125d10b0-895a-11ea-95db-b1ba0de9vcd1",
        //   "total": "500",
        //   "created_at": "2020-04-28 14:10:53",
        //   "status": "refund paid",
        // },
      ],
      'issue': null
    };
  }
  
  static Map<String, dynamic> _mockFetchBusinesses(RequestOptions options) {
    String? name = _parseStringFromUrl(url: options.path, needle: 'name=');
    return _createBusinesses(options: options, name: name);
  }

  static Map<String, dynamic> _mockFetchHelpTickets(RequestOptions options) {
    String? resolved = _parseStringFromUrl(url: options.path, needle: "resolved=");
    bool? resolvedBool;
    if (resolved != null) {
      resolvedBool = resolved == 'true';
    }

    return _createHelpTickets(options: options, resolved: resolvedBool);
  }
  
  static Map<String, dynamic> _mockPatchUnassigned() {
    return generateTransactionResource();
  }

  static Map<String, dynamic> _mockFetchUnassigned() {
    return {
      'data': List.generate(faker.randomGenerator.integer(25, min: 1), (index) => generateUnassignedTransactionResource())
    };
  }
  
  static Map<String, dynamic> _mockOnStart(RequestOptions options) {
    // return {
    //   'data': []
    // };
    return {
      'data': List.generate(faker.randomGenerator.integer(25, min: 2), (index) => generateBusiness())
    };
  }

  static Map<String, dynamic> _mockFetchRefunds(RequestOptions options) {
    return _createRefunds(options: options);
  }

  static Map<String, dynamic> _mockPostHelpTicketReply(RequestOptions options) {
    final DateTime now = DateTime.now();
    return {
      'data': {
        'identifier': options.data['ticket_identifier'],
        'subject': faker.lorem.sentence(),
        'message': faker.lorem.sentences(faker.randomGenerator.integer(4, min: 1)).join(". "),
        'read': faker.randomGenerator.boolean(),
        'resolved': faker.randomGenerator.boolean(),
        'updated_at': DateTime.now().toIso8601String(),
        'replies': [
          {
            'message': options.data['message'],
            'from_customer': true,
            'read': false,
            'created_at': now.toIso8601String(),
          },
          {
            'message': faker.lorem.sentences(faker.randomGenerator.integer(4, min: 1)).join(". "),
            'from_customer': faker.randomGenerator.boolean(),
            'read': faker.randomGenerator.boolean(),
            'created_at': DateTime(now.year, now.month, now.day - 1).toIso8601String(),
          },
        ]
      }
    };
  }

  static Map<String, dynamic> _mockPostHelpTicket(dynamic body) {
    return {
      'data': {
        'identifier': faker.guid.guid(),
        'subject': body['subject'],
        'message': body['message'],
        'read': false,
        'resolved': false,
        'updated_at': DateTime.now().toIso8601String(),
        'replies': []
      }
    };
  }

  static Map<String, dynamic> _mockPatchRepliesRead() {
    return generateHelpTicket();
  }

  static Map<String, dynamic> _mockDeleteHelpTicket() {
    return {
      'data': {
        'deleted': true
      }
    };
  }


  /////////////////// Internal Generators /////////////////////////////
  
  static Map<String, dynamic> _formatPaginatedResponse({
    required RequestOptions options,
    required List<Map<String, dynamic>> data,
    required bool doPaginate
  }) {
    String baseUrl = options.path;
    int currentPage = 1;

    if (options.path.contains('page=')) {
      List<String> urlSplit = options.path.split('page=');
      baseUrl = urlSplit[0];
      currentPage = int.parse(urlSplit[1]);
    } else {
      baseUrl = baseUrl.contains('?')
        ? "$baseUrl&"
        : "$baseUrl?";
    }

    return {
      'data': data,
      'links': {
        "first": baseUrl + "page=1",
        "last": doPaginate 
          ? baseUrl + "page=" + (currentPage + 1).toString()
          : baseUrl + "page=1",
        "prev": currentPage > 1
          ? baseUrl + 'page=' + (currentPage - 1).toString()
          : null,
        "next": doPaginate
          ? baseUrl + 'page=' + (currentPage + 1).toString()
          : null
      },
      'meta': {
        'current_page': 1,
        'from': 1,
        'last_page': 1,
        'path': 'http://novapay.ai/api/customer',
        'per_page': 25,
        'to': 1,
        'total': 10
      }
    };
  }
  
  
  static Map<String, dynamic> _createBusinesses({
    required RequestOptions options,
    int? numberBusinesses,
    String? name,
    bool canPaginate = true,
  }) {
    final bool doPaginate = canPaginate && faker.randomGenerator.boolean();

    numberBusinesses = doPaginate
      ? 25
      : numberBusinesses == null
        ? faker.randomGenerator.integer(25, min: 1)
        : numberBusinesses;

    final List<Map<String, dynamic>> data = List.generate(
      numberBusinesses,
      (index) => generateBusiness(name: name)
    );

    return _formatPaginatedResponse(options: options, data: data, doPaginate: doPaginate);
  }

  static Map<String, dynamic> _createHelpTickets({required RequestOptions options, bool? resolved}) {
    final bool doPaginate = faker.randomGenerator.boolean();
    final int numberHelpTickets = doPaginate
      ? 25
      : faker.randomGenerator.integer(25, min: 1);

    final List<Map<String, dynamic>> data = List.generate(
      numberHelpTickets, 
      (index) => generateHelpTicket(index: index, resolved: resolved)
    );

    return _formatPaginatedResponse(options: options, data: data, doPaginate: doPaginate);
  }

  static Map<String, dynamic> _createRefunds({
    required RequestOptions options,
    int? numberRefunds,
    bool canPaginate = true,
  }) {
    final bool doPaginate = canPaginate && faker.randomGenerator.boolean();

    numberRefunds = doPaginate
      ? 25
      : numberRefunds == null
        ? faker.randomGenerator.integer(25, min: 1)
        : numberRefunds;

    final List<Map<String, dynamic>> data = List.generate(
      numberRefunds, 
      (index) => generateRefundResource(index: index)
    );

    return _formatPaginatedResponse(options: options, data: data, doPaginate: doPaginate);
  }

  static Map<String, dynamic> _createTransactions({
    required RequestOptions options,
    int? numberTransactions,
    bool canPaginate = true,
  }) {
    final bool doPaginate = canPaginate && faker.randomGenerator.boolean();

    numberTransactions = doPaginate
      ? 25
      : numberTransactions == null
        ? faker.randomGenerator.integer(25, min: 1)
        : numberTransactions;

    final List<Map<String, dynamic>> data = List.generate(
      numberTransactions, 
      (index) => generateTransactionResource(index: index)
    );

    return _formatPaginatedResponse(options: options, data: data, doPaginate: doPaginate);
  }
  
  /////////////////// Generators ///////////////////////////////////
  

  static Map<String, dynamic> generateBeacon() {
    return {
      "identifier": faker.guid.guid(),
      "region_identifier": faker.guid.guid(),
      "major": faker.randomGenerator.integer(10000),
      "minor": faker.randomGenerator.integer(10000),
    };
  }

  static Map<String, dynamic> generateGeo() {
    return {
      "identifier": faker.guid.guid(),
      "lat": double.parse("${faker.randomGenerator.integer(90, min: -90)}.825491"),
      "lng": double.parse("${faker.randomGenerator.integer(180, min: -180)}.732108"),
      "radius": 50
    };
  }

  static Map<String, dynamic> generateRegion() {
    return {
      "identifier": faker.guid.guid(),
      "city": faker.address.city(),
      "state": faker.address.stateAbbreviation(),
      "zip": faker.randomGenerator.fromPattern(["#####"]),
      "neighborhood": faker.randomGenerator.boolean()
        ? faker.address.neighborhood()
        : null
    };
  }

  static Map<String, dynamic> generateLocation() {
    return {
      "geo": generateGeo(),
      "beacon": generateBeacon(),
      "region": generateRegion()
    };
  }

  static Map<String, dynamic> generateHours() {
    return {
      "monday": "Monday: 11:00 AM – 10:00 PM",
      "tuesday": "Tuesday: 11:00 AM – 10:00 PM",
      "wednesday": "Wednesday: 11:00 AM – 10:00 PM",
      "thursday": "Thursday: 11:00 AM – 10:00 PM",
      "friday": "Friday: 11:00 AM – 10:30 PM",
      "saturday": "Saturday: 11:00 AM – 10:30 PM",
      "sunday": "Sunday: 10:30 AM – 9:00 PM",
    };
  }

  static Map<String, dynamic> generateBusinessPhotos() {
    return {
      'logo': generateLogo(),
      'banner': generateBanner()
    };
  }
  
  static Map<String, dynamic> generateLogo() {
    return {
      'name': faker.lorem.word(),
      'small_url': faker.image.image(width: 200, height: 200, keywords: ['logo']),
      'large_url': faker.image.image(width: 400, height: 400, keywords: ['logo'])
    };
  }

  static Map<String, dynamic> generateBanner() {
    return {
      'name': faker.lorem.word(),
      'small_url': faker.image.image(width: 500, height: 325, keywords: ['logo']),
      'large_url': faker.image.image(width: 1000, height: 650, keywords: ['logo'])
    };
  }

  static Map<String, dynamic> generateBusinessProfile({String? name}) {
    return {
      'name': name == null ? faker.company.name() : name,
      'website': faker.internet.httpUrl(),
      'description': faker.lorem.sentences(faker.randomGenerator.integer(6, min: 2)).join(". "),
      'phone': faker.randomGenerator.fromPattern(["##########"]),
      'hours': generateHours()
    };
  }

  static Map<String, dynamic> generateBusiness({String? name}) {
    return {
      "identifier": faker.guid.guid(),
      "profile": generateBusinessProfile(name: name),
      'photos': generateBusinessPhotos(),
      "location": generateLocation()
    };
  }

  static Map<String, dynamic> generateAccount() {
    return {
      'identifier': faker.guid.guid(),
      'tip_rate': faker.randomGenerator.integer(30, min: 5),
      'quick_tip_rate': faker.randomGenerator.integer(15, min: 3),
      'primary': faker.randomGenerator.boolean() ? 'ach' : 'credit'
    };
  }

  static Map<String, dynamic> generateActiveLocation() {
    final List<String> types = ['fix_bill', 'auto_paid', 'bill_closed', 'exit'];
    final Random random = Random();
    
    return {
      "active_location_id": faker.guid.guid(),
      "beacon_identifier": faker.guid.guid(),
      "transaction_id": faker.randomGenerator.boolean() 
        ? faker.guid.guid()
        : null,
      "last_notification": faker.randomGenerator.boolean()
        ? types[random.nextInt(types.length)]
        : null
    };
  }

  static Map<String, dynamic> generateCustomerPhoto() {
    return {
      'name': faker.lorem.word(),
      'small_url': faker.image.image(width: 250, height: 250, keywords: ['person']),
      'large_url': faker.image.image(width: 500, height: 500, keywords: ['person'])
    };
  }

  static Map<String, dynamic> generateCustomerProfile() {
    return {
      'identifier': faker.guid.guid(),
      'first_name': faker.person.firstName(),
      'last_name': faker.person.lastName(),
      'photos': generateCustomerPhoto()
    };
  }

  static Map<String, dynamic> generateCustomer() {
    return {
      'identifier': faker.guid.guid(),
      'email': faker.internet.email(),
      'profile': generateCustomerProfile(),
      'account': generateAccount(),
      'status': {
        'name': 'Ready',
        'code': 200
      }
    };
  }

  static Map<String, dynamic> generateReply({int index = 0}) {
    DateTime date = DateTime.now();
    return {
      'message': faker.lorem.sentences(faker.randomGenerator.integer(4, min: 1)).join(". "),
      'from_customer': faker.randomGenerator.boolean(),
      'read': faker.randomGenerator.boolean(),
      'created_at': DateTime(date.year, date.month, date.day - index).toIso8601String(),
      'updated_at': DateTime(date.year, date.month, date.day - index).toIso8601String(),
    };
  }

  static Map<String, dynamic> generateHelpTicket({int index = 0, bool? resolved}) {
    DateTime date = DateTime.now();
    return {
      'identifier': faker.guid.guid(),
      'subject': faker.lorem.sentence(),
      'message': faker.lorem.sentences(faker.randomGenerator.integer(4, min: 1)).join(". "),
      'read': faker.randomGenerator.boolean(),
      'resolved': resolved == null ? faker.randomGenerator.boolean() : resolved,
      'updated_at': DateTime(date.year, date.month, date.day - index).toIso8601String(),
      'replies': List.generate(faker.randomGenerator.integer(5, min: 1), (index) => generateReply(index: index))
    };
  }

  static Map<String, dynamic> generateIssue() {
    return {
      'identifier': faker.guid.guid(),
      'type': 'wrong_bill',
      'issue': faker.lorem.sentences(faker.randomGenerator.integer(4, min: 1)).join(". "),
      'resolved': faker.randomGenerator.boolean(),
      'warnings_sent': faker.randomGenerator.integer(3),
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  static Map<String, dynamic> generatePurchasedItem() {
    final int price = faker.randomGenerator.integer(2000, min: 100);
    final int quantity = faker.randomGenerator.integer(4, min: 1);
    return {
      "name": faker.lorem.word(),
      "sub_name": faker.randomGenerator.boolean()
        ? faker.lorem.word()
        : null,
      "price": price,
      "quantity": quantity,
      "total": price * quantity
    };
  }

  static Map<String, dynamic> generateRefund({int index = 0}) {
    DateTime date = DateTime.now();
    return {
      "identifier": faker.guid.guid(),
      "total": faker.randomGenerator.integer(2000, min: 100),
      "created_at": DateTime(date.year, date.month, date.day - index).toIso8601String(),
      "status": "refund paid",
    };
  }
  
  static Map<String, dynamic> generateTransaction({int index = 0}) {
    DateTime date = DateTime.now();
    final int netSales = faker.randomGenerator.integer(10000, min: 1000);
    final int tax = (netSales * .0475).round();
    final int tip = faker.randomGenerator.integer(1) * ((netSales + tax) * ((faker.randomGenerator.integer(25, min: 5)) / 100)).round();
    final int total = netSales + tax + tip;
    return {
      "identifier": faker.guid.guid(),
      "employee_id": faker.randomGenerator.boolean()
        ? faker.guid.guid()
        : null,
      "tax": tax,
      "tip": tip,
      "net_sales": netSales,
      "total": total,
      "partial_payment": 0,
      "locked": false,
      "bill_created_at": DateTime(date.year, date.month, date.day - index).toIso8601String(),
      "updated_at": DateTime(date.year, date.month, date.day - index).toIso8601String(),
      "status": {
        "name": "open",
        "code": 100
      },
      "purchased_items": List.generate(faker.randomGenerator.integer(5, min: 1), (_) => generatePurchasedItem())
    };
  }

  static Map<String, dynamic> generateRefundResource({int index = 0}) {
    return {
      'refund': generateRefund(index: index),
      'business': generateBusiness(),
      'transaction': generateTransaction(index: index),
      'issue': generateIssue()
    };
  }

  static Map<String, dynamic> generateTransactionResource({int index = 0}) {
    return {
      'transaction': generateTransaction(index: index),
      'business': generateBusiness(),
      'refunds': List.generate(faker.randomGenerator.integer(3), (_) =>  generateRefund(index: index)),
      'issue': generateIssue()
    };
  }

  static Map<String, dynamic> generateTransactionForUnassignedTransaction({int index = 0}) {
    DateTime date = DateTime.now();
    final int netSales = faker.randomGenerator.integer(10000, min: 1000);
    final int tax = (netSales * .0475).round();
    final int total = netSales + tax;

    return {
      "identifier": faker.guid.guid(),
      "tax": tax,
      "net_sales": netSales,
      "total": total,
      "created_at": DateTime(date.year, date.month, date.day - index).toIso8601String(),
      "updated_at": DateTime(date.year, date.month, date.day - index).toIso8601String(),
      "purchased_items": List.generate(faker.randomGenerator.integer(5, min: 1), (_) => generatePurchasedItem())
    };
  }

  static Map<String, dynamic> generateUnassignedTransactionResource() {
    return {
      'transaction': generateTransactionForUnassignedTransaction(),
      'business': generateBusiness()
    };
  }

  static Map<String, dynamic> generateJWTToken({bool expired = false}) {
    DateTime date = DateTime.now();

    final claimSet = JwtClaim(
      issuer: "test",
      subject: "test",
      jwtId: faker.guid.guid(),
      expiry: expired
        ? DateTime(date.year, date.month, date.day, date.hour - 5)
        : DateTime(date.year, date.month, date.day, date.hour + 5),
    );

    final token = issueJwtHS256(claimSet, "test_key");
    return {'token': token};
  }

  /////////////////////// Helpers ////////////////////////////////
  
  static String? _parseStringFromUrl({required String url, required String needle}) {
    if (!url.contains(needle)) return null;

    String foundNeedle;
    final String splitFirst = url.split(needle)[1];
    if (splitFirst.contains("&")) {
      foundNeedle = splitFirst.substring(0, splitFirst.indexOf("&"));
    } else {
      foundNeedle = splitFirst;
    }

    return foundNeedle;
  }
}