import 'package:fixnum/fixnum.dart';
import 'package:xpx_chain_sdk/xpx_sdk.dart';

/// Simple Mosaic API request
void main() async {

  const baseUrl = 'http://bctestnet1.xpxsirius.io:3000';

  final networkType = publicTest;

  final config =  Config(baseUrl, networkType);

  /// Creating a client instance
  /// xpx_chain_sdk uses the Dart's native HttpClient.
  /// Depending on the platform, you may want to use either
  /// the one which comes from dart:io or the BrowserClient
  /// example:
  /// 1- import 'package:http/browser_client.dart';
  /// 2- var client = NewClient(config,  BrowserClient());
  final client = ApiClient.fromConf(config, null);

  /// Gets the mosaic definition for a given mosaicId.
  try {
    final result = await client.mosaic.getMosaic(xpxMosaicId);
    print(result);
  } catch (e) {
    print('Exception when calling Mosaic->GetMosaic: $e\n');
  }

  /// Gets an array of mosaic definition.
  MosaicIds Ids =  MosaicIds();
  Ids.add(xpxMosaicId);
  try {
    final result = await client.mosaic.getMosaics(Ids);
    print(result);
  } catch (e) {
    print("Exception when calling Mosaic->GetMosaics: $e\n");
  }

  /// Returns friendly names for mosaics.
  try {
    final result = await client.mosaic.getMosaicsName(Ids);
    print(result);
  } catch (e) {
    print('Exception when calling Mosaic->GetMosaicsName: $e\n');
  }
}
