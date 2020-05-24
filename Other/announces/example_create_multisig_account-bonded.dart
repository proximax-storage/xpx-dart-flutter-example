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
      '3B7660B5CB19C893694FC49B461CE489BF9588BE16DBE8DC29CF06338133DEE7';

  /// Cosignature public keys
  const cosignatoryOnePrivateKey =
      '16DBE8DC29CF06338133DEE64FC49B461CE489BF9588BE3B9670B5CB19C89369';
  const cosignatoryTwoPrivateKey =
      '461CE489BF9588BE3B9670B5CB19C8936916DBE8DC29CF06338133DEE64FC49B';
  const cosignatoryThreePrivateKey =
      '29CF06338133DEE64FC49BCB19C8936916DBE8DC461CE489BF9588BE3B9670B5';

  /// Minimal approval count
  const minimalApproval = 2;

  /// Minimal removal count
  const minimalRemoval = 3;

  /// Create an Account from a given Private key.
  final multiSig = Account.fromPrivateKey(multiSigPrivateKey, networkType);

  /// Create an PublicAccount from a given Public key.
  final cosignerOne =
      PublicAccount.fromPublicKey(cosignatoryOnePrivateKey, networkType);

  final cosignerTwo =
      PublicAccount.fromPublicKey(cosignatoryTwoPrivateKey, networkType);

  final cosignerThree =
      PublicAccount.fromPublicKey(cosignatoryThreePrivateKey, networkType);

  /// Create a  transaction type transfer
  final modifyMultiSigAccount = ModifyMultisigAccountTransaction(
      // The maximum amount of time to include the transaction in the blockchain.
      deadline,
      // The number of signatures needed to approve a transaction.
      minimalApproval,
      // The number of signatures needed to remove a cosignatory.
      minimalRemoval,
      [
        MultisigCosignatoryModification(remove, cosignerOne),
        MultisigCosignatoryModification(remove, cosignerTwo),
        MultisigCosignatoryModification(remove, cosignerThree),
      ],
      networkType);

  modifyMultiSigAccount.toAggregate = multiSig.publicAccount;

  final aggregateTransaction = AggregateTransaction.bonded(
      deadline, [modifyMultiSigAccount], networkType);

  aggregateTransaction.toAggregate = multiSig.publicAccount;

  final aggregateSign = multiSig.sign(aggregateTransaction, generationHash);

  /// Create a transaction type HashLock.
  final lockFundsTransaction = LockFundsTransaction(
      // The maximum amount of time to include the transaction in the blockchain.
      deadline,
      // Funds to lock
      xpxRelative(1),
      // Duration
      Uint64(100),
      // Aggregate bounded transaction for lock
      aggregateSign,
      networkType);

  final lockFundsSign = multiSig.sign(lockFundsTransaction, generationHash);

  try {
    final restLockFundsTx = await client.transaction.announce(lockFundsSign);
    print(restLockFundsTx);
    print('Signer Lock: ${multiSig.publicAccount.publicKey}');
    print('Hash Lock: ${lockFundsSign.hash}');
  } on Exception catch (e) {
    print('Exception when calling Transaction->Announce: $e\n');
  }

  int number = 0;
  while (number == 0) {
    await new Future.delayed(const Duration(seconds: 3));
    final status =
        await client.transaction.getTransactionStatus(lockFundsSign.hash);
    if (status.status == 'Success' && status.group == 'confirmed') {
      print('Status: ${status.group} \n');
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
      if (status.group == 'failed') {
        print('LockFund Status: ${status.status}');
        break;
      }
      print('LockFund Status: ${status.group}');
    }
  }
}
