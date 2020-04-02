

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
    } else if (options.path.endsWith('avatar/fake_identifier')) {
      return _mockPostPhoto();
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
          'status': {
            'name': 'Profile Account Incomplete',
            'code': "100"
          }
        }
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