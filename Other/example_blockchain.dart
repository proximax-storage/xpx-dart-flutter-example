import 'package:xpx_chain_sdk/xpx_sdk.dart';

/// Simple BlockChain API request
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

  /// Get the current height of the chain.
  try {
    var result = await client.blockChain.getBlockchainHeight();
    print(result);
  } catch (e) {
    print('Exception when calling BlockChain->GetBlockByHeight: $e\n');
  }

  ///Get BlockInfo for a given block height.
  try {
    final height = BigInt.from(1);
    final result = await client.blockChain.getBlockByHeight(height);
    print(result);
  } catch (e) {
    print('Exception when calling BlockChain->GetBlockByHeight: $e\n');
  }

  /// Returns statistical information about the blockchain.
  try {
    final result = await client.blockChain.getDiagnosticStorage();
    print(result);
  } catch (e) {
    print('Exception when calling BlockChain->GetDiagnosticStorage: $e\n');
  }

  /// Gets up to limit number of blocks after given block height.
  final height = BigInt.from(1);
  final limit = 50;
  try {
    var result =
        await client.blockChain.getBlocksByHeightWithLimit(height, limit);
    print(result);
  } catch (e) {
    print(
        'Exception when calling BlockChain->GetBlocksByHeightWithLimit: $e\n');
  }

  /// Get transactions from a block
  try {
    final result = await client.blockChain.getBlockTransactions(height);
    print(result);
  } catch (e) {
    print('Exception when calling BlockChain->GetBlockTransactions: $e\n');
  }

  /// Get the current score of the chain
  try {
    final result = await client.blockChain.getBlockchainScore();
    print(result);
  } catch (e) {
    print('Exception when calling BlockChain->GetBlockchainScore: $e\n');
  }
}
