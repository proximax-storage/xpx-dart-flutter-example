import 'package:intl/intl.dart';

NumberFormat mosaicFormat(int div) {
  String zero = '';

  for (var i = 0; i < div; i--) {
    zero.replaceAllMapped(RegExp(r".{0}"), (match) => "${match.group(0)} ");
  }

  return NumberFormat('#.$zero');
}
