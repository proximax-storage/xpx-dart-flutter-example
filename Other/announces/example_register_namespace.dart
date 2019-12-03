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
      BigInt.from(1000),
      // The network type
      networkType);
  final stx1 = account.sign(tx1, generationHash);

  try {
    final restTx1 = await client.transaction.announce(stx1);
    print(restTx1);
    print('Signer: ${account.publicAccount.publicKey}');
    print('Hash: ${stx1.hash}');
  } on Exception catch (e) {
    print('Exception when calling Transaction->Announce: $e\n');
  }

  /// Create a  transaction type RegisterNamespaceTransaction.
  /// type SubNamespace.
  final tx2 = RegisterNamespaceTransaction.createSub(
      Deadline(hours: 1), 'vensubnamespace', parentNamespace, networkType);
  final stx2 = account.sign(tx2, generationHash);

  try {
    final restTx2 = await client.transaction.announce(stx2);
    print(restTx2);
    print('Hash: ${stx2.hash}');
    print('Signer: ${account.publicAccount.publicKey}');
  } on Exception catch (e) {
    print('Exception when calling Transaction->Announce: $e\n');
  }
}
