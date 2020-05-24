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

  final deadline = Deadline(hours: 1);

  final addressTwo = Account.fromPrivateKey(
      '5D3E959EB0CD69CC1DB6E9C62CB81EC52747AB56FA740CF18AACB5003429AD2E',
      networkType);

  /// Define the namespaceId and the mosaicId you want to link.
  final namespaceId = NamespaceId.fromName('dartnamespace');

  final address =
      Address.fromRawAddress('VC4A3Z6ALFGJPYAGDK2CNE2JAXOMQKILYBVNLQFS');

  /// Create AddressAliasTransaction.
  /// note: If you want to unlink the alias, change alias action type to AliasActionType.aliasUnlink.
  final mosaicAliasTransaction = AddressAliasTransaction(
      deadline, address, namespaceId, AliasActionType.aliasUnlink, networkType);

  final stx = addressTwo.sign(mosaicAliasTransaction, generationHash);

  try {
    final restTx = await client.transaction.announce(stx);
    print(restTx);
    print('Signer: ${addressTwo.publicKey}');
    print('HashTxn: ${stx.hash}');
  } on Exception catch (e) {
    print('Exception when calling Transaction->Announce: $e\n');
  }
}
