import 'package:xpx_chain_sdk/xpx_sdk.dart';

const networkType = publicTest;

const privateKey =
    '1ACE45EAD3C2F0811D9F4355F35BF78483324975083BE4E503EA49DFFEA691A0';

const publicKey =
    '37E95F604301545103E8AC3EFA5A40319DC05587B6192E9658052753356CDBB9';

/// Simple Generate Account
void main() async {
  /// Create an Account from a given private key.
  final account =  Account.fromPrivateKey(privateKey, networkType);

  print('Address: ${account.publicAccount.address}\n');
  print('PublicKey: \t${account.publicAccount.publicKey}');
  print('PrivateKey: ${account.account.privateKey}\n');

  print("-----------------------------------------------------");

  /// Create an Address from a given public key.
  final address =  Address.fromPublicKey(publicKey, networkType);
  print('Address: $address\n');
}
