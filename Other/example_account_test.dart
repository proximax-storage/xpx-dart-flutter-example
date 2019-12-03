import 'package:xpx_chain_sdk/xpx_sdk.dart';

/// Simple Account API request
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

  const hashOne = 'B090128A7D4D2C317B964C6951C0CD7C48899A40C5F936221159A288E4C77B93';
  const hashTwo = 'FF91ABCF52C042A77F0B35BD6E629A0E8932839FC1D23A894B4F8642211A0F21';

  try {
    /// Get a transaction information given a transactionId or hash.
    final result = await client.transaction.getTransaction(hashOne);
    print(result);
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
