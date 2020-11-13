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

  const networkType = publicTest;

  /// Create an Account from a given Private key.
  final accountOne =
      Account.fromPrivateKey('1ACE45EAD3C2F0811D9F4355F35BF78483324975083BE4E503EA49DFFEA691A1', networkType);

  /// Create an Address from a given Public key.
  final accountTwo =
      PublicAccount.fromPublicKey('68f50e10e5b8be2b7e9ddb687a667d6e94dd55fe02b4aed8195f51f9a242558c', networkType);

  final deadline = Deadline(hours: 1);

  /// Create a  transaction type transfer
  final ttxOne = TransferTransaction(
      // The maximum amount of time to include the transaction in the blockchain.
      deadline,
      // The Address of the recipient account.
      accountTwo.address,
      // The List of mosaic to be sent.
      [xpx(52)],
      // The transaction message of 1024 characters.
      PlainMessage(payload: "Let's exchange 10 xpx -> 20 xem"),
      networkType);

  /// Create a  transaction type transfer
  final ttxTwo = TransferTransaction(
      // The maximum amount of time to include the transaction in the blockchain.
      deadline,
      // The Address of the recipient account.
      accountOne.publicAccount.address,
      // The List of mosaic to be sent.
      [xpx(20)],
      // The transaction message of 1024 characters.
      PlainMessage(payload: 'Okay'),
      networkType);

  ttxOne.toAggregate = accountOne.publicAccount;
  ttxTwo.toAggregate = accountTwo;

  // Create Aggregate complete transaction.
  final aggregateTransaction = AggregateTransaction.bonded(deadline, [ttxOne, ttxTwo], networkType);

  final signedAggregate = accountOne.sign(aggregateTransaction, generationHash);

  final lockFundsTransaction = LockFundsTransaction(
      // The maximum amount of time to include the transaction in the blockchain.
      deadline,
      // Funds to lock
      xpxRelative(10),
      // Duration
      Uint64(100),
      // Aggregate bounded transaction for lock
      signedAggregate,
      networkType);

  final signedLock = accountOne.sign(lockFundsTransaction, generationHash);

  try {
    final restLockFundsTx = await client.transaction.announce(signedLock);
    print(restLockFundsTx);
    print('Signer Lock: ${accountOne.publicAccount.publicKey}');
    print('Hash Lock: ${signedLock.hash}');
  } on Exception catch (e) {
    print('Exception when calling Transaction->Announce: $e\n');
  }

  int number = 0;
  while (number == 0) {
    await new Future.delayed(const Duration(seconds: 3));
    final status = await client.transaction.getTransactionStatus(signedLock.hash);
    if (status.status == 'Success' && status.group == 'confirmed') {
      print('Status: ${status.group} \n');
      try {
        final restAggregateTx = await client.transaction.announceAggregateBonded(signedAggregate);
        print(restAggregateTx);
        print('Signer: ${accountOne.publicAccount.publicKey}');
        print('HashTxn: ${signedAggregate.hash}');
      } on Exception catch (e) {
        print('Exception when calling Transaction->AnnounceAggregateBonded: $e\n');
      }
      number = 1;
    } else {
      if (status.group == 'failed') {
        print('LockFund Status: ${status.status}');
        break;
      }
      print('LockFund Status: ${status.group}');
    }
  }
}
