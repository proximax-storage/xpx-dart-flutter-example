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
  final accountOne = Account.fromPrivateKey(
      '1ACE45EAD3C2F0811D9F4355F35BF78483324975083BE4E503EA49DFFEA691A0',
      networkType);

  /// Create an Address from a given Public key.
  final accountTwo = Account.fromPrivateKey(
      '68f50e10e5b8be2b7e9ddb687a667d6e94dd55fe02b4aed8195f51f9a242558c',
      networkType);

  final deadline = Deadline(hours: 1);

  /// Create a  transaction type transfer
  final ttxOne = TransferTransaction(
      // The maximum amount of time to include the transaction in the blockchain.
      deadline,
      // The Address of the recipient account.
      accountTwo.publicAccount.address,
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
  ttxTwo.toAggregate = accountTwo.publicAccount;

  // Create Aggregate complete transaction.
  final aggregateTransaction =
      AggregateTransaction.bonded(deadline, [ttxOne, ttxTwo], networkType);

  final signedAggregate = accountOne.sign(aggregateTransaction, generationHash);

  final lockFundsTransaction = LockFundsTransaction(
      // The maximum amount of time to include the transaction in the blockchain.
      deadline,
      // Funds to lock
      xpxRelative(10),
      // Duration
      BigInt.from(100),
      // Aggregate bounded transaction for lock
      signedAggregate,
      networkType);

  final signedLock = accountOne.sign(lockFundsTransaction, generationHash);

  try {
    final restLockFundsTx = await client.transaction.announce(signedLock);
    print(restLockFundsTx);
    print('Hash: ${signedLock.hash}');
    print('Signer: ${accountOne.publicAccount.publicKey}');
  } on Exception catch (e) {
    print('Exception when calling Transaction->Announce: $e\n');
  }

  int number = 0;
  while (number == 1) {
    await new Future.delayed(const Duration(seconds: 3));
    final status =
        await client.transaction.getTransactionStatus(signedLock.hash);
    if (status.status == 'Success' && status.group == 'confirmed') {
      print('Status: ${status.group} \n');
      try {
        final restAggregateTx =
            await client.transaction.announceAggregateBonded(signedAggregate);
        print(restAggregateTx);
        print('Hash: ${signedAggregate.hash}');
        print('Signer: ${accountOne.publicAccount.publicKey}');
      } on Exception catch (e) {
        print(
            'Exception when calling Transaction->AnnounceAggregateBonded: $e\n');
      }
      number = 1;
    } else {
      print('Status: ${status.group}');
    }
  }
}
