import 'package:xpx_chain_sdk/xpx_sdk.dart';

const baseUrl = 'http://bctestnet1.xpxsirius.io:3000';

const networkType = publicTest;

/// Simple Account API request
void main() async {
  final config =  Config(baseUrl, networkType);

  /// Creating a client instance
  /// xpx_chain_sdk uses the Dart's native HttpClient.
  /// Depending on the platform, you may want to use either
  /// the one which comes from dart:io or the BrowserClient
  /// example:
  /// 1- import 'package:http/browser_client.dart';
  /// 2- var client = ApiClient.fromConf(config,  BrowserClient());
  final client = ApiClient.fromConf(config, null);

  final hashOne = 'D5671C2872419DCD7700DCC06E71273A3CBA61F08F9DCE86EBBFF8C2C7B8F45A';
  final hashTwo = 'FF91ABCF52C042A77F0B35BD6E629A0E8932839FC1D23A894B4F8642211A0F21';

  try {
    /// Get a transaction information given a transactionId or hash.
    var result = await client.transaction.getTransaction(hashOne);
    print(result);
  } catch (e) {
    print('Exception when calling Transaction->GetTransaction: $e\n');
  }

  final hashs =  TransactionIds();
  hashs.transactionIds.add(hashOne);
  hashs.transactionIds.add(hashTwo);

  try {
    /// Get a List of [Transaction] information for a given List of transactionIds.
    final result = await client.transaction.getTransactions(hashs);
    print(result);
  } catch (e) {
    print('Exception when calling Transaction->GetTransactions: $e\n');
  }

  try {
    /// Get the transaction status for a given hash.
    final result = await client.transaction.getTransactionStatus(hashOne);
    print(result);
  } catch (e) {
    print('Exception when calling Transaction->getTransactionStatus: $e\n');
  }
}
