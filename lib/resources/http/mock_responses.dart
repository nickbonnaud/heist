

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
    } else if (options.path.endsWith('account/fake_identifier')) {
      return _mockUpdateAccount();
    }
  }

  static Map<String, dynamic> _mockPostPhoto() {
    return {
      'data': {
        'name': 'fake_avatar.png',
        'small_url': 'https://moresmilesdentalclinic.com/wp-content/uploads/2017/09/bigstock-profile-of-male-geek-smiling-w-35555741-250x250-1.jpg',
        'large_url': 'https://corporate-rebels.com/CDN/378-500x500.jpg'
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
  
  static Map<String, dynamic> _mockRegister(RequestOptions options) {
    return {
      'data': {
        'customer': {
          'identifier': 'fake_identifier',
          'email': 'options.data.email',
          'token': "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9sb2NhbGhvc3RcL2FwaVwvY3VzdG9tZXJcL21lIiwiaWF0IjoxNTgyMTM2NDk0LCJleHAiOjE1OTc5MDQ0OTUsIm5iZiI6MTU4MjEzNjQ5NSwianRpIjoiQVZYUnhNOVBsUnNuZDFqRSIsInN1YiI6MSwicHJ2IjoiZGE5YzU1NjBkZTE2MTUzYmE4MTgwYzU4OTNmZDc0OTRhZDU4YWY5ZSJ9._qGQeHTjiT90MT-zV3XOoA154XzOruP8HmwcnS4tNwk",
          'profile': null,
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
        'first_name': 'fake_name',
        'last_name': 'fake last',
        'photos': {
          'name': 'fake-profile.png',
          'small_url': 'https://upload.wikimedia.org/wikipedia/commons/4/46/Gabrielpalatch-headshot-500x500.png',
          'large_url': 'https://cdn2.pauldavis.info/wp-content/uploads/sites/878/2019/02/26174944/Nate-Headshot-250x250.jpg'
        }
      }
    };
  }

  static Map<String, dynamic> _mockFetchCustomer() {
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
      "data": {
        'identifier': 'fake_identifier',
        'tip_rate': '15',
        'quick_tip_rate': '7',
        'primary': 'ach'
      }
    };
  }

  static Map<String, dynamic> _mockFetchPaidTransactions() {
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
            "locked": "1",
            "bill_created_at": "2020-04-08 18:46:25",
            "updated_at": "2020-04-08 18:46:25",
            "status": "open",
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
          "refund": []
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
            "locked": "1",
            "bill_created_at": "2020-04-08 18:46:25",
            "updated_at": "2020-04-08 18:46:25",
            "status": "open",
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
          "refund": []
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
            "locked": "1",
            "bill_created_at": "2020-04-08 18:46:25",
            "updated_at": "2020-04-08 18:46:25",
            "status": "open",
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
          "refund": []
        }
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
        "to": 3,
        "total": 3,
      }
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
}