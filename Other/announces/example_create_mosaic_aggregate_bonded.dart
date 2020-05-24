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
  final accountOne = PublicAccount.fromPublicKey(
      '3B49BF0A08BB7528E54BB803BEEE0D935B2C800364917B6EFF331368A4232FD5',
      networkType);

  /// Create an Address from a given Public key.
  final accountTwo = Account.fromPrivateKey(
      '99855252F26630133E9080CA4BC73B163A9F6B43B14B98D183C4A793A40AF468',
      networkType);

  final deadline = Deadline(hours: 1);

  /// Create a Mosaic definition transaction.
  final mosaicDefinition = MosaicDefinitionTransaction(
      // The maximum amount of time to include the transaction in the blockchain.
      Deadline(hours: 1),
      mosaicNonce(),
      accountOne.publicKey,
      MosaicProperties(true, true, 4, Uint64.zero),
      // The network type
      networkType);

  mosaicDefinition.toAggregate = accountOne;

  /// Create a Mosaic Supply Change transaction.
  final mosaicSupplyChange = MosaicSupplyChangeTransaction(
      // The maximum amount of time to include the transaction in the blockchain.
      Deadline(hours: 1),
      increase,
      mosaicDefinition.mosaicId,
      Uint64(100000000000),
      // The network type
      networkType);

  mosaicSupplyChange.toAggregate = accountOne;

  // Create Aggregate complete transaction.
  final aggregateTransaction = AggregateTransaction.bonded(
      deadline, [mosaicDefinition, mosaicSupplyChange], networkType);

  final signedAggregate = accountTwo.sign(aggregateTransaction, generationHash);

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

  final signedLock = accountTwo.sign(lockFundsTransaction, generationHash);

  try {
    final restLockFundsTx = await client.transaction.announce(signedLock);
    print(restLockFundsTx);
    print('Lock Hash: ${signedLock.hash}');
    print('Lock Signer: ${accountTwo.publicAccount.publicKey}');
  } on Exception catch (e) {
    print('Exception when calling Transaction->Announce: $e\n');
  }

  int number = 0;
  while (number == 0) {
    await new Future.delayed(const Duration(seconds: 5));
    final status =
        await client.transaction.getTransactionStatus(signedLock.hash);
    if (status.status == 'Success' && status.group == 'confirmed') {
      print('Status: ${status.group}  ${status.group} \n');
      try {
        final restAggregateTx =
            await client.transaction.announceAggregateBonded(signedAggregate);
        print(restAggregateTx);
        print('Signer: ${accountTwo.publicAccount.publicKey}');
        print('HashTxn: ${signedAggregate.hash}');
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
