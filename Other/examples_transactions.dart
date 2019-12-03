import 'package:xpx_chain_sdk/xpx_sdk.dart';

/// Simple Transactions API request
void main() async {
  const baseUrl = 'http://bctestnet2.brimstone.xpxsirius.io:3000';

  const networkType = publicTest;

  /// Creating a client instance
  /// xpx_chain_sdk uses the Dart's native HttpClient.
  /// Depending on the platform, you may want to use either
  /// the one which comes from dart:io or the BrowserClient
  /// example:
  /// 1- import 'package:http/browser_client.dart';
  /// 2- var client = newClient(config,  BrowserClient());
  final client = SiriusClient.fromUrl(baseUrl, null);

  /// Returns transaction information given a transactionId or hash.
  const hash1 = 'FA76AE792C25838A3B025A5883E287BC2A24AABA76832E5CC209F3E27DC816A1';
  const hash2 = '07CC9EAB83D182AE036B1FADD5EE4A343E2CBFD965784D4CB28B6A9B6C582508';

  try {
    final result = await client.transaction.getTransaction(hash1);
    print(result);
  } on Exception catch (e) {
    print('Exception when calling Transaction->GetTransaction: $e\n');
  }

  /// Returns transaction information given a TransactionIds object.
  try {
    final result = await client.transaction.getTransactionsStatuses([hash1, hash2]);
    print(result);
  } on Exception catch (e) {
    print('Exception when calling Transaction->GetTransactionsStatuses: $e\n');
  }
}
