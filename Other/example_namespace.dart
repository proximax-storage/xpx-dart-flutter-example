import 'package:xpx_chain_sdk/xpx_sdk.dart';

/// Simple Namespace API request
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

  final nsId = NamespaceId.fromName('dart');

  /// Generate Id from namespaceName
  try {
    final result = await client.namespace.getNamespace(nsId);
    print(result);
  } catch (e) {
    print('Exception when calling Namespace->GetNamespace: $e\n');
  }
  print('\n');

  /// Gets an list of namespaces for a given account address.
  final address =  Address.fromPublicKey(
      'B4F12E7C9F6946091E2CB8B6D3A12B50D17CCBBF646386EA27CE2946A7423DCF',
      networkType);

  try {
    final result = await client.namespace.getNamespacesFromAccount(address);
    print(result);
  } catch (e) {
    print('Exception when calling Namespace->GetNamespacesFromAccount: $e\n');
  }
  print('\n');

  /// Gets namespaces for a given array of addresses.
  final d =  Addresses();
  d.addresses.add(address.address);

  try {
    final result = await client.namespace.getNamespacesFromAccounts(d);
    print(result);
  } catch (e) {
    print('Exception when calling Namespace->GetNamespacesFromAccounts: $e\n');
  }
  print('\n');

  /// Returns friendly names for mosaics.
  final nsIds =  NamespaceIds();
  nsIds.namespaceIds.add(nsId);
//
  try {
    final result = await client.namespace.getNamespacesNames(nsIds);
    print(result);
  } catch (e) {
    print('Exception when calling Namespace->GetNamespacesNames: $e\n');
  }
}
