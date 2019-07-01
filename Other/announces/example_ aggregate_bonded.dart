import 'package:xpx_chain_sdk/xpx_sdk.dart';

const baseUrl = 'http://bctestnet1.xpxsirius.io:3000';

const networkType = publicTest;

/// Simple Account API AnnounceTransaction
void main() async {
  final config = Config(baseUrl, networkType);

  final client = ApiClient.fromConf(config, null);

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
      Message.plainMessage("Let's exchange 10 xpx -> 20 xem"),
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
      Message.plainMessage('Okay'),
      networkType);

  ttxOne.toAggregate = accountOne.publicAccount;
  ttxTwo.toAggregate = accountTwo.publicAccount;

  // Create Aggregate complete transaction.
  final aggregateTransaction =
      AggregateTransaction.bonded(deadline, [ttxOne, ttxTwo], networkType);

  final signedTransaction = accountOne.sign(aggregateTransaction);

  final lockFundsTransaction = LockFundsTransaction(
      // The maximum amount of time to include the transaction in the blockchain.
      deadline,
      // Funds to lock
      xpxRelative(10),
      // Duration
      BigInt.from(100),
      // Aggregate bounded transaction for lock
      signedTransaction,
      networkType);

  final signedLock = accountOne.sign(lockFundsTransaction);

  final restTxLock = await client.transaction.announce(signedLock);
  print(restTxLock);
  print('HashLock: ${signedLock.hash}');
  print('Signer: ${accountOne.publicAccount.publicKey}');

  for (var i = 0; i <= 20; i++) {
    await new Future.delayed(const Duration(seconds: 2));
    final status =
        await client.transaction.getTransactionStatus(signedLock.hash);
    if (status.status == 'Success') {
      if (status.group == 'confirmed') {
        print('Status: ${status.group}');
        final restTx =
            await client.transaction.announceAggregateBonded(signedTransaction);
        print(restTx);
        print('HashTxn: ${signedTransaction.hash}');
        print('Signer: ${accountOne.publicAccount.publicKey}');
        return;
      } else {
        print('Status: ${status.group}');
      }
    } else {
      print('Status: $status');
      return;
    }
  }
}
