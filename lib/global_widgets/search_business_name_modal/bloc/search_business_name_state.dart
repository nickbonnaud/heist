part of 'search_business_name_bloc.dart';

@immutable
class SearchBusinessNameState extends Equatable {
  final bool isSubmitting;
  final List<Business>? businesses;
  final String errorMessage;

  const SearchBusinessNameState({
    required this.isSubmitting,
    this.businesses,
    required this.errorMessage
  });

  factory SearchBusinessNameState.initial() {
    return SearchBusinessNameState(
      isSubmitting: false,
      businesses: null,
      errorMessage: ""
    );
  }

  SearchBusinessNameState update({
    bool? isSubmitting,
    List<Business>? businesses,
    String? errorMessage,
    bool resetBusinesses: false,
  }) => SearchBusinessNameState(
    isSubmitting: isSubmitting ?? this.isSubmitting,
    businesses: resetBusinesses ? null : businesses ?? this.businesses,
    errorMessage: errorMessage ?? this.errorMessage
  );

  @override
  List<Object?> get props => [isSubmitting, businesses, errorMessage];

  @override
  String toString() => "SearchBusinessNameState { isSubmitting: $isSubmitting, businesses: $businesses, errorMessage: $errorMessage }";
}
