 

import 'package:dio/dio.dart';

class MockResponses {
  
  static Map<String, dynamic> mockResponse(RequestOptions options) {
    if (options.path.endsWith("auth/register")) {
      return _mockRegister(options);
    } else if (options.path.endsWith("auth/login")) {
      return _mockLogin(options);
    } else if (options.path.endsWith("geo-location")) {
      return _mockOnStart(options);
    } else if (options.path.endsWith('profile')) {
      return _mockStoreProfile(options);
    } else if (options.path.endsWith('profile/fake_identifier')) {
      return _mockStoreProfile(options);
    } else if (options.path.endsWith('/me')) {
      return _mockFetchCustomer();
    } else if (options.path.endsWith('me/fake_identifier')) {
      return _mockUpdateCustomer();
    } else if (options.path.endsWith('avatar/fake_identifier')) {
      return _mockPostPhoto();
    } else if (options.path.endsWith('password-check')) {
      return _mockCheckValidPassword();
    } else if (options.path.endsWith('?status=200&page=1')) {
      return _mockFetchPaidTransactions();
    } else if (options.path.endsWith('?status=200&page=2')) {
      return _mockFetchPaidTransactionsTwo();
    } else if (options.path.endsWith('account/fake_identifier')) {
      return _mockUpdateAccount();
    } else if (options.path.contains("transaction?date[]=")) {
      return _mockFetchDateTransactions();
    } else if (options.path.contains('business?name=')) {
      return _mockFetchBusinessesByName();
    } else if (options.path.contains('transaction?business=')) {
      return _mockFetchTransactionsByBusiness();
    } else if (options.path.contains('transaction?id=')) {
      return _mockFetchTransactionsByIdentifier();
    } else if (options.path.endsWith('transaction?open=true')) {
      return _mockFetchOpenTransaction();
    } else if (options.path.endsWith('refund?page=1')) {
      return _mockFetchAllRefunds();
    } else if (options.path.endsWith('refund?page=2')) {
      return _mockFetchAllRefundsTwo();
    } else if (options.path.contains("refund?date[]=")) {
      return _mockFetchRefundsByDate();
    } else if (options.path.contains("refund?business=")) {
      return _mockFetchRefundsByBusiness();
    } else if (options.path.contains("refund?id=")) {
      return _mockFetchRefundById();
    } else if (options.path.contains("refund?transactionId=")) {
      return _mockFetchRefundByTransaction();
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
      return _mockChangeTransactionIssue(options);
    } else if (options.path.contains('transaction-issue/') && options.method.toLowerCase() == 'delete') {
      return _mockDeleteIssue();
    } else {
      return null;
    }
  }

  static Map<String, dynamic> _mockPostPhoto() {
    return {
      'data': {
        'identifier': 'fake_identifier',
        'email': 'fake@gmail.com',
        'token': 'not_a_real_token',
        'profile': {
          'identifier': 'fake_identifier',
          'first_name': 'Nick',
          'last_name': 'Bonnaud',
          'photos': {
            'name': 'fake_avatar.png',
            'small_url': 'https://moresmilesdentalclinic.com/wp-content/uploads/2017/09/bigstock-profile-of-male-geek-smiling-w-35555741-250x250-1.jpg',
            'large_url': 'https://corporate-rebels.com/CDN/378-500x500.jpg'
          }
        },
        'account': {
          'identifier': 'fake_identifier',
          'tip_rate': '15',
          'quick_tip_rate': '5',
          'primary': 'ach'
        },
        'status': {
          'name': 'Ready',
          'code': '102'
        }
      }
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
        'customer': {
          'identifier': 'fake_identifier',
          'email': 'nick@gmail.com',
          'token': "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9sb2NhbGhvc3RcL2FwaVwvY3VzdG9tZXJcL21lIiwiaWF0IjoxNTgyMTM2NDk0LCJleHAiOjE1OTc5MDQ0OTUsIm5iZiI6MTU4MjEzNjQ5NSwianRpIjoiQVZYUnhNOVBsUnNuZDFqRSIsInN1YiI6MSwicHJ2IjoiZGE5YzU1NjBkZTE2MTUzYmE4MTgwYzU4OTNmZDc0OTRhZDU4YWY5ZSJ9._qGQeHTjiT90MT-zV3XOoA154XzOruP8HmwcnS4tNwk",
          'profile': null,
          'account' : {
            'identifier': 'fake_identifier',
            'tip_rate': '15',
            'quick_tip_rate': '5',
            'primary': 'ach'
          },
          'status': {
            'name': 'Profile Account Incomplete',
            'code': "100"
          }
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
        'identifier': 'fake_identifier',
        'email': 'fake@gmail.com',
        'token': 'not_a_real_token',
        'profile': {
          'identifier': 'fake_identifier',
          'first_name': 'Nick',
          'last_name': 'Bonnaud',
          'photos': null
        },
        'account': {
          'identifier': 'fake_identifier',
          'tip_rate': '15',
          'quick_tip_rate': '5',
          'primary': 'ach'
        },
        'status': {
          'name': 'Ready',
          'code': '101'
        }
      }
    };
  }

  static Map<String, dynamic> _mockFetchCustomer() {
    // return {
    //   'data': {
    //     'identifier': 'fake_identifier',
    //     'email': 'fake@gmail.com',
    //     'token': 'not_a_real_token',
    //     'profile': null,
    //     'account': {
    //       'identifier': 'fake_identifier',
    //       'tip_rate': '15',
    //       'quick_tip_rate': '5',
    //       'primary': 'ach'
    //     },
    //     'status': {
    //       'name': 'Profile Account Incomplete',
    //       'code': '100'
    //     }
    //   }
    // };
    
    
    return {
      'data': {
        'identifier': 'fake_identifier_new',
        'email': 'fake@gmail.com',
        'token': 'not_a_real_token',
        'profile': {
          'identifier': 'fake_identifier',
          'first_name': 'Nick',
          'last_name': 'Bonnaud',
          'photos': {
            'name': 'fake-profile.png',
            'small_url': 'https://upload.wikimedia.org/wikipedia/commons/4/46/Gabrielpalatch-headshot-500x500.png',
            'large_url': 'https://cdn2.pauldavis.info/wp-content/uploads/sites/878/2019/02/26174944/Nate-Headshot-250x250.jpg'
          }
        },
        'account': {
          'identifier': 'fake_identifier',
          'tip_rate': '15',
          'quick_tip_rate': '5',
          'primary': 'ach'
        },
        'status': {
          'name': 'Ready',
          'code': '200'
        }
      }
    };
  }

  static Map<String, dynamic> _mockUpdateCustomer() {
    return {
      'data': {
        'identifier': 'fake_identifier',
        'email': 'new@gmail.com',
        'token': 'not_a_real_token',
        'profile': {
          'identifier': 'fake_identifier',
          'first_name': 'Nick',
          'last_name': 'Bonnaud',
          'photos': {
            'name': 'fake-profile.png',
            'small_url': 'https://upload.wikimedia.org/wikipedia/commons/4/46/Gabrielpalatch-headshot-500x500.png',
            'large_url': 'https://cdn2.pauldavis.info/wp-content/uploads/sites/878/2019/02/26174944/Nate-Headshot-250x250.jpg'
          }
        },
        'account': {
          'identifier': 'fake_identifier',
          'tip_rate': '15',
          'quick_tip_rate': '5',
          'primary': 'ach'
        },
        'status': {
          'name': 'Ready',
          'code': '200'
        }
      }
    };
  }

  static Map<String, dynamic> _mockLogin(RequestOptions options) {
    return {
      'data': {
        'customer': {
          'identifier': 'fake_identifier',
          'email': 'fake@email.com',
          'token': "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9sb2NhbGhvc3RcL2FwaVwvY3VzdG9tZXJcL21lIiwiaWF0IjoxNTgyMTM2NDk0LCJleHAiOjE1OTc5MDQ0OTUsIm5iZiI6MTU4MjEzNjQ5NSwianRpIjoiQVZYUnhNOVBsUnNuZDFqRSIsInN1YiI6MSwicHJ2IjoiZGE5YzU1NjBkZTE2MTUzYmE4MTgwYzU4OTNmZDc0OTRhZDU4YWY5ZSJ9._qGQeHTjiT90MT-zV3XOoA154XzOruP8HmwcnS4tNwk",
          'profile': {
            'identifier': 'fake_profile_identifier',
            'first_name': 'Nick',
            'last_name': "Test",
            'photos': {
              'name': 'photo.png',
              'small_url': 'http://localhost/small_url.png',
              'large_url': 'http://localhost/large_url.png'
            }
          },
          'account': {
            'identifier': 'fake_identifier',
            'tip_rate': '15',
            'quick_tip_rate': '5',
            'primary': 'ach'
          },
          'status': {
            'name': 'Profile Account Incomplete',
            'code': "100"
          }
        }
      }
    };
  }

  static Map<String, dynamic> _mockUpdateAccount() {
    return {
      'data': {
        'identifier': 'fake_identifier',
        'email': 'fake@gmail.com',
        'token': 'not_a_real_token',
        'profile': {
          'identifier': 'fake_identifier',
          'first_name': 'Nick',
          'last_name': 'Bonnaud',
          'photos': {
            'name': 'fake_avatar.png',
            'small_url': 'https://moresmilesdentalclinic.com/wp-content/uploads/2017/09/bigstock-profile-of-male-geek-smiling-w-35555741-250x250-1.jpg',
            'large_url': 'https://corporate-rebels.com/CDN/378-500x500.jpg'
          }
        },
        'account': {
          'identifier': 'fake_identifier',
          'tip_rate': '15',
          'quick_tip_rate': '7',
          'primary': 'ach'
        },
        'status': {
          'name': 'Ready',
          'code': '103'
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

  static Map<String, dynamic> _mockFetchDateTransactions() {
    return {
      "data": [
        {
          "transaction": {
            "identifier": "3ff9ad40-79c9-11ea-8b92-a9b4a4c53696",
            "employee_id": null,
            "tax": "457",
            "tip": "1636",
            "net_sales": "6088",
            "total": "8181",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-08 18:46:25",
            "updated_at": "2020-04-08 18:46:25",
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
              'name': "logo_1.png",
              'small_url': "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0019/1114/brand.gif?itok=DKwKOdLe",
              'large_url': "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0019/1114/brand.gif?itok=DKwKOdLe"
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
          "refund": [],
          'issue': null
        },
        {
          "transaction": {
            "identifier": "3ffcf790-79c9-11ea-9786-cda2137559e5",
            "employee_id": null,
            "tax": "54",
            "tip": "77",
            "net_sales": "715",
            "total": "846",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-08 18:46:25",
            "updated_at": "2020-04-08 18:46:25",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "voluptatem",
                "sub_name": "cnsjbjia",
                "price": "1200",
                "quantity": "5",
                "total": "60000"
              },
              {
                "name": "exercitationem",
                "sub_name": 'fskdsf',
                "price": "499",
                "quantity": "2",
                "total": "998"
              },
              {
                "name": "coiahfioda",
                "sub_name": 'fdsankfd',
                "price": "999",
                "quantity": "4",
                "total": "4995"
              },
              {
                "name": "bcjadsbji",
                "sub_name": null,
                "price": "1500",
                "quantity": "1",
                "total": "1500"
              }
            ]
          },
          "business": {
            "identifier": "3ffb7e00-79c9-11ea-8327-0591af6899fa",
            "profile": {
              "name": "Breitenberg and Sons",
              "website": "stroman.com",
              "description": "Tempora non esse iusto libero libero dolores voluptas. Eligendi incidunt impedit ducimus beatae animi voluptatem eligendi rerum. Temporibus earum aut ut sunt dolor nobis. Officiis cumque quae suscipit consectetur et.",
              "google_place_id": null,
              "phone": "0075281221",
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
              'name': "banner_2.png",
              'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
              'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
            },
          },
            "location": {
              "geo": {
                "identifier": "3ffc9af0-79c9-11ea-8ba2-7bc9ac2c03dc",
                "lat": "37.826977",
                "lng": "-122.422958",
                "radius": "50"
              },
              "beacon": {
                "identifier": "3ffc9af0-79c9-11ea-8ba2-7bc9ac2c03dc",
                "region_identifier": "3ffc8fb0-79c9-11ea-8a8d-e920600f039b",
                "major": "2",
                "minor": "3"
              },
              "region": {
                "identifier": "3ffc8fb0-79c9-11ea-8a8d-e920600f039b",
                "city": "east kirsten",
                "state": "ca",
                "zip": "72393",
                "neighborhood": null
              }
            }
          },
          "refund": [],
          'issue': null
        },
        {
          "transaction": {
            "identifier": "3fff7d10-79c9-11ea-aeda-29f060c8d318",
            "employee_id": null,
            "tax": "101",
            "tip": "0",
            "net_sales": "1344",
            "total": "1445",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-08 18:46:25",
            "updated_at": "2020-04-08 18:46:25",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "sequi",
                "sub_name": 'acdsa',
                "price": "1099",
                "quantity": "10",
                "total": "10990"
              },
              {
                "name": "totam",
                "sub_name": 'afdsafd',
                "price": "99",
                "quantity": "1",
                "total": "99"
              }
            ]
          },
          "business": {
            "identifier": "3ffdfd70-79c9-11ea-b016-91e22ba79bcd",
            "profile": {
              "name": "O'Connell Ltd",
              "website": "dach.com",
              "description": "Error repudiandae beatae ex facilis. In est quis ut et in voluptate incidunt. Nulla veniam in ut quasi nobis qui. Hic qui enim harum animi consequatur dolor.",
              "google_place_id": null,
              "phone": "1739470180",
              "hours": {
                "monday": "Monday: 11:00 AM – 10:00 PM",
                "tuesday": "Tuesday: 11:00 AM – 10:00 PM",
                "wednesday": "Wednesday: 11:00 AM – 10:00 PM",
                "thursday": "Thursday: 11:00 AM – 10:00 PM",
                "friday": "Friday: 11:00 AM – 10:30 PM",
                "saturday": "Saturday: 11:00 AM – 10:30 PM",
                "sunday": "Sunday: 10:30 AM – 9:00 PM"
              }
            },
            'photos': {
            'logo': {
              'name': "logo_3.png",
              'small_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg",
              'large_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg"
            },
            'banner': {
              'name': "banner_3.png",
              'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
              'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
            },
          },
            "location": {
              "geo": {
                "identifier": "3fff26c0-79c9-11ea-9608-69d83ac82698",
                "lat": "51.500729",
                "lng": "-0.124625",
                "radius": "50"
              },
              "beacon": {
                "identifier": "3fff26c0-79c9-11ea-9608-69d83ac82698",
                "region_identifier": "3fff1ca0-79c9-11ea-8448-55028a12fcdf",
                "major": "2",
                "minor": "3"
              },
              "region": {
                "identifier": "3fff1ca0-79c9-11ea-8448-55028a12fcdf",
                "city": "east juvenalton",
                "state": "pa",
                "zip": "68109",
                "neighborhood": null
              }
            }
          },
          "refund": [],
          'issue': null
        },
        {
          "transaction": {
            "identifier": "3ff9ad40-79c9-11ea-8b92-a9b4a4c53696",
            "employee_id": null,
            "tax": "683",
            "tip": "2864",
            "net_sales": "9152",
            "total": "101223",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-08 18:46:25",
            "updated_at": "2020-04-08 18:46:25",
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
              },
              {
                "name": "vfs",
                "sub_name": 'fbjdss',
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              },
              {
                "name": "cdcd",
                "sub_name": null,
                "price": "1200",
                "quantity": "2",
                "total": "2400"
              },
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
              'name': "logo_1.png",
              'small_url': "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0019/1114/brand.gif?itok=DKwKOdLe",
              'large_url': "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0019/1114/brand.gif?itok=DKwKOdLe"
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
          "refund": [],
          'issue': null
        },
      ],
      "links": {
        "first": "http://localhost/api/customer/transaction?page=1",
        "last": "http://localhost/api/customer/transaction?page=1",
        "prev": null,
        "next": null
      },
      "meta": {
        "current_page": 1,
        "from": 1,
        "last_page": 1,
        "path": "http://localhost/api/customer/transaction",
        "per_page": 15,
        "to": 4,
        "total": 4,
      }
    };
  }

  static Map<String, dynamic> _mockFetchPaidTransactions() {
    return {
      "data": [
        {
          "transaction": {
            "identifier": "3ff9ad40-79c9-11ea-8b91-a9b4a4c53696",
            "employee_id": null,
            "tax": "457",
            "tip": "1636",
            "net_sales": "6088",
            "total": "8181",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-08 18:46:25",
            "updated_at": "2020-04-08 18:46:25",
            "status": {
              "name": "paid",
              "code": "200"
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
              'name': "logo_1.png",
              'small_url': "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0019/1114/brand.gif?itok=DKwKOdLe",
              'large_url': "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0019/1114/brand.gif?itok=DKwKOdLe"
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
          "refund": [],
          'issue': null
        },
        {
          "transaction": {
            "identifier": "3ffcf791-79c9-11ea-9786-cda2137559e5",
            "employee_id": null,
            "tax": "54",
            "tip": "77",
            "net_sales": "715",
            "total": "846",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-08 18:46:25",
            "updated_at": "2020-04-08 18:46:25",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "voluptatem",
                "sub_name": "cnsjbjia",
                "price": "1200",
                "quantity": "5",
                "total": "60000"
              },
              {
                "name": "exercitationem",
                "sub_name": 'fskdsf',
                "price": "499",
                "quantity": "2",
                "total": "998"
              },
              {
                "name": "coiahfioda",
                "sub_name": 'fdsankfd',
                "price": "999",
                "quantity": "4",
                "total": "4995"
              },
              {
                "name": "bcjadsbji",
                "sub_name": null,
                "price": "1500",
                "quantity": "1",
                "total": "1500"
              }
            ]
          },
          "business": {
            "identifier": "3ffb7e10-79c9-11ea-8327-0591a16899fa",
            "profile": {
              "name": "Breitenberg and Sons",
              "website": "stroman.com",
              "description": "Tempora non esse iusto libero libero dolores voluptas. Eligendi incidunt impedit ducimus beatae animi voluptatem eligendi rerum. Temporibus earum aut ut sunt dolor nobis. Officiis cumque quae suscipit consectetur et.",
              "google_place_id": null,
              "phone": "0075281221",
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
              'name': "banner_2.png",
              'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
              'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
            },
          },
            "location": {
              "geo": {
                "identifier": "3ffc9af0-79c9-11ea-8ba2-7bc9ac2c03dc",
                "lat": "37.826977",
                "lng": "-122.422958",
                "radius": "50"
              },
              "beacon": {
                "identifier": "3ffc9af0-79c9-11ea-8ba2-7bc9ac2c03dc",
                "region_identifier": "3ffc8fb0-79c9-11ea-8a8d-e920600f039b",
                "major": "2",
                "minor": "3"
              },
              "region": {
                "identifier": "3ffc8fb0-79c9-11ea-8a8d-e920600f039b",
                "city": "east kirsten",
                "state": "ca",
                "zip": "72393",
                "neighborhood": null
              }
            }
          },
          "refund": [],
          'issue': null
        },
        {
          "transaction": {
            "identifier": "3fff7d10-79c9-11ea-aedz-29f060c8d318",
            "employee_id": null,
            "tax": "101",
            "tip": "0",
            "net_sales": "1344",
            "total": "1445",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-08 18:46:25",
            "updated_at": "2020-04-08 18:46:25",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "sequi",
                "sub_name": 'acdsa',
                "price": "1099",
                "quantity": "10",
                "total": "10990"
              },
              {
                "name": "totam",
                "sub_name": 'afdsafd',
                "price": "99",
                "quantity": "1",
                "total": "99"
              }
            ]
          },
          "business": {
            "identifier": "3ffdfd70-79c9-11ea-b016-91e22ba79bcd",
            "profile": {
              "name": "O'Connell Ltd",
              "website": "dach.com",
              "description": "Error repudiandae beatae ex facilis. In est quis ut et in voluptate incidunt. Nulla veniam in ut quasi nobis qui. Hic qui enim harum animi consequatur dolor.",
              "google_place_id": null,
              "phone": "1739470180",
              "hours": {
                "monday": "Monday: 11:00 AM – 10:00 PM",
                "tuesday": "Tuesday: 11:00 AM – 10:00 PM",
                "wednesday": "Wednesday: 11:00 AM – 10:00 PM",
                "thursday": "Thursday: 11:00 AM – 10:00 PM",
                "friday": "Friday: 11:00 AM – 10:30 PM",
                "saturday": "Saturday: 11:00 AM – 10:30 PM",
                "sunday": "Sunday: 10:30 AM – 9:00 PM"
              }
            },
            'photos': {
            'logo': {
              'name': "logo_3.png",
              'small_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg",
              'large_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg"
            },
            'banner': {
              'name': "banner_3.png",
              'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
              'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
            },
          },
            "location": {
              "geo": {
                "identifier": "3fff26c0-79c9-11ea-9608-69d83ac82698",
                "lat": "51.500729",
                "lng": "-0.124625",
                "radius": "50"
              },
              "beacon": {
                "identifier": "3fff26c0-79c9-11ea-9608-69d83ac82698",
                "region_identifier": "3fff1ca0-79c9-11ea-8448-55028a12fcdf",
                "major": "2",
                "minor": "3"
              },
              "region": {
                "identifier": "3fff1ca0-79c9-11ea-8448-55028a12fcdf",
                "city": "east juvenalton",
                "state": "pa",
                "zip": "68109",
                "neighborhood": null
              }
            }
          },
          "refund": [],
          'issue': null
        },
        {
          "transaction": {
            "identifier": "3ff9ad40-79c9-11ea-8b92-a9b4a4c536c6",
            "employee_id": null,
            "tax": "457",
            "tip": "1636",
            "net_sales": "6088",
            "total": "8181",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-08 18:46:25",
            "updated_at": "2020-04-08 18:46:25",
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
              'name': "logo_1.png",
              'small_url': "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0019/1114/brand.gif?itok=DKwKOdLe",
              'large_url': "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0019/1114/brand.gif?itok=DKwKOdLe"
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
          "refund": [],
          'issue': null
        },
        {
          "transaction": {
            "identifier": "3ffcf790-79c9-11ea-9786-cda2137559e3",
            "employee_id": null,
            "tax": "54",
            "tip": "77",
            "net_sales": "715",
            "total": "846",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-08 18:46:25",
            "updated_at": "2020-04-08 18:46:25",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "voluptatem",
                "sub_name": "cnsjbjia",
                "price": "1200",
                "quantity": "5",
                "total": "60000"
              },
              {
                "name": "exercitationem",
                "sub_name": 'fskdsf',
                "price": "499",
                "quantity": "2",
                "total": "998"
              },
              {
                "name": "coiahfioda",
                "sub_name": 'fdsankfd',
                "price": "999",
                "quantity": "4",
                "total": "4995"
              },
              {
                "name": "bcjadsbji",
                "sub_name": null,
                "price": "1500",
                "quantity": "1",
                "total": "1500"
              }
            ]
          },
          "business": {
            "identifier": "3ffb7e00-79c9-11ea-8327-0591af6899fa",
            "profile": {
              "name": "Breitenberg and Sons",
              "website": "stroman.com",
              "description": "Tempora non esse iusto libero libero dolores voluptas. Eligendi incidunt impedit ducimus beatae animi voluptatem eligendi rerum. Temporibus earum aut ut sunt dolor nobis. Officiis cumque quae suscipit consectetur et.",
              "google_place_id": null,
              "phone": "0075281221",
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
              'name': "banner_2.png",
              'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
              'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
            },
          },
            "location": {
              "geo": {
                "identifier": "3ffc9af0-79c9-11ea-8ba2-7bc9ac2c03dc",
                "lat": "37.826977",
                "lng": "-122.422958",
                "radius": "50"
              },
              "beacon": {
                "identifier": "3ffc9af0-79c9-11ea-8ba2-7bc9ac2c03dc",
                "region_identifier": "3ffc8fb0-79c9-11ea-8a8d-e920600f039b",
                "major": "2",
                "minor": "3"
              },
              "region": {
                "identifier": "3ffc8fb0-79c9-11ea-8a8d-e920600f039b",
                "city": "east kirsten",
                "state": "ca",
                "zip": "72393",
                "neighborhood": null
              }
            }
          },
          "refund": [],
          'issue': null
        },
        {
          "transaction": {
            "identifier": "3fff7d10-79c9-31ea-aeda-29f060c8d318",
            "employee_id": null,
            "tax": "101",
            "tip": "0",
            "net_sales": "1344",
            "total": "1445",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-08 18:46:25",
            "updated_at": "2020-04-08 18:46:25",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "sequi",
                "sub_name": 'acdsa',
                "price": "1099",
                "quantity": "10",
                "total": "10990"
              },
              {
                "name": "totam",
                "sub_name": 'afdsafd',
                "price": "99",
                "quantity": "1",
                "total": "99"
              }
            ]
          },
          "business": {
            "identifier": "3ffdfd70-79c9-11ea-b016-91e22ba79bcd",
            "profile": {
              "name": "O'Connell Ltd",
              "website": "dach.com",
              "description": "Error repudiandae beatae ex facilis. In est quis ut et in voluptate incidunt. Nulla veniam in ut quasi nobis qui. Hic qui enim harum animi consequatur dolor.",
              "google_place_id": null,
              "phone": "1739470180",
              "hours": {
                "monday": "Monday: 11:00 AM – 10:00 PM",
                "tuesday": "Tuesday: 11:00 AM – 10:00 PM",
                "wednesday": "Wednesday: 11:00 AM – 10:00 PM",
                "thursday": "Thursday: 11:00 AM – 10:00 PM",
                "friday": "Friday: 11:00 AM – 10:30 PM",
                "saturday": "Saturday: 11:00 AM – 10:30 PM",
                "sunday": "Sunday: 10:30 AM – 9:00 PM"
              }
            },
            'photos': {
            'logo': {
              'name': "logo_3.png",
              'small_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg",
              'large_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg"
            },
            'banner': {
              'name': "banner_3.png",
              'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
              'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
            },
          },
            "location": {
              "geo": {
                "identifier": "3fff26c0-79c9-11ea-9608-69d83ac82698",
                "lat": "51.500729",
                "lng": "-0.124625",
                "radius": "50"
              },
              "beacon": {
                "identifier": "3fff26c0-79c9-11ea-9608-69d83ac82698",
                "region_identifier": "3fff1ca0-79c9-11ea-8448-55028a12fcdf",
                "major": "2",
                "minor": "3"
              },
              "region": {
                "identifier": "3fff1ca0-79c9-11ea-8448-55028a12fcdf",
                "city": "east juvenalton",
                "state": "pa",
                "zip": "68109",
                "neighborhood": null
              }
            }
          },
          "refund": [],
          'issue': null
        },
        {
          "transaction": {
            "identifier": "3ff9ad40-79c8-11ea-8b92-a9b4a4c53696",
            "employee_id": null,
            "tax": "457",
            "tip": "1636",
            "net_sales": "6088",
            "total": "8181",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-08 18:46:25",
            "updated_at": "2020-04-08 18:46:25",
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
              'name': "logo_1.png",
              'small_url': "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0019/1114/brand.gif?itok=DKwKOdLe",
              'large_url': "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0019/1114/brand.gif?itok=DKwKOdLe"
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
          "refund": [],
          'issue': null
        },
        {
          "transaction": {
            "identifier": "3ffcf790-79c9-11ea-9786-cda2137549e5",
            "employee_id": null,
            "tax": "54",
            "tip": "77",
            "net_sales": "715",
            "total": "846",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-08 18:46:25",
            "updated_at": "2020-04-08 18:46:25",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "voluptatem",
                "sub_name": "cnsjbjia",
                "price": "1200",
                "quantity": "5",
                "total": "60000"
              },
              {
                "name": "exercitationem",
                "sub_name": 'fskdsf',
                "price": "499",
                "quantity": "2",
                "total": "998"
              },
              {
                "name": "coiahfioda",
                "sub_name": 'fdsankfd',
                "price": "999",
                "quantity": "4",
                "total": "4995"
              },
              {
                "name": "bcjadsbji",
                "sub_name": null,
                "price": "1500",
                "quantity": "1",
                "total": "1500"
              }
            ]
          },
          "business": {
            "identifier": "3ffb7e00-79c9-11ea-8327-0591af6899fa",
            "profile": {
              "name": "Breitenberg and Sons",
              "website": "stroman.com",
              "description": "Tempora non esse iusto libero libero dolores voluptas. Eligendi incidunt impedit ducimus beatae animi voluptatem eligendi rerum. Temporibus earum aut ut sunt dolor nobis. Officiis cumque quae suscipit consectetur et.",
              "google_place_id": null,
              "phone": "0075281221",
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
              'name': "banner_2.png",
              'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
              'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
            },
          },
            "location": {
              "geo": {
                "identifier": "3ffc9af0-79c9-11ea-8ba2-7bc9ac2c03dc",
                "lat": "37.826977",
                "lng": "-122.422958",
                "radius": "50"
              },
              "beacon": {
                "identifier": "3ffc9af0-79c9-11ea-8ba2-7bc9ac2c03dc",
                "region_identifier": "3ffc8fb0-79c9-11ea-8a8d-e920600f039b",
                "major": "2",
                "minor": "3"
              },
              "region": {
                "identifier": "3ffc8fb0-79c9-11ea-8a8d-e920600f039b",
                "city": "east kirsten",
                "state": "ca",
                "zip": "72393",
                "neighborhood": null
              }
            }
          },
          "refund": [],
          'issue': null
        },
        {
          "transaction": {
            "identifier": "1fff7d10-79c9-11ea-aeda-29f060c8d318",
            "employee_id": null,
            "tax": "101",
            "tip": "0",
            "net_sales": "1344",
            "total": "1445",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-08 18:46:25",
            "updated_at": "2020-04-08 18:46:25",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "sequi",
                "sub_name": 'acdsa',
                "price": "1099",
                "quantity": "10",
                "total": "10990"
              },
              {
                "name": "totam",
                "sub_name": 'afdsafd',
                "price": "99",
                "quantity": "1",
                "total": "99"
              }
            ]
          },
          "business": {
            "identifier": "3ffdfd70-79c9-11ea-b016-91e22ba79bcd",
            "profile": {
              "name": "O'Connell Ltd",
              "website": "dach.com",
              "description": "Error repudiandae beatae ex facilis. In est quis ut et in voluptate incidunt. Nulla veniam in ut quasi nobis qui. Hic qui enim harum animi consequatur dolor.",
              "google_place_id": null,
              "phone": "1739470180",
              "hours": {
                "monday": "Monday: 11:00 AM – 10:00 PM",
                "tuesday": "Tuesday: 11:00 AM – 10:00 PM",
                "wednesday": "Wednesday: 11:00 AM – 10:00 PM",
                "thursday": "Thursday: 11:00 AM – 10:00 PM",
                "friday": "Friday: 11:00 AM – 10:30 PM",
                "saturday": "Saturday: 11:00 AM – 10:30 PM",
                "sunday": "Sunday: 10:30 AM – 9:00 PM"
              }
            },
            'photos': {
            'logo': {
              'name': "logo_3.png",
              'small_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg",
              'large_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg"
            },
            'banner': {
              'name': "banner_3.png",
              'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
              'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
            },
          },
            "location": {
              "geo": {
                "identifier": "3fff26c0-79c9-11ea-9608-69d83ac82698",
                "lat": "51.500729",
                "lng": "-0.124625",
                "radius": "50"
              },
              "beacon": {
                "identifier": "3fff26c0-79c9-11ea-9608-69d83ac82698",
                "region_identifier": "3fff1ca0-79c9-11ea-8448-55028a12fcdf",
                "major": "2",
                "minor": "3"
              },
              "region": {
                "identifier": "3fff1ca0-79c9-11ea-8448-55028a12fcdf",
                "city": "east juvenalton",
                "state": "pa",
                "zip": "68109",
                "neighborhood": null
              }
            }
          },
          "refund": [],
          'issue': null
        },
        {
          "transaction": {
            "identifier": "3ff9ad40-79g9-11ea-8b92-a9b4a4c53696",
            "employee_id": null,
            "tax": "457",
            "tip": "1636",
            "net_sales": "6088",
            "total": "8181",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-08 18:46:25",
            "updated_at": "2020-04-08 18:46:25",
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
              'name': "logo_1.png",
              'small_url': "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0019/1114/brand.gif?itok=DKwKOdLe",
              'large_url': "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0019/1114/brand.gif?itok=DKwKOdLe"
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
          "refund": [],
          'issue': null
        },
        {
          "transaction": {
            "identifier": "3ffcf790-79c9-11ea-9776-cda2137559e5",
            "employee_id": null,
            "tax": "54",
            "tip": "77",
            "net_sales": "715",
            "total": "846",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-08 18:46:25",
            "updated_at": "2020-04-08 18:46:25",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "voluptatem",
                "sub_name": "cnsjbjia",
                "price": "1200",
                "quantity": "5",
                "total": "60000"
              },
              {
                "name": "exercitationem",
                "sub_name": 'fskdsf',
                "price": "499",
                "quantity": "2",
                "total": "998"
              },
              {
                "name": "coiahfioda",
                "sub_name": 'fdsankfd',
                "price": "999",
                "quantity": "4",
                "total": "4995"
              },
              {
                "name": "bcjadsbji",
                "sub_name": null,
                "price": "1500",
                "quantity": "1",
                "total": "1500"
              }
            ]
          },
          "business": {
            "identifier": "3ffb7e00-79c9-11ea-8327-0591af6899fa",
            "profile": {
              "name": "Breitenberg and Sons",
              "website": "stroman.com",
              "description": "Tempora non esse iusto libero libero dolores voluptas. Eligendi incidunt impedit ducimus beatae animi voluptatem eligendi rerum. Temporibus earum aut ut sunt dolor nobis. Officiis cumque quae suscipit consectetur et.",
              "google_place_id": null,
              "phone": "0075281221",
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
              'name': "banner_2.png",
              'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
              'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
            },
          },
            "location": {
              "geo": {
                "identifier": "3ffc9af0-79c9-11ea-8ba2-7bc9ac2c03dc",
                "lat": "37.826977",
                "lng": "-122.422958",
                "radius": "50"
              },
              "beacon": {
                "identifier": "3ffc9af0-79c9-11ea-8ba2-7bc9ac2c03dc",
                "region_identifier": "3ffc8fb0-79c9-11ea-8a8d-e920600f039b",
                "major": "2",
                "minor": "3"
              },
              "region": {
                "identifier": "3ffc8fb0-79c9-11ea-8a8d-e920600f039b",
                "city": "east kirsten",
                "state": "ca",
                "zip": "72393",
                "neighborhood": null
              }
            }
          },
          "refund": [],
          'issue': null
        },
        {
          "transaction": {
            "identifier": "3fff7d10-79c9-11ea-atda-29f060c8d318",
            "employee_id": null,
            "tax": "101",
            "tip": "0",
            "net_sales": "1344",
            "total": "1445",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-08 18:46:25",
            "updated_at": "2020-04-08 18:46:25",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "sequi",
                "sub_name": 'acdsa',
                "price": "1099",
                "quantity": "10",
                "total": "10990"
              },
              {
                "name": "totam",
                "sub_name": 'afdsafd',
                "price": "99",
                "quantity": "1",
                "total": "99"
              }
            ]
          },
          "business": {
            "identifier": "3ffdfd70-79c9-11ea-b016-91e22ba79bcd",
            "profile": {
              "name": "O'Connell Ltd",
              "website": "dach.com",
              "description": "Error repudiandae beatae ex facilis. In est quis ut et in voluptate incidunt. Nulla veniam in ut quasi nobis qui. Hic qui enim harum animi consequatur dolor.",
              "google_place_id": null,
              "phone": "1739470180",
              "hours": {
                "monday": "Monday: 11:00 AM – 10:00 PM",
                "tuesday": "Tuesday: 11:00 AM – 10:00 PM",
                "wednesday": "Wednesday: 11:00 AM – 10:00 PM",
                "thursday": "Thursday: 11:00 AM – 10:00 PM",
                "friday": "Friday: 11:00 AM – 10:30 PM",
                "saturday": "Saturday: 11:00 AM – 10:30 PM",
                "sunday": "Sunday: 10:30 AM – 9:00 PM"
              }
            },
            'photos': {
            'logo': {
              'name': "logo_3.png",
              'small_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg",
              'large_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg"
            },
            'banner': {
              'name': "banner_3.png",
              'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
              'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
            },
          },
            "location": {
              "geo": {
                "identifier": "3fff26c0-79c9-11ea-9608-69d83ac82698",
                "lat": "51.500729",
                "lng": "-0.124625",
                "radius": "50"
              },
              "beacon": {
                "identifier": "3fff26c0-79c9-11ea-9608-69d83ac82698",
                "region_identifier": "3fff1ca0-79c9-11ea-8448-55028a12fcdf",
                "major": "2",
                "minor": "3"
              },
              "region": {
                "identifier": "3fff1ca0-79c9-11ea-8448-55028a12fcdf",
                "city": "east juvenalton",
                "state": "pa",
                "zip": "68109",
                "neighborhood": null
              }
            }
          },
          "refund": [],
          'issue': null
        }
      ],
      "links": {
        "first": "http://localhost/api/customer/transaction?page=1",
        "last": "http://localhost/api/customer/transaction?page=2",
        "prev": null,
        "next": "http://localhost/api/customer/transaction?page=2"
      },
      "meta": {
        "current_page": 1,
        "from": 1,
        "last_page": 1,
        "path": "http://localhost/api/customer/transaction",
        "per_page": 12,
        "to": 12,
        "total": 18,
      }
    };
  }
  
  static Map<String, dynamic> _mockFetchPaidTransactionsTwo() {
    return {
      "data": [
        {
          "transaction": {
            "identifier": "3ff9ad40-7949-11ea-8b92-a9b4a4c53696",
            "employee_id": null,
            "tax": "457",
            "tip": "1636",
            "net_sales": "6088",
            "total": "8181",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-08 18:46:25",
            "updated_at": "2020-04-08 18:46:25",
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
              'name': "logo_1.png",
              'small_url': "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0019/1114/brand.gif?itok=DKwKOdLe",
              'large_url': "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0019/1114/brand.gif?itok=DKwKOdLe"
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
          "refund": [],
          'issue': null
        },
        {
          "transaction": {
            "identifier": "3ffcf790-79c9-11ea-9786-cda2137559h5",
            "employee_id": null,
            "tax": "54",
            "tip": "77",
            "net_sales": "715",
            "total": "846",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-08 18:46:25",
            "updated_at": "2020-04-08 18:46:25",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "voluptatem",
                "sub_name": "cnsjbjia",
                "price": "1200",
                "quantity": "5",
                "total": "60000"
              },
              {
                "name": "exercitationem",
                "sub_name": 'fskdsf',
                "price": "499",
                "quantity": "2",
                "total": "998"
              },
              {
                "name": "coiahfioda",
                "sub_name": 'fdsankfd',
                "price": "999",
                "quantity": "4",
                "total": "4995"
              },
              {
                "name": "bcjadsbji",
                "sub_name": null,
                "price": "1500",
                "quantity": "1",
                "total": "1500"
              }
            ]
          },
          "business": {
            "identifier": "3ffb7e00-79c9-11ea-8327-0591af6899fa",
            "profile": {
              "name": "Breitenberg and Sons",
              "website": "stroman.com",
              "description": "Tempora non esse iusto libero libero dolores voluptas. Eligendi incidunt impedit ducimus beatae animi voluptatem eligendi rerum. Temporibus earum aut ut sunt dolor nobis. Officiis cumque quae suscipit consectetur et.",
              "google_place_id": null,
              "phone": "0075281221",
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
              'name': "banner_2.png",
              'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
              'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
            },
          },
            "location": {
              "geo": {
                "identifier": "3ffc9af0-79c9-11ea-8ba2-7bc9ac2c03dc",
                "lat": "37.826977",
                "lng": "-122.422958",
                "radius": "50"
              },
              "beacon": {
                "identifier": "3ffc9af0-79c9-11ea-8ba2-7bc9ac2c03dc",
                "region_identifier": "3ffc8fb0-79c9-11ea-8a8d-e920600f039b",
                "major": "2",
                "minor": "3"
              },
              "region": {
                "identifier": "3ffc8fb0-79c9-11ea-8a8d-e920600f039b",
                "city": "east kirsten",
                "state": "ca",
                "zip": "72393",
                "neighborhood": null
              }
            }
          },
          "refund": [],
          'issue': null
        },
        {
          "transaction": {
            "identifier": "3fff7d10-79c9-11ea-aeda-29f06u0c8d318",
            "employee_id": null,
            "tax": "101",
            "tip": "0",
            "net_sales": "1344",
            "total": "1445",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-08 18:46:25",
            "updated_at": "2020-04-08 18:46:25",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "sequi",
                "sub_name": 'acdsa',
                "price": "1099",
                "quantity": "10",
                "total": "10990"
              },
              {
                "name": "totam",
                "sub_name": 'afdsafd',
                "price": "99",
                "quantity": "1",
                "total": "99"
              }
            ]
          },
          "business": {
            "identifier": "3ffdfd70-79c9-11ea-b016-91e22ba79bcd",
            "profile": {
              "name": "O'Connell Ltd",
              "website": "dach.com",
              "description": "Error repudiandae beatae ex facilis. In est quis ut et in voluptate incidunt. Nulla veniam in ut quasi nobis qui. Hic qui enim harum animi consequatur dolor.",
              "google_place_id": null,
              "phone": "1739470180",
              "hours": {
                "monday": "Monday: 11:00 AM – 10:00 PM",
                "tuesday": "Tuesday: 11:00 AM – 10:00 PM",
                "wednesday": "Wednesday: 11:00 AM – 10:00 PM",
                "thursday": "Thursday: 11:00 AM – 10:00 PM",
                "friday": "Friday: 11:00 AM – 10:30 PM",
                "saturday": "Saturday: 11:00 AM – 10:30 PM",
                "sunday": "Sunday: 10:30 AM – 9:00 PM"
              }
            },
            'photos': {
            'logo': {
              'name': "logo_3.png",
              'small_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg",
              'large_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg"
            },
            'banner': {
              'name': "banner_3.png",
              'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
              'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
            },
          },
            "location": {
              "geo": {
                "identifier": "3fff26c0-79c9-11ea-9608-69d83ac82698",
                "lat": "51.500729",
                "lng": "-0.124625",
                "radius": "50"
              },
              "beacon": {
                "identifier": "3fff26c0-79c9-11ea-9608-69d83ac82698",
                "region_identifier": "3fff1ca0-79c9-11ea-8448-55028a12fcdf",
                "major": "2",
                "minor": "3"
              },
              "region": {
                "identifier": "3fff1ca0-79c9-11ea-8448-55028a12fcdf",
                "city": "east juvenalton",
                "state": "pa",
                "zip": "68109",
                "neighborhood": null
              }
            }
          },
          "refund": [],
          'issue': null
        },
        {
          "transaction": {
            "identifier": "3ff9ad40-79c9-11ea-8b92-a9b4a4c52696",
            "employee_id": null,
            "tax": "457",
            "tip": "1636",
            "net_sales": "6088",
            "total": "8181",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-08 18:46:25",
            "updated_at": "2020-04-08 18:46:25",
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
              'name': "logo_1.png",
              'small_url': "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0019/1114/brand.gif?itok=DKwKOdLe",
              'large_url': "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0019/1114/brand.gif?itok=DKwKOdLe"
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
          "refund": [],
          'issue': null
        },
        {
          "transaction": {
            "identifier": "3ffcf790-79c9-11ea-97m6-cda2137559e5",
            "employee_id": null,
            "tax": "54",
            "tip": "77",
            "net_sales": "715",
            "total": "846",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-08 18:46:25",
            "updated_at": "2020-04-08 18:46:25",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "voluptatem",
                "sub_name": "cnsjbjia",
                "price": "1200",
                "quantity": "5",
                "total": "60000"
              },
              {
                "name": "exercitationem",
                "sub_name": 'fskdsf',
                "price": "499",
                "quantity": "2",
                "total": "998"
              },
              {
                "name": "coiahfioda",
                "sub_name": 'fdsankfd',
                "price": "999",
                "quantity": "4",
                "total": "4995"
              },
              {
                "name": "bcjadsbji",
                "sub_name": null,
                "price": "1500",
                "quantity": "1",
                "total": "1500"
              }
            ]
          },
          "business": {
            "identifier": "3ffb7e00-79c9-11ea-8327-0591af6899fa",
            "profile": {
              "name": "Breitenberg and Sons",
              "website": "stroman.com",
              "description": "Tempora non esse iusto libero libero dolores voluptas. Eligendi incidunt impedit ducimus beatae animi voluptatem eligendi rerum. Temporibus earum aut ut sunt dolor nobis. Officiis cumque quae suscipit consectetur et.",
              "google_place_id": null,
              "phone": "0075281221",
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
              'name': "banner_2.png",
              'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
              'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
            },
          },
            "location": {
              "geo": {
                "identifier": "3ffc9af0-79c9-11ea-8ba2-7bc9ac2c03dc",
                "lat": "37.826977",
                "lng": "-122.422958",
                "radius": "50"
              },
              "beacon": {
                "identifier": "3ffc9af0-79c9-11ea-8ba2-7bc9ac2c03dc",
                "region_identifier": "3ffc8fb0-79c9-11ea-8a8d-e920600f039b",
                "major": "2",
                "minor": "3"
              },
              "region": {
                "identifier": "3ffc8fb0-79c9-11ea-8a8d-e920600f039b",
                "city": "east kirsten",
                "state": "ca",
                "zip": "72393",
                "neighborhood": null
              }
            }
          },
          "refund": [],
          'issue': null
        },
        {
          "transaction": {
            "identifier": "3fff7d10-79c9-11ea-aeda-59f060c8d318",
            "employee_id": null,
            "tax": "101",
            "tip": "0",
            "net_sales": "1344",
            "total": "1445",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-08 18:46:25",
            "updated_at": "2020-04-08 18:46:25",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "sequi",
                "sub_name": 'acdsa',
                "price": "1099",
                "quantity": "10",
                "total": "10990"
              },
              {
                "name": "totam",
                "sub_name": 'afdsafd',
                "price": "99",
                "quantity": "1",
                "total": "99"
              }
            ]
          },
          "business": {
            "identifier": "3ffdfd70-79c9-11ea-b016-91e22ba79bcd",
            "profile": {
              "name": "O'Connell Ltd",
              "website": "dach.com",
              "description": "Error repudiandae beatae ex facilis. In est quis ut et in voluptate incidunt. Nulla veniam in ut quasi nobis qui. Hic qui enim harum animi consequatur dolor.",
              "google_place_id": null,
              "phone": "1739470180",
              "hours": {
                "monday": "Monday: 11:00 AM – 10:00 PM",
                "tuesday": "Tuesday: 11:00 AM – 10:00 PM",
                "wednesday": "Wednesday: 11:00 AM – 10:00 PM",
                "thursday": "Thursday: 11:00 AM – 10:00 PM",
                "friday": "Friday: 11:00 AM – 10:30 PM",
                "saturday": "Saturday: 11:00 AM – 10:30 PM",
                "sunday": "Sunday: 10:30 AM – 9:00 PM"
              }
            },
            'photos': {
            'logo': {
              'name': "logo_3.png",
              'small_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg",
              'large_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg"
            },
            'banner': {
              'name': "banner_3.png",
              'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
              'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
            },
          },
            "location": {
              "geo": {
                "identifier": "3fff26c0-79c9-11ea-9608-69d83ac82698",
                "lat": "51.500729",
                "lng": "-0.124625",
                "radius": "50"
              },
              "beacon": {
                "identifier": "3fff26c0-79c9-11ea-9608-69d83ac82698",
                "region_identifier": "3fff1ca0-79c9-11ea-8448-55028a12fcdf",
                "major": "2",
                "minor": "3"
              },
              "region": {
                "identifier": "3fff1ca0-79c9-11ea-8448-55028a12fcdf",
                "city": "east juvenalton",
                "state": "pa",
                "zip": "68109",
                "neighborhood": null
              }
            }
          },
          "refund": [],
          'issue': null
        },
        {
          "transaction": {
            "identifier": "3ff9ad40-79c9-11ea-8b92-a9b4a4c51296",
            "employee_id": null,
            "tax": "457",
            "tip": "1636",
            "net_sales": "6088",
            "total": "8181",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-08 18:46:25",
            "updated_at": "2020-04-08 18:46:25",
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
              'name': "logo_1.png",
              'small_url': "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0019/1114/brand.gif?itok=DKwKOdLe",
              'large_url': "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0019/1114/brand.gif?itok=DKwKOdLe"
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
          "refund": [],
          'issue': null
        },
        {
          "transaction": {
            "identifier": "3ffcf790-79c9-11ea-9786-cda2137449e5",
            "employee_id": null,
            "tax": "54",
            "tip": "77",
            "net_sales": "715",
            "total": "846",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-08 18:46:25",
            "updated_at": "2020-04-08 18:46:25",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "voluptatem",
                "sub_name": "cnsjbjia",
                "price": "1200",
                "quantity": "5",
                "total": "60000"
              },
              {
                "name": "exercitationem",
                "sub_name": 'fskdsf',
                "price": "499",
                "quantity": "2",
                "total": "998"
              },
              {
                "name": "coiahfioda",
                "sub_name": 'fdsankfd',
                "price": "999",
                "quantity": "4",
                "total": "4995"
              },
              {
                "name": "bcjadsbji",
                "sub_name": null,
                "price": "1500",
                "quantity": "1",
                "total": "1500"
              }
            ]
          },
          "business": {
            "identifier": "3ffb7e00-79c9-11ea-8327-0591af6899fa",
            "profile": {
              "name": "Breitenberg and Sons",
              "website": "stroman.com",
              "description": "Tempora non esse iusto libero libero dolores voluptas. Eligendi incidunt impedit ducimus beatae animi voluptatem eligendi rerum. Temporibus earum aut ut sunt dolor nobis. Officiis cumque quae suscipit consectetur et.",
              "google_place_id": null,
              "phone": "0075281221",
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
              'name': "banner_2.png",
              'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
              'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
            },
          },
            "location": {
              "geo": {
                "identifier": "3ffc9af0-79c9-11ea-8ba2-7bc9ac2c03dc",
                "lat": "37.826977",
                "lng": "-122.422958",
                "radius": "50"
              },
              "beacon": {
                "identifier": "3ffc9af0-79c9-11ea-8ba2-7bc9ac2c03dc",
                "region_identifier": "3ffc8fb0-79c9-11ea-8a8d-e920600f039b",
                "major": "2",
                "minor": "3"
              },
              "region": {
                "identifier": "3ffc8fb0-79c9-11ea-8a8d-e920600f039b",
                "city": "east kirsten",
                "state": "ca",
                "zip": "72393",
                "neighborhood": null
              }
            }
          },
          "refund": [],
          'issue': null
        },
        {
          "transaction": {
            "identifier": "3trv7d10-79c9-11ea-aeda-29f060c8d318",
            "employee_id": null,
            "tax": "101",
            "tip": "0",
            "net_sales": "1344",
            "total": "1445",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-08 18:46:25",
            "updated_at": "2020-04-08 18:46:25",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "sequi",
                "sub_name": 'acdsa',
                "price": "1099",
                "quantity": "10",
                "total": "10990"
              },
              {
                "name": "totam",
                "sub_name": 'afdsafd',
                "price": "99",
                "quantity": "1",
                "total": "99"
              }
            ]
          },
          "business": {
            "identifier": "3ffdfd70-79c9-11ea-b016-91e22ba79bcd",
            "profile": {
              "name": "O'Connell Ltd",
              "website": "dach.com",
              "description": "Error repudiandae beatae ex facilis. In est quis ut et in voluptate incidunt. Nulla veniam in ut quasi nobis qui. Hic qui enim harum animi consequatur dolor.",
              "google_place_id": null,
              "phone": "1739470180",
              "hours": {
                "monday": "Monday: 11:00 AM – 10:00 PM",
                "tuesday": "Tuesday: 11:00 AM – 10:00 PM",
                "wednesday": "Wednesday: 11:00 AM – 10:00 PM",
                "thursday": "Thursday: 11:00 AM – 10:00 PM",
                "friday": "Friday: 11:00 AM – 10:30 PM",
                "saturday": "Saturday: 11:00 AM – 10:30 PM",
                "sunday": "Sunday: 10:30 AM – 9:00 PM"
              }
            },
            'photos': {
            'logo': {
              'name': "logo_3.png",
              'small_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg",
              'large_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg"
            },
            'banner': {
              'name': "banner_3.png",
              'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
              'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
            },
          },
            "location": {
              "geo": {
                "identifier": "3fff26c0-79c9-11ea-9608-69d83ac82698",
                "lat": "51.500729",
                "lng": "-0.124625",
                "radius": "50"
              },
              "beacon": {
                "identifier": "3fff26c0-79c9-11ea-9608-69d83ac82698",
                "region_identifier": "3fff1ca0-79c9-11ea-8448-55028a12fcdf",
                "major": "2",
                "minor": "3"
              },
              "region": {
                "identifier": "3fff1ca0-79c9-11ea-8448-55028a12fcdf",
                "city": "east juvenalton",
                "state": "pa",
                "zip": "68109",
                "neighborhood": null
              }
            }
          },
          "refund": [],
          'issue': null
        },
        {
          "transaction": {
            "identifier": "3ff9ad40-79c9-11ea-qq92-a9b4a4c53696",
            "employee_id": null,
            "tax": "457",
            "tip": "1636",
            "net_sales": "6088",
            "total": "8181",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-08 18:46:25",
            "updated_at": "2020-04-08 18:46:25",
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
              'name': "logo_1.png",
              'small_url': "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0019/1114/brand.gif?itok=DKwKOdLe",
              'large_url': "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0019/1114/brand.gif?itok=DKwKOdLe"
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
          "refund": [],
          'issue': null
        },
        {
          "transaction": {
            "identifier": "3ffcf790-79c9-11ea-9786-cda2197559e5",
            "employee_id": null,
            "tax": "54",
            "tip": "77",
            "net_sales": "715",
            "total": "846",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-08 18:46:25",
            "updated_at": "2020-04-08 18:46:25",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "voluptatem",
                "sub_name": "cnsjbjia",
                "price": "1200",
                "quantity": "5",
                "total": "60000"
              },
              {
                "name": "exercitationem",
                "sub_name": 'fskdsf',
                "price": "499",
                "quantity": "2",
                "total": "998"
              },
              {
                "name": "coiahfioda",
                "sub_name": 'fdsankfd',
                "price": "999",
                "quantity": "4",
                "total": "4995"
              },
              {
                "name": "bcjadsbji",
                "sub_name": null,
                "price": "1500",
                "quantity": "1",
                "total": "1500"
              }
            ]
          },
          "business": {
            "identifier": "3ffb7e00-79c9-11ea-8327-0591af6899fa",
            "profile": {
              "name": "Breitenberg and Sons",
              "website": "stroman.com",
              "description": "Tempora non esse iusto libero libero dolores voluptas. Eligendi incidunt impedit ducimus beatae animi voluptatem eligendi rerum. Temporibus earum aut ut sunt dolor nobis. Officiis cumque quae suscipit consectetur et.",
              "google_place_id": null,
              "phone": "0075281221",
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
              'name': "banner_2.png",
              'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
              'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
            },
          },
            "location": {
              "geo": {
                "identifier": "3ffc9af0-79c9-11ea-8ba2-7bc9ac2c03dc",
                "lat": "37.826977",
                "lng": "-122.422958",
                "radius": "50"
              },
              "beacon": {
                "identifier": "3ffc9af0-79c9-11ea-8ba2-7bc9ac2c03dc",
                "region_identifier": "3ffc8fb0-79c9-11ea-8a8d-e920600f039b",
                "major": "2",
                "minor": "3"
              },
              "region": {
                "identifier": "3ffc8fb0-79c9-11ea-8a8d-e920600f039b",
                "city": "east kirsten",
                "state": "ca",
                "zip": "72393",
                "neighborhood": null
              }
            }
          },
          "refund": [],
          'issue': null
        },
        {
          "transaction": {
            "identifier": "3fff7d10-79c8-11ea-aeda-29f160c8d318",
            "employee_id": null,
            "tax": "101",
            "tip": "0",
            "net_sales": "1344",
            "total": "1445",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-08 18:46:25",
            "updated_at": "2020-04-08 18:46:25",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "sequi",
                "sub_name": 'acdsa',
                "price": "1099",
                "quantity": "10",
                "total": "10990"
              },
              {
                "name": "totam",
                "sub_name": 'afdsafd',
                "price": "99",
                "quantity": "1",
                "total": "99"
              }
            ]
          },
          "business": {
            "identifier": "3ffdfd70-79c9-11ea-b016-91e22ba79bcd",
            "profile": {
              "name": "Last One!",
              "website": "dach.com",
              "description": "Error repudiandae beatae ex facilis. In est quis ut et in voluptate incidunt. Nulla veniam in ut quasi nobis qui. Hic qui enim harum animi consequatur dolor.",
              "google_place_id": null,
              "phone": "1739470180",
              "hours": {
                "monday": "Monday: 11:00 AM – 10:00 PM",
                "tuesday": "Tuesday: 11:00 AM – 10:00 PM",
                "wednesday": "Wednesday: 11:00 AM – 10:00 PM",
                "thursday": "Thursday: 11:00 AM – 10:00 PM",
                "friday": "Friday: 11:00 AM – 10:30 PM",
                "saturday": "Saturday: 11:00 AM – 10:30 PM",
                "sunday": "Sunday: 10:30 AM – 9:00 PM"
              }
            },
            'photos': {
            'logo': {
              'name': "logo_3.png",
              'small_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg",
              'large_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg"
            },
            'banner': {
              'name': "banner_3.png",
              'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
              'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
            },
          },
            "location": {
              "geo": {
                "identifier": "3fff26c0-79c9-11ea-9608-69d83ac82698",
                "lat": "51.500729",
                "lng": "-0.124625",
                "radius": "50"
              },
              "beacon": {
                "identifier": "3fff26c0-79c9-11ea-9608-69d83ac82698",
                "region_identifier": "3fff1ca0-79c9-11ea-8448-55028a12fcdf",
                "major": "2",
                "minor": "3"
              },
              "region": {
                "identifier": "3fff1ca0-79c9-11ea-8448-55028a12fcdf",
                "city": "east juvenalton",
                "state": "pa",
                "zip": "68109",
                "neighborhood": null
              }
            }
          },
          "refund": [],
          'issue': null
        }
      ],
      "links": {
        "first": "http://localhost/api/customer/transaction?page=1",
        "last": "http://localhost/api/customer/transaction?page=2",
        "prev": "http://localhost/api/customer/transaction?page=1",
        "next": null
      },
      "meta": {
        "current_page": 2,
        "from": 13,
        "last_page": 1,
        "path": "http://localhost/api/customer/transaction",
        "per_page": 12,
        "to": 24,
        "total": 24,
      }
    };
  }
  
  static Map<String, dynamic> _mockReportTransactionIssue(RequestOptions options) {
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
        "bill_created_at": "2020-04-08 18:46:25",
        "updated_at": "2020-04-08 18:46:25",
        "status": {
          "name": "wrong bill assigned",
          "code": "500"
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
      "refund": [],
      'issue': {
        'identifier': 'fake_id',
        'type': options.data['type'].toString(),
        'issue': options.data['issue'],
        'resolved': false,
        'warnings_sent': '2',
        'updated_at': '2020-05-26T22:04:56.000000Z'
      }
    };
  }

  static Map<String, dynamic> _mockChangeTransactionIssue(RequestOptions options) {
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
        "bill_created_at": "2020-04-08 18:46:25",
        "updated_at": "2020-04-08 18:46:25",
        "status": {
          "name": "wrong bill assigned",
          "code": "500"
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
      "refund": [],
      'issue': {
        'identifier': 'fake_id',
        'type': options.data['type'].toString(),
        'issue': options.data['issue'],
        'resolved': false,
        'warnings_sent': '2',
        'updated_at': '2020-05-26T22:04:56.000000Z'
      }
    };
  }

  static Map<String, dynamic> _mockDeleteIssue() {
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
        "bill_created_at": "2020-04-08 18:46:25",
        "updated_at": "2020-04-08 18:46:25",
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
      "refund": [],
      'issue': null
    };
  }
  
  static Map<String, dynamic> _mockAcceptTransaction() {
    return {
      "transaction": {
        "identifier": "fake_open_transaction",
        "employee_id": null,
        "tax": "457",
        "tip": "1636",
        "net_sales": "6088",
        "total": "8181",
        "partial_payment": "0",
        "locked": false,
        "bill_created_at": "2020-04-08 18:46:25",
        "updated_at": "2020-04-08 18:46:25",
        "status": {
          "name": "error",
          "code": "501"
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
      "refund": [],
      'issue': {
        'identifier': 'fake_identifier',
        'type': 'wrong_bill',
        'issue': "My bill is not this",
        'resolved': false,
        'warnings_sent': '2',
        'updated_at': '2020-05-21T22:27:59.000000Z'
      }
    };
  }
  
  static Map<String, dynamic> _mockFetchOpenTransaction() {
    return {
      'data': [
        {
          "transaction": {
          "identifier": "fake_open_transaction",
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
          {
            "identifier": "125d10b0-895a-11ea-95db-b1ba0de9dfd1",
            "total": "952",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid",
          },
          {
            "identifier": "125d10b0-895a-11ea-95db-b1ba0de9vcd1",
            "total": "500",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid",
          },
        ],
        'issue': null
        },
      ],
      "links": {
        "first": "http://localhost/api/customer/transaction?page=1",
        "last": "http://localhost/api/customer/transaction?page=1",
        "prev": null,
        "next": null
      },
      "meta": {
        "current_page": 1,
        "from": 1,
        "last_page": 1,
        "path": "http://localhost/api/customer/transaction",
        "per_page": 15,
        "to": 1,
        "total": 0,
      }
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
  
  static Map<String, dynamic> _mockFetchTransactionsByBusiness() {
    return {
      'data': [
        {
          "transaction": {
            "identifier": "3ff9ad40-79c9-11ea-8b92-a9b4a4c53696",
            "employee_id": null,
            "tax": "457",
            "tip": "1636",
            "net_sales": "6088",
            "total": "8181",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-08 18:46:25",
            "updated_at": "2020-04-08 18:46:25",
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
              'name': "logo_1.png",
              'small_url': "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0019/1114/brand.gif?itok=DKwKOdLe",
              'large_url': "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0019/1114/brand.gif?itok=DKwKOdLe"
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
          "refund": [],
          'issue': null
        },
      ],
      "links": {
        "first": "http://localhost/api/customer/transaction?page=1",
        "last": "http://localhost/api/customer/transaction?page=1",
        "prev": null,
        "next": null
      },
      "meta": {
        "current_page": 1,
        "from": 1,
        "last_page": 1,
        "path": "http://localhost/api/customer/transaction",
        "per_page": 15,
        "to": 1,
        "total": 1,
      }
    };
  }

  static Map<String, dynamic> _mockFetchTransactionsByIdentifier() {
    return {
      'data': [
        {
          "transaction": {
            "identifier": "3ff22ad40-79c9-11ea-8b92-a9b4a4c53633",
            "employee_id": null,
            "tax": "457",
            "tip": "1636",
            "net_sales": "6088",
            "total": "8181",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-08 18:46:25",
            "updated_at": "2020-04-08 18:46:25",
            "status": {
              "name": "bill_closed",
              "code": "101"
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
              "name": "Fake PLC",
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
              'name': "logo_1.png",
              'small_url': "https://www.sosfactory.com/wp-content/uploads/2018/09/what-is-mascot-logo.png",
              'large_url': "https://www.sosfactory.com/wp-content/uploads/2018/09/what-is-mascot-logo.png"
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
          "refund": [],
          'issue': null
        },
      ],
      "links": {
        "first": "http://localhost/api/customer/transaction?page=1",
        "last": "http://localhost/api/customer/transaction?page=1",
        "prev": null,
        "next": null
      },
      "meta": {
        "current_page": 1,
        "from": 1,
        "last_page": 1,
        "path": "http://localhost/api/customer/transaction",
        "per_page": 15,
        "to": 1,
        "total": 1,
      }
    };
  }
  
  static Map<String, dynamic> _mockFetchBusinessesByName() {
    return {
      'data': [
        {
          'identifier': "fake_id_1",
          'profile': {
            'name': "Acme Inc.",
            'website': "https://acmecarrboro.com/",
            'description': "A description of the Acme Inc. company. It's a really cool company that you should patronize.",
            'phone': "9195244477",
            'hours': {
              'monday': 'Monday: 11:00 AM - 10:00 PM',
              'tuesday': 'Tuesday: 11:00 AM - 10:00 PM',
              'wednesday': 'Wednesday: 11:00 AM - 10:00 PM',
              'thursday': 'Thursday: 11:00 AM - 10:00 PM',
              'friday': 'Friday: 11:00 AM - 10:30 PM',
              'saturday': 'Saturday: 11:00 AM - 10:30 PM',
              'sunday': 'Sunday: 10:30 AM - 9:00 PM',
            }
          },
          'photos': {
            'logo': {
              'name': "logo_1.png",
              'small_url': "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0019/1114/brand.gif?itok=DKwKOdLe",
              'large_url': "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0019/1114/brand.gif?itok=DKwKOdLe"
            },
            'banner': {
              'name': "banner_1.png",
              'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
              'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
            },
          },
          'location': {
            'geo': {
              'identifier': 'bcdhbv31r3yv',
              'lat': '35.927115',
              'lng': '-79.027379',
              'radius': '50'
            },
            'beacon': {
              'identifier': 'bcdhbv31r3yv',
              'region_identifier': 'dcansjcbds22ded',
              'major': '0',
              'minor': '0'
            },
            'region': {
              'identifier': 'fcdjnasy3y8',
              'city': 'Chapel Hill',
              'state': 'NC',
              'zip': '27514',
              'neighborhood': 'bchsavc'
            }
          }
        },
        {
          'identifier': "fake_id_2",
          'profile': {
            'name': "Sunrise Biscuits",
            'website': "http://sunrisebiscuits.com/",
            'description': "A description of the Sunrise Biscuits. It's a really cool company that you should patronize.",
            'phone': "3743734848",
            'hours': {
              'monday': 'Monday: 8:00 AM - 10:00 PM',
              'tuesday': 'Tuesday: 8:00 AM - 10:00 PM',
              'wednesday': 'Wednesday: 8:00 AM - 10:00 PM',
              'thursday': 'Thursday: 8:00 AM - 10:00 PM',
              'friday': 'Friday: 8:00 AM - 10:30 PM',
              'saturday': 'Saturday: 8:00 AM - 10:30 PM',
              'sunday': 'Sunday: 9:00 AM - 9:00 PM',
            }
          },
          'photos': {
            'logo': {
              'name': "logo_2.png",
              'small_url': "https://cdna.artstation.com/p/assets/images/images/021/760/294/micro_square/jip-scheepers-2018-04-25.jpg?1572865897",
              'large_url': "https://cdna.artstation.com/p/assets/images/images/021/760/294/micro_square/jip-scheepers-2018-04-25.jpg?1572865897"
            },
            'banner': {
              'name': "banner_2.png",
              'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
              'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
            },
          },
          'location': {
            'geo': {
              'identifier': 'cdsnji2rty42',
              'lat': '35.927393',
              'lng': '-79.035551',
              'radius': '60'
            },
            'beacon': {
              'identifier': 'cdsnji2rty42',
              'region_identifier': 'cdjsb1y27qycd',
              'major': '1',
              'minor': '1'
            },
            'region': {
              'identifier': 'fcdjnasy3y8',
              'city': 'Chapel Hill',
              'state': 'NC',
              'zip': '27514',
              'neighborhood': 'cnsajcbads'
            }
          }
        },
        {
          'identifier': "fake_id_3",
          'profile': {
            'name': "City Kitchen",
            'website': "https://citykitchenchapelhill.com/",
            'description': "A description of the City Kitchen Bistro. It's a really cool company that you should patronize.",
            'phone': "3750370153",
            'hours': {
              'monday': 'Monday: 11:00 AM - 10:00 PM',
              'tuesday': 'Tuesday: 11:00 AM - 10:00 PM',
              'wednesday': 'Wednesday: 11:00 AM - 10:00 PM',
              'thursday': 'Thursday: 11:00 AM - 10:00 PM',
              'friday': 'Friday: 11:00 AM - 10:30 PM',
              'saturday': 'Saturday: 11:00 AM - 10:30 PM',
              'sunday': 'Sunday: 10:30 AM - 9:00 PM',
            }
          },
          'photos': {
            'logo': {
              'name': "logo_3.png",
              'small_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg",
              'large_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg"
            },
            'banner': {
              'name': "banner_3.png",
              'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
              'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
            },
          },
          'location': {
            'geo': {
              'identifier': '39320ifjebufcd',
              'lat': '35.914624',
              'lng': '-79.052906',
              'radius': '50'
            },
            'beacon': {
              'identifier': '39320ifjebufcd',
              'region_identifier': 'cdabsjhvchvda2j2',
              'major': '2',
              'minor': '2'
            },
            'region': {
              'identifier': 'fcdjnasy3y8',
              'city': 'Chapel Hill',
              'state': 'NC',
              'zip': '27514',
              'neighborhood': 'cbjsabc'
            }
          }
        }
      ]
    };
  }
  
  static Map<String, dynamic> _mockFetchRefundsByDate() {
    return {
      "data": [
        {
          "refund": {
            "identifier": "125d10b0-895a-11ea-95db-b1ba0de9dfd1",
            "total": "952",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid",
          },
          "business": {
            "identifier": "12569fc0-895a-11ea-8954-15c72741d7ca",
            "profile": {
              "name": "McClure-Gerhold",
              "website": "huel.org",
              "description": "Omnis aut beatae neque similique veniam numquam sint. Omnis expedita magni quaerat harum ipsum temporibus. Inventore ab sit non vel et quia veniam. Est fugit laborum incidunt natus id sit eius.",
              "google_place_id": null,
              "phone": "4080247291",
              "hours": {
                "monday": "Monday: 11:00 AM – 10:00 PM",
                "tuesday": "Tuesday: 11:00 AM – 10:00 PM",
                "wednesday": "Wednesday: 11:00 AM – 10:00 PM",
                "thursday": "Thursday: 11:00 AM – 10:00 PM",
                "friday": "Friday: 11:00 AM – 10:30 PM",
                "saturday": "Saturday: 11:00 AM – 10:30 PM",
                "sunday": "Sunday: 10:30 AM – 9:00 PM"
              }
            },
            'photos': {
              'logo': {
                'name': "logo_1.png",
                'small_url': "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0019/1114/brand.gif?itok=DKwKOdLe",
                'large_url': "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0019/1114/brand.gif?itok=DKwKOdLe"
              },
              'banner': {
                'name': "banner_1.png",
                'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
                'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
              },
            },
            "location": {
              "geo": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "lat": "71.699508",
                "lng": "169.164125",
                "radius": "50"
              },
              "beacon": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "region_identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "major": "0",
                "minor": "1"
              },
              "region": {
                "identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "city": "bernardland",
                "state": "in",
                "zip": "27313",
                "neighborhood": null
              }
            }
          },
          "transaction": {
            "identifier": "125aed30-895a-11ea-8f7a-1543da585c50",
            "employee_id": null,
            "tax": "198",
            "tip": "652",
            "net_sales": "2635",
            "total": "3485",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-28 14:10:53",
            "updated_at": "2020-04-28 14:10:53",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "3",
                "total": "6000"
              },
              {
                "name": "ratione",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              }
            ]
          },
          'issue': {
            'identifier': 'fake_identifier',
            'type': 'wrong_bill',
            'issue': "My bill is not this",
            'resolved': true,
            'warnings_sent': '2',
            'updated_at': '2020-05-21T22:27:59.000000Z'
          }
        },
        {
          "refund": {
            "identifier": "125f9f80-895a-11ea-b64a-b9ec2bd727cd",
            "total": "654",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid"
          },
          "business": {
            "identifier": "125d26e0-895a-11ea-9b43-0fca3f454941",
            "profile": {
              "name": "Kutch, Champlin and Cole",
              "website": "kuvalis.com",
              "description": "Nulla enim occaecati sunt dolorem modi quia debitis minus. Quam eveniet libero atque doloribus molestiae voluptatem enim. Eum nemo repudiandae repudiandae voluptatem id eaque reprehenderit molestias.",
              "google_place_id": null,
              "phone": "8670721138",
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
              'name': "logo_3.png",
              'small_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg",
              'large_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg"
            },
            'banner': {
              'name': "banner_3.png",
              'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
              'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
            },
          },
            "location": {
              "geo": {
                "identifier": "125e3bd0-895a-11ea-934f-77f81e6ad181",
                "lat": "79.940106",
                "lng": "-16.031526",
                "radius": "50",
              },
              "beacon": {
                "identifier": "125e3bd0-895a-11ea-934f-77f81e6ad181",
                "region_identifier": "125e31b0-895a-11ea-8569-3783ad60a175",
                "major": "2",
                "minor": "3"
              },
              "region": {
                "identifier": "125e31b0-895a-11ea-8569-3783ad60a175",
                "city": "west beatriceburgh",
                "state": "me",
                "zip": "59395",
                "neighborhood": null
              }
            }
          },
          "transaction": {
            "identifier": "125e9600-895a-11ea-8675-d7891bfbd70d",
            "employee_id": null,
            "tax": "393",
            "tip": "0",
            "net_sales": "5242",
            "total": "5635",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-28 14:10:53",
            "updated_at": "2020-04-28 14:10:53",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "dolores",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              },
              {
                "name": "pariatur",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              },
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "2",
                "total": "4000"
              }
            ]
          },
          'issue': {
            'identifier': 'fake_identifier',
            'type': 'wrong_bill',
            'issue': "My bill is not this",
            'resolved': true,
            'warnings_sent': '2',
            'updated_at': '2020-05-21T22:27:59.000000Z'
          }
        },
        {
          "refund": {
            "identifier": "125d10b0-895a-11ea-95db-b1ba0de9dfd1",
            "total": "2001",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid",
          },
          "business": {
            "identifier": "12569fc0-895a-11ea-8954-15c72741d7ca",
            "profile": {
              "name": "Bud Light",
              "website": "huel.org",
              "description": "Omnis aut beatae neque similique veniam numquam sint. Omnis expedita magni quaerat harum ipsum temporibus. Inventore ab sit non vel et quia veniam. Est fugit laborum incidunt natus id sit eius.",
              "google_place_id": null,
              "phone": "4080247291",
              "hours": {
                "monday": "Monday: 11:00 AM – 10:00 PM",
                "tuesday": "Tuesday: 11:00 AM – 10:00 PM",
                "wednesday": "Wednesday: 11:00 AM – 10:00 PM",
                "thursday": "Thursday: 11:00 AM – 10:00 PM",
                "friday": "Friday: 11:00 AM – 10:30 PM",
                "saturday": "Saturday: 11:00 AM – 10:30 PM",
                "sunday": "Sunday: 10:30 AM – 9:00 PM"
              }
            },
            'photos': {
              'logo': {
                'name': "logo_3.png",
                'small_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg",
                'large_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg"
              },
              'banner': {
                'name': "banner_3.png",
                'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
                'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
              },
            },
            "location": {
              "geo": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "lat": "71.699508",
                "lng": "169.164125",
                "radius": "50"
              },
              "beacon": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "region_identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "major": "0",
                "minor": "1"
              },
              "region": {
                "identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "city": "bernardland",
                "state": "in",
                "zip": "27313",
                "neighborhood": null
              }
            }
          },
          "transaction": {
            "identifier": "125aed30-895a-11ea-8f7a-1543da585c50",
            "employee_id": null,
            "tax": "408",
            "tip": "1252",
            "net_sales": "5035",
            "total": "7085",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-28 14:10:53",
            "updated_at": "2020-04-28 14:10:53",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "3",
                "total": "6000"
              },
              {
                "name": "ratione",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              },
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "3",
                "total": "6000"
              },
              {
                "name": "ratione",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              }
            ]
          },
          'issue': {
            'identifier': 'fake_identifier',
            'type': 'wrong_bill',
            'issue': "My bill is not this",
            'resolved': true,
            'warnings_sent': '2',
            'updated_at': '2020-05-21T22:27:59.000000Z'
          }
        },
      ],
      "links": {
        "first": "http://localhost/api/customer/refund?page=1",
        "last": "http://localhost/api/customer/refund?page=1",
        "prev": null,
        "next": null,
      },
      "meta": {
        "current_page": "1",
        "from": "1",
        "last_page": "1",
        "path": "http://localhost/api/customer/refund",
        "per_page": "15",
        "to": "3",
        "total": "3",
      }
    };
  }
  
  static Map<String, dynamic> _mockFetchRefundByTransaction() {
    return {
      "data": [
        {
          "refund": {
            "identifier": "125d10b0-895a-11ea-95db-b1ba0de9dfd1",
            "total": "952",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid",
          },
          "business": {
            "identifier": "12569fc0-895a-11ea-8954-15c72741d7ca",
            "profile": {
              "name": "McClure-Gerhold",
              "website": "huel.org",
              "description": "Omnis aut beatae neque similique veniam numquam sint. Omnis expedita magni quaerat harum ipsum temporibus. Inventore ab sit non vel et quia veniam. Est fugit laborum incidunt natus id sit eius.",
              "google_place_id": null,
              "phone": "4080247291",
              "hours": {
                "monday": "Monday: 11:00 AM – 10:00 PM",
                "tuesday": "Tuesday: 11:00 AM – 10:00 PM",
                "wednesday": "Wednesday: 11:00 AM – 10:00 PM",
                "thursday": "Thursday: 11:00 AM – 10:00 PM",
                "friday": "Friday: 11:00 AM – 10:30 PM",
                "saturday": "Saturday: 11:00 AM – 10:30 PM",
                "sunday": "Sunday: 10:30 AM – 9:00 PM"
              }
            },
            'photos': {
              'logo': {
                'name': "logo_3.png",
                'small_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg",
                'large_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg"
              },
              'banner': {
                'name': "banner_3.png",
                'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
                'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
              },
            },
            "location": {
              "geo": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "lat": "71.699508",
                "lng": "169.164125",
                "radius": "50"
              },
              "beacon": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "region_identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "major": "0",
                "minor": "1"
              },
              "region": {
                "identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "city": "bernardland",
                "state": "in",
                "zip": "27313",
                "neighborhood": null
              }
            }
          },
          "transaction": {
            "identifier": "125aed30-895a-11ea-8f7a-1543da585c50",
            "employee_id": null,
            "tax": "198",
            "tip": "652",
            "net_sales": "2635",
            "total": "3485",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-28 14:10:53",
            "updated_at": "2020-04-28 14:10:53",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "3",
                "total": "6000"
              },
              {
                "name": "ratione",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              }
            ]
          },
          'issue': {
            'identifier': 'fake_identifier',
            'type': 'wrong_bill',
            'issue': "My bill is not this",
            'resolved': true,
            'warnings_sent': '2',
            'updated_at': '2020-05-21T22:27:59.000000Z'
          }
        },
      ],
      "links": {
        "first": "http://localhost/api/customer/refund?page=1",
        "last": "http://localhost/api/customer/refund?page=1",
        "prev": null,
        "next": null,
      },
      "meta": {
        "current_page": "1",
        "from": "1",
        "last_page": "1",
        "path": "http://localhost/api/customer/refund",
        "per_page": "15",
        "to": "1",
        "total": "1",
      }
    };
  }
  
  static Map<String, dynamic> _mockPatchUnassigned() {
    return {
      "data": {
        "transaction": {
          "identifier": "3ff9ad40-79c9-11ea-8b92-a9b4a4c53696",
          "employee_id": null,
          "tax": "457",
          "tip": "0",
          "net_sales": "6088",
          "total": "8181",
          "partial_payment": "0",
          "locked": false,
          "bill_created_at": "2020-04-08 18:46:25",
          "updated_at": "2020-04-08 18:46:25",
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
            "name": "Fake PLC",
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
            'name': "logo_1.png",
            'small_url': "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0019/1114/brand.gif?itok=DKwKOdLe",
            'large_url': "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0019/1114/brand.gif?itok=DKwKOdLe"
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
        "refund": [],
        'issue': null
      }
    };
  }
  
  static Map<String, dynamic> _mockFetchRefundById() {
    return {
      "data": [
        {
          "refund": {
            "identifier": "125d10b0-895a-11ea-95db-b1ba0de9dfd1",
            "total": "952",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid",
          },
          "business": {
            "identifier": "12569fc0-895a-11ea-8954-15c72741d7ca",
            "profile": {
              "name": "McClure-Gerhold",
              "website": "huel.org",
              "description": "Omnis aut beatae neque similique veniam numquam sint. Omnis expedita magni quaerat harum ipsum temporibus. Inventore ab sit non vel et quia veniam. Est fugit laborum incidunt natus id sit eius.",
              "google_place_id": null,
              "phone": "4080247291",
              "hours": {
                "monday": "Monday: 11:00 AM – 10:00 PM",
                "tuesday": "Tuesday: 11:00 AM – 10:00 PM",
                "wednesday": "Wednesday: 11:00 AM – 10:00 PM",
                "thursday": "Thursday: 11:00 AM – 10:00 PM",
                "friday": "Friday: 11:00 AM – 10:30 PM",
                "saturday": "Saturday: 11:00 AM – 10:30 PM",
                "sunday": "Sunday: 10:30 AM – 9:00 PM"
              }
            },
            'photos': {
              'logo': {
                'name': "logo_3.png",
                'small_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg",
                'large_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg"
              },
              'banner': {
                'name': "banner_3.png",
                'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
                'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
              },
            },
            "location": {
              "geo": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "lat": "71.699508",
                "lng": "169.164125",
                "radius": "50"
              },
              "beacon": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "region_identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "major": "0",
                "minor": "1"
              },
              "region": {
                "identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "city": "bernardland",
                "state": "in",
                "zip": "27313",
                "neighborhood": null
              }
            }
          },
          "transaction": {
            "identifier": "125aed30-895a-11ea-8f7a-1543da585c50",
            "employee_id": null,
            "tax": "198",
            "tip": "652",
            "net_sales": "2635",
            "total": "3485",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-28 14:10:53",
            "updated_at": "2020-04-28 14:10:53",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "3",
                "total": "6000"
              },
              {
                "name": "ratione",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              }
            ]
          }
        },
      ],
      "links": {
        "first": "http://localhost/api/customer/refund?page=1",
        "last": "http://localhost/api/customer/refund?page=1",
        "prev": null,
        "next": null,
      },
      "meta": {
        "current_page": "1",
        "from": "1",
        "last_page": "1",
        "path": "http://localhost/api/customer/refund",
        "per_page": "15",
        "to": "1",
        "total": "1",
      }
    };
  }
  
  static Map<String, dynamic> _mockFetchRefundsByBusiness() {
    return {
      "data": [
        {
          "refund": {
            "identifier": "125d10b0-895a-11ea-95db-b1ba0de9dfd1",
            "total": "952",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid",
          },
          "business": {
            "identifier": "12569fc0-895a-11ea-8954-15c72741d7ca",
            "profile": {
              "name": "McClure-Gerhold",
              "website": "huel.org",
              "description": "Omnis aut beatae neque similique veniam numquam sint. Omnis expedita magni quaerat harum ipsum temporibus. Inventore ab sit non vel et quia veniam. Est fugit laborum incidunt natus id sit eius.",
              "google_place_id": null,
              "phone": "4080247291",
              "hours": {
                "monday": "Monday: 11:00 AM – 10:00 PM",
                "tuesday": "Tuesday: 11:00 AM – 10:00 PM",
                "wednesday": "Wednesday: 11:00 AM – 10:00 PM",
                "thursday": "Thursday: 11:00 AM – 10:00 PM",
                "friday": "Friday: 11:00 AM – 10:30 PM",
                "saturday": "Saturday: 11:00 AM – 10:30 PM",
                "sunday": "Sunday: 10:30 AM – 9:00 PM"
              }
            },
            'photos': {
              'logo': {
                'name': "logo_1.png",
                'small_url': "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0019/1114/brand.gif?itok=DKwKOdLe",
                'large_url': "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0019/1114/brand.gif?itok=DKwKOdLe"
              },
              'banner': {
                'name': "banner_1.png",
                'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
                'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
              },
            },
            "location": {
              "geo": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "lat": "71.699508",
                "lng": "169.164125",
                "radius": "50"
              },
              "beacon": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "region_identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "major": "0",
                "minor": "1"
              },
              "region": {
                "identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "city": "bernardland",
                "state": "in",
                "zip": "27313",
                "neighborhood": null
              }
            }
          },
          "transaction": {
            "identifier": "125aed30-895a-11ea-8f7a-1543da585c50",
            "employee_id": null,
            "tax": "198",
            "tip": "652",
            "net_sales": "2635",
            "total": "3485",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-28 14:10:53",
            "updated_at": "2020-04-28 14:10:53",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "3",
                "total": "6000"
              },
              {
                "name": "ratione",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              }
            ]
          },
          'issue': {
            'identifier': 'fake_identifier',
            'type': 'wrong_bill',
            'issue': "My bill is not this",
            'resolved': true,
            'warnings_sent': '2',
            'updated_at': '2020-05-21T22:27:59.000000Z'
          }
        },
        {
          "refund": {
            "identifier": "125f9f80-895a-11ea-b64a-b9ec2bd727cd",
            "total": "654",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid"
          },
          "business": {
            "identifier": "125d26e0-895a-11ea-9b43-0fca3f454941",
            "profile": {
              "name": "Kutch, Champlin and Cole",
              "website": "kuvalis.com",
              "description": "Nulla enim occaecati sunt dolorem modi quia debitis minus. Quam eveniet libero atque doloribus molestiae voluptatem enim. Eum nemo repudiandae repudiandae voluptatem id eaque reprehenderit molestias.",
              "google_place_id": null,
              "phone": "8670721138",
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
              'name': "logo_3.png",
              'small_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg",
              'large_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg"
            },
            'banner': {
              'name': "banner_3.png",
              'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
              'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
            },
          },
            "location": {
              "geo": {
                "identifier": "125e3bd0-895a-11ea-934f-77f81e6ad181",
                "lat": "79.940106",
                "lng": "-16.031526",
                "radius": "50",
              },
              "beacon": {
                "identifier": "125e3bd0-895a-11ea-934f-77f81e6ad181",
                "region_identifier": "125e31b0-895a-11ea-8569-3783ad60a175",
                "major": "2",
                "minor": "3"
              },
              "region": {
                "identifier": "125e31b0-895a-11ea-8569-3783ad60a175",
                "city": "west beatriceburgh",
                "state": "me",
                "zip": "59395",
                "neighborhood": null
              }
            }
          },
          "transaction": {
            "identifier": "125e9600-895a-11ea-8675-d7891bfbd70d",
            "employee_id": null,
            "tax": "393",
            "tip": "0",
            "net_sales": "5242",
            "total": "5635",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-28 14:10:53",
            "updated_at": "2020-04-28 14:10:53",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "dolores",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              },
              {
                "name": "pariatur",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              },
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "2",
                "total": "4000"
              }
            ]
          },
          'issue': {
            'identifier': 'fake_identifier',
            'type': 'wrong_bill',
            'issue': "My bill is not this",
            'resolved': true,
            'warnings_sent': '2',
            'updated_at': '2020-05-21T22:27:59.000000Z'
          }
        },
        {
          "refund": {
            "identifier": "125d10b0-895a-11ea-95db-b1ba0de9dfd1",
            "total": "2001",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid",
          },
          "business": {
            "identifier": "12569fc0-895a-11ea-8954-15c72741d7ca",
            "profile": {
              "name": "Bud Light",
              "website": "huel.org",
              "description": "Omnis aut beatae neque similique veniam numquam sint. Omnis expedita magni quaerat harum ipsum temporibus. Inventore ab sit non vel et quia veniam. Est fugit laborum incidunt natus id sit eius.",
              "google_place_id": null,
              "phone": "4080247291",
              "hours": {
                "monday": "Monday: 11:00 AM – 10:00 PM",
                "tuesday": "Tuesday: 11:00 AM – 10:00 PM",
                "wednesday": "Wednesday: 11:00 AM – 10:00 PM",
                "thursday": "Thursday: 11:00 AM – 10:00 PM",
                "friday": "Friday: 11:00 AM – 10:30 PM",
                "saturday": "Saturday: 11:00 AM – 10:30 PM",
                "sunday": "Sunday: 10:30 AM – 9:00 PM"
              }
            },
            'photos': {
              'logo': {
                'name': "logo_3.png",
                'small_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg",
                'large_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg"
              },
              'banner': {
                'name': "banner_3.png",
                'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
                'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
              },
            },
            "location": {
              "geo": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "lat": "71.699508",
                "lng": "169.164125",
                "radius": "50"
              },
              "beacon": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "region_identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "major": "0",
                "minor": "1"
              },
              "region": {
                "identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "city": "bernardland",
                "state": "in",
                "zip": "27313",
                "neighborhood": null
              }
            }
          },
          "transaction": {
            "identifier": "125aed30-895a-11ea-8f7a-1543da585c50",
            "employee_id": null,
            "tax": "408",
            "tip": "1252",
            "net_sales": "5035",
            "total": "7085",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-28 14:10:53",
            "updated_at": "2020-04-28 14:10:53",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "3",
                "total": "6000"
              },
              {
                "name": "ratione",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              },
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "3",
                "total": "6000"
              },
              {
                "name": "ratione",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              }
            ]
          },
          'issue': {
            'identifier': 'fake_identifier',
            'type': 'wrong_bill',
            'issue': "My bill is not this",
            'resolved': true,
            'warnings_sent': '2',
            'updated_at': '2020-05-21T22:27:59.000000Z'
          }
        },
        {
          "refund": {
            "identifier": "125d10b0-895a-11ea-95db-b1ba0de9dfd1",
            "total": "952",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid",
          },
          "business": {
            "identifier": "12569fc0-895a-11ea-8954-15c72741d7ca",
            "profile": {
              "name": "McClure-Gerhold",
              "website": "huel.org",
              "description": "Omnis aut beatae neque similique veniam numquam sint. Omnis expedita magni quaerat harum ipsum temporibus. Inventore ab sit non vel et quia veniam. Est fugit laborum incidunt natus id sit eius.",
              "google_place_id": null,
              "phone": "4080247291",
              "hours": {
                "monday": "Monday: 11:00 AM – 10:00 PM",
                "tuesday": "Tuesday: 11:00 AM – 10:00 PM",
                "wednesday": "Wednesday: 11:00 AM – 10:00 PM",
                "thursday": "Thursday: 11:00 AM – 10:00 PM",
                "friday": "Friday: 11:00 AM – 10:30 PM",
                "saturday": "Saturday: 11:00 AM – 10:30 PM",
                "sunday": "Sunday: 10:30 AM – 9:00 PM"
              }
            },
            'photos': {
              'logo': {
                'name': "logo_1.png",
                'small_url': "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0019/1114/brand.gif?itok=DKwKOdLe",
                'large_url': "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0019/1114/brand.gif?itok=DKwKOdLe"
              },
              'banner': {
                'name': "banner_1.png",
                'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
                'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
              },
            },
            "location": {
              "geo": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "lat": "71.699508",
                "lng": "169.164125",
                "radius": "50"
              },
              "beacon": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "region_identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "major": "0",
                "minor": "1"
              },
              "region": {
                "identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "city": "bernardland",
                "state": "in",
                "zip": "27313",
                "neighborhood": null
              }
            }
          },
          "transaction": {
            "identifier": "125aed30-895a-11ea-8f7a-1543da585c50",
            "employee_id": null,
            "tax": "198",
            "tip": "652",
            "net_sales": "2635",
            "total": "3485",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-28 14:10:53",
            "updated_at": "2020-04-28 14:10:53",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "3",
                "total": "6000"
              },
              {
                "name": "ratione",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              }
            ]
          },
          'issue': {
            'identifier': 'fake_identifier',
            'type': 'wrong_bill',
            'issue': "My bill is not this",
            'resolved': true,
            'warnings_sent': '2',
            'updated_at': '2020-05-21T22:27:59.000000Z'
          }
        },
        {
          "refund": {
            "identifier": "125f9f80-895a-11ea-b64a-b9ec2bd727cd",
            "total": "654",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid"
          },
          "business": {
            "identifier": "125d26e0-895a-11ea-9b43-0fca3f454941",
            "profile": {
              "name": "Kutch, Champlin and Cole",
              "website": "kuvalis.com",
              "description": "Nulla enim occaecati sunt dolorem modi quia debitis minus. Quam eveniet libero atque doloribus molestiae voluptatem enim. Eum nemo repudiandae repudiandae voluptatem id eaque reprehenderit molestias.",
              "google_place_id": null,
              "phone": "8670721138",
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
              'name': "logo_3.png",
              'small_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg",
              'large_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg"
            },
            'banner': {
              'name': "banner_3.png",
              'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
              'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
            },
          },
            "location": {
              "geo": {
                "identifier": "125e3bd0-895a-11ea-934f-77f81e6ad181",
                "lat": "79.940106",
                "lng": "-16.031526",
                "radius": "50",
              },
              "beacon": {
                "identifier": "125e3bd0-895a-11ea-934f-77f81e6ad181",
                "region_identifier": "125e31b0-895a-11ea-8569-3783ad60a175",
                "major": "2",
                "minor": "3"
              },
              "region": {
                "identifier": "125e31b0-895a-11ea-8569-3783ad60a175",
                "city": "west beatriceburgh",
                "state": "me",
                "zip": "59395",
                "neighborhood": null
              }
            }
          },
          "transaction": {
            "identifier": "125e9600-895a-11ea-8675-d7891bfbd70d",
            "employee_id": null,
            "tax": "393",
            "tip": "0",
            "net_sales": "5242",
            "total": "5635",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-28 14:10:53",
            "updated_at": "2020-04-28 14:10:53",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "dolores",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              },
              {
                "name": "pariatur",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              },
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "2",
                "total": "4000"
              }
            ]
          },
          'issue': {
            'identifier': 'fake_identifier',
            'type': 'wrong_bill',
            'issue': "My bill is not this",
            'resolved': true,
            'warnings_sent': '2',
            'updated_at': '2020-05-21T22:27:59.000000Z'
          }
        },
        {
          "refund": {
            "identifier": "125d10b0-895a-11ea-95db-b1ba0de9dfd1",
            "total": "2001",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid",
          },
          "business": {
            "identifier": "12569fc0-895a-11ea-8954-15c72741d7ca",
            "profile": {
              "name": "Bud Light",
              "website": "huel.org",
              "description": "Omnis aut beatae neque similique veniam numquam sint. Omnis expedita magni quaerat harum ipsum temporibus. Inventore ab sit non vel et quia veniam. Est fugit laborum incidunt natus id sit eius.",
              "google_place_id": null,
              "phone": "4080247291",
              "hours": {
                "monday": "Monday: 11:00 AM – 10:00 PM",
                "tuesday": "Tuesday: 11:00 AM – 10:00 PM",
                "wednesday": "Wednesday: 11:00 AM – 10:00 PM",
                "thursday": "Thursday: 11:00 AM – 10:00 PM",
                "friday": "Friday: 11:00 AM – 10:30 PM",
                "saturday": "Saturday: 11:00 AM – 10:30 PM",
                "sunday": "Sunday: 10:30 AM – 9:00 PM"
              }
            },
            'photos': {
              'logo': {
                'name': "logo_3.png",
                'small_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg",
                'large_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg"
              },
              'banner': {
                'name': "banner_3.png",
                'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
                'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
              },
            },
            "location": {
              "geo": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "lat": "71.699508",
                "lng": "169.164125",
                "radius": "50"
              },
              "beacon": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "region_identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "major": "0",
                "minor": "1"
              },
              "region": {
                "identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "city": "bernardland",
                "state": "in",
                "zip": "27313",
                "neighborhood": null
              }
            }
          },
          "transaction": {
            "identifier": "125aed30-895a-11ea-8f7a-1543da585c50",
            "employee_id": null,
            "tax": "408",
            "tip": "1252",
            "net_sales": "5035",
            "total": "7085",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-28 14:10:53",
            "updated_at": "2020-04-28 14:10:53",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "3",
                "total": "6000"
              },
              {
                "name": "ratione",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              },
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "3",
                "total": "6000"
              },
              {
                "name": "ratione",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              }
            ]
          },
          'issue': {
            'identifier': 'fake_identifier',
            'type': 'wrong_bill',
            'issue': "My bill is not this",
            'resolved': true,
            'warnings_sent': '2',
            'updated_at': '2020-05-21T22:27:59.000000Z'
          }
        },
      ],
      "links": {
        "first": "http://localhost/api/customer/refund?page=1",
        "last": "http://localhost/api/customer/refund?page=1",
        "prev": null,
        "next": null,
      },
      "meta": {
        "current_page": "1",
        "from": "1",
        "last_page": "1",
        "path": "http://localhost/api/customer/refund",
        "per_page": "15",
        "to": "6",
        "total": "6",
      }
    };
  }

  static Map<String, dynamic> _mockFetchUnassigned() {
    return {
      'data': [
        {
          "transaction": {
            "identifier": "3ff9ad40-79c9-11ea-8b92-a9b4a4c53696",
            "employee_id": null,
            "tax": "457",
            "net_sales": "6088",
            "total": "8181",
            "partial_payment": "0",
            "created_at": "2020-04-08 18:46:25",
            "updated_at": "2020-04-08 18:46:25",
            "purchased_items": [
              {
                "name": "Beer",
                "sub_name": 'ipa',
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
              'name': "logo_1.png",
              'small_url': "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0019/1114/brand.gif?itok=DKwKOdLe",
              'large_url': "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0019/1114/brand.gif?itok=DKwKOdLe"
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
          }
        },
        {
          "transaction": {
            "identifier": "3ffcf790-79c9-11ea-9786-cda2137559e5",
            "employee_id": null,
            "tax": "54",
            "net_sales": "715",
            "total": "846",
            "partial_payment": "0",
            "created_at": "2020-04-08 18:46:25",
            "updated_at": "2020-04-08 18:46:25",
            "purchased_items": [
              {
                "name": "Beer",
                "sub_name": 'ipa',
                "price": "2000",
                "quantity": "3",
                "total": "6000"
              },
              {
                "name": "exercitationem",
                "sub_name": 'fskdsf',
                "price": "499",
                "quantity": "2",
                "total": "998"
              },
              {
                "name": "pizza",
                "sub_name": null,
                "price": "1000",
                "quantity": "1",
                "total": "1000"
              },
              {
                "name": "soda",
                "sub_name": null,
                "price": "199",
                "quantity": "1",
                "total": "199"
              }
            ]
          },
          "business": {
            "identifier": "3ffb7e00-79c9-11ea-8327-0591af6899fa",
            "profile": {
              "name": "Breitenberg and Sons",
              "website": "stroman.com",
              "description": "Tempora non esse iusto libero libero dolores voluptas. Eligendi incidunt impedit ducimus beatae animi voluptatem eligendi rerum. Temporibus earum aut ut sunt dolor nobis. Officiis cumque quae suscipit consectetur et.",
              "google_place_id": null,
              "phone": "0075281221",
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
              'name': "banner_2.png",
              'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
              'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
            },
          },
            "location": {
              "geo": {
                "identifier": "3ffc9af0-79c9-11ea-8ba2-7bc9ac2c03dc",
                "lat": "37.826977",
                "lng": "-122.422958",
                "radius": "50"
              },
              "beacon": {
                "identifier": "3ffc9af0-79c9-11ea-8ba2-7bc9ac2c03dc",
                "region_identifier": "3ffc8fb0-79c9-11ea-8a8d-e920600f039b",
                "major": "2",
                "minor": "3"
              },
              "region": {
                "identifier": "3ffc8fb0-79c9-11ea-8a8d-e920600f039b",
                "city": "east kirsten",
                "state": "ca",
                "zip": "72393",
                "neighborhood": null
              }
            }
          }
        },
        {
          "transaction": {
            "identifier": "3fff7d10-79c9-11ea-aeda-29f060c8d318",
            "employee_id": null,
            "tax": "101",
            "net_sales": "1344",
            "total": "1445",
            "partial_payment": "0",
            "created_at": "2020-04-08 18:46:25",
            "updated_at": "2020-04-08 18:46:25",
            "purchased_items": [
              {
                "name": "Beer",
                "sub_name": 'ipa',
                "price": "2000",
                "quantity": "3",
                "total": "6000"
              },
              {
                "name": "totam",
                "sub_name": 'afdsafd',
                "price": "99",
                "quantity": "1",
                "total": "99"
              },
              {
                "name": "pizza",
                "sub_name": null,
                "price": "1000",
                "quantity": "1",
                "total": "1000"
              },
            ]
          },
          "business": {
            "identifier": "3ffdfd70-79c9-11ea-b016-91e22ba79bcd",
            "profile": {
              "name": "O'Connell Ltd",
              "website": "dach.com",
              "description": "Error repudiandae beatae ex facilis. In est quis ut et in voluptate incidunt. Nulla veniam in ut quasi nobis qui. Hic qui enim harum animi consequatur dolor.",
              "google_place_id": null,
              "phone": "1739470180",
              "hours": {
                "monday": "Monday: 11:00 AM – 10:00 PM",
                "tuesday": "Tuesday: 11:00 AM – 10:00 PM",
                "wednesday": "Wednesday: 11:00 AM – 10:00 PM",
                "thursday": "Thursday: 11:00 AM – 10:00 PM",
                "friday": "Friday: 11:00 AM – 10:30 PM",
                "saturday": "Saturday: 11:00 AM – 10:30 PM",
                "sunday": "Sunday: 10:30 AM – 9:00 PM"
              }
            },
            'photos': {
            'logo': {
              'name': "logo_3.png",
              'small_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg",
              'large_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg"
            },
            'banner': {
              'name': "banner_3.png",
              'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
              'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
            },
          },
            "location": {
              "geo": {
                "identifier": "3fff26c0-79c9-11ea-9608-69d83ac82698",
                "lat": "51.500729",
                "lng": "-0.124625",
                "radius": "50"
              },
              "beacon": {
                "identifier": "3fff26c0-79c9-11ea-9608-69d83ac82698",
                "region_identifier": "3fff1ca0-79c9-11ea-8448-55028a12fcdf",
                "major": "2",
                "minor": "3"
              },
              "region": {
                "identifier": "3fff1ca0-79c9-11ea-8448-55028a12fcdf",
                "city": "east juvenalton",
                "state": "pa",
                "zip": "68109",
                "neighborhood": null
              }
            }
          }
        },
        {
          "transaction": {
            "identifier": "5ff9ad40-89c9-11ea-8b92-a9b4a4c53695",
            "employee_id": null,
            "tax": "683",
            "net_sales": "9152",
            "total": "101223",
            "partial_payment": "0",
            "created_at": "2020-04-08 18:46:25",
            "updated_at": "2020-04-08 18:46:25",
            "purchased_items": [
              {
                "name": "Beer",
                "sub_name": 'ipa',
                "price": "2000",
                "quantity": "3",
                "total": "6000"
              },
              {
                "name": "pizza",
                "sub_name": null,
                "price": "1000",
                "quantity": "1",
                "total": "1000"
              },
              {
                "name": "soda",
                "sub_name": null,
                "price": "199",
                "quantity": "1",
                "total": "199"
              },
              {
                "name": "cdcd",
                "sub_name": null,
                "price": "1200",
                "quantity": "2",
                "total": "2400"
              },
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
              'name': "logo_1.png",
              'small_url': "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0019/1114/brand.gif?itok=DKwKOdLe",
              'large_url': "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0019/1114/brand.gif?itok=DKwKOdLe"
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
          }
        },
        {
          "transaction": {
            "identifier": "3ff9ad40-79c9-11ea-8b92-a9b4a4c53696",
            "employee_id": null,
            "tax": "683",
            "net_sales": "9152",
            "total": "101223",
            "partial_payment": "0",
            "created_at": "2020-04-08 18:46:25",
            "updated_at": "2020-04-08 18:46:25",
            "purchased_items": [
              {
                "name": "Beer",
                "sub_name": 'ipa',
                "price": "2000",
                "quantity": "3",
                "total": "6000"
              },
              {
                "name": "pizza",
                "sub_name": null,
                "price": "1000",
                "quantity": "1",
                "total": "1000"
              },
              {
                "name": "soda",
                "sub_name": null,
                "price": "199",
                "quantity": "1",
                "total": "199"
              },
              {
                "name": "cdcd",
                "sub_name": null,
                "price": "1200",
                "quantity": "2",
                "total": "2400"
              },
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
              'name': "logo_1.png",
              'small_url': "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0019/1114/brand.gif?itok=DKwKOdLe",
              'large_url': "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0019/1114/brand.gif?itok=DKwKOdLe"
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
          }
        },
      ]
    };
  }
  
  static Map<String, dynamic> _mockOnStart(RequestOptions options) {
    // return {
    //   'data': []
    // };
    return {
      'data': [
        {
          'identifier': "fake_id_1",
          'profile': {
            'name': "Acme Inc.",
            'website': "https://acmecarrboro.com/",
            'description': "A description of the Acme Inc. company. It's a really cool company that you should patronize.",
            'phone': "9195244477",
            'hours': {
              'monday': 'Monday: 11:00 AM - 10:00 PM',
              'tuesday': 'Tuesday: 11:00 AM - 10:00 PM',
              'wednesday': 'Wednesday: 11:00 AM - 10:00 PM',
              'thursday': 'Thursday: 11:00 AM - 10:00 PM',
              'friday': 'Friday: 11:00 AM - 10:30 PM',
              'saturday': 'Saturday: 11:00 AM - 10:30 PM',
              'sunday': 'Sunday: 10:30 AM - 9:00 PM',
            }
          },
          'photos': {
            'logo': {
              'name': "logo_1.png",
              'small_url': "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0019/1114/brand.gif?itok=DKwKOdLe",
              'large_url': "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0019/1114/brand.gif?itok=DKwKOdLe"
            },
            'banner': {
              'name': "banner_1.png",
              'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
              'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
            },
          },
          'location': {
            'geo': {
              'identifier': 'bcdhbv31r3yv',
              'lat': '35.927115',
              'lng': '-79.027379',
              'radius': '50'
            },
            'beacon': {
              'identifier': 'bcdhbv31r3yv',
              'region_identifier': 'dcansjcbds22ded',
              'major': '0',
              'minor': '0'
            },
            'region': {
              'identifier': 'fcdjnasy3y8',
              'city': 'Chapel Hill',
              'state': 'NC',
              'zip': '27514',
              'neighborhood': 'bchsavc'
            }
          }
        },
        {
          'identifier': "fake_id_2",
          'profile': {
            'name': "Sunrise Biscuits",
            'website': "http://sunrisebiscuits.com/",
            'description': "A description of the Sunrise Biscuits. It's a really cool company that you should patronize.",
            'phone': "3743734848",
            'hours': {
              'monday': 'Monday: 8:00 AM - 10:00 PM',
              'tuesday': 'Tuesday: 8:00 AM - 10:00 PM',
              'wednesday': 'Wednesday: 8:00 AM - 10:00 PM',
              'thursday': 'Thursday: 8:00 AM - 10:00 PM',
              'friday': 'Friday: 8:00 AM - 10:30 PM',
              'saturday': 'Saturday: 8:00 AM - 10:30 PM',
              'sunday': 'Sunday: 9:00 AM - 9:00 PM',
            }
          },
          'photos': {
            'logo': {
              'name': "logo_2.png",
              'small_url': "https://cdna.artstation.com/p/assets/images/images/021/760/294/micro_square/jip-scheepers-2018-04-25.jpg?1572865897",
              'large_url': "https://cdna.artstation.com/p/assets/images/images/021/760/294/micro_square/jip-scheepers-2018-04-25.jpg?1572865897"
            },
            'banner': {
              'name': "banner_2.png",
              'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
              'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
            },
          },
          'location': {
            'geo': {
              'identifier': 'cdsnji2rty42',
              'lat': '35.927393',
              'lng': '-79.035551',
              'radius': '60'
            },
            'beacon': {
              'identifier': 'cdsnji2rty42',
              'region_identifier': 'cdjsb1y27qycd',
              'major': '1',
              'minor': '1'
            },
            'region': {
              'identifier': 'fcdjnasy3y8',
              'city': 'Chapel Hill',
              'state': 'NC',
              'zip': '27514',
              'neighborhood': 'cnsajcbads'
            }
          }
        },
        {
          'identifier': "fake_id_3",
          'profile': {
            'name': "City Kitchen",
            'website': "https://citykitchenchapelhill.com/",
            'description': "A description of the City Kitchen Bistro. It's a really cool company that you should patronize.",
            'phone': "3750370153",
            'hours': {
              'monday': 'Monday: 11:00 AM - 10:00 PM',
              'tuesday': 'Tuesday: 11:00 AM - 10:00 PM',
              'wednesday': 'Wednesday: 11:00 AM - 10:00 PM',
              'thursday': 'Thursday: 11:00 AM - 10:00 PM',
              'friday': 'Friday: 11:00 AM - 10:30 PM',
              'saturday': 'Saturday: 11:00 AM - 10:30 PM',
              'sunday': 'Sunday: 10:30 AM - 9:00 PM',
            }
          },
          'photos': {
            'logo': {
              'name': "logo_3.png",
              'small_url': "https://awmedu.com/wp-content/uploads/2016/08/bmw-cars-logo-emblem-200x200.jpg",
              'large_url': "https://awmedu.com/wp-content/uploads/2016/08/bmw-cars-logo-emblem-200x200.jpg"
            },
            'banner': {
              'name': "banner_3.png",
              'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
              'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
            },
          },
          'location': {
            'geo': {
              'identifier': '39320if4jebufcd',
              'lat': '35.914624',
              'lng': '-79.052906',
              'radius': '50'
            },
            'beacon': {
              'identifier': '39320ifj4ebufcd',
              'region_identifier': 'cdabsjhvchvda2j2',
              'major': '2',
              'minor': '2'
            },
            'region': {
              'identifier': 'fcdjnasy3y8',
              'city': 'Chapel Hill',
              'state': 'NC',
              'zip': '27514',
              'neighborhood': 'cbjsabc'
            }
          }
        },
        {
          'identifier': "fake_id_4",
          'profile': {
            'name': "Acme Inc.",
            'website': "https://acmecarrboro.com/",
            'description': "A description of the Acme Inc. company. It's a really cool company that you should patronize.",
            'phone': "9195244477",
            'hours': {
              'monday': 'Monday: 11:00 AM - 10:00 PM',
              'tuesday': 'Tuesday: 11:00 AM - 10:00 PM',
              'wednesday': 'Wednesday: 11:00 AM - 10:00 PM',
              'thursday': 'Thursday: 11:00 AM - 10:00 PM',
              'friday': 'Friday: 11:00 AM - 10:30 PM',
              'saturday': 'Saturday: 11:00 AM - 10:30 PM',
              'sunday': 'Sunday: 10:30 AM - 9:00 PM',
            }
          },
          'photos': {
            'logo': {
              'name': "logo_1.png",
              'small_url': "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0019/1114/brand.gif?itok=DKwKOdLe",
              'large_url': "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0019/1114/brand.gif?itok=DKwKOdLe"
            },
            'banner': {
              'name': "banner_1.png",
              'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
              'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
            },
          },
          'location': {
            'geo': {
              'identifier': 'bcdhbv31r3yv',
              'lat': '35.927115',
              'lng': '-79.027379',
              'radius': '50'
            },
            'beacon': {
              'identifier': 'bcdhbfv31r3yv4',
              'region_identifier': 'dcansjcbds22ded',
              'major': '0',
              'minor': '0'
            },
            'region': {
              'identifier': 'fcdjnasy3y8',
              'city': 'Chapel Hill',
              'state': 'NC',
              'zip': '27514',
              'neighborhood': 'bchsavc'
            }
          }
        },
        {
          'identifier': "fake_id_5",
          'profile': {
            'name': "Sunrise Biscuits",
            'website': "http://sunrisebiscuits.com/",
            'description': "A description of the Sunrise Biscuits. It's a really cool company that you should patronize.",
            'phone': "3743734848",
            'hours': {
              'monday': 'Monday: 8:00 AM - 10:00 PM',
              'tuesday': 'Tuesday: 8:00 AM - 10:00 PM',
              'wednesday': 'Wednesday: 8:00 AM - 10:00 PM',
              'thursday': 'Thursday: 8:00 AM - 10:00 PM',
              'friday': 'Friday: 8:00 AM - 10:30 PM',
              'saturday': 'Saturday: 8:00 AM - 10:30 PM',
              'sunday': 'Sunday: 9:00 AM - 9:00 PM',
            }
          },
          'photos': {
            'logo': {
              'name': "logo_2.png",
              'small_url': "https://cdna.artstation.com/p/assets/images/images/021/760/294/micro_square/jip-scheepers-2018-04-25.jpg?1572865897",
              'large_url': "https://cdna.artstation.com/p/assets/images/images/021/760/294/micro_square/jip-scheepers-2018-04-25.jpg?1572865897"
            },
            'banner': {
              'name': "banner_2.png",
              'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
              'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
            },
          },
          'location': {
            'geo': {
              'identifier': 'cdsnji2rty42',
              'lat': '35.927393',
              'lng': '-79.035551',
              'radius': '60'
            },
            'beacon': {
              'identifier': 'cdsnji2rty42',
              'region_identifier': 'cdjsb1y27qycd',
              'major': '1',
              'minor': '1'
            },
            'region': {
              'identifier': 'fcdjnasy3y8',
              'city': 'Chapel Hill',
              'state': 'NC',
              'zip': '27514',
              'neighborhood': 'cnsajcbads'
            }
          }
        },
        {
          'identifier': "fake_id_6",
          'profile': {
            'name': "City Kitchen",
            'website': "https://citykitchenchapelhill.com/",
            'description': "A description of the City Kitchen Bistro. It's a really cool company that you should patronize.",
            'phone': "3750370153",
            'hours': {
              'monday': 'Monday: 11:00 AM - 10:00 PM',
              'tuesday': 'Tuesday: 11:00 AM - 10:00 PM',
              'wednesday': 'Wednesday: 11:00 AM - 10:00 PM',
              'thursday': 'Thursday: 11:00 AM - 10:00 PM',
              'friday': 'Friday: 11:00 AM - 10:30 PM',
              'saturday': 'Saturday: 11:00 AM - 10:30 PM',
              'sunday': 'Sunday: 10:30 AM - 9:00 PM',
            }
          },
          'photos': {
            'logo': {
              'name': "logo_3.png",
              'small_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg",
              'large_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg"
            },
            'banner': {
              'name': "banner_3.png",
              'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
              'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
            },
          },
          'location': {
            'geo': {
              'identifier': '39320ifjeb5ufcd',
              'lat': '35.914624',
              'lng': '-79.052906',
              'radius': '50'
            },
            'beacon': {
              'identifier': '392320ifjebufcd',
              'region_identifier': 'cdabsjhvchvda2j2',
              'major': '2',
              'minor': '2'
            },
            'region': {
              'identifier': 'fcdjnasy3y8',
              'city': 'Chapel Hill',
              'state': 'NC',
              'zip': '27514',
              'neighborhood': 'cbjsabc'
            }
          }
        }
      ]
    };
  }

  static Map<String, dynamic> _mockFetchAllRefunds() {
    return {
      "data": [
        {
          "refund": {
            "identifier": "125d10b0-895a-11ea-95db-b1ba0de9dfd1",
            "total": "952",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid",
          },
          "business": {
            "identifier": "12569fc0-895a-11ea-8954-15c72741d7ca",
            "profile": {
              "name": "McClure-Gerhold",
              "website": "huel.org",
              "description": "Omnis aut beatae neque similique veniam numquam sint. Omnis expedita magni quaerat harum ipsum temporibus. Inventore ab sit non vel et quia veniam. Est fugit laborum incidunt natus id sit eius.",
              "google_place_id": null,
              "phone": "4080247291",
              "hours": {
                "monday": "Monday: 11:00 AM – 10:00 PM",
                "tuesday": "Tuesday: 11:00 AM – 10:00 PM",
                "wednesday": "Wednesday: 11:00 AM – 10:00 PM",
                "thursday": "Thursday: 11:00 AM – 10:00 PM",
                "friday": "Friday: 11:00 AM – 10:30 PM",
                "saturday": "Saturday: 11:00 AM – 10:30 PM",
                "sunday": "Sunday: 10:30 AM – 9:00 PM"
              }
            },
            'photos': {
              'logo': {
                'name': "logo_3.png",
                'small_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg",
                'large_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg"
              },
              'banner': {
                'name': "banner_3.png",
                'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
                'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
              },
            },
            "location": {
              "geo": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "lat": "71.699508",
                "lng": "169.164125",
                "radius": "50"
              },
              "beacon": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "region_identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "major": "0",
                "minor": "1"
              },
              "region": {
                "identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "city": "bernardland",
                "state": "in",
                "zip": "27313",
                "neighborhood": null
              }
            }
          },
          "transaction": {
            "identifier": "125aed31-895a-11ea-8f7a-1543da585c50",
            "employee_id": null,
            "tax": "198",
            "tip": "652",
            "net_sales": "2635",
            "total": "3485",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-28 14:10:53",
            "updated_at": "2020-04-28 14:10:53",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "3",
                "total": "6000"
              },
              {
                "name": "ratione",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              }
            ]
          },
          'issue': {
            'identifier': 'fake_identifier',
            'type': 'wrong_bill',
            'issue': "My bill is not this",
            'resolved': true,
            'warnings_sent': '2',
            'updated_at': '2020-05-21T22:27:59.000000Z'
          }
        },
        {
          "refund": {
            "identifier": "125f9f80-895a-11ea-b64a-b9ec2bd727cd",
            "total": "654",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid"
          },
          "business": {
            "identifier": "125d26e0-895a-11ea-9b43-0fca3f454941",
            "profile": {
              "name": "Kutch, Champlin and Cole",
              "website": "kuvalis.com",
              "description": "Nulla enim occaecati sunt dolorem modi quia debitis minus. Quam eveniet libero atque doloribus molestiae voluptatem enim. Eum nemo repudiandae repudiandae voluptatem id eaque reprehenderit molestias.",
              "google_place_id": null,
              "phone": "8670721138",
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
                'name': "banner_2.png",
                'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
                'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
              },
            },
            "location": {
              "geo": {
                "identifier": "125e3bd0-895a-11ea-934f-77f81e6ad181",
                "lat": "79.940106",
                "lng": "-16.031526",
                "radius": "50",
              },
              "beacon": {
                "identifier": "125e3bd0-895a-11ea-934f-77f81e6ad181",
                "region_identifier": "125e31b0-895a-11ea-8569-3783ad60a175",
                "major": "2",
                "minor": "3"
              },
              "region": {
                "identifier": "125e31b0-895a-11ea-8569-3783ad60a175",
                "city": "west beatriceburgh",
                "state": "me",
                "zip": "59395",
                "neighborhood": null
              }
            }
          },
          "transaction": {
            "identifier": "125e9600-895a-11ea-8675-d7891bfbd70d",
            "employee_id": null,
            "tax": "393",
            "tip": "0",
            "net_sales": "5242",
            "total": "5635",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-28 14:10:53",
            "updated_at": "2020-04-28 14:10:53",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "dolores",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              },
              {
                "name": "pariatur",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              },
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "2",
                "total": "4000"
              }
            ]
          },
          'issue': {
            'identifier': 'fake_identifier',
            'type': 'wrong_bill',
            'issue': "My bill is not this",
            'resolved': true,
            'warnings_sent': '2',
            'updated_at': '2020-05-21T22:27:59.000000Z'
          }
        },
        {
          "refund": {
            "identifier": "125d10b0-895a-11ea-95db-b1ba0de9dfd1",
            "total": "952",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid",
          },
          "business": {
            "identifier": "12569fc0-895a-11ea-8954-15c72741d7ca",
            "profile": {
              "name": "McClure-Gerhold",
              "website": "huel.org",
              "description": "Omnis aut beatae neque similique veniam numquam sint. Omnis expedita magni quaerat harum ipsum temporibus. Inventore ab sit non vel et quia veniam. Est fugit laborum incidunt natus id sit eius.",
              "google_place_id": null,
              "phone": "4080247291",
              "hours": {
                "monday": "Monday: 11:00 AM – 10:00 PM",
                "tuesday": "Tuesday: 11:00 AM – 10:00 PM",
                "wednesday": "Wednesday: 11:00 AM – 10:00 PM",
                "thursday": "Thursday: 11:00 AM – 10:00 PM",
                "friday": "Friday: 11:00 AM – 10:30 PM",
                "saturday": "Saturday: 11:00 AM – 10:30 PM",
                "sunday": "Sunday: 10:30 AM – 9:00 PM"
              }
            },
            'photos': {
              'logo': {
                'name': "logo_3.png",
                'small_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg",
                'large_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg"
              },
              'banner': {
                'name': "banner_3.png",
                'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
                'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
              },
            },
            "location": {
              "geo": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "lat": "71.699508",
                "lng": "169.164125",
                "radius": "50"
              },
              "beacon": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "region_identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "major": "0",
                "minor": "1"
              },
              "region": {
                "identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "city": "bernardland",
                "state": "in",
                "zip": "27313",
                "neighborhood": null
              }
            }
          },
          "transaction": {
            "identifier": "125aed30-895a-11ea-8a7a-1543da585c50",
            "employee_id": null,
            "tax": "198",
            "tip": "652",
            "net_sales": "2635",
            "total": "3485",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-28 14:10:53",
            "updated_at": "2020-04-28 14:10:53",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "3",
                "total": "6000"
              },
              {
                "name": "ratione",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              }
            ]
          },
          'issue': {
            'identifier': 'fake_identifier',
            'type': 'wrong_bill',
            'issue': "My bill is not this",
            'resolved': true,
            'warnings_sent': '2',
            'updated_at': '2020-05-21T22:27:59.000000Z'
          }
        },
        {
          "refund": {
            "identifier": "125f9f80-895a-11ea-b64a-b9ec2bd727cd",
            "total": "654",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid"
          },
          "business": {
            "identifier": "125d26e0-895a-11ea-9b43-0fca3f454941",
            "profile": {
              "name": "Kutch, Champlin and Cole",
              "website": "kuvalis.com",
              "description": "Nulla enim occaecati sunt dolorem modi quia debitis minus. Quam eveniet libero atque doloribus molestiae voluptatem enim. Eum nemo repudiandae repudiandae voluptatem id eaque reprehenderit molestias.",
              "google_place_id": null,
              "phone": "8670721138",
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
                'name': "banner_2.png",
                'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
                'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
              },
            },
            "location": {
              "geo": {
                "identifier": "125e3bd0-895a-11ea-934f-77f81e6ad181",
                "lat": "79.940106",
                "lng": "-16.031526",
                "radius": "50",
              },
              "beacon": {
                "identifier": "125e3bd0-895a-11ea-934f-77f81e6ad181",
                "region_identifier": "125e31b0-895a-11ea-8569-3783ad60a175",
                "major": "2",
                "minor": "3"
              },
              "region": {
                "identifier": "125e31b0-895a-11ea-8569-3783ad60a175",
                "city": "west beatriceburgh",
                "state": "me",
                "zip": "59395",
                "neighborhood": null
              }
            }
          },
          "transaction": {
            "identifier": "125e9600-895a-11ea-8675-d0891bfbd70d",
            "employee_id": null,
            "tax": "393",
            "tip": "0",
            "net_sales": "5242",
            "total": "5635",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-28 14:10:53",
            "updated_at": "2020-04-28 14:10:53",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "dolores",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              },
              {
                "name": "pariatur",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              },
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "2",
                "total": "4000"
              }
            ]
          },
          'issue': {
            'identifier': 'fake_identifier',
            'type': 'wrong_bill',
            'issue': "My bill is not this",
            'resolved': true,
            'warnings_sent': '2',
            'updated_at': '2020-05-21T22:27:59.000000Z'
          }
        },
        {
          "refund": {
            "identifier": "125d10b0-895a-11ea-95db-b1ba0de9dfd1",
            "total": "952",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid",
          },
          "business": {
            "identifier": "12569fc0-895a-11ea-8954-15c72741d7ca",
            "profile": {
              "name": "McClure-Gerhold",
              "website": "huel.org",
              "description": "Omnis aut beatae neque similique veniam numquam sint. Omnis expedita magni quaerat harum ipsum temporibus. Inventore ab sit non vel et quia veniam. Est fugit laborum incidunt natus id sit eius.",
              "google_place_id": null,
              "phone": "4080247291",
              "hours": {
                "monday": "Monday: 11:00 AM – 10:00 PM",
                "tuesday": "Tuesday: 11:00 AM – 10:00 PM",
                "wednesday": "Wednesday: 11:00 AM – 10:00 PM",
                "thursday": "Thursday: 11:00 AM – 10:00 PM",
                "friday": "Friday: 11:00 AM – 10:30 PM",
                "saturday": "Saturday: 11:00 AM – 10:30 PM",
                "sunday": "Sunday: 10:30 AM – 9:00 PM"
              }
            },
            'photos': {
              'logo': {
                'name': "logo_3.png",
                'small_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg",
                'large_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg"
              },
              'banner': {
                'name': "banner_3.png",
                'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
                'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
              },
            },
            "location": {
              "geo": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "lat": "71.699508",
                "lng": "169.164125",
                "radius": "50"
              },
              "beacon": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "region_identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "major": "0",
                "minor": "1"
              },
              "region": {
                "identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "city": "bernardland",
                "state": "in",
                "zip": "27313",
                "neighborhood": null
              }
            }
          },
          "transaction": {
            "identifier": "125aed30-895a-11ea-8f7a-1543da585cb0",
            "employee_id": null,
            "tax": "198",
            "tip": "652",
            "net_sales": "2635",
            "total": "3485",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-28 14:10:53",
            "updated_at": "2020-04-28 14:10:53",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "3",
                "total": "6000"
              },
              {
                "name": "ratione",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              }
            ]
          },
          'issue': {
            'identifier': 'fake_identifier',
            'type': 'wrong_bill',
            'issue': "My bill is not this",
            'resolved': true,
            'warnings_sent': '2',
            'updated_at': '2020-05-21T22:27:59.000000Z'
          }
        },
        {
          "refund": {
            "identifier": "125f9f80-895a-11ea-b64a-b9ec2bd727cd",
            "total": "654",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid"
          },
          "business": {
            "identifier": "125d26e0-895a-11ea-9b43-0fca3f454941",
            "profile": {
              "name": "Kutch, Champlin and Cole",
              "website": "kuvalis.com",
              "description": "Nulla enim occaecati sunt dolorem modi quia debitis minus. Quam eveniet libero atque doloribus molestiae voluptatem enim. Eum nemo repudiandae repudiandae voluptatem id eaque reprehenderit molestias.",
              "google_place_id": null,
              "phone": "8670721138",
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
                'name': "banner_2.png",
                'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
                'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
              },
            },
            "location": {
              "geo": {
                "identifier": "125e3bd0-895a-11ea-934f-77f81e6ad181",
                "lat": "79.940106",
                "lng": "-16.031526",
                "radius": "50",
              },
              "beacon": {
                "identifier": "125e3bd0-895a-11ea-934f-77f81e6ad181",
                "region_identifier": "125e31b0-895a-11ea-8569-3783ad60a175",
                "major": "2",
                "minor": "3"
              },
              "region": {
                "identifier": "125e31b0-895a-11ea-8569-3783ad60a175",
                "city": "west beatriceburgh",
                "state": "me",
                "zip": "59395",
                "neighborhood": null
              }
            }
          },
          "transaction": {
            "identifier": "125e960t-895a-11ea-8675-d7891bfbd70d",
            "employee_id": null,
            "tax": "393",
            "tip": "0",
            "net_sales": "5242",
            "total": "5635",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-28 14:10:53",
            "updated_at": "2020-04-28 14:10:53",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "dolores",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              },
              {
                "name": "pariatur",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              },
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "2",
                "total": "4000"
              }
            ]
          },
          'issue': {
            'identifier': 'fake_identifier',
            'type': 'wrong_bill',
            'issue': "My bill is not this",
            'resolved': true,
            'warnings_sent': '2',
            'updated_at': '2020-05-21T22:27:59.000000Z'
          }
        },
        {
          "refund": {
            "identifier": "125d10b0-895a-11ea-95db-b1ba0de9dfd1",
            "total": "952",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid",
          },
          "business": {
            "identifier": "12569fc0-895a-11ea-8954-15c72741d7ca",
            "profile": {
              "name": "McClure-Gerhold",
              "website": "huel.org",
              "description": "Omnis aut beatae neque similique veniam numquam sint. Omnis expedita magni quaerat harum ipsum temporibus. Inventore ab sit non vel et quia veniam. Est fugit laborum incidunt natus id sit eius.",
              "google_place_id": null,
              "phone": "4080247291",
              "hours": {
                "monday": "Monday: 11:00 AM – 10:00 PM",
                "tuesday": "Tuesday: 11:00 AM – 10:00 PM",
                "wednesday": "Wednesday: 11:00 AM – 10:00 PM",
                "thursday": "Thursday: 11:00 AM – 10:00 PM",
                "friday": "Friday: 11:00 AM – 10:30 PM",
                "saturday": "Saturday: 11:00 AM – 10:30 PM",
                "sunday": "Sunday: 10:30 AM – 9:00 PM"
              }
            },
            'photos': {
              'logo': {
                'name': "logo_3.png",
                'small_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg",
                'large_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg"
              },
              'banner': {
                'name': "banner_3.png",
                'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
                'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
              },
            },
            "location": {
              "geo": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "lat": "71.699508",
                "lng": "169.164125",
                "radius": "50"
              },
              "beacon": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "region_identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "major": "0",
                "minor": "1"
              },
              "region": {
                "identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "city": "bernardland",
                "state": "in",
                "zip": "27313",
                "neighborhood": null
              }
            }
          },
          "transaction": {
            "identifier": "125aed30-895a-11ea-8f7a-1n43da585c50",
            "employee_id": null,
            "tax": "198",
            "tip": "652",
            "net_sales": "2635",
            "total": "3485",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-28 14:10:53",
            "updated_at": "2020-04-28 14:10:53",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "3",
                "total": "6000"
              },
              {
                "name": "ratione",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              }
            ]
          },
          'issue': {
            'identifier': 'fake_identifier',
            'type': 'wrong_bill',
            'issue': "My bill is not this",
            'resolved': true,
            'warnings_sent': '2',
            'updated_at': '2020-05-21T22:27:59.000000Z'
          }
        },
        {
          "refund": {
            "identifier": "125f9f80-895a-11ea-b64a-b9ec2bd727cd",
            "total": "654",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid"
          },
          "business": {
            "identifier": "125d26e0-895a-11ea-9b43-0fca3f454941",
            "profile": {
              "name": "Kutch, Champlin and Cole",
              "website": "kuvalis.com",
              "description": "Nulla enim occaecati sunt dolorem modi quia debitis minus. Quam eveniet libero atque doloribus molestiae voluptatem enim. Eum nemo repudiandae repudiandae voluptatem id eaque reprehenderit molestias.",
              "google_place_id": null,
              "phone": "8670721138",
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
                'name': "banner_2.png",
                'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
                'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
              },
            },
            "location": {
              "geo": {
                "identifier": "125e3bd0-895a-11ea-934f-77f81e6ad181",
                "lat": "79.940106",
                "lng": "-16.031526",
                "radius": "50",
              },
              "beacon": {
                "identifier": "125e3bd0-895a-11ea-934f-77f81e6ad181",
                "region_identifier": "125e31b0-895a-11ea-8569-3783ad60a175",
                "major": "2",
                "minor": "3"
              },
              "region": {
                "identifier": "125e31b0-895a-11ea-8569-3783ad60a175",
                "city": "west beatriceburgh",
                "state": "me",
                "zip": "59395",
                "neighborhood": null
              }
            }
          },
          "transaction": {
            "identifier": "125e9600-895a-11ea-8675-d7891bfbd77p",
            "employee_id": null,
            "tax": "393",
            "tip": "0",
            "net_sales": "5242",
            "total": "5635",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-28 14:10:53",
            "updated_at": "2020-04-28 14:10:53",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "dolores",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              },
              {
                "name": "pariatur",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              },
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "2",
                "total": "4000"
              }
            ]
          },
          'issue': {
            'identifier': 'fake_identifier',
            'type': 'wrong_bill',
            'issue': "My bill is not this",
            'resolved': true,
            'warnings_sent': '2',
            'updated_at': '2020-05-21T22:27:59.000000Z'
          }
        },
        {
          "refund": {
            "identifier": "125d10b0-895a-11ea-95db-b1ba0de9dfd1",
            "total": "952",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid",
          },
          "business": {
            "identifier": "12569fc0-895a-11ea-8954-15c72741d7ca",
            "profile": {
              "name": "McClure-Gerhold",
              "website": "huel.org",
              "description": "Omnis aut beatae neque similique veniam numquam sint. Omnis expedita magni quaerat harum ipsum temporibus. Inventore ab sit non vel et quia veniam. Est fugit laborum incidunt natus id sit eius.",
              "google_place_id": null,
              "phone": "4080247291",
              "hours": {
                "monday": "Monday: 11:00 AM – 10:00 PM",
                "tuesday": "Tuesday: 11:00 AM – 10:00 PM",
                "wednesday": "Wednesday: 11:00 AM – 10:00 PM",
                "thursday": "Thursday: 11:00 AM – 10:00 PM",
                "friday": "Friday: 11:00 AM – 10:30 PM",
                "saturday": "Saturday: 11:00 AM – 10:30 PM",
                "sunday": "Sunday: 10:30 AM – 9:00 PM"
              }
            },
            'photos': {
              'logo': {
                'name': "logo_3.png",
                'small_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg",
                'large_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg"
              },
              'banner': {
                'name': "banner_3.png",
                'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
                'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
              },
            },
            "location": {
              "geo": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "lat": "71.699508",
                "lng": "169.164125",
                "radius": "50"
              },
              "beacon": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "region_identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "major": "0",
                "minor": "1"
              },
              "region": {
                "identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "city": "bernardland",
                "state": "in",
                "zip": "27313",
                "neighborhood": null
              }
            }
          },
          "transaction": {
            "identifier": "225aed40-895a-11ea-8f7a-1543da585c50",
            "employee_id": null,
            "tax": "198",
            "tip": "652",
            "net_sales": "2635",
            "total": "3485",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-28 14:10:53",
            "updated_at": "2020-04-28 14:10:53",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "3",
                "total": "6000"
              },
              {
                "name": "ratione",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              }
            ]
          },
          'issue': {
            'identifier': 'fake_identifier',
            'type': 'wrong_bill',
            'issue': "My bill is not this",
            'resolved': true,
            'warnings_sent': '2',
            'updated_at': '2020-05-21T22:27:59.000000Z'
          }
        },
        {
          "refund": {
            "identifier": "125f9f80-895a-11ea-b64a-b9ec2bd727cd",
            "total": "654",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid"
          },
          "business": {
            "identifier": "125d26e0-895a-11ea-9b43-0fca3f454941",
            "profile": {
              "name": "Kutch, Champlin and Cole",
              "website": "kuvalis.com",
              "description": "Nulla enim occaecati sunt dolorem modi quia debitis minus. Quam eveniet libero atque doloribus molestiae voluptatem enim. Eum nemo repudiandae repudiandae voluptatem id eaque reprehenderit molestias.",
              "google_place_id": null,
              "phone": "8670721138",
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
                'name': "banner_2.png",
                'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
                'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
              },
            },
            "location": {
              "geo": {
                "identifier": "125e3bd0-895a-11ea-934f-77f81e6ad181",
                "lat": "79.940106",
                "lng": "-16.031526",
                "radius": "50",
              },
              "beacon": {
                "identifier": "125e3bd0-895a-11ea-934f-77f81e6ad181",
                "region_identifier": "125e31b0-895a-11ea-8569-3783ad60a175",
                "major": "2",
                "minor": "3"
              },
              "region": {
                "identifier": "125e31b0-895a-11ea-8569-3783ad60a175",
                "city": "west beatriceburgh",
                "state": "me",
                "zip": "59395",
                "neighborhood": null
              }
            }
          },
          "transaction": {
            "identifier": "125e9600-895a-11ea-8675-d7891fbbd70d",
            "employee_id": null,
            "tax": "393",
            "tip": "0",
            "net_sales": "5242",
            "total": "5635",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-28 14:10:53",
            "updated_at": "2020-04-28 14:10:53",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "dolores",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              },
              {
                "name": "pariatur",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              },
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "2",
                "total": "4000"
              }
            ]
          },
          'issue': {
            'identifier': 'fake_identifier',
            'type': 'wrong_bill',
            'issue': "My bill is not this",
            'resolved': true,
            'warnings_sent': '2',
            'updated_at': '2020-05-21T22:27:59.000000Z'
          }
        },
        {
          "refund": {
            "identifier": "125d10b0-895a-11ea-95db-b1ba0de9dfd1",
            "total": "952",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid",
          },
          "business": {
            "identifier": "12569fc0-895a-11ea-8954-15c72741d7ca",
            "profile": {
              "name": "McClure-Gerhold",
              "website": "huel.org",
              "description": "Omnis aut beatae neque similique veniam numquam sint. Omnis expedita magni quaerat harum ipsum temporibus. Inventore ab sit non vel et quia veniam. Est fugit laborum incidunt natus id sit eius.",
              "google_place_id": null,
              "phone": "4080247291",
              "hours": {
                "monday": "Monday: 11:00 AM – 10:00 PM",
                "tuesday": "Tuesday: 11:00 AM – 10:00 PM",
                "wednesday": "Wednesday: 11:00 AM – 10:00 PM",
                "thursday": "Thursday: 11:00 AM – 10:00 PM",
                "friday": "Friday: 11:00 AM – 10:30 PM",
                "saturday": "Saturday: 11:00 AM – 10:30 PM",
                "sunday": "Sunday: 10:30 AM – 9:00 PM"
              }
            },
            'photos': {
              'logo': {
                'name': "logo_3.png",
                'small_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg",
                'large_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg"
              },
              'banner': {
                'name': "banner_3.png",
                'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
                'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
              },
            },
            "location": {
              "geo": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "lat": "71.699508",
                "lng": "169.164125",
                "radius": "50"
              },
              "beacon": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "region_identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "major": "0",
                "minor": "1"
              },
              "region": {
                "identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "city": "bernardland",
                "state": "in",
                "zip": "27313",
                "neighborhood": null
              }
            }
          },
          "transaction": {
            "identifier": "125aed30-895a-11ea-8f7a-1543da5d6c50",
            "employee_id": null,
            "tax": "198",
            "tip": "652",
            "net_sales": "2635",
            "total": "3485",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-28 14:10:53",
            "updated_at": "2020-04-28 14:10:53",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "3",
                "total": "6000"
              },
              {
                "name": "ratione",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              }
            ]
          },
          'issue': {
            'identifier': 'fake_identifier',
            'type': 'wrong_bill',
            'issue': "My bill is not this",
            'resolved': true,
            'warnings_sent': '2',
            'updated_at': '2020-05-21T22:27:59.000000Z'
          }
        },
        {
          "refund": {
            "identifier": "125f9f80-895a-11ea-b64a-b9ec2bd727cd",
            "total": "654",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid"
          },
          "business": {
            "identifier": "125d26e0-895a-11ea-9b43-0fca3f454941",
            "profile": {
              "name": "Kutch, Champlin and Cole",
              "website": "kuvalis.com",
              "description": "Nulla enim occaecati sunt dolorem modi quia debitis minus. Quam eveniet libero atque doloribus molestiae voluptatem enim. Eum nemo repudiandae repudiandae voluptatem id eaque reprehenderit molestias.",
              "google_place_id": null,
              "phone": "8670721138",
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
                'name': "banner_2.png",
                'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
                'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
              },
            },
            "location": {
              "geo": {
                "identifier": "125e3bd0-895a-11ea-934f-77f81e6ad181",
                "lat": "79.940106",
                "lng": "-16.031526",
                "radius": "50",
              },
              "beacon": {
                "identifier": "125e3bd0-895a-11ea-934f-77f81e6ad181",
                "region_identifier": "125e31b0-895a-11ea-8569-3783ad60a175",
                "major": "2",
                "minor": "3"
              },
              "region": {
                "identifier": "125e31b0-895a-11ea-8569-3783ad60a175",
                "city": "west beatriceburgh",
                "state": "me",
                "zip": "59395",
                "neighborhood": null
              }
            }
          },
          "transaction": {
            "identifier": "126ye9600-895a-11ea-8675-d7891bfbd70d",
            "employee_id": null,
            "tax": "393",
            "tip": "0",
            "net_sales": "5242",
            "total": "5635",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-28 14:10:53",
            "updated_at": "2020-04-28 14:10:53",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "dolores",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              },
              {
                "name": "pariatur",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              },
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "2",
                "total": "4000"
              }
            ]
          },
          'issue': {
            'identifier': 'fake_identifier',
            'type': 'wrong_bill',
            'issue': "My bill is not this",
            'resolved': true,
            'warnings_sent': '2',
            'updated_at': '2020-05-21T22:27:59.000000Z'
          }
        },
        {
          "refund": {
            "identifier": "125d10b0-895a-11ea-95db-b1ba0de9dfd1",
            "total": "952",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid",
          },
          "business": {
            "identifier": "12569fc0-895a-11ea-8954-15c72741d7ca",
            "profile": {
              "name": "McClure-Gerhold",
              "website": "huel.org",
              "description": "Omnis aut beatae neque similique veniam numquam sint. Omnis expedita magni quaerat harum ipsum temporibus. Inventore ab sit non vel et quia veniam. Est fugit laborum incidunt natus id sit eius.",
              "google_place_id": null,
              "phone": "4080247291",
              "hours": {
                "monday": "Monday: 11:00 AM – 10:00 PM",
                "tuesday": "Tuesday: 11:00 AM – 10:00 PM",
                "wednesday": "Wednesday: 11:00 AM – 10:00 PM",
                "thursday": "Thursday: 11:00 AM – 10:00 PM",
                "friday": "Friday: 11:00 AM – 10:30 PM",
                "saturday": "Saturday: 11:00 AM – 10:30 PM",
                "sunday": "Sunday: 10:30 AM – 9:00 PM"
              }
            },
            'photos': {
              'logo': {
                'name': "logo_3.png",
                'small_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg",
                'large_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg"
              },
              'banner': {
                'name': "banner_3.png",
                'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
                'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
              },
            },
            "location": {
              "geo": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "lat": "71.699508",
                "lng": "169.164125",
                "radius": "50"
              },
              "beacon": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "region_identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "major": "0",
                "minor": "1"
              },
              "region": {
                "identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "city": "bernardland",
                "state": "in",
                "zip": "27313",
                "neighborhood": null
              }
            }
          },
          "transaction": {
            "identifier": "125aed30-895a-11ea-ff7a-1543da584c50",
            "employee_id": null,
            "tax": "198",
            "tip": "652",
            "net_sales": "2635",
            "total": "3485",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-28 14:10:53",
            "updated_at": "2020-04-28 14:10:53",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "3",
                "total": "6000"
              },
              {
                "name": "ratione",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              }
            ]
          },
          'issue': {
            'identifier': 'fake_identifier',
            'type': 'wrong_bill',
            'issue': "My bill is not this",
            'resolved': true,
            'warnings_sent': '2',
            'updated_at': '2020-05-21T22:27:59.000000Z'
          }
        },
        {
          "refund": {
            "identifier": "125f9f80-895a-11ea-b64a-b9ec2bd727cd",
            "total": "654",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid"
          },
          "business": {
            "identifier": "125d26e0-895a-11ea-9b43-0fca3f454941",
            "profile": {
              "name": "Kutch, Champlin and Cole",
              "website": "kuvalis.com",
              "description": "Nulla enim occaecati sunt dolorem modi quia debitis minus. Quam eveniet libero atque doloribus molestiae voluptatem enim. Eum nemo repudiandae repudiandae voluptatem id eaque reprehenderit molestias.",
              "google_place_id": null,
              "phone": "8670721138",
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
                'name': "banner_2.png",
                'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
                'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
              },
            },
            "location": {
              "geo": {
                "identifier": "125e3bd0-895a-11ea-934f-77f81e6ad181",
                "lat": "79.940106",
                "lng": "-16.031526",
                "radius": "50",
              },
              "beacon": {
                "identifier": "125e3bd0-895a-11ea-934f-77f81e6ad181",
                "region_identifier": "125e31b0-895a-11ea-8569-3783ad60a175",
                "major": "2",
                "minor": "3"
              },
              "region": {
                "identifier": "125e31b0-895a-11ea-8569-3783ad60a175",
                "city": "west beatriceburgh",
                "state": "me",
                "zip": "59395",
                "neighborhood": null
              }
            }
          },
          "transaction": {
            "identifier": "128e9600-895a-11ea-8675-d7891bfbd71d",
            "employee_id": null,
            "tax": "393",
            "tip": "0",
            "net_sales": "5242",
            "total": "5635",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-28 14:10:53",
            "updated_at": "2020-04-28 14:10:53",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "dolores",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              },
              {
                "name": "pariatur",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              },
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "2",
                "total": "4000"
              }
            ]
          },
          'issue': {
            'identifier': 'fake_identifier',
            'type': 'wrong_bill',
            'issue': "My bill is not this",
            'resolved': true,
            'warnings_sent': '2',
            'updated_at': '2020-05-21T22:27:59.000000Z'
          }
        },
        {
          "refund": {
            "identifier": "125d10b0-895a-11ea-95db-b1ba0de9dfd1",
            "total": "952",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid",
          },
          "business": {
            "identifier": "12569fc0-895a-11ea-8954-15c72741d7ca",
            "profile": {
              "name": "McClure-Gerhold",
              "website": "huel.org",
              "description": "Omnis aut beatae neque similique veniam numquam sint. Omnis expedita magni quaerat harum ipsum temporibus. Inventore ab sit non vel et quia veniam. Est fugit laborum incidunt natus id sit eius.",
              "google_place_id": null,
              "phone": "4080247291",
              "hours": {
                "monday": "Monday: 11:00 AM – 10:00 PM",
                "tuesday": "Tuesday: 11:00 AM – 10:00 PM",
                "wednesday": "Wednesday: 11:00 AM – 10:00 PM",
                "thursday": "Thursday: 11:00 AM – 10:00 PM",
                "friday": "Friday: 11:00 AM – 10:30 PM",
                "saturday": "Saturday: 11:00 AM – 10:30 PM",
                "sunday": "Sunday: 10:30 AM – 9:00 PM"
              }
            },
            'photos': {
              'logo': {
                'name': "logo_3.png",
                'small_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg",
                'large_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg"
              },
              'banner': {
                'name': "banner_3.png",
                'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
                'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
              },
            },
            "location": {
              "geo": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "lat": "71.699508",
                "lng": "169.164125",
                "radius": "50"
              },
              "beacon": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "region_identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "major": "0",
                "minor": "1"
              },
              "region": {
                "identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "city": "bernardland",
                "state": "in",
                "zip": "27313",
                "neighborhood": null
              }
            }
          },
          "transaction": {
            "identifier": "125aed30-895a-115a-8f7a-1543da585i50",
            "employee_id": null,
            "tax": "198",
            "tip": "652",
            "net_sales": "2635",
            "total": "3485",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-28 14:10:53",
            "updated_at": "2020-04-28 14:10:53",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "3",
                "total": "6000"
              },
              {
                "name": "ratione",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              }
            ]
          },
          'issue': {
            'identifier': 'fake_identifier',
            'type': 'wrong_bill',
            'issue': "My bill is not this",
            'resolved': true,
            'warnings_sent': '2',
            'updated_at': '2020-05-21T22:27:59.000000Z'
          }
        },
        {
          "refund": {
            "identifier": "125f9f80-895a-11ea-b64a-b9ec2bd727cd",
            "total": "654",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid"
          },
          "business": {
            "identifier": "125d26e0-895a-11ea-9b43-0fca3f454941",
            "profile": {
              "name": "Kutch, Champlin and Cole",
              "website": "kuvalis.com",
              "description": "Nulla enim occaecati sunt dolorem modi quia debitis minus. Quam eveniet libero atque doloribus molestiae voluptatem enim. Eum nemo repudiandae repudiandae voluptatem id eaque reprehenderit molestias.",
              "google_place_id": null,
              "phone": "8670721138",
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
                'name': "banner_2.png",
                'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
                'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
              },
            },
            "location": {
              "geo": {
                "identifier": "125e3bd0-895a-11ea-934f-77f81e6ad181",
                "lat": "79.940106",
                "lng": "-16.031526",
                "radius": "50",
              },
              "beacon": {
                "identifier": "125e3bd0-895a-11ea-934f-77f81e6ad181",
                "region_identifier": "125e31b0-895a-11ea-8569-3783ad60a175",
                "major": "2",
                "minor": "3"
              },
              "region": {
                "identifier": "125e31b0-895a-11ea-8569-3783ad60a175",
                "city": "west beatriceburgh",
                "state": "me",
                "zip": "59395",
                "neighborhood": null
              }
            }
          },
          "transaction": {
            "identifier": "125e9607-895a-11ea-8675-d7891bfkd70d",
            "employee_id": null,
            "tax": "393",
            "tip": "0",
            "net_sales": "5242",
            "total": "5635",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-28 14:10:53",
            "updated_at": "2020-04-28 14:10:53",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "dolores",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              },
              {
                "name": "pariatur",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              },
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "2",
                "total": "4000"
              }
            ]
          },
          'issue': {
            'identifier': 'fake_identifier',
            'type': 'wrong_bill',
            'issue': "My bill is not this",
            'resolved': true,
            'warnings_sent': '2',
            'updated_at': '2020-05-21T22:27:59.000000Z'
          }
        }
      ],
      "links": {
        "first": "http://localhost/api/customer/refund?page=1",
        "last": "http://localhost/api/customer/refund?page=2",
        "prev": null,
        "next": "http://localhost/api/customer/refund?page=2",
      },
      "meta": {
        "current_page": "1",
        "from": "1",
        "last_page": "2",
        "path": "http://localhost/api/customer/refund",
        "per_page": "15",
        "to": "15",
        "total": "20",
      }
    };
  }

  static Map<String, dynamic> _mockFetchAllRefundsTwo() {
    return {
      "data": [
        {
          "refund": {
            "identifier": "125d10b0-895a-11ea-95db-b1ba0de9dfd1",
            "total": "952",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid",
          },
          "business": {
            "identifier": "12569fc0-895a-11ea-8954-15c72741d7ca",
            "profile": {
              "name": "McClure-Gerhold",
              "website": "huel.org",
              "description": "Omnis aut beatae neque similique veniam numquam sint. Omnis expedita magni quaerat harum ipsum temporibus. Inventore ab sit non vel et quia veniam. Est fugit laborum incidunt natus id sit eius.",
              "google_place_id": null,
              "phone": "4080247291",
              "hours": {
                "monday": "Monday: 11:00 AM – 10:00 PM",
                "tuesday": "Tuesday: 11:00 AM – 10:00 PM",
                "wednesday": "Wednesday: 11:00 AM – 10:00 PM",
                "thursday": "Thursday: 11:00 AM – 10:00 PM",
                "friday": "Friday: 11:00 AM – 10:30 PM",
                "saturday": "Saturday: 11:00 AM – 10:30 PM",
                "sunday": "Sunday: 10:30 AM – 9:00 PM"
              }
            },
            'photos': {
              'logo': {
                'name': "logo_3.png",
                'small_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg",
                'large_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg"
              },
              'banner': {
                'name': "banner_3.png",
                'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
                'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
              },
            },
            "location": {
              "geo": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "lat": "71.699508",
                "lng": "169.164125",
                "radius": "50"
              },
              "beacon": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "region_identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "major": "0",
                "minor": "1"
              },
              "region": {
                "identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "city": "bernardland",
                "state": "in",
                "zip": "27313",
                "neighborhood": null
              }
            }
          },
          "transaction": {
            "identifier": "125aed30-895a-11ea-8f7a-1543c0585c50",
            "employee_id": null,
            "tax": "198",
            "tip": "652",
            "net_sales": "2635",
            "total": "3485",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-28 14:10:53",
            "updated_at": "2020-04-28 14:10:53",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "3",
                "total": "6000"
              },
              {
                "name": "ratione",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              }
            ]
          },
          'issue': {
            'identifier': 'fake_identifier',
            'type': 'wrong_bill',
            'issue': "My bill is not this",
            'resolved': true,
            'warnings_sent': '2',
            'updated_at': '2020-05-21T22:27:59.000000Z'
          }
        },
        {
          "refund": {
            "identifier": "125f9f80-895a-11ea-b64a-b9ec2bd727cd",
            "total": "654",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid"
          },
          "business": {
            "identifier": "125d26e0-895a-11ea-9b43-0fca3f454941",
            "profile": {
              "name": "Kutch, Champlin and Cole",
              "website": "kuvalis.com",
              "description": "Nulla enim occaecati sunt dolorem modi quia debitis minus. Quam eveniet libero atque doloribus molestiae voluptatem enim. Eum nemo repudiandae repudiandae voluptatem id eaque reprehenderit molestias.",
              "google_place_id": null,
              "phone": "8670721138",
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
                'name': "banner_2.png",
                'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
                'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
              },
            },
            "location": {
              "geo": {
                "identifier": "125e3bd0-895a-11ea-934f-77f81e6ad181",
                "lat": "79.940106",
                "lng": "-16.031526",
                "radius": "50",
              },
              "beacon": {
                "identifier": "125e3bd0-895a-11ea-934f-77f81e6ad181",
                "region_identifier": "125e31b0-895a-11ea-8569-3783ad60a175",
                "major": "2",
                "minor": "3"
              },
              "region": {
                "identifier": "125e31b0-895a-11ea-8569-3783ad60a175",
                "city": "west beatriceburgh",
                "state": "me",
                "zip": "59395",
                "neighborhood": null
              }
            }
          },
          "transaction": {
            "identifier": "135e9600-895a-11ea-8675-d7891bfbd71d",
            "employee_id": null,
            "tax": "393",
            "tip": "0",
            "net_sales": "5242",
            "total": "5635",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-28 14:10:53",
            "updated_at": "2020-04-28 14:10:53",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "dolores",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              },
              {
                "name": "pariatur",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              },
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "2",
                "total": "4000"
              }
            ]
          },
          'issue': {
            'identifier': 'fake_identifier',
            'type': 'wrong_bill',
            'issue': "My bill is not this",
            'resolved': true,
            'warnings_sent': '2',
            'updated_at': '2020-05-21T22:27:59.000000Z'
          }
        },
        {
          "refund": {
            "identifier": "125d10b0-895a-11ea-95db-b1ba0de9dfd1",
            "total": "952",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid",
          },
          "business": {
            "identifier": "12569fc0-895a-11ea-8954-15c72741d7ca",
            "profile": {
              "name": "McClure-Gerhold",
              "website": "huel.org",
              "description": "Omnis aut beatae neque similique veniam numquam sint. Omnis expedita magni quaerat harum ipsum temporibus. Inventore ab sit non vel et quia veniam. Est fugit laborum incidunt natus id sit eius.",
              "google_place_id": null,
              "phone": "4080247291",
              "hours": {
                "monday": "Monday: 11:00 AM – 10:00 PM",
                "tuesday": "Tuesday: 11:00 AM – 10:00 PM",
                "wednesday": "Wednesday: 11:00 AM – 10:00 PM",
                "thursday": "Thursday: 11:00 AM – 10:00 PM",
                "friday": "Friday: 11:00 AM – 10:30 PM",
                "saturday": "Saturday: 11:00 AM – 10:30 PM",
                "sunday": "Sunday: 10:30 AM – 9:00 PM"
              }
            },
            'photos': {
              'logo': {
                'name': "logo_3.png",
                'small_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg",
                'large_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg"
              },
              'banner': {
                'name': "banner_3.png",
                'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
                'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
              },
            },
            "location": {
              "geo": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "lat": "71.699508",
                "lng": "169.164125",
                "radius": "50"
              },
              "beacon": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "region_identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "major": "0",
                "minor": "1"
              },
              "region": {
                "identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "city": "bernardland",
                "state": "in",
                "zip": "27313",
                "neighborhood": null
              }
            }
          },
          "transaction": {
            "identifier": "125aed30-895a-114o-8f7a-1543da585c50",
            "employee_id": null,
            "tax": "198",
            "tip": "652",
            "net_sales": "2635",
            "total": "3485",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-28 14:10:53",
            "updated_at": "2020-04-28 14:10:53",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "3",
                "total": "6000"
              },
              {
                "name": "ratione",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              }
            ]
          }, 
          'issue': {
            'identifier': 'fake_identifier',
            'type': 'wrong_bill',
            'issue': "My bill is not this",
            'resolved': true,
            'warnings_sent': '2',
            'updated_at': '2020-05-21T22:27:59.000000Z'
          }
        },
        {
          "refund": {
            "identifier": "125f9f80-895a-11ea-b64a-b9ec2bd727cd",
            "total": "654",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid"
          },
          "business": {
            "identifier": "125d26e0-895a-11ea-9b43-0fca3f454941",
            "profile": {
              "name": "Kutch, Champlin and Cole",
              "website": "kuvalis.com",
              "description": "Nulla enim occaecati sunt dolorem modi quia debitis minus. Quam eveniet libero atque doloribus molestiae voluptatem enim. Eum nemo repudiandae repudiandae voluptatem id eaque reprehenderit molestias.",
              "google_place_id": null,
              "phone": "8670721138",
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
                'name': "banner_2.png",
                'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
                'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
              },
            },
            "location": {
              "geo": {
                "identifier": "125e3bd0-895a-11ea-934f-77f81e6ad181",
                "lat": "79.940106",
                "lng": "-16.031526",
                "radius": "50",
              },
              "beacon": {
                "identifier": "125e3bd0-895a-11ea-934f-77f81e6ad181",
                "region_identifier": "125e31b0-895a-11ea-8569-3783ad60a175",
                "major": "2",
                "minor": "3"
              },
              "region": {
                "identifier": "125e31b0-895a-11ea-8569-3783ad60a175",
                "city": "west beatriceburgh",
                "state": "me",
                "zip": "59395",
                "neighborhood": null
              }
            }
          },
          "transaction": {
            "identifier": "125e8600-895a-11ea-86f5-d7891bfbd70d",
            "employee_id": null,
            "tax": "393",
            "tip": "0",
            "net_sales": "5242",
            "total": "5635",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-28 14:10:53",
            "updated_at": "2020-04-28 14:10:53",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "dolores",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              },
              {
                "name": "pariatur",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              },
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "2",
                "total": "4000"
              }
            ]
          },
          'issue': {
            'identifier': 'fake_identifier',
            'type': 'wrong_bill',
            'issue': "My bill is not this",
            'resolved': true,
            'warnings_sent': '2',
            'updated_at': '2020-05-21T22:27:59.000000Z'
          }
        },
        {
          "refund": {
            "identifier": "125d10b0-895a-11ea-95db-b1ba0de9dfd1",
            "total": "952",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid",
          },
          "business": {
            "identifier": "12569fc0-895a-11ea-8954-15c72741d7ca",
            "profile": {
              "name": "McClure-Gerhold",
              "website": "huel.org",
              "description": "Omnis aut beatae neque similique veniam numquam sint. Omnis expedita magni quaerat harum ipsum temporibus. Inventore ab sit non vel et quia veniam. Est fugit laborum incidunt natus id sit eius.",
              "google_place_id": null,
              "phone": "4080247291",
              "hours": {
                "monday": "Monday: 11:00 AM – 10:00 PM",
                "tuesday": "Tuesday: 11:00 AM – 10:00 PM",
                "wednesday": "Wednesday: 11:00 AM – 10:00 PM",
                "thursday": "Thursday: 11:00 AM – 10:00 PM",
                "friday": "Friday: 11:00 AM – 10:30 PM",
                "saturday": "Saturday: 11:00 AM – 10:30 PM",
                "sunday": "Sunday: 10:30 AM – 9:00 PM"
              }
            },
            'photos': {
              'logo': {
                'name': "logo_3.png",
                'small_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg",
                'large_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg"
              },
              'banner': {
                'name': "banner_3.png",
                'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
                'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
              },
            },
            "location": {
              "geo": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "lat": "71.699508",
                "lng": "169.164125",
                "radius": "50"
              },
              "beacon": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "region_identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "major": "0",
                "minor": "1"
              },
              "region": {
                "identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "city": "bernardland",
                "state": "in",
                "zip": "27313",
                "neighborhood": null
              }
            }
          },
          "transaction": {
            "identifier": "125aed30-895a-11ea-8f7a-2043da585c50",
            "employee_id": null,
            "tax": "198",
            "tip": "652",
            "net_sales": "2635",
            "total": "3485",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-28 14:10:53",
            "updated_at": "2020-04-28 14:10:53",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "3",
                "total": "6000"
              },
              {
                "name": "ratione",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              }
            ]
          },
          'issue': {
            'identifier': 'fake_identifier',
            'type': 'wrong_bill',
            'issue': "My bill is not this",
            'resolved': true,
            'warnings_sent': '2',
            'updated_at': '2020-05-21T22:27:59.000000Z'
          }
        },
        {
          "refund": {
            "identifier": "125f9f80-895a-11ea-b64a-b9ec2bd727cd",
            "total": "654",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid"
          },
          "business": {
            "identifier": "125d26e0-895a-11ea-9b43-0fca3f454941",
            "profile": {
              "name": "Kutch, Champlin and Cole",
              "website": "kuvalis.com",
              "description": "Nulla enim occaecati sunt dolorem modi quia debitis minus. Quam eveniet libero atque doloribus molestiae voluptatem enim. Eum nemo repudiandae repudiandae voluptatem id eaque reprehenderit molestias.",
              "google_place_id": null,
              "phone": "8670721138",
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
                'name': "banner_2.png",
                'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
                'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
              },
            },
            "location": {
              "geo": {
                "identifier": "125e3bd0-895a-11ea-934f-77f81e6ad181",
                "lat": "79.940106",
                "lng": "-16.031526",
                "radius": "50",
              },
              "beacon": {
                "identifier": "125e3bd0-895a-11ea-934f-77f81e6ad181",
                "region_identifier": "125e31b0-895a-11ea-8569-3783ad60a175",
                "major": "2",
                "minor": "3"
              },
              "region": {
                "identifier": "125e31b0-895a-11ea-8569-3783ad60a175",
                "city": "west beatriceburgh",
                "state": "me",
                "zip": "59395",
                "neighborhood": null
              }
            }
          },
          "transaction": {
            "identifier": "125e9600-895z-11ea-8675-d78h1bfbd70d",
            "employee_id": null,
            "tax": "393",
            "tip": "0",
            "net_sales": "5242",
            "total": "5635",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-28 14:10:53",
            "updated_at": "2020-04-28 14:10:53",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "dolores",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              },
              {
                "name": "pariatur",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              },
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "2",
                "total": "4000"
              }
            ]
          },
          'issue': {
            'identifier': 'fake_identifier',
            'type': 'wrong_bill',
            'issue': "My bill is not this",
            'resolved': true,
            'warnings_sent': '2',
            'updated_at': '2020-05-21T22:27:59.000000Z'
          }
        },
        {
          "refund": {
            "identifier": "125d10b0-895a-11ea-95db-b1ba0de9dfd1",
            "total": "952",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid",
          },
          "business": {
            "identifier": "12569fc0-895a-11ea-8954-15c72741d7ca",
            "profile": {
              "name": "McClure-Gerhold",
              "website": "huel.org",
              "description": "Omnis aut beatae neque similique veniam numquam sint. Omnis expedita magni quaerat harum ipsum temporibus. Inventore ab sit non vel et quia veniam. Est fugit laborum incidunt natus id sit eius.",
              "google_place_id": null,
              "phone": "4080247291",
              "hours": {
                "monday": "Monday: 11:00 AM – 10:00 PM",
                "tuesday": "Tuesday: 11:00 AM – 10:00 PM",
                "wednesday": "Wednesday: 11:00 AM – 10:00 PM",
                "thursday": "Thursday: 11:00 AM – 10:00 PM",
                "friday": "Friday: 11:00 AM – 10:30 PM",
                "saturday": "Saturday: 11:00 AM – 10:30 PM",
                "sunday": "Sunday: 10:30 AM – 9:00 PM"
              }
            },
            'photos': {
              'logo': {
                'name': "logo_3.png",
                'small_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg",
                'large_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg"
              },
              'banner': {
                'name': "banner_3.png",
                'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
                'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
              },
            },
            "location": {
              "geo": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "lat": "71.699508",
                "lng": "169.164125",
                "radius": "50"
              },
              "beacon": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "region_identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "major": "0",
                "minor": "1"
              },
              "region": {
                "identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "city": "bernardland",
                "state": "in",
                "zip": "27313",
                "neighborhood": null
              }
            }
          },
          "transaction": {
            "identifier": "125aed30-895d-11ea-8f7a-1543da58hc50",
            "employee_id": null,
            "tax": "198",
            "tip": "652",
            "net_sales": "2635",
            "total": "3485",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-28 14:10:53",
            "updated_at": "2020-04-28 14:10:53",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "3",
                "total": "6000"
              },
              {
                "name": "ratione",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              }
            ]
          },
          'issue': {
            'identifier': 'fake_identifier',
            'type': 'wrong_bill',
            'issue': "My bill is not this",
            'resolved': true,
            'warnings_sent': '2',
            'updated_at': '2020-05-21T22:27:59.000000Z'
          }
        },
        {
          "refund": {
            "identifier": "125f9f80-895a-11ea-b64a-b9ec2bd727cd",
            "total": "654",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid"
          },
          "business": {
            "identifier": "125d26e0-895a-11ea-9b43-0fca3f454941",
            "profile": {
              "name": "Kutch, Champlin and Cole",
              "website": "kuvalis.com",
              "description": "Nulla enim occaecati sunt dolorem modi quia debitis minus. Quam eveniet libero atque doloribus molestiae voluptatem enim. Eum nemo repudiandae repudiandae voluptatem id eaque reprehenderit molestias.",
              "google_place_id": null,
              "phone": "8670721138",
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
                'name': "banner_2.png",
                'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
                'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
              },
            },
            "location": {
              "geo": {
                "identifier": "125e3bd0-895a-11ea-934f-77f81e6ad181",
                "lat": "79.940106",
                "lng": "-16.031526",
                "radius": "50",
              },
              "beacon": {
                "identifier": "125e3bd0-895a-11ea-934f-77f81e6ad181",
                "region_identifier": "125e31b0-895a-11ea-8569-3783ad60a175",
                "major": "2",
                "minor": "3"
              },
              "region": {
                "identifier": "125e31b0-895a-11ea-8569-3783ad60a175",
                "city": "west beatriceburgh",
                "state": "me",
                "zip": "59395",
                "neighborhood": null
              }
            }
          },
          "transaction": {
            "identifier": "145e9600-895a-11ea-8675-d7891bqbd70d",
            "employee_id": null,
            "tax": "393",
            "tip": "0",
            "net_sales": "5242",
            "total": "5635",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-28 14:10:53",
            "updated_at": "2020-04-28 14:10:53",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "dolores",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              },
              {
                "name": "pariatur",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              },
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "2",
                "total": "4000"
              }
            ]
          },
          'issue': {
            'identifier': 'fake_identifier',
            'type': 'wrong_bill',
            'issue': "My bill is not this",
            'resolved': true,
            'warnings_sent': '2',
            'updated_at': '2020-05-21T22:27:59.000000Z'
          }
        },
        {
          "refund": {
            "identifier": "125d10b0-895a-11ea-95db-b1ba0de9dfd1",
            "total": "952",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid",
          },
          "business": {
            "identifier": "12569fc0-895a-11ea-8954-15c72741d7ca",
            "profile": {
              "name": "McClure-Gerhold",
              "website": "huel.org",
              "description": "Omnis aut beatae neque similique veniam numquam sint. Omnis expedita magni quaerat harum ipsum temporibus. Inventore ab sit non vel et quia veniam. Est fugit laborum incidunt natus id sit eius.",
              "google_place_id": null,
              "phone": "4080247291",
              "hours": {
                "monday": "Monday: 11:00 AM – 10:00 PM",
                "tuesday": "Tuesday: 11:00 AM – 10:00 PM",
                "wednesday": "Wednesday: 11:00 AM – 10:00 PM",
                "thursday": "Thursday: 11:00 AM – 10:00 PM",
                "friday": "Friday: 11:00 AM – 10:30 PM",
                "saturday": "Saturday: 11:00 AM – 10:30 PM",
                "sunday": "Sunday: 10:30 AM – 9:00 PM"
              }
            },
            'photos': {
              'logo': {
                'name': "logo_3.png",
                'small_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg",
                'large_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg"
              },
              'banner': {
                'name': "banner_3.png",
                'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
                'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
              },
            },
            "location": {
              "geo": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "lat": "71.699508",
                "lng": "169.164125",
                "radius": "50"
              },
              "beacon": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "region_identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "major": "0",
                "minor": "1"
              },
              "region": {
                "identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "city": "bernardland",
                "state": "in",
                "zip": "27313",
                "neighborhood": null
              }
            }
          },
          "transaction": {
            "identifier": "125aedu0-895a-11ea-8f7a-15u3da585c50",
            "employee_id": null,
            "tax": "198",
            "tip": "652",
            "net_sales": "2635",
            "total": "3485",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-28 14:10:53",
            "updated_at": "2020-04-28 14:10:53",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "3",
                "total": "6000"
              },
              {
                "name": "ratione",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              }
            ]
          },
          'issue': {
            'identifier': 'fake_identifier',
            'type': 'wrong_bill',
            'issue': "My bill is not this",
            'resolved': true,
            'warnings_sent': '2',
            'updated_at': '2020-05-21T22:27:59.000000Z'
          }
        },
        {
          "refund": {
            "identifier": "125f9f80-895a-11ea-b64a-b9ec2bd727cd",
            "total": "654",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid"
          },
          "business": {
            "identifier": "125d26e0-895a-11ea-9b43-0fca3f454941",
            "profile": {
              "name": "Kutch, Champlin and Cole",
              "website": "kuvalis.com",
              "description": "Nulla enim occaecati sunt dolorem modi quia debitis minus. Quam eveniet libero atque doloribus molestiae voluptatem enim. Eum nemo repudiandae repudiandae voluptatem id eaque reprehenderit molestias.",
              "google_place_id": null,
              "phone": "8670721138",
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
                'name': "banner_2.png",
                'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
                'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
              },
            },
            "location": {
              "geo": {
                "identifier": "125e3bd0-895a-11ea-934f-77f81e6ad181",
                "lat": "79.940106",
                "lng": "-16.031526",
                "radius": "50",
              },
              "beacon": {
                "identifier": "125e3bd0-895a-11ea-934f-77f81e6ad181",
                "region_identifier": "125e31b0-895a-11ea-8569-3783ad60a175",
                "major": "2",
                "minor": "3"
              },
              "region": {
                "identifier": "125e31b0-895a-11ea-8569-3783ad60a175",
                "city": "west beatriceburgh",
                "state": "me",
                "zip": "59395",
                "neighborhood": null
              }
            }
          },
          "transaction": {
            "identifier": "125e9600-8952-112a-8675-d7891bfbd70d",
            "employee_id": null,
            "tax": "393",
            "tip": "0",
            "net_sales": "5242",
            "total": "5635",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-28 14:10:53",
            "updated_at": "2020-04-28 14:10:53",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "dolores",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              },
              {
                "name": "pariatur",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              },
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "2",
                "total": "4000"
              }
            ]
          },
          'issue': {
            'identifier': 'fake_identifier',
            'type': 'wrong_bill',
            'issue': "My bill is not this",
            'resolved': true,
            'warnings_sent': '2',
            'updated_at': '2020-05-21T22:27:59.000000Z'
          }
        },
        {
          "refund": {
            "identifier": "125d10b0-895a-11ea-95db-b1ba0de9dfd1",
            "total": "952",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid",
          },
          "business": {
            "identifier": "12569fc0-895a-11ea-8954-15c72741d7ca",
            "profile": {
              "name": "McClure-Gerhold",
              "website": "huel.org",
              "description": "Omnis aut beatae neque similique veniam numquam sint. Omnis expedita magni quaerat harum ipsum temporibus. Inventore ab sit non vel et quia veniam. Est fugit laborum incidunt natus id sit eius.",
              "google_place_id": null,
              "phone": "4080247291",
              "hours": {
                "monday": "Monday: 11:00 AM – 10:00 PM",
                "tuesday": "Tuesday: 11:00 AM – 10:00 PM",
                "wednesday": "Wednesday: 11:00 AM – 10:00 PM",
                "thursday": "Thursday: 11:00 AM – 10:00 PM",
                "friday": "Friday: 11:00 AM – 10:30 PM",
                "saturday": "Saturday: 11:00 AM – 10:30 PM",
                "sunday": "Sunday: 10:30 AM – 9:00 PM"
              }
            },
            'photos': {
              'logo': {
                'name': "logo_3.png",
                'small_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg",
                'large_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg"
              },
              'banner': {
                'name': "banner_3.png",
                'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
                'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
              },
            },
            "location": {
              "geo": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "lat": "71.699508",
                "lng": "169.164125",
                "radius": "50"
              },
              "beacon": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "region_identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "major": "0",
                "minor": "1"
              },
              "region": {
                "identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "city": "bernardland",
                "state": "in",
                "zip": "27313",
                "neighborhood": null
              }
            }
          },
          "transaction": {
            "identifier": "125aed3l-895a-11ea-8f7a-1543dx585c50",
            "employee_id": null,
            "tax": "198",
            "tip": "652",
            "net_sales": "2635",
            "total": "3485",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-28 14:10:53",
            "updated_at": "2020-04-28 14:10:53",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "3",
                "total": "6000"
              },
              {
                "name": "ratione",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              }
            ]
          },
          'issue': {
            'identifier': 'fake_identifier',
            'type': 'wrong_bill',
            'issue': "My bill is not this",
            'resolved': true,
            'warnings_sent': '2',
            'updated_at': '2020-05-21T22:27:59.000000Z'
          }
        },
        {
          "refund": {
            "identifier": "125f9f80-895a-11ea-b64a-b9ec2bd727cd",
            "total": "654",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid"
          },
          "business": {
            "identifier": "125d26e0-895a-11ea-9b43-0fca3f454941",
            "profile": {
              "name": "Kutch, Champlin and Cole",
              "website": "kuvalis.com",
              "description": "Nulla enim occaecati sunt dolorem modi quia debitis minus. Quam eveniet libero atque doloribus molestiae voluptatem enim. Eum nemo repudiandae repudiandae voluptatem id eaque reprehenderit molestias.",
              "google_place_id": null,
              "phone": "8670721138",
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
                'name': "banner_2.png",
                'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
                'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
              },
            },
            "location": {
              "geo": {
                "identifier": "125e3bd0-895a-11ea-934f-77f81e6ad181",
                "lat": "79.940106",
                "lng": "-16.031526",
                "radius": "50",
              },
              "beacon": {
                "identifier": "125e3bd0-895a-11ea-934f-77f81e6ad181",
                "region_identifier": "125e31b0-895a-11ea-8569-3783ad60a175",
                "major": "2",
                "minor": "3"
              },
              "region": {
                "identifier": "125e31b0-895a-11ea-8569-3783ad60a175",
                "city": "west beatriceburgh",
                "state": "me",
                "zip": "59395",
                "neighborhood": null
              }
            }
          },
          "transaction": {
            "identifier": "125e9600-895a-31ea-8675-d7891sfbd70d",
            "employee_id": null,
            "tax": "393",
            "tip": "0",
            "net_sales": "5242",
            "total": "5635",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-28 14:10:53",
            "updated_at": "2020-04-28 14:10:53",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "dolores",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              },
              {
                "name": "pariatur",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              },
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "2",
                "total": "4000"
              }
            ]
          },
          'issue': {
            'identifier': 'fake_identifier',
            'type': 'wrong_bill',
            'issue': "My bill is not this",
            'resolved': true,
            'warnings_sent': '2',
            'updated_at': '2020-05-21T22:27:59.000000Z'
          }
        },
        {
          "refund": {
            "identifier": "125d10b0-895a-11ea-95db-b1ba0de9dfd1",
            "total": "952",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid",
          },
          "business": {
            "identifier": "12569fc0-895a-11ea-8954-15c72741d7ca",
            "profile": {
              "name": "McClure-Gerhold",
              "website": "huel.org",
              "description": "Omnis aut beatae neque similique veniam numquam sint. Omnis expedita magni quaerat harum ipsum temporibus. Inventore ab sit non vel et quia veniam. Est fugit laborum incidunt natus id sit eius.",
              "google_place_id": null,
              "phone": "4080247291",
              "hours": {
                "monday": "Monday: 11:00 AM – 10:00 PM",
                "tuesday": "Tuesday: 11:00 AM – 10:00 PM",
                "wednesday": "Wednesday: 11:00 AM – 10:00 PM",
                "thursday": "Thursday: 11:00 AM – 10:00 PM",
                "friday": "Friday: 11:00 AM – 10:30 PM",
                "saturday": "Saturday: 11:00 AM – 10:30 PM",
                "sunday": "Sunday: 10:30 AM – 9:00 PM"
              }
            },
            'photos': {
              'logo': {
                'name': "logo_3.png",
                'small_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg",
                'large_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg"
              },
              'banner': {
                'name': "banner_3.png",
                'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
                'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
              },
            },
            "location": {
              "geo": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "lat": "71.699508",
                "lng": "169.164125",
                "radius": "50"
              },
              "beacon": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "region_identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "major": "0",
                "minor": "1"
              },
              "region": {
                "identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "city": "bernardland",
                "state": "in",
                "zip": "27313",
                "neighborhood": null
              }
            }
          },
          "transaction": {
            "identifier": "12haed30-895a-11ea-8f4a-1543da585c50",
            "employee_id": null,
            "tax": "198",
            "tip": "652",
            "net_sales": "2635",
            "total": "3485",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-28 14:10:53",
            "updated_at": "2020-04-28 14:10:53",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "3",
                "total": "6000"
              },
              {
                "name": "ratione",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              }
            ]
          },
          'issue': {
            'identifier': 'fake_identifier',
            'type': 'wrong_bill',
            'issue': "My bill is not this",
            'resolved': true,
            'warnings_sent': '2',
            'updated_at': '2020-05-21T22:27:59.000000Z'
          }
        },
        {
          "refund": {
            "identifier": "125f9f80-895a-11ea-b64a-b9ec2bd727cd",
            "total": "654",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid"
          },
          "business": {
            "identifier": "125d26e0-895a-11ea-9b43-0fca3f454941",
            "profile": {
              "name": "Kutch, Champlin and Cole",
              "website": "kuvalis.com",
              "description": "Nulla enim occaecati sunt dolorem modi quia debitis minus. Quam eveniet libero atque doloribus molestiae voluptatem enim. Eum nemo repudiandae repudiandae voluptatem id eaque reprehenderit molestias.",
              "google_place_id": null,
              "phone": "8670721138",
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
                'name': "banner_2.png",
                'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
                'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
              },
            },
            "location": {
              "geo": {
                "identifier": "125e3bd0-895a-11ea-934f-77f81e6ad181",
                "lat": "79.940106",
                "lng": "-16.031526",
                "radius": "50",
              },
              "beacon": {
                "identifier": "125e3bd0-895a-11ea-934f-77f81e6ad181",
                "region_identifier": "125e31b0-895a-11ea-8569-3783ad60a175",
                "major": "2",
                "minor": "3"
              },
              "region": {
                "identifier": "125e31b0-895a-11ea-8569-3783ad60a175",
                "city": "west beatriceburgh",
                "state": "me",
                "zip": "59395",
                "neighborhood": null
              }
            }
          },
          "transaction": {
            "identifier": "125e9600-894a-11ea-8675-d789ybfbd70d",
            "employee_id": null,
            "tax": "393",
            "tip": "0",
            "net_sales": "5242",
            "total": "5635",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-28 14:10:53",
            "updated_at": "2020-04-28 14:10:53",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "dolores",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              },
              {
                "name": "pariatur",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              },
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "2",
                "total": "4000"
              }
            ]
          },
          'issue': {
            'identifier': 'fake_identifier',
            'type': 'wrong_bill',
            'issue': "My bill is not this",
            'resolved': true,
            'warnings_sent': '2',
            'updated_at': '2020-05-21T22:27:59.000000Z'
          }
        },
        {
          "refund": {
            "identifier": "125d10b0-895a-11ea-95db-b1ba0de9dfd1",
            "total": "952",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid",
          },
          "business": {
            "identifier": "12569fc0-895a-11ea-8954-15c72741d7ca",
            "profile": {
              "name": "McClure-Gerhold",
              "website": "huel.org",
              "description": "Omnis aut beatae neque similique veniam numquam sint. Omnis expedita magni quaerat harum ipsum temporibus. Inventore ab sit non vel et quia veniam. Est fugit laborum incidunt natus id sit eius.",
              "google_place_id": null,
              "phone": "4080247291",
              "hours": {
                "monday": "Monday: 11:00 AM – 10:00 PM",
                "tuesday": "Tuesday: 11:00 AM – 10:00 PM",
                "wednesday": "Wednesday: 11:00 AM – 10:00 PM",
                "thursday": "Thursday: 11:00 AM – 10:00 PM",
                "friday": "Friday: 11:00 AM – 10:30 PM",
                "saturday": "Saturday: 11:00 AM – 10:30 PM",
                "sunday": "Sunday: 10:30 AM – 9:00 PM"
              }
            },
            'photos': {
              'logo': {
                'name': "logo_3.png",
                'small_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg",
                'large_url': "https://www.tuesdaytactics.com/htmlemail/images/tt470-2.jpg"
              },
              'banner': {
                'name': "banner_3.png",
                'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
                'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
              },
            },
            "location": {
              "geo": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "lat": "71.699508",
                "lng": "169.164125",
                "radius": "50"
              },
              "beacon": {
                "identifier": "1259ec00-895a-11ea-a2d2-77e4192378c0",
                "region_identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "major": "0",
                "minor": "1"
              },
              "region": {
                "identifier": "1259dd10-895a-11ea-bfe0-f30c4635b3f1",
                "city": "bernardland",
                "state": "in",
                "zip": "27313",
                "neighborhood": null
              }
            }
          },
          "transaction": {
            "identifier": "025aed30-895a-11ea-8f7a-1543da585c00",
            "employee_id": null,
            "tax": "198",
            "tip": "652",
            "net_sales": "2635",
            "total": "3485",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-28 14:10:53",
            "updated_at": "2020-04-28 14:10:53",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "3",
                "total": "6000"
              },
              {
                "name": "ratione",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              }
            ]
          },
          'issue': {
            'identifier': 'fake_identifier',
            'type': 'wrong_bill',
            'issue': "My bill is not this",
            'resolved': true,
            'warnings_sent': '2',
            'updated_at': '2020-05-21T22:27:59.000000Z'
          }
        },
        {
          "refund": {
            "identifier": "125f9f80-895a-11ea-b64a-b9ec2bd727cd",
            "total": "654",
            "created_at": "2020-04-28 14:10:53",
            "status": "refund paid"
          },
          "business": {
            "identifier": "125d26e0-895a-11ea-9b43-0fca3f454941",
            "profile": {
              "name": "Last Business Name",
              "website": "kuvalis.com",
              "description": "Nulla enim occaecati sunt dolorem modi quia debitis minus. Quam eveniet libero atque doloribus molestiae voluptatem enim. Eum nemo repudiandae repudiandae voluptatem id eaque reprehenderit molestias.",
              "google_place_id": null,
              "phone": "8670721138",
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
                'name': "banner_2.png",
                'small_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg",
                'large_url': "https://www.gerardhuerta.com/wp-content/uploads/2016/08/ACDC-1000x650.jpg"
              },
            },
            "location": {
              "geo": {
                "identifier": "125e3bd0-895a-11ea-934f-77f81e6ad181",
                "lat": "79.940106",
                "lng": "-16.031526",
                "radius": "50",
              },
              "beacon": {
                "identifier": "125e3bd0-895a-11ea-934f-77f81e6ad181",
                "region_identifier": "125e31b0-895a-11ea-8569-3783ad60a175",
                "major": "2",
                "minor": "3"
              },
              "region": {
                "identifier": "125e31b0-895a-11ea-8569-3783ad60a175",
                "city": "west beatriceburgh",
                "state": "me",
                "zip": "59395",
                "neighborhood": null
              }
            }
          },
          "transaction": {
            "identifier": "125e9600-895a-1111-8675-d7891bf1d70d",
            "employee_id": null,
            "tax": "393",
            "tip": "0",
            "net_sales": "5242",
            "total": "5635",
            "partial_payment": "0",
            "locked": false,
            "bill_created_at": "2020-04-28 14:10:53",
            "updated_at": "2020-04-28 14:10:53",
            "status": {
              "name": "open",
              "code": "100"
            },
            "purchased_items": [
              {
                "name": "dolores",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              },
              {
                "name": "pariatur",
                "sub_name": null,
                "price": "2000",
                "quantity": "1",
                "total": "2000"
              },
              {
                "name": "sit",
                "sub_name": null,
                "price": "2000",
                "quantity": "2",
                "total": "4000"
              }
            ]
          },
          'issue': {
            'identifier': 'fake_identifier',
            'type': 'wrong_bill',
            'issue': "My bill is not this",
            'resolved': true,
            'warnings_sent': '2',
            'updated_at': '2020-05-21T22:27:59.000000Z'
          }
        }
      ],
      "links": {
        "first": "http://localhost/api/customer/refund?page=1",
        "last": "http://localhost/api/customer/refund?page=2",
        "prev": "http://localhost/api/customer/refund?page=1",
        "next": null,
      },
      "meta": {
        "current_page": "2",
        "from": "15",
        "last_page": "2",
        "path": "http://localhost/api/customer/refund",
        "per_page": "15",
        "to": "20",
        "total": "20",
      }
    };
  }
}