import 'package:xpx_chain_sdk/xpx_sdk.dart';

/// Simple Mosaic API request
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

  final mosaicId = MosaicId.fromHex('13bfc518e40549d7');

  /// Gets the mosaic definition for a given mosaicId.
  try {
    final result = await client.mosaic.getMosaic(mosaicId);
    print(result);
  } on Exception catch (e) {
    print('Exception when calling Mosaic->GetMosaic: $e\n');
  }

  /// Gets an array of mosaic definition.
  try {
    final result = await client.mosaic.getMosaics([mosaicId]);
    print(result);
  } on Exception catch (e) {
    print('Exception when calling Mosaic->GetMosaics: $e\n');
  }

  /// Returns friendly names for mosaics.
  try {
    final result = await client.mosaic.getMosaicsName([mosaicId]);
    print(result);
  } on Exception catch (e) {
    print('Exception when calling Mosaic->GetMosaicsName: $e\n');
  }
}
