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

  /// Future multiSig private key
  const multiSigPrivateKey =
      '3B7560B5CB19C893694FC49B461CE489BF9588BE16DBE8DC29CF06338133DEE6';

  /// Cosignature public keys
  const cosignatoryOnePrivateKey =
      '16DBE8DC29CF06338133DEE64FC49B461CE489BF9588BE3B9670B5CB19C89369';
  const cosignatoryTwoPrivateKey =
      '461CE489BF9588BE3B9670B5CB19C8936916DBE8DC29CF06338133DEE64FC49B';

  /// Minimal approval count
  const minimalApproval = 2;

  /// Minimal removal count
  const minimalRemoval = -1;

  /// Create an Account from a given Private key.
  final multiSig = Account.fromPrivateKey(multiSigPrivateKey, networkType);

  /// Create an PublicAccount from a given Public key.
  final cosignerOne =
      Account.fromPrivateKey(cosignatoryOnePrivateKey, networkType);

  final cosignerTwo =
      Account.fromPrivateKey(cosignatoryTwoPrivateKey, networkType);

  /// Create a  transaction type transfer
  final modifyMultiSigAccount = ModifyMultisigAccountTransaction(
      // The maximum amount of time to include the transaction in the blockchain.
      deadline,
      // The number of signatures needed to approve a transaction.
      minimalApproval,
      // The number of signatures needed to remove a cosignatory.
      minimalRemoval,
      [
        MultisigCosignatoryModification(remove, cosignerTwo.publicAccount),
      ],
      networkType);

  modifyMultiSigAccount.toAggregate = multiSig.publicAccount;

  final aggregateTransaction = AggregateTransaction.bonded(
      deadline, [modifyMultiSigAccount], networkType);

  aggregateTransaction.toAggregate = multiSig.publicAccount;

  final aggregateSign = cosignerOne.sign(aggregateTransaction, generationHash);

  /// Create a transaction type HashLock.
  final lockFundsTransaction = LockFundsTransaction(
      // The maximum amount of time to include the transaction in the blockchain.
      deadline,
      // Funds to lock
      xpxRelative(10),
      // Duration
      Uint64(100),
      // Aggregate bounded transaction for lock
      aggregateSign,
      networkType);

  final lockFundsSign = cosignerOne.sign(lockFundsTransaction, generationHash);

  try {
    final restLockFundsTx = await client.transaction.announce(lockFundsSign);
    print(restLockFundsTx);
    print('Signer Lock: ${cosignerOne.publicAccount.publicKey}');
    print('Hash Lock: ${lockFundsSign.hash}');
  } on Exception catch (e) {
    print('Exception when calling Transaction->Announce: $e\n');
  }

  int number = 0;
  while (number == 0) {
    await new Future.delayed(const Duration(seconds: 2));
    final status =
        await client.transaction.getTransactionStatus(lockFundsSign.hash);
    if (status.status == 'Success') {
      if (status.group == 'confirmed') {
        print('Status: ${status.group}');
        try {
          final restAggregateTx =
              await client.transaction.announceAggregateBonded(aggregateSign);
          print(restAggregateTx);
          print('Signer: ${multiSig.publicAccount.publicKey}');
          print('HashTxn: ${aggregateSign.hash}');
        } on Exception catch (e) {
          print(
              'Exception when calling Transaction->AnnounceAggregateBonded: $e\n');
        }
        number = 1;
      } else {
        print('Status: ${status.group}');
      }
    } else {
      if (status.group == 'failed') {
        print('LockFund Status: ${status.status}');
        break;
      }
      print('LockFund Status: ${status.group}');
    }
  }
}
