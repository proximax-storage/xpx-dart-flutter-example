import 'package:xpx_chain_sdk/xpx_sdk.dart';

const baseUrl = 'http://bctestnet2.brimstone.xpxsirius.io:3000';

const networkType = publicTest;

/// Simple Transactions API request
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

  final deadline = Deadline(hours: 1);

  final addressTwo = Account.fromPrivateKey(
      '5D39DFFB41BB92C5932C29BAB4E1E5AC2C1901784BF008DC937A8A460B925331',
      networkType);

  /// Define the namespaceId and the mosaicId you want to link.
  final namespaceId = NamespaceId.fromName('dartnamespace');
  final mosaicId = MosaicId.fromHex('1CD789616604883F');

  /// Create MosaicAliasTransaction.
  /// note: If you want to unlink the alias, change alias action type to AliasActionType.unlink.
  final mosaicAliasTransaction = MosaicAliasTransaction(
      deadline, mosaicId, namespaceId, AliasActionType.aliasUnlink, networkType);

  final stx = addressTwo.sign(mosaicAliasTransaction, generationHash);

  try {
    final restTx = await client.transaction.announce(stx);
    print(restTx);
    print('HashTxn: ${stx.hash}');
    print('Signer: ${addressTwo.publicKey}');
  } on Exception catch (e) {
    print('Exception when calling Transaction->Announce: $e\n');
  }
}
