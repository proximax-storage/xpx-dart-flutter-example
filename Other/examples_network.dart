import 'package:xpx_chain_sdk/xpx_sdk.dart';

/// Simple Node API request
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

  /// Get the node information.
  try {
    final result = await client.network.getNetworkType();
    print(result);
  } on Exception catch (e) {
    print('Exception when calling Network->GetNetworkType: $e\n');
  }

  /// Get the node time.
  try {
    final result = await client.node.getNodeTime();
    print(result);
  } on Exception catch (e) {
    print('Exception when calling Node->GetNodeTime: $e\n');
  }

  /// Get the node information
  try {
    final result = await client.node.getNodeInfo();
    print(result);
  } on Exception catch (e) {
    print('Exception when calling Node->getNodeInfo: $e\n');
  }
}
