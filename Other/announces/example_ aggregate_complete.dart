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

  /// Create an Address from a given Public key.
  final recipient = Address.fromPublicKey(
      '68f50e10e5b8be2b7e9ddb687a667d6e94dd55fe02b4aed8195f51f9a242558b',
      networkType);

  final deadline = Deadline(hours: 1);

  /// Create a  transaction type transfer
  final ttxOne = TransferTransaction(
      // The maximum amount of time to include the transaction in the blockchain.
      deadline,
      // The Address of the recipient account.
      recipient,
      // The List of mosaic to be sent.
      [xpx(52)],
      // The transaction message of 1024 characters.
      Message.plainMessage('From ProximaX Dart SDK UNO'),
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
      Message.plainMessage('From ProximaX Dart SDK DOS'),
      networkType);

  ttxOne.toAggregate = account.publicAccount;
  ttxTwo.toAggregate = account.publicAccount;

  // Create Aggregate complete transaction.
  final aggregateTransaction =
      AggregateTransaction(deadline, [ttxOne, ttxTwo], networkType);

  final stx = account.sign(aggregateTransaction);

  final restTx = await client.transaction.announceTransaction(stx);
  print(restTx);
  print('Hash: ${stx.hash}');
  print('Signer: ${account.publicAccount.publicKey}');
}
