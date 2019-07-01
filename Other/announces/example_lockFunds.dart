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

  final deadline = Deadline(hours: 1);

  /// Create a transaction type HashLock.
  final lockFundsTransaction = LockFundsTransaction(
      // The maximum amount of time to include the transaction in the blockchain.
      deadline,
      // Funds to lock
      xpxRelative(10),
      // Duration
      BigInt.from(100),
      // Aggregate bounded transaction for lock
      SignedTransaction(0x4241, 'payload',
          '8498B38D89C1DC8A448EA5824938FF828926CD9F7747B1844B59B4B6807E878B'),
      networkType);

  final stx = account.sign(lockFundsTransaction);

  final restTx = await client.transaction.announce(stx);
  print(restTx);
  print('Hash: ${stx.hash}');
  print('Signer: ${account.publicAccount.publicKey}');
}
