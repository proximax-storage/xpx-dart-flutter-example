import 'package:xpx_chain_sdk/xpx_sdk.dart';

/// Simple Account API request
void main() async {
  const baseUrl = 'http://bctestnet1.xpxsirius.io:3000';

  const networkType = publicTest;

  final config = Config(baseUrl, networkType);

  /// Creating a client instance
  /// xpx_chain_sdk uses the Dart's native HttpClient.
  /// Depending on the platform, you may want to use either
  /// the one which comes from dart:io or the BrowserClient
  /// example:
  /// 1- import 'package:http/browser_client.dart';
  /// 2- var client = newClient(config,  BrowserClient());
  final client = ApiClient.fromConf(config, null);

  final addressTwo = Account.fromPrivateKey(
      '1ACE45EAD3C2F0811D9F4355F35BF78483324975083BE4E503EA49DFFEA691A0',
      networkType);

  try {
    final result = await client.account
        .aggregateBondedTransactions(addressTwo.publicAccount);

    for (final txn in result) {
      final d = CosignatureTransaction(txn);

      final signedTransaction = addressTwo.signCosignatureTransaction(d);

      final restTx = await client.transaction
          .announceAggregateBondedCosignature(signedTransaction);
      print(restTx);
      print('HashTxn: ${signedTransaction.hash}');
      print('Signer: ${addressTwo.publicKey}');
    }
  } on Exception catch (e) {
    print('Exception when calling Account->GetAccountInfo: $e\n');
  }
}
