import 'package:xpx_chain_sdk/xpx_sdk.dart';

/// Simple Transactions API request
void main() async {

  const baseUrl = 'http://bctestnet1.xpxsirius.io:3000';

  final networkType = publicTest;

  final config =  Config(baseUrl, networkType);

  /// Creating a client instance
  /// xpx_chain_sdk uses the Dart's native HttpClient.
  /// Depending on the platform, you may want to use either
  /// the one which comes from dart:io or the BrowserClient
  /// example:
  /// 1- import 'package:http/browser_client.dart';
  /// 2- var client = NewClient(config,  BrowserClient());
  final client = ApiClient.fromConf(config, null);

  /// Returns transaction information given a transactionId or hash.
  var hash = 'A19FCEBC0EDC3A862E81640B410EFAF2F67D8F22E43350EC9F03BFA35544ABB3';

  try {
    final result = await client.transaction.getTransaction(hash);
    print(result);
  } catch (e) {
    print('Exception when calling Transaction->GetTransaction: $e\n');
  }

  /// Returns transaction information given a TransactionIds object.
  List<String> hashes =  [];
  hashes.add("07CC9EAB83D182AE036B1FADD5EE4A343E2CBFD965784D4CB28B6A9B6C582508");
  hashes.add("D72B60D83EAADC82764E700799E65DF19190B5FE36DF28512B7D8F2ED1CC147C");

  try {
    final result = await client.transaction.getTransactionsStatuses(hashes);
    print(result);
  } catch (e) {
    print("Exception when calling Transaction->GetTransactions: $e\n");
  }
}
