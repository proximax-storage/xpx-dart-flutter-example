import 'package:xpx_chain_sdk/xpx_sdk.dart';

/// Simple Account API request
void main() async {
  const baseUrl = 'http://bctestnet2.brimstone.xpxsirius.io:3000';

  const networkType = publicTest;

  /// Creating a client instance
  /// xpx_chain_sdk uses the Dart's native HttpClient.
  /// Depending on the platform, you may want to use either
  /// the one which comes from dart:io or the BrowserClient
  /// example:
  /// 1- import 'package:http/browser_client.dart';
  /// 2- var client = newClient(config,  BrowserClient());
  final client = SiriusClient.fromUrl(baseUrl, null);

  /// Create an PublicAccount from a given public key.
  final accountOne =
      PublicAccount.fromPublicKey('3B49BF0A08BB7528E54BB803BEEE0D935B2C800364917B6EFF331368A4232FD5', networkType);

  /// Create an Address from a given public key.
  final addressTwo =
      Address.fromPublicKey('3B49BF0A08BB7528E54BB803BEEE0D935B2C800364917B6EFF331368A4232FD5', networkType);

  try {
    /// Get AccountInfo for an account.
    /// Param address - address to get info.
    final result = await client.account.getAccountInfo(accountOne.address);
    print(result);
  } on Exception catch (e) {
    print('Exception when calling Account->GetAccountInfo: $e\n');
  }

  try {
    /// Get AccountInfo for multiple accounts.
    /// Param List Addresses - addresses to get info.
    final result = await client.account.getAccountsInfo([accountOne.address, addressTwo]);
    print(result);
  } on Exception catch (e) {
    print('Exception when calling Account->GetAccountsInfo: $e\n');
  }

  try {
    /// Get confirmed transactions information.
    /// Public Account - account to get transactions associated.
    final result = await client.account.getAccountInfo(accountOne.address);
    print(result);
  } on Exception catch (e) {
    print('Exception when calling Account->GetAccountsInfo: $e\n');
  }

  try {
    /// Get incoming transactions information.
    /// Public Account - account to get transactions associated.
    final result = await client.account.transactions(accountOne);
    print(result);
  } on Exception catch (e) {
    print('Exception when calling Account->IncomingTransactions: $e\n');
  }

  /// Get outgoing transactions information.
  /// Public Account - account to get transactions associated.
  try {
    final result = await client.account.outgoingTransactions(accountOne);
    print(result);
  } on Exception catch (e) {
    print('Exception when calling Account->OutgoingTransactions: $e\n');
  }

  /// Get unconfirmed transactions information.
  /// Public Account - account to get transactions associated.
  try {
    final result = await client.account.unconfirmedTransactions(accountOne);
    print(result);
  } on Exception catch (e) {
    print('Exception when calling Account->UnconfirmedTransactions: $e\n');
  }

  /// Get properties information.
  try {
    final result = await client.account.getAccountProperties(accountOne.address);
    print(result);
  } on Exception catch (e) {
    print('Exception when calling Account->GetAccountProperties: $e\n');
  }
}
