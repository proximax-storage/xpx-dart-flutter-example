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

  final mosaic = Mosaic(MosaicId.fromHex('4D99247A12F64217'), Uint64(50));

  /// Create AddExchangeOfferTransaction.
  final addExchangeOfferTxn = AddExchangeOfferTransaction(
      deadline,
      [
        AddOffer(
            offer: Offer(buyOffer, mosaic, Uint64(50)), duration: Uint64(1000))
      ],
      networkType);

  final signedAddExchangeOffer =
      account.sign(addExchangeOfferTxn, generationHash);

  try {
    final restAddExchangeOffer =
        await client.transaction.announce(signedAddExchangeOffer);
    print(restAddExchangeOffer);
    print('Signer: ${account.publicAccount.publicKey}');
    print('HashTxn: ${signedAddExchangeOffer.hash}');
  } on Exception catch (e) {
    print('Exception when calling Transaction->Announce: $e\n');
  }
}
