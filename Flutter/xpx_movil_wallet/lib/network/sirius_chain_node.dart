import "dart:math";
import 'package:xpx_chain_sdk/xpx_sdk.dart' as sdk;

class ChainNodes {
  static final nodes = <ChainNode>[
    ChainNode.fromUrl('http://bctestnet1.brimstone.xpxsirius.io:3000'),
    ChainNode.fromUrl('http://bctestnet2.brimstone.xpxsirius.io:3000'),
    ChainNode.fromUrl('http://bctestnet3.brimstone.xpxsirius.io:3000'),
  ];

  ChainNode get defaultNode => _getRandomNode();

  /// generates a new Random ChainNode
  static ChainNode _getRandomNode() {
    final _random = new Random();

    // generate a random index based on the list length
    // and use it to retrieve the element
    return nodes[_random.nextInt(nodes.length)];
  }
}

class ChainNode {
  int port;
  String url;
  String method;

  ChainNode._(this.url, this.port, this.method);

  sdk.SiriusClient get client => _client();

  static ChainNode fromUrl(String url) {
    final method = url.split('://')[0];

    final port = int.tryParse(url.split('://')[1].split(':')[1]);

    return ChainNode._(url, port, method);
  }

  String getHostName(String url) => url.split('://')[1].split(':')[0];

  sdk.SiriusClient _client() {
    return sdk.SiriusClient.fromUrl(url, null);
  }
}

final siriusClient = ChainNodes();
