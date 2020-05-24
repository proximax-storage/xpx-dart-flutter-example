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
      Uint64(100),
      // Aggregate bounded transaction for lock
      SignedTransaction(0x4241, '',
          '1731245d3bd7af58e065a6971e75845cc4a4cc5f102629c84f0dade6b2a8d56f'),
      networkType);

  final lockFundsSign = account.sign(lockFundsTransaction, generationHash);

//  try {
//    final restLockFundsTx = await client.transaction.announce(lockFundsSign);
//    print(restLockFundsTx);
//    print('Signer: ${account.publicAccount.publicKey}');
//    print('HashTxn: ${lockFundsSign.hash}');
//  } on Exception catch (e) {
//    print('Exception when calling Transaction->Announce: $e\n');
//  }
}
