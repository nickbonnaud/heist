import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum PrimaryType {
  ach,
  credit,
  unknown
}

@immutable
class Account extends Equatable {
  final String identifier;
  final int tipRate;
  final int quickTipRate;
  final PrimaryType primary;

  Account({
    required this.identifier,
    required this.tipRate,
    required this.quickTipRate,
    required this.primary
  });

  String get primaryToString => primary.toString().substring(primary.toString().indexOf('.') + 1).toLowerCase();

  Account.fromJson({required Map<String, dynamic> json})
    : identifier = json['identifier'],
      tipRate = json['tip_rate'],
      quickTipRate = json['quick_tip_rate'],
      primary = _stringToPrimaryType(primaryTypeString: json['primary']);

  Account.empty()
    : identifier = "",
      tipRate = 20,
      quickTipRate = 15,
      primary = PrimaryType.unknown;

  Account update({
    int? tipRate,
    int? quickTipRate,
    PrimaryType? primary,
  }) => Account(
    identifier: this.identifier,
    tipRate: tipRate ?? this.tipRate,
    quickTipRate: quickTipRate ?? this.quickTipRate,
    primary: primary ?? this.primary,
  );

  static PrimaryType _stringToPrimaryType({required String primaryTypeString}) {
    return PrimaryType.values.firstWhere((primaryType) {
      return primaryType.toString().substring(primaryType.toString().indexOf('.') + 1).toLowerCase() == primaryTypeString.toLowerCase();
    });
  }

  @override
  List<Object> get props => [identifier, tipRate, quickTipRate, primary];

  @override
  String toString() => 'Account { identifier: $identifier, tipRate: $tipRate, quickTipRate: $quickTipRate, primary: $primary }';
}