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
      '68f50e10e5b8be2b7e9ddb687a667d6e94dd55fe02b4aed8195f51f9a242558c',
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
