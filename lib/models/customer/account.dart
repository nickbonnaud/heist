import 'package:equatable/equatable.dart';

class Account extends Equatable {
  final String identifier;
  final int tipRate;
  final int quickTipRate;
  final String primary;
  final String error;

  Account({this.identifier, this.tipRate, this.quickTipRate, this.primary, this.error});

  Account.fromJson(Map<String, dynamic> json)
    : identifier = json['identifier'],
      tipRate = int.parse(json['tip_rate']),
      quickTipRate = int.parse(json['quick_tip_rate']),
      primary = json['primary'],
      error = '';

  Account.withError(String error)
    : identifier = null,
      tipRate = null,
      quickTipRate = null,
      primary = null,
      error = error;

  Account update({
    String identifier,
    int tipRate,
    int quickTipRate,
    String primary,
    String error
  }) {
    return _copyWith(
      identifier: identifier,
      tipRate: tipRate,
      quickTipRate: quickTipRate,
      primary: primary,
      error: error
    );
  }

  Account _copyWith({
    String identifier,
    int tipRate,
    int quickTipRate,
    String primary,
    String error
  }) {
    return Account(
      identifier: identifier ?? this.identifier,
      tipRate: tipRate ?? this.tipRate,
      quickTipRate: quickTipRate ?? this.quickTipRate,
      primary: primary ?? this.primary,
      error: error ?? this.error
    );
  }

  @override
  List<Object> get props => [identifier, tipRate, quickTipRate, primary, error];

  @override
  String toString() => 'Account { identifier: $identifier, tipRate: $tipRate, quickTipRate: $quickTipRate, primary: $primary, error: $error }';
}