import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/global_widgets/search_business_name_modal/bloc/search_business_name_bloc.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/repositories/business_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:mocktail/mocktail.dart';

class MockBusinessRepository extends Mock implements BusinessRepository {}
class MockBusiness extends Mock implements Business {}

void main() {
  group("Search Business Name Modal Tests", () {
    late BusinessRepository businessRepository;
    late SearchBusinessNameBloc searchBusinessNameBloc;

    late SearchBusinessNameState _baseState;
    late List<Business> _businesses;

    setUp(() {
      businessRepository = MockBusinessRepository();
      searchBusinessNameBloc = SearchBusinessNameBloc(businessRepository: businessRepository);

      _baseState = searchBusinessNameBloc.state;
    });

    tearDown(() {
      searchBusinessNameBloc.close();
    });

    test("Initial state of SearchBusinessNameBloc is SearchBusinessNameState.initial()", () {
      expect(searchBusinessNameBloc.state, SearchBusinessNameState.initial());
    });

    blocTest<SearchBusinessNameBloc, SearchBusinessNameState>(
      "SearchBusinessNameBloc BusinessNameChanged event changes state: [isSubmitting: true], [isSubmitting: false, businesses: List<Businesses>]",
      build: () {
        _businesses = List<Business>.generate(4, (index) => MockBusiness());

        when(() => businessRepository.fetchByName(name: any(named: "name")))
          .thenAnswer((_) async => PaginateDataHolder(data: _businesses));

        return searchBusinessNameBloc;
      },
      wait: Duration(milliseconds: 500),
      act: (bloc) => bloc.add(BusinessNameChanged(name: "name")),
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, businesses: _businesses)]
    );

    blocTest<SearchBusinessNameBloc, SearchBusinessNameState>(
      "SearchBusinessNameBloc BusinessNameChanged event empty name changes state: [isSubmitting: false, businesses: null, errorMessage: ""]",
      build: () {
        _businesses = List<Business>.generate(4, (index) => MockBusiness());

        when(() => businessRepository.fetchByName(name: any(named: "name")))
          .thenAnswer((_) async => PaginateDataHolder(data: _businesses));

        return searchBusinessNameBloc;
      },
      seed: () => _baseState.update(isSubmitting: true, businesses: List<Business>.generate(3, (index) => MockBusiness()), errorMessage: "error"),
      wait: Duration(milliseconds: 500),
      act: (bloc) => bloc.add(BusinessNameChanged(name: "")),
      expect: () => [_baseState.update(isSubmitting: false, businesses: null, errorMessage: "")]
    );

    blocTest<SearchBusinessNameBloc, SearchBusinessNameState>(
      "SearchBusinessNameBloc BusinessNameChanged event empty name does not call businessRepository",
      build: () {
        _businesses = List<Business>.generate(4, (index) => MockBusiness());

        when(() => businessRepository.fetchByName(name: any(named: "name")))
          .thenAnswer((_) async => PaginateDataHolder(data: _businesses));

        return searchBusinessNameBloc;
      },
      seed: () => _baseState.update(isSubmitting: true, businesses: List<Business>.generate(3, (index) => MockBusiness()), errorMessage: "error"),
      wait: Duration(milliseconds: 500),
      act: (bloc) => bloc.add(BusinessNameChanged(name: "")),
      verify: ((_) {
        verifyNever(() => businessRepository.fetchByName(name: any(named: "name")));
      })
    );

    blocTest<SearchBusinessNameBloc, SearchBusinessNameState>(
      "SearchBusinessNameBloc BusinessNameChanged event calls businessRepository",
      build: () {
        _businesses = List<Business>.generate(4, (index) => MockBusiness());

        when(() => businessRepository.fetchByName(name: any(named: "name")))
          .thenAnswer((_) async => PaginateDataHolder(data: _businesses));

        return searchBusinessNameBloc;
      },
      wait: Duration(milliseconds: 500),
      act: (bloc) => bloc.add(BusinessNameChanged(name: "name")),
      verify: ((_) {
        verify(() => businessRepository.fetchByName(name: any(named: "name"))).called(1);
      })
    );

    blocTest<SearchBusinessNameBloc, SearchBusinessNameState>(
      "SearchBusinessNameBloc BusinessNameChanged event on error changes state: [isSubmitting: true], [isSubmitting: false, errorMessage: error]",
      build: () {

        when(() => businessRepository.fetchByName(name: any(named: "name")))
          .thenThrow(ApiException(error: "error"));

        return searchBusinessNameBloc;
      },
      wait: Duration(milliseconds: 500),
      act: (bloc) => bloc.add(BusinessNameChanged(name: "name")),
      expect: () => [_baseState.update(isSubmitting: true), _baseState.update(isSubmitting: false, errorMessage: "error")]
    );

    blocTest<SearchBusinessNameBloc, SearchBusinessNameState>(
      "SearchBusinessNameBloc Reset event changes state: [isSubmitting: false, businesses: null, errorMessage: ""]",
      build: () {
        return searchBusinessNameBloc;
      },
      seed: () => _baseState.update(isSubmitting: true, businesses: List<Business>.generate(3, (index) => MockBusiness()), errorMessage: "error"),
      act: (bloc) => bloc.add(Reset()),
      expect: () => [_baseState.update(isSubmitting: false, businesses: null, errorMessage: "")]
    );
  });
}