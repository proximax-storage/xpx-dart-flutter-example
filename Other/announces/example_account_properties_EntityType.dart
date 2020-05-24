import 'package:xpx_chain_sdk/xpx_sdk.dart';

/// Simple Account API AnnounceTransaction
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
      '86258172F90639811F2ABD055747D1E11B55A64B68AED2CEA9A34FBD6C0BE791',
      networkType);

  /// Create an TransactionType.
  final entityType = TransactionType.addExchangeOffer;

  /// Create a  transaction type AccountPropertiesEntityTypeTransaction.
  final tx = AccountPropertiesEntityTypeTransaction(
      // The maximum amount of time to include the transaction in the blockchain.
      Deadline(hours: 1),
      AccountPropertyType.blockTransaction,
      [
        AccountPropertiesEntityTypeModification(
            PropertyModificationType.removeProperty, entityType)
      ],
      networkType);

  final stx = account.sign(tx, generationHash);

  try {
    final restTx = await client.transaction.announce(stx);
    print(restTx);
    print('Hash: ${stx.hash}');
    print('Signer: ${account.publicAccount.publicKey}');
  } on Exception catch (e) {
    print('Exception when calling Transaction->Announce: $e\n');
  }
}
