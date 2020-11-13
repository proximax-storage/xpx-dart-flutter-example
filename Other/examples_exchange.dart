import 'package:xpx_chain_sdk/xpx_sdk.dart';

/// Simple Transactions API request
void main() async {
  const baseUrl = 'http://bctestnet2.brimstone.xpxsirius.io:3000';

  /// Creating a client instance
  /// xpx_chain_sdk uses the Dart's native HttpClient.
  /// Depending on the platform, you may want to use either
  /// the one which comes from dart:io or the BrowserClient
  /// example:
  /// 1- import 'package:http/browser_client.dart';
  /// 2- var client = newClient(config,  BrowserClient());
  final client = SiriusClient.fromUrl(baseUrl, null);

  final mosaicId = MosaicId.fromHex('4D99247A12F64217');

  final networkType = await client.networkType;

  final account =
      Account.fromPrivateKey('63485A29E5D1AA15696095DCE792AACD014B85CBC8E473803406DEE20EC71958', networkType);

  try {
    /// Get a transaction information given a transactionId or hash.
    final result = await client.exchange.getExchangeOfferByAssetId(mosaicId, sellOffer);
    print(result);
  } on Exception catch (e) {
    print('Exception when calling Transaction->GetTransaction: $e\n');
  }

  try {
    /// Get a transaction information given a transactionId or hash.
    final result = await client.exchange.getAccountExchangeInfo(account.publicAccount);
    print(result.sellOffers);
  } on Exception catch (e) {
    print('Exception when calling Transaction->GetTransaction: $e\n');
  }
}
