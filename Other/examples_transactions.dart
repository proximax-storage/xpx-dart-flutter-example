import 'package:xpx_chain_sdk/xpx_sdk.dart';

/// Simple Transactions API request
void main() async {
  const baseUrl = 'http://bctestnet3.brimstone.xpxsirius.io:3000';

  /// Creating a client instance
  /// xpx_chain_sdk uses the Dart's native HttpClient.
  /// Depending on the platform, you may want to use either
  /// the one which comes from dart:io or the BrowserClient
  /// example:
  /// 1- import 'package:http/browser_client.dart';
  /// 2- var client = newClient(config,  BrowserClient());
  final client = SiriusClient.fromUrl(baseUrl, null);

  const hashOne = '2975066EE949F1C5BE008625E74BF71F9F62E39382FEF73F5371B86879008EF5';
  const hashTwo = 'FF91ABCF52C042A77F0B35BD6E629A0E8932839FC1D23A894B4F8642211A0F21';

  try {
    /// Get a transaction information given a transactionId or hash.
    final result = await client.transaction.getTransaction(hashOne);
    print(result.toJson());
  } on Exception catch (e) {
    print('Exception when calling Transaction->GetTransaction: $e\n');
  }

  try {
    /// Get a List of [Transaction] information for a given List of transactionIds.
    final result = await client.transaction.getTransactions([hashOne,hashTwo]);
    print(result);
  } on Exception catch (e) {
    print('Exception when calling Transaction->GetTransactions: $e\n');
  }

  try {
    /// Get the transaction status for a given hash.
    final result = await client.transaction.getTransactionStatus(hashOne);
    print(result);
  } on Exception catch (e) {
    print('Exception when calling Transaction->getTransactionStatus: $e\n');
  }

  try {
    /// Get transactions status.
    final result = await client.transaction.getTransactionsStatuses([hashOne,hashTwo]);
    print(result);
  } on Exception catch (e) {
    print('Exception when calling Transaction->getTransactionStatus: $e\n');
  }
}

