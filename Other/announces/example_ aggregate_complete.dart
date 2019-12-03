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

  final deadline = Deadline(hours: 1);

  /// Create an Account from a given Private key.
  final account = Account.fromPrivateKey(
      '5D39DFFB41BB92C5932C29BAB4E1E5AC2C1901784BF008DC937A8A460B925331',
      networkType);

  /// Create an Address from a given Public key.
  final recipient = Address.fromPublicKey(
      '68f50e10e5b8be2b7e9ddb687a667d6e94dd55fe02b4aed8195f51f9a242558c',
      networkType);

  /// Create a  transaction type transfer
  final ttxOne = TransferTransaction(
      // The maximum amount of time to include the transaction in the blockchain.
      deadline,
      // The Address of the recipient account.
      recipient,
      // The List of mosaic to be sent.
      [xpx(52)],
      // The transaction message of 1024 characters.
      PlainMessage(payload: 'From ProximaX Dart SDK UNO'),
      networkType);

  /// Create a  transaction type transfer
  final ttxTwo = TransferTransaction(
      // The maximum amount of time to include the transaction in the blockchain.
      deadline,
      // The Address of the recipient account.
      recipient,
      // The List of mosaic to be sent.
      [xpxRelative(15)],
      // The transaction message of 1024 characters.
      PlainMessage(payload: 'From ProximaX Dart SDK DOS'),
      networkType);

  ttxOne.toAggregate = account.publicAccount;
  ttxTwo.toAggregate = account.publicAccount;

  // Create Aggregate complete transaction.
  final aggregateTransaction =
      AggregateTransaction.complete(deadline, [ttxOne, ttxTwo], networkType);

  final stx = account.sign(aggregateTransaction, generationHash);

  try {
    final restTx = await client.transaction.announce(stx);
    print(restTx);
    print('Hash: ${stx.hash}');
    print('Signer: ${account.publicAccount.publicKey}');
  } on Exception catch (e) {
    print('Exception when calling Transaction->Announce: $e\n');
  }
}
