import 'dart:async';

class Validators{
  final validateaccountName = StreamTransformer<String, String>.fromHandlers(
      handleData: (accountName, sink) {
    RegExp('[a-zA-Z]').hasMatch(accountName)
        ? sink.add(accountName)
        : sink.addError('Enter a valid Name');
  });

  final validateaccountAddress = StreamTransformer<String, String>.fromHandlers(
      handleData: (accountAddress, sink) {
    //1st Regular Expression to Validate Credit Card Number
    RegExp(r'^(?:4[0-9]{12}(?:[0-9]{3})?|[25][1-7][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\d{3})\d{11})$')
            //2nd Regular Expression to remove white spaces
            .hasMatch(accountAddress.replaceAll(RegExp(r'\s+\b|\b\s'), ''))
        ? sink.add(accountAddress)
        : sink.addError('Enter a valid card number');
  });

  final validatexpxBalance = StreamTransformer<String, String>.fromHandlers(
      handleData: (xpxBalance, sink) {
    if (xpxBalance.isNotEmpty &&
        int.parse(xpxBalance) > 0 &&
        int.parse(xpxBalance) < 13) {
      sink.add(xpxBalance);
    } else {
      sink.addError('Err month');
    }
  });

  final validateusdBalance = StreamTransformer<String, String>.fromHandlers(
      handleData: (usdBalance, sink) {
    if (usdBalance.isNotEmpty &&
        int.parse(usdBalance) > 2000 &&
        int.parse(usdBalance) < 2028) {
      sink.add(usdBalance);
    } else {
      sink.addError('Invalid Year');
    }
  });

  final validateCardVerificationValue =
      StreamTransformer<String, String>.fromHandlers(
          handleData: (cardCvv, sink) {
    if (cardCvv.length > 2) {
      sink.add(cardCvv);
    } else {
      sink.addError('Invalid cvv');
    }
  });
}