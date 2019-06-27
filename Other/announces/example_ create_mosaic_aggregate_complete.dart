import 'package:xpx_chain_sdk/xpx_sdk.dart';

const baseUrl = 'http://bctestnet1.xpxsirius.io:3000';

const networkType = publicTest;

/// Simple Account API AnnounceTransaction
void main() async {
  final config = Config(baseUrl, networkType);

  final client = ApiClient.fromConf(config, null);

  /// Create an Account from a given Private key.
  final account = Account.fromPrivateKey(
      '52BFDA0BDC6456ECAF78B8D2046A8ECB1D951B5BB95EE37165627959DD7C029E',
      networkType);

  print(account);

  final deadline = Deadline(hours: 1);

  /// Create a Mosaic definition transaction.
  final mosaicDefinition = MosaicDefinitionTransaction(
      // The maximum amount of time to include the transaction in the blockchain.
      Deadline(hours: 1),
      mosaicNonce(),
      account.publicAccount.publicKey,
      MosaicProperties(true, true, true, 4, BigInt.from(1000)),
      BigInt.from(1000),
      // The network type
      networkType);

  /// Create a Mosaic Supply Change transaction.
  final mosaicSupplyChange = MosaicSupplyChangeTransaction(
      // The maximum amount of time to include the transaction in the blockchain.
      Deadline(hours: 1),
      increase,
      mosaicDefinition.mosaicId,
      BigInt.from(10000),
      // The network type
      networkType);

  mosaicDefinition.toAggregate = account.publicAccount;
  mosaicSupplyChange.toAggregate = account.publicAccount;

  // Create Aggregate complete transaction.
  final aggregateTransaction = AggregateTransaction(
      deadline, [mosaicDefinition, mosaicSupplyChange], networkType);

  final stx = account.sign(aggregateTransaction);

  final restTx = await client.transaction.announceTransaction(stx);
  print(restTx);
  print('Hash: ${stx.hash}');
  print('Signer: ${account.publicAccount.publicKey}');
}
