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

  final account = Account.fromPrivateKey(
      '63485A29E5D1AA15696095DCE792AACD014B85CBC8E473803406DEE20EC71958',
      networkType);

  final p = PublicAccount.fromPublicKey(
      '9A49366406ACA952B88BADF5F1E9BE6CE4968141035A60BE503273EA65456B24',
      networkType);

  final ms = Mosaic(storageNamespaceId, Uint64(2));

  /// Create AddExchangeOfferTransaction.
  final addExchangeOfferTxn = AddExchangeOfferTransaction(
      deadline,
      [AddOffer(offer: Offer(sellOffer, ms, Uint64(2)), duration: Uint64(1))],
      networkType);

  addExchangeOfferTxn.toAggregate = p;

  /// Create Aggregate complete transaction.
  final aggregateTransaction =
      AggregateTransaction.bonded(deadline, [addExchangeOfferTxn], networkType);

  final signedAggregate = account.sign(aggregateTransaction, generationHash);

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

  final signedLock = account.sign(lockFundsTransaction, generationHash);

  try {
    final restLockFundsTx = await client.transaction.announce(signedLock);
    print(restLockFundsTx);
    print('Signer Lock: ${account.publicAccount.publicKey}');
    print('Hash Lock: ${signedLock.hash}');
  } on Exception catch (e) {
    print('Exception when calling Transaction->Announce: $e\n');
  }

  int number = 0;
  while (number == 0) {
    await new Future.delayed(const Duration(seconds: 10));
    final status =
        await client.transaction.getTransactionStatus(signedLock.hash);
    if (status.status == 'Success' && status.group == 'confirmed') {
      print('Status: ${status.group} \n');
      try {
        final restAggregateTx =
            await client.transaction.announceAggregateBonded(signedAggregate);
        print(restAggregateTx);
        print('Signer: ${account.publicAccount.publicKey}');
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
