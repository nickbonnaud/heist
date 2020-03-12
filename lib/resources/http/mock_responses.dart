

import 'package:dio/dio.dart';

class MockResponses {
  
  static Map<String, dynamic> mockResponse(RequestOptions options) {
    if (options.path.endsWith("auth/register")) {
      return _mockRegister(options);
    } else if (options.path.endsWith("auth/login")) {
      return _mockLogin(options);
    }
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
}