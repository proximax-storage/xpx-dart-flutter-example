import 'package:xpx_chain_sdk/xpx_sdk.dart';

const baseUrl = 'http://bctestnet1.xpxsirius.io:3000';

const networkType = publicTest;

/// Simple Account API AnnounceTransaction
void main() async {
  final config = Config(baseUrl, networkType);

  final client = ApiClient.fromConf(config, null);

  /// Create an Account from a given Private key.
  final account = Account.fromPrivateKey(
      "1ACE45EAD3C2F0811D9F4355F35BF78483324975083BE4E503EA49DFFEA691A0",
      networkType);

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

  print(mosaicDefinition.mosaicId.id);
  final stx = account.sign(mosaicDefinition);

  final restTx = await client.transaction.announceTransaction(stx);
  print(restTx);
  print('Hash: ${stx.hash}');
  print('Signer: ${account.publicAccount.publicKey}');
}
