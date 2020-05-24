import 'package:xpx_chain_sdk/xpx_sdk.dart';

/// Simple Account API AnnounceTransaction
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

  const networkType = publicTest;

  final accountTwo = Account.fromPrivateKey(
      '29CF06338133DEE64FC49BCB19C8936916DBE8DC461CE489BF9588BE3B9670B5',
      networkType);

  try {
    final result = await client.account
        .aggregateBondedTransactions(accountTwo.publicAccount);

    for (final txn in result) {
      final d = CosignatureTransaction(txn);

      final signedTransaction = accountTwo.signCosignatureTransaction(d);

      try {
        final restTx = await client.transaction
            .announceAggregateBondedCosignature(signedTransaction);
        print(restTx);
        print('Signer: ${accountTwo.publicKey}');
        print('HashTxn: ${signedTransaction.hash}');
      } on Exception catch (e) {
        print('Exception when calling Transaction->Announce: $e\n');
      }
    }
  } on Exception catch (e) {
    print('Exception when calling Account->GetAccountInfo: $e\n');
  }
}
