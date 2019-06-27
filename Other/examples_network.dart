import 'package:xpx_chain_sdk/xpx_sdk.dart';

/// Simple Node API request
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

  /// Get the node information.
  try {
    final result = await client.network.getNetworkType();
    print(result);
  } catch (e) {
    print('Exception when calling Transaction->GetNodeInfo: $e\n');
  }

  /// Get the node time.
  try {
    final result = await client.node.getNodeTime();
    print(result);
  } catch (e) {
    print('Exception when calling Transaction->GetNodeTime: $e\n');
  }
}
