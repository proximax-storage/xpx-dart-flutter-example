import 'package:xpx_chain_sdk/xpx_sdk.dart';

/// Simple Generate Account
void main() async {
  const networkType = publicTest;

  const publicKey = '37E95F604301545103E8AC3EFA5A40319DC05587B6192E9658052753356CDBB9';

  /// Create an Account from a given private key.
  final account = Account.random(networkType);

  print('PublicKey: \t${account.publicAccount.publicKey}');
  print('PrivateKey: ${account.account.privateKey}');
  print('Address: ${account.publicAccount.address.address}\n');

  print('-----------------------------------------------------');

  /// Create an Address from a given public key.
  final address = Address.fromPublicKey(publicKey, networkType);
  print('Address: $address\n');
}
