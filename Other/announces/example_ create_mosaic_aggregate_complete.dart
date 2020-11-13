import 'package:xpx_chain_sdk/xpx_sdk.dart';

/// Simple Account API AnnounceTransaction
void main() async {
  const baseUrl = 'http://bcstage1.xpxsirius.io:3000';

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
  final account =
      Account.fromPrivateKey('63485A29E5D1AA15696095DCE792AACD014B85CBC8E473803406DEE20EC71951', networkType);

  final deadline = Deadline(hours: 1);

  /// Create a Mosaic definition transaction.
  final mosaicDefinition = MosaicDefinitionTransaction(
      // The maximum amount of time to include the transaction in the blockchain.
      Deadline(hours: 1),
      mosaicNonce(),
      account.publicAccount.publicKey,
      MosaicProperties(true, true, 6, Uint64.zero),
      // The network type
      networkType);

  mosaicDefinition.toAggregate = account.publicAccount;

  /// Create a Mosaic Supply Change transaction.
  final mosaicSupplyChange = MosaicSupplyChangeTransaction(
      // The maximum amount of time to include the transaction in the blockchain.
      Deadline(hours: 1),
      increase,
      mosaicDefinition.mosaicId,
      Uint64(100000000000),
      // The network type
      networkType);

  mosaicSupplyChange.toAggregate = account.publicAccount;

  print(mosaicDefinition.mosaicId);

  // Create Aggregate complete transaction.
  final aggregateTransaction =
      AggregateTransaction.complete(deadline, [mosaicDefinition, mosaicSupplyChange], networkType);

  final stx = account.sign(aggregateTransaction, generationHash);

  try {
    final restTx = await client.transaction.announce(stx);
    print(restTx);
    print('Signer: ${account.publicAccount.publicKey}');
    print('HashTxn: ${stx.hash}');
  } on Exception catch (e) {
    print('Exception when calling Transaction->Announce: $e\n');
  }
}
