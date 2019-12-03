import 'package:xpx_chain_sdk/xpx_sdk.dart';

const baseUrl = 'http://bctestnet2.brimstone.xpxsirius.io:3000';

const networkType = publicTest;

/// Simple Account API AnnounceTransaction
void main() async {

  /// Creating a client instance
  /// xpx_chain_sdk uses the Dart's native HttpClient.
  /// Depending on the platform, you may want to use either
  /// the one which comes from dart:io or the BrowserClient
  /// example:
  /// 1- import 'package:http/browser_client.dart';
  /// 2- var client = newClient(config,  BrowserClient());
  final client = SiriusClient.fromUrl(baseUrl, null);

  final generationHash = await client.generationHash;

  /// Create an Account from a given Private key.
  final account = Account.fromPrivateKey(
      '5D39DFFB41BB92C5932C29BAB4E1E5AC2C1901784BF008DC937A8A460B925331',
      networkType);

  final deadline =  Deadline(hours: 1);

  /// Create a Mosaic definition transaction.
  final mosaicDefinition = MosaicDefinitionTransaction(
    // The maximum amount of time to include the transaction in the blockchain.
      Deadline(hours: 1),
      mosaicNonce(),
      account.publicAccount.publicKey,
      MosaicProperties(true, true, 4, BigInt.from(0)),
      // The network type
      networkType);

  mosaicDefinition.toAggregate = account.publicAccount;

  /// Create a Mosaic Supply Change transaction.
  final mosaicSupplyChange = MosaicSupplyChangeTransaction(
    // The maximum amount of time to include the transaction in the blockchain.
      Deadline(hours: 1),
      increase,
      mosaicDefinition.mosaicId,
      BigInt.from(100000000000),
      // The network type
      networkType);

  mosaicSupplyChange.toAggregate = account.publicAccount;

  print(mosaicDefinition.mosaicId);

  // Create Aggregate complete transaction.
  final aggregateTransaction = AggregateTransaction.complete(
      deadline, [mosaicDefinition, mosaicSupplyChange], networkType);

  final stx = account.sign(aggregateTransaction, generationHash);

  try {
    final restTx = await client.transaction.announce(stx);
    print(restTx);
    print('Hash: ${stx.hash}');
    print('Signer: ${account.publicAccount.publicKey}');
  } on Exception catch (e) {
    print('Exception when calling Transaction->Announce: $e\n');
  }
}
