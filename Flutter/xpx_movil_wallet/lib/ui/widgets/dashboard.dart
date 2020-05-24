import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:xpx_movil_wallet/ui/widgets/flip_card.dart';
import 'package:xpx_movil_wallet/ui/widgets/card_back.dart';

import 'package:xpx_movil_wallet/models/mosaic_model.dart';
import 'package:xpx_movil_wallet/models/account_model.dart';
import 'package:xpx_movil_wallet/models/sirius_model.dart';

import 'package:xpx_movil_wallet/blocs/account_list_bloc.dart';
import 'package:xpx_movil_wallet/blocs/mosaic_bloc.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:xpx_movil_wallet/utils/screensize_reducers.dart';
import 'package:xpx_movil_wallet/utils/size_config.dart';

class DashBoard extends StatefulWidget {
  @override
  _CardList createState() => _CardList();
}

class _CardList extends State<DashBoard> with TickerProviderStateMixin {
  final AccountListBloc _bloc = accountListBloc;
  TabController _controller;

  MosaicListBloc _mosaicBloc;

  Account _accountModel;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 2, vsync: this);
    _mosaicBloc = mosaicListBloc;
    _accountModel = accountDefault;
  }

  static List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    sizeConfig.init(context);
    return StreamBuilder<List<Account>>(
      stream: _bloc.cardList,
      builder: (context, snapshot) {
        return Column(
          children: <Widget>[
            !snapshot.hasData
                ? CircularProgressIndicator()
                : CarouselSlider(
                    height:
                        screenHeightExcludingToolbar(context, dividedBy: 3.5),
                    initialPage: 0,
//                  autoPlay: true,
//                  autoPlayInterval: Duration(seconds: 1),
//                  pauseAutoPlayOnTouch: Duration(seconds: 10),
                    autoPlayCurve: Curves.linear,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: Duration(milliseconds: 50),
                    scrollDirection: Axis.horizontal,
                    items: map<Widget>(snapshot.data, (_, account) {
                      return Container(
                          height: screenHeightExcludingToolbar(context),
                          margin: EdgeInsets.symmetric(horizontal: 8.0),
                          child: FlipCard(
                            front: CardFrontList(
                              accountModel: account,
                            ),
                            back: CardBack(
                              accountModel: account,
                            ),
                          ));
                    }).toList(),
                    onPageChanged: (index) {
                      accountDefault = snapshot.data[index];

                      setState(() {
                        _mosaicBloc.dispose();
                        _accountModel = accountDefault;
                        _mosaicBloc = MosaicListBloc.fromAccount(_accountModel);
                      });
                    },
                    viewportFraction: snapshot.data.length > 1 ? 0.9 : 1.0,
                  ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            _customTabBarMenuState(context)
          ],
        );
      },
    );
  }

  Widget _customTabBarMenuState(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          height: screenHeightExcludingToolbar(context, dividedBy: 10),
          //This is responsible for the background of the tabbar, does the magic
          decoration: BoxDecoration(
              //This is for background color
              color: Colors.white.withOpacity(0.0),
              //This is for bottom border that is needed
              border: Border(
                  bottom: BorderSide(color: Colors.grey[200], width: 2))),
          child: TabBar(
            controller: _controller,
            indicator: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.blueGrey, width: 2))),
            labelStyle: TextStyle(
                fontFamily: 'Open Sans',
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold),
            labelColor: Colors.blueGrey,
            unselectedLabelColor: Colors.blueGrey,
            tabs: <Widget>[
              Tab(
                  child: Text('ASSETS',
                      style: TextStyle(
                        fontSize: 15.0,
                      ))),
              Tab(
                  child:
                      Text('TRANSACTIONS', style: TextStyle(fontSize: 15.0))),
            ],
          )),
      Container(
          height: screenHeightExcludingToolbar(context, dividedBy: 2.0),
          margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
          child: TabBarView(
              controller: _controller,
              children: <Widget>[_mosaicsFrontList(context), Text('PLOMO')]))
    ]);
  }

  Widget _mosaicsFrontList(BuildContext context) {
    return StreamBuilder<List<Mosaic>>(
        stream: _mosaicBloc.mosaicsList,
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? CircularProgressIndicator()
              : ListView.builder(
                  itemCount:
                      snapshot.data.length > 5 ? 5 : snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    final mosaic = snapshot.data[index];
                    return Container(
                        margin: const EdgeInsets.all(1.0),
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: FractionalOffset.topCenter,
                            end: FractionalOffset.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.02),
                              Colors.black54,
                            ],
                            stops: [0.97, 1.0],
                          ),
                          border: Border.all(color: Colors.black26, width: 0.2),
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              mosaic.mosaicId.toString() ==
                                      sirius.defaultMosaicId
                                  ? SvgPicture.asset(
                                      'assets/icon/icon-proximax-color.svg',
                                      width: 30,
                                      height: 30)
                                  : SvgPicture.asset(
                                      'assets/icon/icon-sirius-mosaics.svg',
                                      width: 30,
                                      height: 30),
                              SizedBox(width: 10.0),
                              Text(
                                mosaic.mosaicId != sirius.defaultMosaicId
                                    ? mosaic.mosaicId
                                    : 'PRX.XPX',
                                style: TextStyle(
                                    fontFamily: 'Open Sans',
                                    color: Colors.blueGrey,
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                child: Text(
                                  ((mosaic.amount / sirius.divisibility)
                                      .toString()),
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      color: Colors.blueGrey,
                                      fontSize: 15.0),
                                ),
                              )
                            ]));
                  },
                );
        });
  }

  Widget _cardFront(BuildContext context) {
    final _accountLogo = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: Image(
            image: AssetImage('assets/proximax_logo.png'),
            width: 95.0,
            height: 62.0,
          ),
        )
      ],
    );

    final _accountAddress = Padding(
      padding: const EdgeInsets.all(5),
      child: Center(
        child: AutoSizeText(
          _accountModel.accountAddress,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'Open Sans', color: Colors.white, fontSize: 12.0),
          minFontSize: 5,
          maxLines: 1,
        ),
      ),
    );

    final _accountName = Padding(
      padding: const EdgeInsets.only(top: 10, left: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Text(
          'Account: ',
          style: TextStyle(
              fontFamily: 'Open Sans',
              color: Colors.white,
              fontSize: 15.0,
              fontWeight: FontWeight.bold),
        ),
        Text(
          _accountModel.accountName,
          textAlign: TextAlign.left,
          style: TextStyle(
              fontFamily: 'Open Sans', color: Colors.white, fontSize: 16.0),
        ),
      ]),
    );

    final _xpxBalance = Padding(
      padding: const EdgeInsets.only(top: 3, left: 10, right: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Text(
          'XPX Balance: ',
          style: TextStyle(
              fontFamily: 'Open Sans',
              color: Colors.white,
              fontSize: 15.0,
              fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: StreamBuilder(
              stream: _accountModel.getXpxBalance,
              builder: (context, snapshot) {
                return Text(
                  snapshot?.data ?? _accountModel.xpxBalance,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    color: Colors.white,
                    fontSize: 15.0,
                  ),
                );
              }),
        ),
      ]),
    );

    final _usdBalance = Padding(
      padding: const EdgeInsets.only(top: 3, left: 10, right: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Text(
          "US\$ Balance: ",
          style: TextStyle(
              fontFamily: 'Open Sans',
              color: Colors.white,
              fontSize: 15.0,
              fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(
            _accountModel.usdBalance,
            textAlign: TextAlign.right,
            style: TextStyle(
                fontFamily: 'Open Sans', color: Colors.white, fontSize: 15.0),
          ),
        ),
      ]),
    );

    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          image: DecorationImage(
            image: AssetImage("assets/map.png"),
            fit: BoxFit.fill,
            colorFilter: ColorFilter.mode(
                _accountModel.accountColor, BlendMode.softLight),
          ),
        ),
        child: RotatedBox(
          quarterTurns: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _accountLogo,
              _accountAddress,
              _accountName,
              _xpxBalance,
              _usdBalance,
            ],
          ),
        ));
  }
}

class CardFrontList extends StatelessWidget {
  CardFrontList({this.accountModel});

  final Account accountModel;

  @override
  Widget build(BuildContext context) {
    final _accountLogo = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: Image(
            image: AssetImage('assets/proximax_logo.png'),
            width: SizeConfig.safeBlockHorizontal * 23.75,
            height: SizeConfig.safeBlockHorizontal * 15.5,
          ),
        )
      ],
    );

    final _accountAddress = Padding(
      padding: const EdgeInsets.all(5),
      child: Center(
        child: AutoSizeText(
          accountModel.accountAddress,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'Open Sans',
              color: Colors.white,
              fontSize: SizeConfig.safeBlockHorizontal * 12.0),
          minFontSize: 5,
          maxLines: 1,
        ),
      ),
    );

    final _accountName = Padding(
      padding: const EdgeInsets.only(top: 10, left: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Text(
          'Account: ',
          style: TextStyle(
              fontFamily: 'Open Sans',
              color: Colors.white,
              fontSize: SizeConfig.safeBlockHorizontal * 4.25,
              fontWeight: FontWeight.bold),
        ),
        Text(
          accountModel.accountName,
          textAlign: TextAlign.left,
          style: TextStyle(
              fontFamily: 'Open Sans',
              color: Colors.white,
              fontSize: SizeConfig.safeBlockHorizontal * 4),
        ),
      ]),
    );

    final _xpxBalance = Padding(
      padding: const EdgeInsets.only(top: 3, left: 10, right: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Text(
          'XPX Balance: ',
          style: TextStyle(
              fontFamily: 'Open Sans',
              color: Colors.white,
              fontSize: SizeConfig.safeBlockHorizontal * 4.25,
              fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: StreamBuilder(
              stream: accountModel.getXpxBalance,
              builder: (context, snapshot) {
                return Text(
                  snapshot?.data ?? accountModel.xpxBalance,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: 'Open Sans',
                    color: Colors.white,
                    fontSize: SizeConfig.safeBlockHorizontal * 3.75,
                  ),
                );
              }),
        ),
      ]),
    );

    final _usdBalance = Padding(
      padding: const EdgeInsets.only(top: 3, left: 10, right: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Text(
          "US\$ Balance: ",
          style: TextStyle(
              fontFamily: 'Open Sans',
              color: Colors.white,
              fontSize: SizeConfig.safeBlockHorizontal * 4.25,
              fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(
            accountModel.usdBalance,
            textAlign: TextAlign.right,
            style: TextStyle(
                fontFamily: 'Open Sans',
                color: Colors.white,
                fontSize: SizeConfig.safeBlockHorizontal * 3.75),
          ),
        ),
      ]),
    );

    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: accountModel.accountColor,
//          image: DecorationImage(
//            image: AssetImage("assets/map.png"),
//            fit: BoxFit.fill,
//            colorFilter: ColorFilter.mode(
//                accountModel.accountColor, BlendMode.softLight),
//          ),
        ),
        child: RotatedBox(
          quarterTurns: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _accountLogo,
              _accountAddress,
              _accountName,
              _xpxBalance,
              _usdBalance,
            ],
          ),
        ));
  }
}
