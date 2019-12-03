import 'package:xpx_chain_sdk/xpx_sdk.dart';

/// Simple Account API request
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

  /// Create an Address from a given public key.
  final addressOne = Address.fromPublicKey(
      'C64FA80DB046F488CC1C480454834D4CAE8284DDC14D6E93332AD02E345FF2C6',
      networkType);

  final addressTwo = Address.fromPublicKey(
      '72837FC53D330A289FBC3CC41A44DD52C0DBA25566BF6AD5FC03CDBC4FAD4CB4',
      networkType);
  print(addressTwo);

  try {
    /// Get AccountInfo for an account.
    /// Param address - A Address object.
    var result = await client.account.getAccountInfo(addressOne);
    print(result);
  } catch (e) {
    print('Exception when calling Account->GetAccountInfo: $e\n');
  }

  var adds = <String>[addressOne.address, addressTwo.address];

  try {
    /// Get accounts information.
    /// Param address - A Address object.
    var result = await client.account.getAccountsInfo(adds);
    print(result);
  } catch (e) {
    print("Exception when calling Account->GetAccountsInfo: $e\n");
  }
}
