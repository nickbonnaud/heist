import 'package:meta/meta.dart';

@immutable
class Currency {

  static String create({required int cents}) {
    return "\$${(cents / 100).toStringAsFixed(2)}";
  }
}