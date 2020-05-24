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

  /// Future multisig private key
  const multiSigPrivateKey =
      '3B5560B5CB19C893694FC49B461CE489BF9588BE16DBE8DC29CF06338133DEE7';

  /// Cosignature public keys
  const cosignatoryOnePublicKey =
      '16DBE8DC29CF06338133DEE64FC49B461CE489BF9588BE3B9670B5CB19C89369';
  const cosignatoryTwoPublicKey =
      '461CE489BF9588BE3B9670B5CB19C8936916DBE8DC29CF06338133DEE64FC49B';
  const cosignatoryThreePublicKey =
      '29CF06338133DEE64FC49BCB19C8936916DBE8DC461CE489BF9588BE3B9670B5';

  /// Minimal approval count
  const minimalApproval = 2;

  /// Minimal removal count
  const minimalRemoval = 3;

  /// Create an Account from a given Private key.
  final multiSig = Account.fromPrivateKey(multiSigPrivateKey, networkType);

  /// Create an PublicAccount from a given Public key.
  final cosignerOne =
      Account.fromPrivateKey(cosignatoryOnePublicKey, networkType);

  final cosignerTwo =
      Account.fromPrivateKey(cosignatoryTwoPublicKey, networkType);

  final cosignerThree =
      Account.fromPrivateKey(cosignatoryThreePublicKey, networkType);

  /// Create a  transaction type transfer
  final modifyMultisigAccount = ModifyMultisigAccountTransaction(
      // The maximum amount of time to include the transaction in the blockchain.
      deadline,
      // The number of signatures needed to approve a transaction.
      minimalApproval,
      // The number of signatures needed to remove a cosignatory.
      minimalRemoval,
      [
        MultisigCosignatoryModification(add, cosignerOne.publicAccount),
        MultisigCosignatoryModification(add, cosignerTwo.publicAccount),
        MultisigCosignatoryModification(add, cosignerThree.publicAccount),
      ],
      networkType);

  modifyMultisigAccount.toAggregate = multiSig.publicAccount;

  final aggregateTransaction = AggregateTransaction.complete(
      deadline, [modifyMultisigAccount], networkType);

  final stx = multiSig.signWithCosignatures(aggregateTransaction,
      [cosignerOne, cosignerTwo, cosignerThree], generationHash);

//  try {
//    final restTx = await client.transaction.announce(stx);
//    print(restTx);
//    print('Signer: ${multiSig.publicAccount.publicKey}');
//    print('HashTxn: ${stx.hash}');
//  } on Exception catch (e) {
//    print('Exception when calling Transaction->Announce: $e\n');
//  }
}
