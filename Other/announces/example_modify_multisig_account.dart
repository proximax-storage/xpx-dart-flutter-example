import 'package:xpx_chain_sdk/xpx_sdk.dart';

// Future multisig private key
const multisigPrivateKey =
    '16DBE8DC29CF06338133DEE64FC49B461CE489BF9588BE3B9670B5CB19C89368';

// Cosignature public keys
const cosignatoryOnePublicKey =
    '46DBE8DC29CF06338133DEE64FC49B461CE489BF9588BE3B9670B5CB19C89368';
const cosignatoryTwoPublicKey =
    '461CE489BF9588BE3B9670B5CB19C8936916DBE8DC29CF06338133DEE64FC49C';
const cosignatoryThreePublicKey =
    '29CF06338133DEE64FC49BCB19C8936916DBE8DC461CE489BF9588BE3B9670B6';

// Minimal approval count
const minimalApproval = 2;
// Minimal removal count
const minimalRemoval = 3;

/// Simple Transactions API request
void main() async {
  const baseUrl = 'http://bctestnet1.xpxsirius.io:3000';

  const networkType = publicTest;

  final config = Config(baseUrl, networkType);

  /// Creating a client instance
  /// xpx_chain_sdk uses the Dart's native HttpClient.
  /// Depending on the platform, you may want to use either
  /// the one which comes from dart:io or the BrowserClient
  /// example:
  /// 1- import 'package:http/browser_client.dart';
  /// 2- var client = newClient(config,  BrowserClient());
  final client = ApiClient.fromConf(config, null);

  /// Create an Account from a given Private key.
  final multisig = Account.fromPrivateKey(multisigPrivateKey, networkType);

  /// Create an PublicAccount from a given Public key.
  final cosignerOne =
      PublicAccount.fromPublicKey(cosignatoryOnePublicKey, networkType);

  final cosignerTwo =
      PublicAccount.fromPublicKey(cosignatoryTwoPublicKey, networkType);

  final cosignerThree =
      PublicAccount.fromPublicKey(cosignatoryThreePublicKey, networkType);

  print(cosignerThree);

  /// Create a  transaction type transfer
  final tx = ModifyMultisigAccountTransaction(
      // The maximum amount of time to include the transaction in the blockchain.
      Deadline(hours: 1),
      // The number of signatures needed to approve a transaction.
      minimalApproval,
      // The number of signatures needed to remove a cosignatory.
      minimalRemoval,
      [
        MultisigCosignatoryModification(add, cosignerOne),
        MultisigCosignatoryModification(add, cosignerTwo),
        MultisigCosignatoryModification(add, cosignerThree),
      ],
      networkType);

  final stx = multisig.sign(tx);

  final restTx = await client.transaction.announce(stx);
  print(restTx);
  print('Hash: ${stx.hash}');
  print('Signer: ${multisig.account.publicKey}');
}
