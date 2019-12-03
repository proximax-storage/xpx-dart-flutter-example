import 'package:xpx_chain_sdk/xpx_sdk.dart';

/// Simple BlockChain API request
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

  /// Get the current height of the chain.
  try {
    final result = await client.blockChain.getBlockchainHeight();
    print(result);
  } on Exception catch (e) {
    print('Exception when calling BlockChain->GetBlockByHeight: $e\n');
  }

  ///Get BlockInfo for a given block height.
  try {
    final height = BigInt.from(1);
    final result = await client.blockChain.getBlockByHeight(height);
    print(result);
  } on Exception catch (e) {
    print('Exception when calling BlockChain->GetBlockByHeight: $e\n');
  }

  /// Returns statistical information about the blockchain.
  try {
    final result = await client.blockChain.getDiagnosticStorage();
    print(result);
  } on Exception catch (e) {
    print('Exception when calling BlockChain->GetDiagnosticStorage: $e\n');
  }

  /// Gets up to limit number of blocks after given block height.
  final height = BigInt.from(1);
  const limit = 50;

  try {
    final result =
    await client.blockChain.getBlocksByHeightWithLimit(height, limit);
    print(result);
  } on Exception catch (e) {
    print(
        'Exception when calling BlockChain->GetBlocksByHeightWithLimit: $e\n');
  }

  /// Get transactions from a block
  try {
    final result = await client.blockChain.getBlockTransactions(height);
    print(result);
  } on Exception catch (e) {
    print('Exception when calling BlockChain->GetBlockTransactions: $e\n');
  }

  /// Get the current score of the chain
  try {
    final result = await client.blockChain.getBlockchainScore();
    print(result);
  } on Exception catch (e) {
    print('Exception when calling BlockChain->GetBlockchainScore: $e\n');
  }
}
