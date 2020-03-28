import 'package:xpx_chain_sdk/xpx_sdk.dart' as sdk;
import 'package:xpx_movil_wallet/network/sirius_chain_node.dart';


class Sirius {
  String generationHash;
  int networkType;
  
  final String defaultMosaicId = '13bfc518e40549d7'.toUpperCase();
  final BigInt divisibility = BigInt.from(1000000);

  Sirius(){
    _initData();
  }

  void _initData() async {
    generationHash =  await siriusClient.defaultNode.client.generationHash;
    final nodeInfo = await siriusClient.defaultNode.client.node.getNodeInfo();
    networkType = sdk.addressNet[nodeInfo.networkIdentifier];
  }
}

final sirius = Sirius();