import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class PaginateDataHolder extends Equatable {
  final List<dynamic> data;
  final String? next;

  PaginateDataHolder({required this.data, this.next});

  PaginateDataHolder update({required List<dynamic> data}) {
    return PaginateDataHolder(data: data, next: this.next);
  }

  @override
  List<Object?> get props => [data, next];

  @override
  String toString() => '''PaginateDataHolder { data: $data, next: $next }''';
}