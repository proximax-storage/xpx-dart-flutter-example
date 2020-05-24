import 'package:xpx_chain_sdk/xpx_sdk.dart';

/// Simple Transactions API request
void main() async {
  const baseUrl = 'http://bctestnet1.brimstone.xpxsirius.io:3000';

  /// Creating a client instance
  /// xpx_chain_sdk uses the Dart's native HttpClient.
  /// Depending on the platform, you may want to use either
  /// the one which comes from dart:io or the BrowserClient
  /// example:
  /// 1- import 'package:http/browser_client.dart';
  /// 2- var client = newClient(config,  BrowserClient());
  final client = SiriusClient.fromUrl(baseUrl, null);

  final generationHash = await client.generationHash;

  final networkType = await client.networkType;

  /// Create an Account from a given Private key.
  final account = Account.fromPrivateKey(
      '5D39DFFB41BB92C5932C29BAB4E1E5AC2C1901784BF008DC937A8A460B925331',
      networkType);

  /// Create a Mosaic definition transaction.
  final mosaicDefinition = MosaicDefinitionTransaction(
      // The maximum amount of time to include the transaction in the blockchain.
      Deadline(hours: 1),
      mosaicNonce(),
      account.publicAccount.publicKey,
      MosaicProperties(true, true, 4, Uint64.zero),
      // The network type
      networkType);

  final stx = account.sign(mosaicDefinition, generationHash);

  try {
    final restTx = await client.transaction.announce(stx);
    print(restTx);
    print('Signer: ${account.publicAccount.publicKey}');
    print('HashTxn: ${stx.hash}');
  } on Exception catch (e) {
    print('Exception when calling Transaction->Announce: $e\n');
  }
}
