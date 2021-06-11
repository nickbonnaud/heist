import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/models/paginated_api_response.dart';
import 'package:heist/providers/business_provider.dart';
import 'package:heist/repositories/business_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';

class MockBusinessProvider extends Mock implements BusinessProvider {}

void main() {
  group("Business Repository Tests", () {
    late BusinessRepository businessRepository;
    late BusinessProvider mockBusinessProvider;
    late BusinessRepository businessRepositoryWithMock;

    setUp(() {
      businessRepository = BusinessRepository(businessProvider: BusinessProvider());
      
      mockBusinessProvider = MockBusinessProvider();
      when(() => mockBusinessProvider.fetch(query: any(named: "query")))
        .thenAnswer((_) async => PaginatedApiResponse(body: [], isOK: false));
      
      businessRepositoryWithMock = BusinessRepository(businessProvider: mockBusinessProvider);
    });

    test("Business Repository can fetch Businesses by name", () async {
      var paginateData = await businessRepository.fetchByName(name: "name");
      expect(paginateData, isA<PaginateDataHolder>());
      expect(paginateData.data, isA<List<Business>>());
      expect(paginateData.data.isNotEmpty, true);
    });

    test("Fetch Businesses by name on fail throws error", () async {
      expect(
        businessRepositoryWithMock.fetchByName(name: "name"),
        throwsA(isA<ApiException>())
      );
    });

    test("Business Repository can fetch Businesses by identifier", () async {
      var paginateData = await businessRepository.fetchByIdentifier(identifier: "identifier");
      expect(paginateData, isA<PaginateDataHolder>());
      expect(paginateData.data, isA<List<Business>>());
      expect(paginateData.data.isNotEmpty, true);
    });

    test("Fetch Businesses by identifier on fail throws error", () async {
      expect(
        businessRepositoryWithMock.fetchByName(name: "name"),
        throwsA(isA<ApiException>())
      );
    });

    test("Business Repository can fetch Businesses by beacon identifier", () async {
      var paginateData = await businessRepository.fetchByBeaconIdentifier(identifier: "identifier");
      expect(paginateData, isA<PaginateDataHolder>());
      expect(paginateData.data, isA<List<Business>>());
      expect(paginateData.data.isNotEmpty, true);
    });

    test("Fetch Businesses by beacon identifier on fail throws error", () async {
      expect(
        businessRepositoryWithMock.fetchByBeaconIdentifier(identifier: "identifier"),
        throwsA(isA<ApiException>())
      );
    });
  });
}