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
      '63485A29E5D1AA15696095DCE792AACD014B85CBC8E473803406DEE20EC71958',
      networkType);

  /// The namespace name.
  const parentNamespace = 'dartnamespace';

  /// Create a  transaction type RegisterNamespaceTransaction.
  /// type RootNamespace.
  final tx1 = RegisterNamespaceTransaction.createRoot(
      // The maximum amount of time to include the transaction in the blockchain.
      Deadline(hours: 1),
      // The namespace name.
      parentNamespace,
      // The duration of the namespace.
      Uint64(1),
      // The network type
      networkType);
  final stx1 = account.sign(tx1, generationHash);

  try {
    final restTx1 = await client.transaction.announce(stx1);
    print(restTx1);
    print('Signer: ${account.publicAccount.publicKey}');
    print('HashTxn: ${stx1.hash}');
  } on Exception catch (e) {
    print('Exception when calling Transaction->Announce: $e\n');
  }

//  /// Create a  transaction type RegisterNamespaceTransaction.
//  /// type SubNamespace.
//  final tx2 = RegisterNamespaceTransaction.createSub(
//      Deadline(hours: 1), 'vensubnamespace', parentNamespace, networkType);
//  final stx2 = account.sign(tx2, generationHash);
//
//  try {
//    final restTx2 = await client.transaction.announce(stx2);
//    print(restTx2);
//    print('Signer: ${account.publicAccount.publicKey}');
//    print('Hash: ${stx2.hash}');
//  } on Exception catch (e) {
//    print('Exception when calling Transaction->Announce: $e\n');
//  }
}
