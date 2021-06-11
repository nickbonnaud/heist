import 'package:flutter/material.dart';
import 'package:heist/models/api_response.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/models/paginated_api_response.dart';
import 'package:heist/resources/helpers/api_exception.dart';

abstract class BaseRepository {
  
  dynamic deserialize({PaginateDataHolder? holder, Map<String, dynamic>? json});
  
  Future<Map<String, dynamic>> send({required Future<ApiResponse> request}) async {
    return request.then((response) {
      if (response.isOK) return response.body;
      throw ApiException(error: response.error); 
    });
  }
  
  Future<PaginateDataHolder> sendPaginated({required Future<PaginatedApiResponse> request}) async {
    return request.then((response) {
      if (response.isOK) return _handleSuccess(response: response);
      throw ApiException(error: response.error); 
    });
  }

  String formatQuery({required String baseQuery, DateTimeRange? dateRange}) {
    return "?$baseQuery${formatDateQuery(dateRange: dateRange)}";
  }
  
  String formatDateQuery({DateTimeRange? dateRange}) {
    return dateRange != null
      ? "?date[]=${Uri.encodeQueryComponent(dateRange.start.toIso8601String())}&date[]=${Uri.encodeQueryComponent(dateRange.end.toIso8601String())}"
      : "";
  }
  
  PaginateDataHolder _handleSuccess({required PaginatedApiResponse response}) {
    return PaginateDataHolder(data: response.body, next: response.next);
  }
}