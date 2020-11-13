import 'package:xpx_chain_sdk/xpx_sdk.dart';

/// Simple Transactions API request
void main() async {
  const baseUrl = 'http://bctestnet2.brimstone.xpxsirius.io:3000';

  /// Creating a client instance
  /// xpx_chain_sdk uses the Dart's native HttpClient.
  /// Depending on the platform, you may want to use either
  /// the one which comes from dart:io or the BrowserClient
  /// example:
  /// 1- import 'package:http/browser_client.dart';
  /// 2- var client = newClient(config,  BrowserClient());
  final client = SiriusClient.fromUrl(baseUrl, null);

  const hashOne = '2384FB41E7DD15D668EBC56EFA726F7E100AF39025B90B3E04C23E76BED6CB2B';

  try {
    /// Get a transaction information given a transactionId or hash.
    final result = await client.transaction.getTransaction(hashOne);

    final TransferTransaction transfer = result;
    print(transfer.toJson());
//    print(transfer.signer);

  } on Exception catch (e) {
    print('Exception when calling Transaction->GetTransaction: $e\n');
  }

  try {
    /// Get a List of [Transaction] information for a given List of transactionIds.
    final result = await client.transaction.getTransactions([hashOne]);
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
    final result = await client.transaction.getTransactionsStatuses([hashOne]);
    print(result);
  } on Exception catch (e) {
    print('Exception when calling Transaction->getTransactionStatus: $e\n');
  }
}
