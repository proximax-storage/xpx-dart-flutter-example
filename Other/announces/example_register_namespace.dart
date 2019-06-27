import 'package:xpx_chain_sdk/xpx_sdk.dart';

const baseUrl = 'http://bctestnet1.xpxsirius.io:3000';

const networkType = publicTest;

/// Simple Account API AnnounceTransaction
void main() async {
  final config = Config(baseUrl, networkType);

  final client = ApiClient.fromConf(config, null);

  /// Create an Account from a given Private key.
  final account = Account.fromPrivateKey(
      '1ACE45EAD3C2F0811D9F4355F35BF78483324975083BE4E503EA49DFFEA691A0',
      networkType);

  /// The namespace name.
  final parentNamespace = 'dartnamespace';

  /// Create a  transaction type RegisterNamespaceTransaction.
  /// type RootNamespace.
  final tx = RegisterNamespaceTransaction.createRoot(
      // The maximum amount of time to include the transaction in the blockchain.
      Deadline(hours: 1),
      // The namespace name.
      parentNamespace,
      // The duration of the namespace.
      BigInt.from(1000),
      // The network type
      networkType);
  final stx = account.sign(tx);

  final restTx = await client.transaction.announceTransaction(stx);
  print(restTx);
  print('Hash: ${stx.hash}');
  print('Signer: ${account.publicAccount.publicKey}');

  /// Create a  transaction type RegisterNamespaceTransaction.
  /// type SubNamespace.
  final tx2 = RegisterNamespaceTransaction.createSub(
      Deadline(hours: 1), 'vensubnamespace', parentNamespace, networkType);
  final stx2 = account.sign(tx2);

  final restTx2 = await client.transaction.announceTransaction(stx2);
  print(restTx2);
  print('Hash: ${stx2.hash}');
  print('Signer: ${account.publicAccount.publicKey}');
}
